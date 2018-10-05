library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memExt is
	generic
	(
		DATA_WIDTH	: natural	:= 8;
		END_WIDTH	: natural 	:= 8
	);
	
	port
	(
		clk				: in std_logic;
		ctrl_memExt		: in std_logic;
		entrada_write	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_addr	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_read		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcMemExt of memExt is 
subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
type memory_t is array(2**END_WIDTH-1 downto 0) of word_t;
signal ram		: memory_t;
attribute ram_init_file	: string;
attribute ram_init_file of ram	: signal is "iniciarMemoriaExt.mif";
	
signal addr_reg	: natural range 0 to 2**END_WIDTH-1;
signal endereco_convert	: natural range 0 to 2**END_WIDTH-1;

begin
	endereco_convert <= to_integer(unsigned(entrada_addr));
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_memExt='1') then
				ram(endereco_convert) <= entrada_write;
			end if;
		end if;
	end process;
	
	saida_read <= ram(endereco_convert);			-- MEMORIA EXTERNA SEMPRE ESTARÁ LENDO!
	
end arcMemExt;