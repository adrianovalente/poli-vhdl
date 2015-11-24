library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity triggerGenerator is
  port (
    clk, rst: in std_logic;
    pwm: out std_logic
  );
end triggerGenerator;

architecture bhv of triggerGenerator is
  signal counter : integer range 0 to 625000 := 0;
  shared variable max_cycles_value : integer range 0 to 50000000 := 500;

begin

  -- counter update
  process(clk, rst)
  begin
    if clk'event and clk = '1' then
      if rst = '1' then
        counter <= counter + 1;
      else
        counter <= 0;
      end if;
    end if;
  end process;


    -- output logic
  process(counter)
  begin
    if (counter > max_cycles_value) then
      pwm <= '0';
    else
      pwm  <= '1';
    end if;
  end process;

end bhv;
