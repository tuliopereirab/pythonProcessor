library ieee;
use ieee.std_logic_1164.all;

entity regEnd is
	generic
	(
		DATA_WIDTH	: natural := 16
	);

	port
	(
		clk				: in std_logic;
		ctrl_regEnd		: in std_logic;
		entrada_regEnd	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regEnd	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerEnd of regEnd is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regEnd='1') then
				saida_regEnd <= entrada_regEnd;
			end if;
		end if;
	end process;
end registerEnd;
