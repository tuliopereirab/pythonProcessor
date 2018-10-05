library ieee;
use ieee.std_logic_1164.all;

entity regArg is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		clk						: in std_logic;
		ctrl_regArg				: in std_logic;
		entrada_regArg			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regArg_toCtrl	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regArg			: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerArg of regArg is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regArg='1') then
				saida_regArg <= entrada_regArg;
				saida_regArg_toCtrl <= entrada_regArg;
			end if;
		end if;
	end process;
end registerArg;