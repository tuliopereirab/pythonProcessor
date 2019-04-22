library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memInstr is
	generic
	(
		DATA_WIDTH	: natural	:= 16;
		END_WIDTH	: natural	:= 24;
		DATA_OUT	: natural	:= 8
	);

	port
	(
		entrada_pc		: in std_logic_vector((END_WIDTH-1) downto 0);
		saida_opCode	: out std_logic_vector((DATA_OUT-1) downto 0);
		saida_opArg		: out std_logic_vector((DATA_OUT-1) downto 0);
		saida_regJump	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcMemInstr of memInstr is
subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);   -- largura palavra
type memory_t is array(2**END_WIDTH-1 downto 0) of word_t;   -- largura do endereço (criação do array)
signal memInstr		: memory_t;
attribute ram_init_file	: string;
attribute ram_init_file of memInstr	: signal is "iniciarMemInstr.mif";

signal addr_reg	: natural range 0 to 2**END_WIDTH-1;
signal endereco_convert	: natural range 0 to 2**END_WIDTH-1;

signal instrFull	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
		endereco_convert <= to_integer(unsigned(entrada_pc));

		instrFull <= memInstr(endereco_convert);
		saida_opArg <= instrFull(DATA_WIDTH-1 downto DATA_OUT);
		saida_opCode <= instrFull(DATA_OUT-1 downto 0); -- MODELO DE INSTRUÇÃO: OPARG + OPCODE
		saida_regJump <= instrFull(DATA_WIDTH-1 downto 0);
end arcMemInstr;
