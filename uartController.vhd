library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity uartController is
  port (
    clk, ja_enviou, mandar: in std_logic;
    uart_trigger: out std_logic;
    alg0, alg1, alg2, ang2, ang1, ang0: in std_logic_vector(3 downto 0);
    alg_enviar: out std_logic_vector(3 downto 0)
  );
end uartController;

architecture arch of uartController is

  type state is (espera,
                prepara_2, envia_2,
                prepara_1, envia_1,
                prepara_0, envia_0,
                prepara_virgula, envia_virgula,
                prepara_ang_2, envia_ang_2,
                prepara_ang_1, envia_ang_1,
                prepara_ang_0, envia_ang_0,
                prepara_ponto, envia_ponto
                );

  signal current_state: state := espera;

begin

  -- next state logic
  process(mandar, clk)
  begin
    if clk'event and clk='1'then
      case current_state is

        when espera =>
          if mandar='1'then
            current_state <= prepara_ang_2;
          end if;

        when prepara_2 =>
          current_state <= envia_2;

        when envia_2 =>
          if ja_enviou = '1' then
            current_state <= prepara_1;
          end if;

        when prepara_1 =>
          current_state <= envia_1;

        when envia_1 =>
          if ja_enviou = '1' then
            current_state <= prepara_0;
          end if;

        when prepara_0 =>
          current_state <= envia_0;

        when envia_0 =>
          if ja_enviou = '1' then
            current_state <= prepara_ponto;
          end if;

        when prepara_virgula =>
          current_state <= envia_virgula;

        when envia_virgula =>
          if ja_enviou = '1' then
            current_state <= prepara_2;
          end if;

        when prepara_ang_2 =>
          current_state <= envia_ang_2;

        when envia_ang_2 =>
          if ja_enviou = '1' then
            current_state <= prepara_ang_1;
          end if;

        when prepara_ang_1 =>
          current_state <= envia_ang_1;

        when envia_ang_1 =>
          if ja_enviou = '1' then
            current_state <= prepara_ang_0;
          end if;

        when prepara_ang_0 =>
          current_state <= envia_ang_0;

        when envia_ang_0 =>
          if ja_enviou = '1' then
            current_state <= prepara_virgula;
          end if;

        when prepara_ponto =>
          current_state <= envia_ponto;

        when envia_ponto =>
          if ja_enviou = '1' then
            current_state <= espera;
          end if;

        when others =>
          current_state <= espera;

      end case;
    end if;
  end process;

  -- output logic
  process(current_state)
  begin
    case current_state is
      when espera =>
        alg_enviar   <= alg2;
        uart_trigger <= '0';

      when prepara_2 =>
        alg_enviar <= alg2;
        uart_trigger <= '0';

      when envia_2 =>
        alg_enviar <= alg2;
        uart_trigger <= '1';

      when prepara_1 =>
        alg_enviar <= alg1;
        uart_trigger <= '0';

      when envia_1 =>
        alg_enviar <= alg1;
        uart_trigger <= '1';

      when prepara_0 =>
        alg_enviar <= alg0;
        uart_trigger <= '0';

      when envia_0 =>
        alg_enviar <= alg0;
        uart_trigger <= '1';

      when prepara_virgula =>
        alg_enviar <= "1101";
        uart_trigger <= '0';

      when envia_virgula =>
        alg_enviar <= "1101";
        uart_trigger <= '1';

      when prepara_ang_2 =>
        alg_enviar <= ang2;
        uart_trigger <= '0';

      when envia_ang_2 =>
        alg_enviar <= ang2;
        uart_trigger <= '1';

      when prepara_ang_1 =>
        alg_enviar <= ang1;
        uart_trigger <= '0';

      when envia_ang_1 =>
        alg_enviar <= ang1;
        uart_trigger <= '1';

      when prepara_ang_0 =>
        alg_enviar <= ang0;
        uart_trigger <= '0';

      when envia_ang_0 =>
        alg_enviar <= ang0;
        uart_trigger <= '1';

      when prepara_ponto =>
        alg_enviar <= "1100";
        uart_trigger <= '0';

      when envia_ponto =>
        alg_enviar <= "1100";
        uart_trigger <= '1';

      when others =>
        alg_enviar <= "1111";
        uart_trigger <= '0';

    end case;
  end process;
end arch;