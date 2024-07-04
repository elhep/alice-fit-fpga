library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library xil_defaultlib;

entity fit_tb is
    
end entity fit_tb;

architecture rtl of fit_tb is  

  
  signal tdc_clk_p : std_logic := '0';
  signal tdc_clk_n : std_logic := '1';

  signal mclk_p : std_logic := '1';
  signal mclk_n : std_logic := '0';

  signal mgt_clk_p : std_logic := '0';
  signal mgt_clk_n : std_logic := '1';

  
  signal RDA1_P : std_logic := '0';
  signal RDA1_N : std_logic := '1';
  signal RSA1_P : std_logic := '0';
  signal RSA1_N : std_logic := '1';
  signal RDB1_P : std_logic := '0';
  signal RDB1_N : std_logic := '1';
  signal RSB1_P : std_logic := '0';
  signal RSB1_N : std_logic := '1';
  signal RDC1_P : std_logic := '0';
  signal RDC1_N : std_logic := '1';
  signal RSC1_P : std_logic := '0';
  signal RSC1_N : std_logic := '1';
  signal RDD1_P : std_logic := '0';
  signal RDD1_N : std_logic := '1';
  signal RSD1_P : std_logic := '0';
  signal RSD1_N : std_logic := '1';
  signal INA1_P : std_logic := '0';
  signal INA1_N : std_logic := '1';
  signal INB1_P : std_logic := '0';
  signal INB1_N : std_logic := '1';
  signal INC1_P : std_logic := '0';
  signal INC1_N : std_logic := '1';
  signal IND1_P : std_logic := '0';
  signal IND1_N : std_logic := '1';
  signal DI1 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI2 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI3 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI4 : STD_LOGIC_VECTOR (12 downto 0);
  signal STR1 : STD_LOGIC;
  signal STR2 : STD_LOGIC;
  signal STR3 : STD_LOGIC;
  signal STR4 : STD_LOGIC;

  signal RDA2_P : STD_LOGIC;
  signal RDA2_N : STD_LOGIC;
  signal RSA2_P : STD_LOGIC;
  signal RSA2_N : STD_LOGIC;
  signal RDB2_P : STD_LOGIC;
  signal RDB2_N : STD_LOGIC;
  signal RSB2_P : STD_LOGIC;
  signal RSB2_N : STD_LOGIC;
  signal RDC2_P : STD_LOGIC;
  signal RDC2_N : STD_LOGIC;
  signal RSC2_P : STD_LOGIC;
  signal RSC2_N : STD_LOGIC;
  signal RDD2_P : STD_LOGIC;
  signal RDD2_N : STD_LOGIC;
  signal RSD2_P : STD_LOGIC;
  signal RSD2_N : STD_LOGIC;
  signal INA2_P : STD_LOGIC;
  signal INA2_N : STD_LOGIC;
  signal INB2_P : STD_LOGIC;
  signal INB2_N : STD_LOGIC;
  signal INC2_P : STD_LOGIC;
  signal INC2_N : STD_LOGIC;
  signal IND2_P : STD_LOGIC;
  signal IND2_N : STD_LOGIC;
  signal DI5 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI6 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI7 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI8 : STD_LOGIC_VECTOR (12 downto 0);
  signal STR5 : STD_LOGIC;
  signal STR6 : STD_LOGIC;
  signal STR7 : STD_LOGIC;
  signal STR8 : STD_LOGIC;
  
  signal TDCCLK3_P : STD_LOGIC;
  signal TDCCLK3_N : STD_LOGIC;
  signal RDA3_P : STD_LOGIC;
  signal RDA3_N : STD_LOGIC;
  signal RSA3_P : STD_LOGIC;
  signal RSA3_N : STD_LOGIC;
  signal RDB3_P : STD_LOGIC;
  signal RDB3_N : STD_LOGIC;
  signal RSB3_P : STD_LOGIC;
  signal RSB3_N : STD_LOGIC;
  signal RDC3_P : STD_LOGIC;
  signal RDC3_N : STD_LOGIC;
  signal RSC3_P : STD_LOGIC;
  signal RSC3_N : STD_LOGIC;
  signal RDD3_P : STD_LOGIC;
  signal RDD3_N : STD_LOGIC;
  signal RSD3_P : STD_LOGIC;
  signal RSD3_N : STD_LOGIC;
  signal INA3_P : STD_LOGIC;
  signal INA3_N : STD_LOGIC;
  signal INB3_P : STD_LOGIC;
  signal INB3_N : STD_LOGIC;
  signal INC3_P : STD_LOGIC;
  signal INC3_N : STD_LOGIC;
  signal IND3_P : STD_LOGIC;
  signal IND3_N : STD_LOGIC;
  signal DI9 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI10 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI11 : STD_LOGIC_VECTOR (12 downto 0);
  signal DI12 : STD_LOGIC_VECTOR (12 downto 0);
  signal STR9 : STD_LOGIC;
  signal STR10 : STD_LOGIC;
  signal STR11 : STD_LOGIC;
  signal STR12 : STD_LOGIC;
  
  signal SCK : STD_LOGIC;
  signal MISO : STD_LOGIC;
  signal MOSI : STD_LOGIC;
  signal CS : STD_LOGIC;
  signal IRQ : STD_LOGIC;
  signal AT0_P : STD_LOGIC;
  signal AT0_N : STD_LOGIC;
  signal AT1_P : STD_LOGIC;
  signal AT1_N : STD_LOGIC;
  signal TT0_P : STD_LOGIC;
  signal TT0_N : STD_LOGIC;
  signal TT1_P : STD_LOGIC;
  signal TT1_N : STD_LOGIC;

  signal HMOSI : STD_LOGIC := '0';
  signal HMISO : STD_LOGIC := '0';
  signal HSCK : STD_LOGIC := '0';
  signal HSEL : STD_LOGIC := '0';

  signal LA0 : STD_LOGIC_VECTOR (15 downto 0);
  signal LA1 : STD_LOGIC_VECTOR (15 downto 0);
  signal LA2 : STD_LOGIC_VECTOR (15 downto 0);
  signal LA3 : STD_LOGIC_VECTOR (15 downto 0);
  signal LACK0 : STD_LOGIC;
  signal LACK1 : STD_LOGIC;
  signal LACK2 : STD_LOGIC;
  signal LACK3 : STD_LOGIC;
  signal EVNT : STD_LOGIC;
  signal LED1 : STD_LOGIC;
  signal LED2 : STD_LOGIC;
  signal LED3 : STD_LOGIC;
  signal LED4 : STD_LOGIC;
  signal GBT_RX_P : STD_LOGIC := '1';
  signal GBT_RX_N : STD_LOGIC := '0';
  signal GBT_TX_P : STD_LOGIC;
  signal GBT_TX_N : STD_LOGIC;

  -- Flash signals
  signal FSEL : STD_LOGIC;
  signal FMOSI : STD_LOGIC;
  signal FMISO : STD_LOGIC := '0';

  -- Reset signal
  signal rst_n : STD_LOGIC := '0';

  -- 
  signal en : std_logic;

