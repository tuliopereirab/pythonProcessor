library ieee;
use ieee.std_logic_1164.all;

entity regDataReturn is
	generic
	(
		DATA_WIDTH	: natural := 8
	);
	
	port
	(
		clk					: in std_logic;
		ctrl_regDataReturn			: in std_logic;
		entrada_readPilha		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxPilha		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerDataReturn of regDataReturn is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regDataReturn='1') then
				saida_muxPilha <= entrada_readPilha;
			end if;
		end if;
	end process;
end registerDataReturn;