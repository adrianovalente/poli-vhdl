library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity alertaRegister is
  port (
    rst, alerta, clk: in std_logic;
    alerta_out: in std_logic_vector(3 downto 0)
  );
end alertaRegister;

architecture arch of alertaRegister is

  signal algarismo: std_logic_vector(3 downto 0) := "0000";

begin
  process(clk)
  begin
    if clk'event and clk='1' then
      if rst='1' then
        algarismo <= "0000";
      else
        if alerta = '1' then
          algarismo <= "0001";
        end if;
      end if;
    end if;
  end process;

  alerta_out <= algarismo;
end arch;
