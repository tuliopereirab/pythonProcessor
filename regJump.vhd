library ieee;
use ieee.std_logic_1164.all;

entity regJump is
	generic
	(
		DATA_SAIDA	: natural := 24;
		DATA_HALF	: natural := 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regJump		: in std_logic;
		entrada_regArg		: in std_logic_vector((DATA_HALF-1) downto 0);
		entrada_memInstr	: in std_logic_vector(((DATA_HALF*2)-1) downto 0);
		saida_regJump		: out std_logic_vector((DATA_SAIDA-1) downto 0)
	);
end entity;

architecture registerJump of regJump is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regJump='1') then
				saida_regJump <= entrada_regArg & entrada_memInstr;
			end if;
		end if;
	end process;
end registerJump;