begin

  main_tb_ctrl_inst : entity xil_defaultlib.main_tb_ctrl
  port map (
    tdc_clk_o => tdc_clk_p,
    m_clk_o => mclk_p,
    mgt_clk_o => mgt_clk_p,
    rst_n_o => rst_n,

    en_o => en,

    hspi_clk_o  => HSCK,
    hspi_cs_n_o => HSEL,
    hspi_miso_i => HMISO,
    hspi_mosi_o => HMOSI,

    spi_clk_o  => SCK,
    spi_cs_n_o => CS,
    spi_miso_i => MISO,
    spi_mosi_o => MOSI
  );

  tdc_clk_n <= not tdc_clk_p;
  mclk_n <= not mclk_p;
  mgt_clk_n <= not mgt_clk_p;


  channel_sim_inst_1 : entity work.channel_sim
    port map (
      tdc_clk_i => tdc_clk_p,
      mclk_i => mclk_p,
      rst_n_i => rst_n,
      en_i => en,
      rd_o => RDA1_P,
      rs_o => RSA1_P,
      in_o => INA1_P,
      d_ov => DI1,
      s_o => STR1
    );

  RDA1_N <= not RDA1_P;
  RSA1_N <= not RSA1_P;
  INA1_N <= not INA1_P;



  PM12_inst : entity work.PM12
    port map (
      TDCCLK1_P => tdc_clk_p,
      TDCCLK1_N => tdc_clk_n,

      RDA1_P => RDA1_P,
      RDA1_N => RDA1_N,
      RSA1_P => RSA1_P,
      RSA1_N => RSA1_N,

      RDB1_P => RDB1_P,
      RDB1_N => RDB1_N,
      RSB1_P => RSB1_P,
      RSB1_N => RSB1_N,
      RDC1_P => RDC1_P,
      RDC1_N => RDC1_N,
      RSC1_P => RSC1_P,
      RSC1_N => RSC1_N,
      RDD1_P => RDD1_P,
      RDD1_N => RDD1_N,
      RSD1_P => RSD1_P,
      RSD1_N => RSD1_N,

      INA1_P => INA1_P,
      INA1_N => INA1_N,

      INB1_P => INB1_P,
      INB1_N => INB1_N,
      INC1_P => INC1_P,
      INC1_N => INC1_N,
      IND1_P => IND1_P,
      IND1_N => IND1_N,

      DI1 => DI1,

      DI2 => DI2,

      DI3 => DI3,
      DI4 => DI4,
      STR1 => STR1,

      STR2 => STR2,
      STR3 => STR3,
      STR4 => STR4,
      MCLK1_P => mclk_p,
      MCLK1_N => mclk_n,

      TDCCLK2_P => tdc_clk_p,
      TDCCLK2_N => tdc_clk_n,

      RDA2_P => RDA2_P,
      RDA2_N => RDA2_N,
      RSA2_P => RSA2_P,
      RSA2_N => RSA2_N,
      RDB2_P => RDB2_P,
      RDB2_N => RDB2_N,
      RSB2_P => RSB2_P,
      RSB2_N => RSB2_N,
      RDC2_P => RDC2_P,
      RDC2_N => RDC2_N,
      RSC2_P => RSC2_P,
      RSC2_N => RSC2_N,
      RDD2_P => RDD2_P,
      RDD2_N => RDD2_N,
      RSD2_P => RSD2_P,
      RSD2_N => RSD2_N,

      INA2_P => INA2_P,
      INA2_N => INA2_N,
      INB2_P => INB2_P,
      INB2_N => INB2_N,
      INC2_P => INC2_P,
      INC2_N => INC2_N,
      IND2_P => IND2_P,
      IND2_N => IND2_N,
      DI5 => DI5,
      DI6 => DI6,
      DI7 => DI7,
      DI8 => DI8,
      STR5 => STR5,
      STR6 => STR6,
      STR7 => STR7,
      STR8 => STR8,
      MCLK2_P => mclk_p,
      MCLK2_N => mclk_n,

      TDCCLK3_P => tdc_clk_p,
      TDCCLK3_N => tdc_clk_n,

      RDA3_P => RDA3_P,
      RDA3_N => RDA3_N,
      RSA3_P => RSA3_P,
      RSA3_N => RSA3_N,
      RDB3_P => RDB3_P,
      RDB3_N => RDB3_N,
      RSB3_P => RSB3_P,
      RSB3_N => RSB3_N,
      RDC3_P => RDC3_P,
      RDC3_N => RDC3_N,
      RSC3_P => RSC3_P,
      RSC3_N => RSC3_N,
      RDD3_P => RDD3_P,
      RDD3_N => RDD3_N,
      RSD3_P => RSD3_P,
      RSD3_N => RSD3_N,

      INA3_P => INA3_P,
      INA3_N => INA3_N,
      INB3_P => INB3_P,
      INB3_N => INB3_N,
      INC3_P => INC3_P,
      INC3_N => INC3_N,
      IND3_P => IND3_P,
      IND3_N => IND3_N,
      DI9 => DI9,
      DI10 => DI10,
      DI11 => DI11,
      DI12 => DI12,
      STR9 => STR9,
      STR10 => STR10,
      STR11 => STR11,
      STR12 => STR12,
      MCLK3_P => mclk_p,
      MCLK3_N => mclk_n,

      SCK => SCK,
      MISO => MISO,
      MOSI => MOSI,
      CS => CS,

      RST => rst_n,
      IRQ => IRQ,
      AT0_P => AT0_P,
      AT0_N => AT0_N,
      AT1_P => AT1_P,
      AT1_N => AT1_N,
      TT0_P => TT0_P,
      TT0_N => TT0_N,
      TT1_P => TT1_P,
      TT1_N => TT1_N,

      HMOSI => HMOSI,
      HMISO => HMISO,
      HSCK => HSCK,
      HSEL => HSEL,
      
      LA0 => LA0,
      LA1 => LA1,
      LA2 => LA2,
      LA3 => LA3,
      LACK0 => LACK0,
      LACK1 => LACK1,
      LACK2 => LACK2,
      LACK3 => LACK3,

      EVNT => EVNT,

      LED1 => LED1,
      LED2 => LED2,
      LED3 => LED3,
      LED4 => LED4,

      MGTCLK_P => mgt_clk_p,
      MGTCLK_N => mgt_clk_n,
      GBT_RX_P => GBT_RX_P,
      GBT_RX_N => GBT_RX_N,
      GBT_TX_P => GBT_TX_P,
      GBT_TX_N => GBT_TX_N,

      FSEL => FSEL,
      FMOSI => FMOSI,
      FMISO => FMISO
    );

  trig_rec_inst : entity work.trig_rec
  port map (
    AT0_i => AT0_P,
    AT1_i => AT1_P,
    TT0_i => TT0_P,
    TT1_i => TT1_P
  );

end architecture;