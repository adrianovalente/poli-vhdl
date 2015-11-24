-- code from Pong Chu - FPGA Prototyping by VHDL Examples
-- Listing 4.11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_m_divisor is
   generic(
      N: integer := 4     -- count

  );
   port(
      clk: in std_logic;
      max_tick: out std_logic

   );
end mod_m_divisor;

architecture arch of mod_m_divisor is
  shared variable counter : integer range N-1 downto 0 := 0 ;
begin
   -- register
   process(clk)
   begin
      if (clk'event and clk='1') then
         counter := counter + 1;
      end if;
   end process;
   -- next-state logic
   max_tick <= '1' when counter=(N-1) else '0';
end arch;
