library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity somador_subtrator is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		sel_somaSub				: in std_logic;
		entrada			: in std_logic_vector((DATA_WIDTH-1) downto 0);     
		saida		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcSoma_Sub of somador_subtrator is
signal s_add, s_sub	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	s_add		<= entrada + "00000001";
	s_sub		<= entrada - "00000001";
	
	           
	
	saida <= s_add when (sel_SomaSub='0') else
						  s_sub;
	
end arcSoma_Sub;