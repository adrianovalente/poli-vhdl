library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity custom_edge_detector is
      port ( clk         : in  STD_LOGIC;
             signal_in   : in  STD_LOGIC;
             output      : out  STD_LOGIC
      );
end custom_edge_detector;

architecture arch of custom_edge_detector is
     signal signal_d : STD_LOGIC;
begin
    process(clk)
    begin
         if rising_edge(clk) then
               signal_d <= signal_in;
         end if;
    end process;
    output <= (not signal_d) and signal_in; 
end arch;