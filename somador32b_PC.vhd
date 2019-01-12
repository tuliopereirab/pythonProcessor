library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity somador32b_PC is
	generic
	(
		DATA_WIDTH	: natural	:= 32;
		INCREMENTA_WIDTH	: natural	:= 8
	);
	port 
	(
		ctrl_somador32b	: in std_logic;
		valPc_in	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		valIncrementa_in	: in std_logic_vector((INCREMENTA_WIDTH-1) downto 0);
		valPc_out	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture rtl_somador32b of somador32b is
signal valIncrementa_32b, valPc_saida_interna	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	valIncrementa_32b((DATA_WIDTH-1) downto 8) <= "000000000000000000000000";
	valIncrementa_32b(7 downto 0) <= valIncrementa_in;
	
	valPc_saida_interna <= valPc_in + valincrementa_32b;
	
	valPc_out <= valPc_saida_interna when (ctrl_somador32b='0') else
					 valIncrementa_32b;
	
end rtl_somador32b;