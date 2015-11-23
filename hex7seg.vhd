library ieee;
use ieee.std_logic_1164.all;

entity hex7seg is
	port (
		x3, x2, x1, x0 : in std_logic;
		a,b,c,d,e,f,g : out std_logic
	);
end hex7seg;

architecture hex7seg of hex7seg is
	signal a_to_g :  std_logic_vector(0 to 6);
begin
	
    a <= a_to_g(0);
    b <= a_to_g(1);
    c <= a_to_g(2);
    d <= a_to_g(3);
    e <= a_to_g(4);
    f <= a_to_g(5);
    g <= a_to_g(6);
    
	process (x3,x2,x1,x0)
		variable x: std_logic_vector(3 downto 0);
	begin
		x := x3&x2&x1&x0;
		case x is
			when "0000" => a_to_g <= "0000001"; -- 0
			when "0001" => a_to_g <= "1001111"; -- 1
			when "0010" => a_to_g <= "0010010"; -- 2
			when "0011" => a_to_g <= "0000110"; -- 3
			when "0100" => a_to_g <= "1001100"; -- 4
			when "0101" => a_to_g <= "0100100"; -- 5
			when "0110" => a_to_g <= "0100000"; -- 6
			when "0111" => a_to_g <= "0001101"; -- 7
			when "1000" => a_to_g <= "0000000"; -- 8
			when "1001" => a_to_g <= "0000100"; -- 9
			when "1010" => a_to_g <= "0001000"; -- A
			when "1011" => a_to_g <= "1100000"; -- B
			when "1100" => a_to_g <= "0110001"; -- C
			when "1101" => a_to_g <= "1000010"; -- D
			when "1110" => a_to_g <= "0110000"; -- E
			when others => a_to_g <= "0111000"; -- F
		end case;
	end process;
end hex7seg;