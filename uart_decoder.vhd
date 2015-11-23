LIBRARY IEEE;
use ieee.std_logic_1164.all;

entity uart_decoder is

port(
      data_in: in std_logic_vector (7 downto 0);
      control_out: out std_logic_vector (2 downto 0)
   );
end uart_decoder ;

architecture bhv of uart_decoder is

begin

	process(data_in)
	begin
		case data_in is
        when "01000001" => control_out <= "111";
        when "01000010" => control_out <= "001";
        when "01001101" => control_out <= "100";
        when others => control_out <= "000";
		end case;
	end process;
end bhv;
