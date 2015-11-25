library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity calc is
  port(
    time_in: in integer range 0 to 24000;
    alg0, alg1, alg2, color: out std_logic_vector(3 downto 0);
    distancia: out integer range 0 to 512;
    alerta: out std_logic
  );
end calc;

architecture seila of calc is
  signal dist: integer range 0 to 512;
  signal first, second: integer range 0 to 512;
begin

  dist <= time_in/58;
  distancia <= dist;
  alg0 <= std_logic_vector(to_unsigned(dist mod 10, alg0'length));
  first <= dist/10;
  alg1 <= std_logic_vector(to_unsigned(first mod 10, alg1'length));
  second <= first/10;
  alg2 <= std_logic_vector(to_unsigned(second mod 10, alg2'length));
  process(dist)
    begin
      if dist<20 then
        color <= "1111";
        alerta <= '1';
      else
        if dist<40 then
          color <= "1011";
          alerta <= '0';
        else
          color <= "1010";
          alerta <= '0';
        end if;
      end if;
    end process;

end seila;
