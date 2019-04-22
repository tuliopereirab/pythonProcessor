library ieee;
use ieee.std_logic_1164.all;

entity regOp2 is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk				: in std_logic;
		ctrl_regOp2		: in std_logic;
		entrada_regOp2	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regOp2	: out std_logic_vector(((DATA_WIDTH*3)-1) downto 0)
	);
end entity;

architecture registerOp2 of regOp2 is
signal saida_interna	: std_logic_vector(((DATA_WIDTH*3)-1) downto 0);
begin
	saida_interna <= "0000000000000000" & entrada_regOp2;
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regOp2='1') then
				saida_regOp2 <= saida_interna;
			end if;
		end if;
	end process;
end registerOp2;
