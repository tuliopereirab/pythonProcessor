library ieee;
use ieee.std_logic_1164.all;

entity regJump is
	generic
	(
		DATA_SAIDA	: natural := 16;
		DATA_HALF	: natural := 8
	);

	port
	(
		clk					: in std_logic;											-- clk
		ctrl_regJump		: in std_logic;											-- ctrl_in
		entrada_regArg		: in std_logic_vector((DATA_HALF-1) downto 0);			-- data_in_1
		entrada_memInstr	: in std_logic_vector(((DATA_HALF*2)-1) downto 0);		-- data_in_2
		saida_regJump		: out std_logic_vector((DATA_SAIDA-1) downto 0)			-- data_out
	);
end entity;

architecture registerJump of regJump is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regJump='1') then
				saida_regJump <= entrada_memInstr;--entrada_regArg & entrada_memInstr;
			end if;
		end if;
	end process;
end registerJump;
