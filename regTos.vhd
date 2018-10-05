library ieee;
use ieee.std_logic_1164.all;

entity regTos is
	generic
	(
		DATA_WIDTH	: natural := 8
	);
	
	port
	(
		clk				: in std_logic;
		reset				: in std_logic;
		ctrl_regTos		: in std_logic;
		entrada_regTos	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regTos	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerTos of regTos is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset='1') then
				saida_regTos <= "00000000";
			elsif(ctrl_regTos='1') then
				saida_regTos <= entrada_regTos;
			end if;
		end if;
	end process;
end registerTos;