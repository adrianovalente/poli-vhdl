library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity asciiConverter is
  port(
    alg_in: in std_logic_vector (3 downto 0);
    ascii_out: out std_logic_vector (7 downto 0)
  );

end asciiConverter;

architecture arch of asciiConverter is
begin
  process(alg_in)
  begin
    case alg_in is

      when "0000" =>
        ascii_out <= "00110000";

      when "0001" =>
        ascii_out <= "00110001";

      when "0010" =>
        ascii_out <= "00110010";

      when "0011" =>
        ascii_out <= "00110011";

      when "0100" =>
        ascii_out <= "00110100";

      when "0101" =>
        ascii_out <= "00110101";

      when "0110" =>
        ascii_out <= "00110110";

      when "0111" =>
        ascii_out <= "00110111";

      when "1000" =>
        ascii_out <= "00111000";

      when "1001" =>
        ascii_out <= "00111001";

      when "1010" =>
        ascii_out <= "01000111"; -- GREEN

      when "1011" =>
        ascii_out <= "01011001"; -- YELLOW

      when "1111" =>
        ascii_out <= "01010010"; -- RED

      when "1101" =>
        ascii_out <= "00101100"; -- VIRGULA

      when "1100" =>
        ascii_out <= "00101110"; -- PONTO FINAL

      when others =>
        ascii_out <= "00111111";

    end case;
  end process;
end arch;
