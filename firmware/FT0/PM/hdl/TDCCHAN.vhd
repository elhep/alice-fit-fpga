----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2017 09:02:28 PM
-- Design Name: 
-- Module Name: TDCCHAN - tdcchan
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TDCCHAN is
  port
  (
    pin_in       : in std_logic;
    pin_out      : out std_logic;
    clk300       : in std_logic;
    clk600       : in std_logic;
    clk600_90    : in std_logic;
    reset        : in std_logic;
    tdcclk       : in std_logic;
    rstr         : in std_logic;
    rdata        : in std_logic;
    tdc_count    : in std_logic_vector (3 downto 0);
    bc_time      : in std_logic_vector (6 downto 0);
    tdc_out      : out std_logic_vector (11 downto 0);
    tdc_rdy      : out std_logic;
    tdc_raw      : out std_logic_vector (12 downto 0);
    tdc_raw_lock : in std_logic
  );
end TDCCHAN;

architecture RTL of TDCCHAN is

  signal C_STR, C_STR1, C_STR2, STR_wr, TDCFIFO_wr, TDCFIFO_rd, TDCFIFO_full, TDCFIFO_empty, rs300_0, rs300_1, rs300_2, TDCF_cou_40, TDCF_delay, rs_1, TDC_rdy1, TDC_raw_wr, reset300 : std_logic := '0';

  signal C_BITS, TDC_bitcount : std_logic_vector (2 downto 0)  := (others => '0');
  signal C_TIME, C_PER, TDC   : std_logic_vector (6 downto 0)  := (others => '0');
  signal C_FIFO, TDCF_cou     : std_logic_vector (5 downto 0)  := (others => '0');
  signal CH_CORR              : std_logic_vector (4 downto 0)  := (others => '0');
  signal tdc_raw_i            : std_logic_vector (12 downto 0) := (others => '0');
  
  component pin_capt
    port
    (
      pin_in    : in std_logic;
      pin_out   : out std_logic;
      clk600    : in std_logic;
      clk600_90 : in std_logic;
      clk300    : in std_logic;
      str       : out std_logic;
      ptime     : out std_logic_vector (2 downto 0));
  end component;

  component TDC_FIFO
    port
    (
      clk   : in std_logic;
      srst  : in std_logic;
      din   : in std_logic_vector(5 downto 0);
      wr_en : in std_logic;
      rd_en : in std_logic;
      dout  : out std_logic_vector(5 downto 0);
      full  : out std_logic;
      empty : out std_logic);
  end component;

begin

  tdc_raw <= tdc_raw_i;

  PINCAPT : pin_capt port map
    (pin_in => pin_in, pin_out => pin_out, clk600 => clk600, clk600_90 => clk600_90, clk300 => clk300, str => C_STR, ptime => C_BITS);
  TDCFIFO : TDC_FIFO port
  map (clk => clk300, srst => reset300, din => C_TIME(6 downto 1), wr_en => TDCFIFO_wr, rd_en => TDCFIFO_rd, dout => C_FIFO, full => TDCFIFO_full, empty => TDCFIFO_empty);

  process (clk300)
  begin
    if (clk300'event and clk300 = '1') then

      reset300   <= reset or TDCF_cou_40;
      TDCF_delay <= TDCF_cou_40;

      C_STR1 <= C_STR;
      C_STR2 <= C_STR1;
      if (C_STR = '1' and C_STR1 = '0') then
        C_PER <= tdc_count & C_BITS;
      end if;

      if (rs300_1 = '0') or (TDCFIFO_empty = '1') then
        TDCF_cou <= "000000";
      else
        TDCF_cou <= TDCF_cou + 1;
      end if;

      rs300_0 <= rstr;
      rs300_2 <= rs300_1;
      rs300_1 <= rs300_0;
    end if;
  end process;

  C_TIME     <= (C_PER - bc_time);
  STR_wr     <= C_STR1 and not C_STR2;
  TDCFIFO_wr <= STR_wr and not (TDCFIFO_full or TDCF_delay or reset300);

  TDCF_cou_40 <= '1' when (TDCF_cou = 40) else
    '0';

  TDCFIFO_rd <= '1' when (rs300_1 = '0' and rs300_2 = '1') and (TDCFIFO_empty = '0') and (reset300 = '0') else
    '0';

  process (tdcclk)
  begin
    if (tdcclk'event and tdcclk = '1') then
      rs_1 <= rstr;
      if (rstr = '0') and (rs_1 = '1') then
        TDC_bitcount <= "111";
        TDC_rdy1     <= '0';
        TDC_raw_wr   <= '1';
      end if;
      if (TDC_bitcount /= "000") then
        TDC          <= rdata & TDC(6 downto 1);
        TDC_bitcount <= TDC_bitcount - 1;
      else
        if (TDC_raw_wr = '1') then
          TDC_raw_wr <= '0';
          if (tdc_raw_lock = '0') then
            TDC_raw_i <= C_FIFO(5 downto 0) & TDC(6 downto 0);
          end if;
        end if;
      end if;
      if (TDC_bitcount = "010") then
        TDC_rdy1 <= '1';
      end if;

    end if;
    if (tdcclk'event and tdcclk = '0') then
      tdc_rdy <= TDC_rdy1;
    end if;
  end process;

  CH_CORR <= "00001" when (C_FIFO(0) = '1') and (TDC(6 downto 5) = "00") else
    "11111" when (C_FIFO(0) = '0') and (TDC(6 downto 5) = "11") else
    "00000";

  tdc_out <= (C_FIFO(5 downto 1) + CH_CORR & TDC);
  --tdc_out<=(C_FIFO(5 downto 0) & TDC(6 downto 1));
end RTL;