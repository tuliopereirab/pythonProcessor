library ieee;
use ieee.std_logic_1164.all;

entity muxOp2 is
	generic
	(
		DATA_WIDTH	: natural := 24;
		LENGTH_REG_ARG	: natural := 8
	);

	port
	(
		sel_MuxOp2			: in std_logic_vector(1 downto 0);
		entr_regTos			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regPc			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regOp2			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regArg			: in std_logic_vector((LENGTH_REG_ARG-1) downto 0);
		saida_muxOp2		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture mux2 of muxOp2 is
signal intern_regArg	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	intern_regArg <= "0000000000000000" & entr_regArg;
	saida_muxOp2 <= entr_regOp2 when (sel_MuxOp2="11") else
						 entr_regPc when (sel_MuxOp2="00") else
						 entr_regTos when (sel_MuxOp2="01") else
						 intern_regArg;

end mux2;
