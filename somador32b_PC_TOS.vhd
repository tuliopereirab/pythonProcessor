library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity somador32b_PC_TOS is
	generic
	(
		DATA_WIDTH	: natural	:= 32;
		INCREMENTA_WIDTH	: natural	:= 8
	);
	port 
	(
		ctrl_somador32b	: in std_logic_vector(1 downto 0);
		valPc_in	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		valIncrementa_in	: in std_logic_vector((INCREMENTA_WIDTH-1) downto 0);
		valPc_out	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture rtl_somador32b of somador32b_PC_TOS is
signal valIncrementa_32b, soma, subtracao: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	valIncrementa_32b((DATA_WIDTH-1) downto 8) <= "000000000000000000000000";
	valIncrementa_32b(7 downto 0) <= valIncrementa_in;
	
	soma <= valPc_in + valincrementa_32b;
	subtracao <= valPc_in - valIncrementa_32b;
	
	valPc_out <= soma when (ctrl_somador32b="00") else
					 valIncrementa_32b when (ctrl_somador32b="11") else
					 subtracao when (ctrl_somador32b="01") else
					 "00000000000000000000000000000000";
	
end rtl_somador32b;