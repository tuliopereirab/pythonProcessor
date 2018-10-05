library ieee;
use ieee.std_logic_1164.all;

entity regOverflow is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		clk					: in std_logic;
		ctrl_regOverflow	: in std_logic;
		entrada_regOverflow	: in std_logic;
		saida_regOverflow	: out std_logic
	);
end entity;

architecture registerOverflow of regOverflow is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regOverflow='1') then
				saida_regOverflow <= entrada_regOverflow;
			end if;
		end if;
	end process;
end registerOverflow;