library ieee;
use ieee.std_logic_1164.all;

entity regMemExt is
	generic
	(
		DATA_WIDTH	: natural 	:= 8
	);
	
	port
	(
		clk							: in std_logic;
		ctrl_regMemExt_Write		: in std_logic;
		ctrl_regMemExt_Read		: in std_logic;
		entrada_RegPilha			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_Mem					: in std_logic_vector((DATA_WIDTH-1) downto 0); -- vem da memória (READ)
		saida_regPilha				: out std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Mem					: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerMemExt of regMemExt is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regMemExt_Read='1') then
				saida_regPilha <= entrada_Mem;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regMemExt_Write='1') then
				saida_Mem <= entrada_RegPilha;
			end if;
		end if;
	end process;
end registerMemExt;
	