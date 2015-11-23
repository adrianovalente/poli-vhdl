library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pwmGenerator is
  port (
    clk, rst, entra: in std_logic;
    pwm: out std_logic;
    ct: out integer range 0 to 1000000
  );
end pwmGenerator;

architecture bhv of pwmGenerator is
  shared variable counter : integer range 0 to 1000000 := 0;
  shared variable max_cycles_value : integer range 0 to 120000 := 30000;
  shared variable state_counter : integer range 0 to 180 := 0;
  shared variable direction : integer range -1 to 1 := 1; 
  signal mudar: std_logic;

begin
  
  baud_gen_unit: entity work.mod_m_divisor(arch)
      generic map(N=>1000000)
      port map(clk=>clk, max_tick=>mudar);
  
  -- counter update
  process(clk, rst)
  begin
    if clk'event and clk = '0' then
      if rst = '1' then
        counter := counter + 1;
      else
        counter := 0;
      end if;
      ct <= counter;
    end if;
    
    if (counter > max_cycles_value) then
      pwm <= '0';
    else
      pwm  <= '1';
    end if;
    
  end process;

  -- reference update
  process(clk)
  begin
    if mudar'event and mudar='1' then
	  max_cycles_value := 30000 + 500 * state_counter;
	  if(state_counter = 180) then
			direction := -1;
	  elsif(state_counter = 0) then
            direction := 1;
	  end if;
	  state_counter := state_counter + direction;
    
    end if;
  end process;

end bhv;
