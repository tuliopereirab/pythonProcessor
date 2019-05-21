library ieee;
use ieee.std_logic_1164.all;

entity regTos is
	generic
	(
		DATA_WIDTH	: natural := 16
	);

	port
	(
		clk				: in std_logic;											-- clk
		reset			: in std_logic;											-- data_in_2
		ctrl_regTos		: in std_logic;											-- ctrl_in
		entrada_regTos	: in std_logic_vector((DATA_WIDTH-1) downto 0);			-- data_in_1
		saida_regTos	: out std_logic_vector((DATA_WIDTH-1) downto 0)			-- data_out
	);
end entity;

architecture registerTos of regTos is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset='1') then
				saida_regTos <= "0000000000000000";   -- 24 bits
			elsif(ctrl_regTos='1') then
				saida_regTos <= entrada_regTos;
			end if;
		end if;
	end process;
end registerTos;
