library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity hexReg is
  port(
    grava: in std_logic;
    d: in integer range 0 to 24000;
    q: out integer range 0 to 24000
  );
end hexReg;

architecture bhv of hexReg is
  signal value: integer range 0 to 24000;
begin

  process(grava)
  begin
    if grava'event and grava='1' then
      value <= d;
    end if;
  end process;

  q <= value;
end bhv;
