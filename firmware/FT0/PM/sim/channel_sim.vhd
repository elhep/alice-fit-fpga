library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;


entity channel_sim is
  generic (
    g_channel_name : string := "ch1"
  );
  port
  (
    tdc_clk_i : in std_logic;
    mclk_i    : in std_logic;

    rst_n_i : in std_logic;

    en_i : in std_logic;

    rd_o : out std_logic := '0';
    rs_o : out std_logic := '1';
    in_o : out std_logic := '0';

    d_ov : out std_logic_vector(12 downto 0) := (others => '0');
    s_o  : out std_logic := '0'
  );
end entity channel_sim;

architecture beh of channel_sim is


  signal rd : std_logic;
  signal rs : std_logic;

  signal latch : std_logic;

  signal tdc_value : std_logic_vector(7 downto 0) := (others => '0') ;
  signal data_channel : std_logic := '0';
  signal data_value : std_logic_vector(12 downto 0) := (others => '0') ;


  signal tdc_en : std_logic := '0';
  signal latch_en : std_logic := '0';
  signal adc_en : std_logic := '0';


begin

  -- Main process 
  process 
    file ch_file  : text open read_mode is (g_channel_name & ".txt");
    variable input_line : line;
    variable wait_time : time;
    variable v_tdc_value : integer := 0;
    variable v_data_channel : integer := 0;
    variable v_data_value : integer := 0;


  begin
    wait for 1 ps;
    if en_i = '1' then
      if(not endfile(ch_file)) then
        readline(ch_file, input_line);
        read(input_line, wait_time);
        read(input_line, v_tdc_value);

        tdc_value <= std_logic_vector(to_unsigned(v_tdc_value,8));
        read(input_line, v_data_channel);
        data_channel <= to_unsigned(v_data_channel,1)(0);
        read(input_line, v_data_value);
        data_value <= std_logic_vector(to_unsigned(v_data_value,13));
        wait for wait_time;
        tdc_en <= '1';
        latch_en <= '1';
        adc_en <= '1';
        wait for 1 ps;
        tdc_en <= '0';
        latch_en <= '0';
        adc_en <= '0';

      end if;
    
    else
      
    end if;
  end process;


  -- Latch  process 
  process 
    
  begin
    latch <= '0';

    wait for 1 ps;
    if latch_en = '1' then
      latch <= '1';
      wait for 6 ns;
      latch <= '0';
    else
      latch <= '0';
    end if;
  end process;

  in_o <= latch;

  -- TDC Strobe and data process 
  process 

  begin
    rd <= '0';
    rs <= '1';
    wait for 1 ps;

    if tdc_en = '1' then

        for i in 0 to 8 loop
          wait until rising_edge(tdc_clk_i);
          rs <= '0';
          if i > 0 then
            rd <= tdc_value(i - 1);
          end if;
        end loop;

        rs <= '1';
        rd <= '0';
        wait until rising_edge(tdc_clk_i);
        wait until rising_edge(tdc_clk_i);


    else
      rd <= '0';
      rs <= '1';
    end if;
  end process;

  rd_o <= rd;
  rs_o <= rs;


  -- Data process 
  process 

  begin
    wait for 1 ps;

    if adc_en = '1' then

      wait until rising_edge(mclk_i);
      d_ov <= data_value;

    end if;
  end process;

end architecture;