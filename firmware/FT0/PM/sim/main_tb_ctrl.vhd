library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

entity main_tb_ctrl is
  port
  (
    tdc_clk_o : out std_logic := '0';
    m_clk_o   : out std_logic := '0';
    mgt_clk_o : out std_logic := '0';

    rst_n_o : out std_logic := '0';

    en_o : out std_logic := '0';

    hspi_clk_o  : out std_logic;
    hspi_cs_n_o : out std_logic;
    hspi_miso_i : in std_logic;
    hspi_mosi_o : out  std_logic;

    spi_clk_o  : out std_logic;
    spi_cs_n_o : out std_logic;
    spi_miso_i : in std_logic;
    spi_mosi_o : out  std_logic
  );
end entity main_tb_ctrl;

architecture rtl of main_tb_ctrl is

  -----------------------------------------------------------------------------
  -- Constant declarations
  -----------------------------------------------------------------------------
  constant c_hspi : integer := 0;
  constant c_spi : integer := 1;


  
  -----------------------------------------------------------------------------
  -- Procedures declarations
  -----------------------------------------------------------------------------
  -- Procedure for clock generation
  procedure clk_gen(
    signal clk : out std_logic; 
    constant FREQ : real
    ) is
    constant PERIOD    : time := 1 sec / FREQ; -- Full period
    constant HIGH_TIME : time := PERIOD / 2; -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME; -- Low time; always >= HIGH_TIME
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

  procedure clk_gen_jump(
    signal clk : out std_logic; 
    constant FREQ : real
    ) is
    constant PERIOD    : time := 1 sec / FREQ; -- Full period
    constant HIGH_TIME : time := PERIOD / 2; -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME; -- Low time; always >= HIGH_TIME
    variable value : integer := 0;
    variable jump : boolean := false;
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
    -- Generate a clock cycle
    loop
      if (jump = false) and (value = 200) then -- introduce signal delay to jump start autophase IP Core
        jump := true;
        wait for 1 ns;
      end if;

      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
      value  := value + 1;

    end loop;
  end procedure;

  -----------------------------------------------------------------------------
  -- Signal declarations
  -----------------------------------------------------------------------------
  signal rst_n : std_logic;

  signal tdc_clk : std_logic;
  signal m_clk   : std_logic;
  signal mgt_clk : std_logic;

  signal spi_clk : std_logic;

  signal spi_en  : std_logic := '0';
  signal hspi_en : std_logic := '0';
  signal spi_busy : std_logic;
  signal hspi_busy : std_logic;
  signal en : std_logic := '0';

  signal spi_tx :std_logic_vector(31 downto 0) := x"0000_0000";
  signal spi_rx :std_logic_vector(31 downto 0) := x"0000_0000";

  signal hspi_tx :std_logic_vector(31 downto 0) := x"0000_0000";
  signal hspi_rx :std_logic_vector(31 downto 0) := x"0000_0000";

begin

  -- Clock generation
  clk_gen(tdc_clk, 300.000E6); -- 300 MHz clock
  tdc_clk_o <= tdc_clk;
  clk_gen_jump(m_clk, 40.000E6); -- 40 MHz clock
  m_clk_o <= m_clk;
  clk_gen(mgt_clk, 40.000E6); -- 40 MHz clock
  mgt_clk_o <= mgt_clk;

  clk_gen(spi_clk, 10.000E6); -- 40 MHz clock

  rst_n_o <= rst_n;

  en_o <= en;

  -- Testbench sequence
  process is
    
    procedure spi_transfer (
      constant interface : in integer;
      variable value_in : in std_logic_vector(31 downto 0);
      variable value_out : out std_logic_vector(31 downto 0)
    ) is
    begin
      if (interface = c_hspi) then
        wait until rising_edge(spi_clk);
        hspi_en <= '1';
        hspi_tx <= value_in;
        wait until rising_edge(spi_clk);
        hspi_en <= '0';
        wait until falling_edge(hspi_busy);
        value_out := hspi_rx;
        wait until rising_edge(spi_clk);
      else 
        wait until rising_edge(spi_clk);
        spi_en <= '1';
        spi_tx <= value_in;
        wait until rising_edge(spi_clk);
        spi_en <= '0';
        wait until falling_edge(spi_busy);
        value_out := spi_rx;
        wait until rising_edge(spi_clk);
      end if;
    end procedure;

    procedure spi_read (
      constant interface : in integer;
      constant address  : in std_logic_vector(7 downto 0);
      variable data  : out std_logic_vector
      
    ) is
      variable vector : std_logic_vector(31 downto 0) := x"0000_0000";
      
    begin
      vector(31) := '1';
      vector(29 downto 22) := address;
      spi_transfer(interface, vector, data);
    end procedure;
    

    procedure spi_write (
      constant interface  : in integer;
      constant address    : in std_logic_vector(7 downto 0);
      variable data       : in std_logic_vector
      
    ) is
      variable vector : std_logic_vector(31 downto 0) := x"0000_0000";
      variable data_out : std_logic_vector(31 downto 0);
    begin
      vector(31) := '0';
      vector(29 downto 22) := address;
      vector(15 downto 0) := data;
      spi_transfer(interface, vector, data_out);
    end procedure;

    -- variable test : std_logic_vector(31 downto 0);
    variable reg_address : std_logic_vector(7 downto 0);
    variable write_data  : std_logic_vector(15 downto 0);

  begin
    rst_n <= '0';
    for i in 0 to 49 loop
      wait until rising_edge(m_clk);
    end loop;
    -- Take the DUT out of reset
    rst_n <= '1';
    for i in 0 to 9 loop
      wait until rising_edge(m_clk);
    end loop;

    -- must wait till 25 ns, when all IP Cores are out from reset

    wait for 30 us;

    -- based on https://github.com/Nikitavoz/ControlServer/blob/master/PM.h
    -- Set gate time high 
    reg_address := x"00";
    write_data := x"0007";
    spi_write(c_spi, reg_address, write_data);

    -- Enable CH 1, reg_address x"7C", 
    reg_address := x"7C";
    write_data := x"0001";
    spi_write(c_spi, reg_address, write_data);

    -- Lock Channels
    reg_address := x"7F";
    write_data := x"0800";
    spi_write(c_spi, reg_address, write_data);

    -- Set TRGchargeLevelHi and TRGchargeLevelLo
    reg_address := x"3D";
    write_data := x"0800";
    spi_write(c_spi, reg_address, write_data);

    wait for 1 us;


    en <= '1';

    wait;
  end process;

  -- HSPI
  hspi_master_inst : entity work.spi_master
    generic
    map (
    data_length => 32
    )
    port map
    (
      clk     => spi_clk,
      reset_n => rst_n,
      enable  => hspi_en,
      cpol    => '0',
      cpha    => '0',
      miso    => hspi_miso_i,
      sclk    => hspi_clk_o,
      ss_n    => hspi_cs_n_o,
      mosi    => hspi_mosi_o,
      busy    => hspi_busy,
      tx      => hspi_tx,
      rx      => hspi_rx
    );

    
  -- SPI
spi_master_inst : entity work.spi_master
  generic
  map (
  data_length => 32
  )
  port map
  (
    clk     => spi_clk,
    reset_n => rst_n,
    enable  => spi_en,
    cpol    => '0',
    cpha    => '0',
    miso    => spi_miso_i,
    sclk    => spi_clk_o,
    ss_n    => spi_cs_n_o,
    mosi    => spi_mosi_o,
    busy    => spi_busy,
    tx      => spi_tx,
    rx      => spi_rx
  );

end architecture;