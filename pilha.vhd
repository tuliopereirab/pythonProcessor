library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity pilha is
	generic
	(
		DATA_WIDTH	:	natural	:= 8;
		END_WIDTH	:	natural	:= 24
	);

	port
	(
		clk				: in std_logic;
		ctrl_pilha		: in std_logic;
		entrada_tos		: in std_logic_vector((END_WIDTH-1) downto 0);
		entrada_write	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_read		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcPilha of pilha is
subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
type memory_t is array(2**END_WIDTH-1 downto 0) of word_t;
signal pilha		: memory_t;
--attribute pilha_init_file	: string;
--attribute pilha_init_file of pilha	: signal is "iniciarPilha.mif";

signal addr_reg	: natural range 0 to 2**END_WIDTH-1;
signal endereco_read	: natural range 0 to 2**END_WIDTH-1;

signal end_write	:	natural range 0 to 2**END_WIDTH-1;

begin
	endereco_read <= to_integer(unsigned(entrada_tos));
	end_write <= endereco_read + 0;


	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_pilha='1') then
				pilha(end_write) <= entrada_write;
			end if;
		end if;
	end process;

	saida_read <= pilha(end_write);
end arcPilha;
