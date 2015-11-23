-- code from Pong Chu - FPGA Prototyping by VHDL Examples
-- Listing 7.4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart is
   generic(
      -- Default setting:
      -- 19,200 baud, 8 data bis, 1 stop its, 2^2 FIFO
      DBIT: integer:=8;     -- # data bits
      SB_TICK: integer:=16; -- # ticks for stop bits, 16/24/32
                            --   for 1/1.5/2 stop bits
      DVSR: integer:= 162;  -- baud rate divisor
                            -- DVSR = 50M/(16*baud rate)
      DVSR_BIT: integer:=8; -- # bits of DVSR
      FIFO_W: integer:=1    -- # addr bits of FIFO
                            -- # words in FIFO=2^FIFO_W
   );
   port(
      CLK:					   in std_logic;
      KEY:					   in std_logic_vector(1 downto 0);
      UART_RXD:        in std_logic;
	    LEDR:				    out std_logic_vector(7 downto 0);
	    LEDG:					  out std_logic_vector(7 downto 0);
      UART_TXD:				out std_logic;

      ------- RADAR -------

      trigger: out std_logic;
      echo: in std_logic;
      pwm_motor: out std_logic


   );
end uart;

architecture str_arch of uart is
   signal tick: std_logic;
   signal rx_done_tick: std_logic;
   signal tx_fifo_out: std_logic_vector(7 downto 0);
   signal rx_data_out: std_logic_vector(7 downto 0);
   signal tx_empty, tx_fifo_not_empty: std_logic;
   signal tx_done_tick: std_logic;
   signal read_data_in: std_logic_vector(7 downto 0);
   signal rx_fifo_empty: std_logic;
   signal edge_detector_tx_output: std_logic;
   signal rd, wr: std_logic;

   -- RADAR --

   signal counter, distancia: integer range 0 to 24000;
   signal alg0, alg1, alg2, algarismo: std_logic_vector(3 downto 0);
   signal enviar: std_logic;
   signal saida_uart: std_logic_vector(7 downto 0);

begin
   baud_gen_unit: entity work.mod_m_counter(arch)
      generic map(M=>DVSR, N=>DVSR_BIT)
      port map(clk=>CLK, reset=>(not KEY(0)),
               q=>open, max_tick=>tick);

   uart_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>CLK, reset=>(not KEY(0)), rx=>UART_RXD,
               s_tick=>tick, rx_done_tick=>rx_done_tick,
               dout=>rx_data_out, reading=>LEDG(5));

   fifo_rx_unit: entity work.fifo(arch)
      generic map(B=>DBIT, W=>FIFO_W)
      port map(clk=>CLK, reset=>(not KEY(0)), rd=>NOT rx_fifo_empty,
               wr=>rx_done_tick, w_data=>rx_data_out,
               empty=>rx_fifo_empty, full=>LEDR(0), r_data=>read_data_in);

   fifo_tx_unit: entity work.fifo(arch)
      generic map(B=>DBIT, W=>FIFO_W)
      port map(clk=>CLK, reset=>(not KEY(0)), rd=>tx_done_tick,
               wr=>edge_detector_tx_output, w_data=>saida_uart, empty=>tx_empty,
               full=>open, r_data=>tx_fifo_out);

   uart_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>CLK, reset=>(not KEY(0)),
               tx_start=>tx_fifo_not_empty,
               s_tick=>tick, din=>tx_fifo_out,
               tx_done_tick=> tx_done_tick, tx=>UART_TXD);

   edge_detector_tx: entity work.custom_edge_detector(arch)
	  port map(clk=>CLK, signal_in=>wr, output=>edge_detector_tx_output);




   wr <= not KEY(1);
   tx_fifo_not_empty <= not tx_empty;

   LEDG(6) <= rd;
   LEDG(7) <= tx_fifo_not_empty;


   --------------------- RADAR LOGIC -----------------------

   pwmGenerator: entity work.pwmGenerator(bhv)
    port map(clk=>CLK, rst=>'1', pwm=>pwm_motor, ct=>open);


    triggerCounter: entity work.triggerCounter(bhv)
      port map(
        clk=>CLK,
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

    enviar_edge_detector: entity work.custom_edge_detector(arch)
    port map(clk=>CLK, signal_in=>not echo, output=>enviar);

    uartController: entity work.uartController(arch)
    port map(
      clk=>CLK,
      ja_enviou=>tx_done_tick,
      mandar=>enviar,
      uart_trigger=>wr,
      alg0=>alg0,
      alg1=>alg1,
      alg2=>alg2,
      ang2=>"0001",
      ang1=>"0110",
      ang0=>"0010",
      alg_enviar=>algarismo
    );

    asciiConverter: entity work.asciiConverter(arch)
    port map(alg_in=>algarismo, ascii_out=>saida_uart);

end str_arch;
