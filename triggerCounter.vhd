library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity triggerCounter is
  port (echo, clk: in std_logic;
        counter:  out integer range 0 to 24000
  );
end triggerCounter;

architecture bhv of triggerCounter is
  signal count: integer range 0 to 1200000 := 0;
begin
  process(clk, echo)
  begin

    -- incrementando o contador
    if clk'event and clk='1' then
      if echo='1' then
        if count = 1199999 then
          count <= 0;
        else
          count <= count + 1;
        end if;
      else
        count <= 0;
      end if;
    end if;

  end process;

  -- Precisa dividir por 50 para ter o valor em milisegundos.
  counter <= count/50;
end bhv;
