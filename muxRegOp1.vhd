library ieee;
use ieee.std_logic_1164.all;

entity muxRegOp1 is
	generic 
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		ctrl_muxRegOp1		: in std_logic;
		entrada_regArg	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_regOp1	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxRegOp1	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcMuxOp1 of muxRegOp1 is
begin
	saida_muxRegOp1 <= entrada_regOp1 when (ctrl_muxRegOp1='0') else
							 entrada_regArg;
end arcMuxOp1;