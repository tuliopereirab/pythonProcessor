library ieee;
use ieee.std_logic_1164.all;

entity muxPc is
	generic
	(
		DATA_WIDTH	: natural	:= 24
	);

	port
	(
		ctrl_muxPc		: in std_logic;
		entrada_Ula	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_Pilha	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Pc	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcMuxPc of muxPc is
begin
	saida_Pc <= entrada_Ula when (ctrl_muxPc='0') else
					entrada_Pilha;
end arcMuxPc;
