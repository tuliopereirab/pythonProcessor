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
		saida_regOp1		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerOp1 of regOp1 is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regOp1='1') then
				saida_regOp1 <= entrada_regOp1;
			end if;
		end if;
	end process;
end registerOp1;