library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

entity trig_rec is
    generic (
        g_file_name : string := "trig.txt"
        
    );
    port (
        AT0_i : in std_logic;
        AT1_i : in std_logic;
        TT0_i : in std_logic;
        TT1_i : in std_logic
    );
end entity;

architecture rtl of trig_rec is
  constant clk_320_period : time := 3.125ns;
  
  signal s_clk_320 : std_logic := '0';
  signal s_clk_en : std_logic :='0';

begin

  process(all)
  begin
    if rising_edge(AT0_i) then
      s_clk_en <= '1';
    end if;
  end process;

  s_clk_320 <= not s_clk_320 after clk_320_period/2 when s_clk_en = '1' else '0';


  -- Main process 
  process (all)
    file trg_file  : text open write_mode is g_file_name;
    variable output_line : line;
    variable now_time : time;
    
    variable v_cnt_value : unsigned(2 downto 0) := (others => '0'); 
    variable v_sync : std_logic := '0';
    variable v_data_vector : std_logic_vector(7 downto 0) := (others => '0'); 


  begin
    if rising_edge(s_clk_320) then
      v_cnt_value := v_cnt_value + 1;

      v_data_vector(7 downto 1) := v_data_vector(6 downto 0);
      v_data_vector(0) := AT0_i;

      if v_cnt_value = 0 then
        if v_data_vector = x"40" then
          v_sync := '1';
        end if;

        if (v_sync = '1') then
          if (v_data_vector /= x"40") then
            now_time := now;
            write(output_line, now_time);-- & to_hstring(v_data_vector));
            writeline(trg_file, output_line);
          end if;
        end if;
      end if;
      
    end if;
  end process;

    

end architecture;