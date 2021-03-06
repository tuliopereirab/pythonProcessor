library ieee;
use ieee.std_logic_1164.all;

entity muxOp1 is
	generic
	(
		DATA_WIDTH	: natural := 16
	);

	port
	(
		sel_MuxOp1		: in std_logic_vector(1 downto 0);
		entr_regOp1		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regJump	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxOp1	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

-- só entra o regOp1 porque os outros valores serão adicionados manualmente como sinais internos, já que sera constantes;

architecture mux1 of muxOp1 is
signal val1, val0, valPilha	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	val1 <= "0000000000000001";         -- controle diretamente pela entrada no arquivo inicial
	val0 <= "0000000000000000";
	valPilha <= "0000000000000001";

	saida_muxOp1 <= entr_regOp1 when (sel_MuxOp1="11") else
						 val0 when (sel_MuxOp1="00") else
						 val1 when (sel_MuxOp1="01") else
						 entr_regJump;

end mux1;
