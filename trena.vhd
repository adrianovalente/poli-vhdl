library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity trena is
  port(
    clk: in std_logic;
    echo_time: out integer range 0 to 24000;
    trigger: out std_logic;
    echo: in std_logic;
    alg0, alg1, alg2: out std_logic_vector(3 downto 0)
  );
end trena;

architecture structural of trena is
  signal counter, distancia: integer range 0 to 24000;
begin

  triggerGenerator: entity work.triggerGenerator(bhv)
    port map(
      clk=>clk,
      rst=>'1',
      pwm=>open
    );

  triggerCounter: entity work.triggerCounter(bhv)
    port map(
      clk=>clk,
      echo=>echo,
      counter=>counter
    );

  reg: entity work.hexReg(bhv)
  port map(
    grava=>not echo,
    d=>counter,
    q=>distancia
  );

  calc: entity work.calc(seila)
  port map(
    time_in=>distancia,
    alg0=>alg0,
    alg1=>alg1,
    alg2=>alg2
  );

  controller: entity work.controlUnit(arch)
  port map(
    clk=>clk,
    echo=>echo,
    enable=>'1',
    trigger=>trigger,
    enviar=>open,
    max_value=>open,
    angulo_out=>open
  );

echo_time <= distancia;

end structural;
