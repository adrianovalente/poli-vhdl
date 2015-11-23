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
      CLK:					in std_logic;
      KEY:					in std_logic_vector(1 downto 0);
      UART_RXD:				in std_logic;
      SW:					in std_logic_vector(7 downto 0);
	  LEDR:					out std_logic_vector(7 downto 0);
	  LEDG:					out std_logic_vector(7 downto 0);
      HEX0:					out std_logic_vector(6 downto 0);
      HEX1:					out std_logic_vector(6 downto 0);
      HEX2:					out std_logic_vector(6 downto 0);
      HEX3:					out std_logic_vector(6 downto 0);
      UART_TXD:				out std_logic;
      GPIO_0: 				out std_logic_vector(1 downto 0)
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
   signal controle_servo: std_logic_vector (2 downto 0);
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
               wr=>edge_detector_tx_output, w_data=>SW, empty=>tx_empty,
               full=>open, r_data=>tx_fifo_out);
               
   uart_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>CLK, reset=>(not KEY(0)),
               tx_start=>tx_fifo_not_empty,
               s_tick=>tick, din=>tx_fifo_out,
               tx_done_tick=> tx_done_tick, tx=>UART_TXD);
	  
   edge_detector_tx: entity work.custom_edge_detector(arch)
	  port map(clk=>CLK, signal_in=>wr, output=>edge_detector_tx_output);
	  
   decoder0: entity work.hex7seg(hex7seg)
	  port map(rx_data_out(3), rx_data_out(2), rx_data_out(1), rx_data_out(0),
			   HEX0(0), HEX0(1), HEX0(2), HEX0(3), HEX0(4), HEX0(5), HEX0(6));
						
   decoder1: entity work.hex7seg(hex7seg)
      port map(rx_data_out(7), rx_data_out(6), rx_data_out(5), rx_data_out(4),
			   HEX1(0), HEX1(1), HEX1(2), HEX1(3), HEX1(4), HEX1(5), HEX1(6));
						
   decoder2: entity work.hex7seg(hex7seg)
      port map(read_data_in(3), read_data_in(2), read_data_in(1), read_data_in(0),
			   HEX2(0), HEX2(1), HEX2(2), HEX2(3), HEX2(4), HEX2(5), HEX2(6));
						
   decoder3: entity work.hex7seg(hex7seg)
      port map(read_data_in(7), read_data_in(6), read_data_in(5), read_data_in(4),
			   HEX3(0), HEX3(1), HEX3(2), HEX3(3), HEX3(4), HEX3(5), HEX3(6));																		
   
   
   uart_decoder: entity work.uart_decoder(bhv)
	port map(rx_data_out, controle_servo);
   
   pwdGenerator: entity work.pwdGenerator(bhv)
	port map(clk=>CLK, rst=>'1', entra=>not rx_done_tick, chaves=>controle_servo, ct=>open, pwm=>GPIO_0(0));
   
   wr <= not KEY(1);
   tx_fifo_not_empty <= not tx_empty;
   
   --LEDR(6) <= read_data_in(7);
   LEDG(6) <= rd;
   LEDG(7) <= tx_fifo_not_empty;
end str_arch;