library ieee;
use ieee.std_logic_1164.all;

entity regOp1 is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regOp1			: in std_logic;
		entrada_regOp1		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regOp1		: out std_logic_vector(((DATA_WIDTH*2)-1) downto 0)
	);
end entity;

architecture registerOp1 of regOp1 is
signal saida_interna	: std_logic_vector(((DATA_WIDTH*2)-1) downto 0);
begin
	saida_interna <= "00000000" & entrada_regOp1;

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regOp1='1') then
				saida_regOp1 <= saida_interna;
			end if;
		end if;
	end process;
end registerOp1;
