library ieee;
use ieee.std_logic_1164.all;

entity regTosFuncao is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk						: in std_logic;										-- clk
		reset					: in std_logic;										-- data_in_2
		ctrl_regTosFuncao		: in std_logic;										-- ctrl_in
		entrada_regTosFuncao	: in std_logic_vector((DATA_WIDTH-1) downto 0);		-- data_in_1
		saida_regTosFuncao		: out std_logic_vector((DATA_WIDTH-1) downto 0)		-- data_out
	);
end entity;

architecture registerTosFuncao of regTosFuncao is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset='1') then
				saida_regTosFuncao <= "00000000";
			elsif(ctrl_regTosFuncao='1') then
				saida_regTosFuncao <= entrada_regTosFuncao;
			end if;
		end if;
	end process;
end registerTosFuncao;
