library ieee;
use ieee.std_logic_1164.all;

entity muxTos is
	generic 
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		ctrl_muxTos		: in std_logic;
		entrada_Ula	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_Tos	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Tos	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture arcMuxTos of muxTos is
begin
	saida_Tos <= entrada_Ula when (ctrl_muxTos='0') else
					entrada_Tos;
end arcMuxTos;