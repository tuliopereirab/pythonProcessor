library ieee;
use ieee.std_logic_1164.all;

entity regInstr is
	generic
	(
		DATA_WIDTH	: natural := 8 -- 8 bits do opcode 
	);
	
	port
	(
		clk					: in std_logic;
		ctrl_regInstr		: in std_logic;
		entrada_regInstr	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regInstr		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerInstr of regInstr is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regInstr='1') then
				saida_regInstr <= entrada_regInstr;
			end if;
		end if;
	end process;
end registerInstr;


