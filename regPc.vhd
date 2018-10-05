library ieee;
use ieee.std_logic_1164.all;

entity regPc is
	generic
	(
		DATA_WIDTH	: natural := 8
	);
	
	port
	(
		clk				: in std_logic;
		reset				: in std_logic;
		ctrl_regPc		: in std_logic;
		entrada_regPc	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regPc		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerPc	of regPc is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset='1') then
				saida_regPc <= "00000000";
			elsif(ctrl_regPc='1') then
				saida_regPc <= entrada_regPc;
			end if;
		end if;
	end process;
end registerPc;