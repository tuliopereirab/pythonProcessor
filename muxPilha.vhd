library ieee;
use ieee.std_logic_1164.all;

entity muxPilha is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		sel_muxPilha		: in std_logic_vector(1 downto 0);
		entr_ULA			: in std_logic_vector(((DATA_WIDTH*2)-1) downto 0);     -- width = 24 bits
		entr_memInstr		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_memExt			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regDataReturn  : in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxPilha		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture muxPilh of muxPilha is
signal val_ula	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin
	val_ula <= entr_ULA((DATA_WIDTH-1) downto 0);
	saida_muxPilha <= val_ula when (sel_muxPilha="00") else
					  entr_memInstr when (sel_muxPilha="11") else
					  entr_memExt	when (sel_muxPilha="01") else
					  entr_regDataReturn;
end muxPilh;
