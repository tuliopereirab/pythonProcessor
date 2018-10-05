library ieee;
use ieee.std_logic_1164.all;

entity muxOp2 is
	generic
	(
		DATA_WIDTH	: natural := 8
	);
	
	port
	(
		sel_MuxOp2			: in std_logic_vector(1 downto 0);
		entr_regTos			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regPc			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regOp2			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regArg			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxOp2		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture mux2 of muxOp2 is
begin
	saida_muxOp2 <= entr_regOp2 when (sel_MuxOp2="11") else
						 entr_regPc when (sel_MuxOp2="00") else
						 entr_regTos when (sel_MuxOp2="01") else
						 entr_regArg;
						 
end mux2;