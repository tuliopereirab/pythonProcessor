library ieee;
use ieee.std_logic_1164.all;

entity regComp is
	generic
	(
		DATA_WIDTH	: natural 	:= 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regComp 		: in std_logic;
		entrada_regComp		: in std_logic;
		saida_regComp		: out std_logic
	);
end entity;

architecture registerComp of regComp is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regComp='1') then
				saida_regComp <= entrada_regComp;
			end if;
		end if;
	end process;
end registerComp;
