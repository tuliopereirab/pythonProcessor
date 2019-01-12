library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity somador32b_TOS is
	generic
	(
		DATA_WIDTH	: natural	:= 32
	);
	port 
	(
		ctrl_somadorTos	: in std_logic;
		valTos_in	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		valTos_out	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture rtl_somador32b of somador32b is
signal soma, sub	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	soma <= valTos_in + "00000000000000000000000000000001";
	sub <= valTos_in - "00000000000000000000000000000001";
	
	valTos_out <= soma when (ctrl_somadorTos='0') else
					  sub;
	
end rtl_somador32b;