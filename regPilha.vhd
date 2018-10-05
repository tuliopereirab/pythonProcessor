library ieee;
use ieee.std_logic_1164.all;

entity regPilha is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		clk						: in std_logic;
		ctrl_regPilha_Write	: in std_logic;
		ctrl_regPilha_Saida	: in std_logic;
		entrada_Mux				: in std_logic_vector((DATA_WIDTH-1) downto 0);			 -- liga com saida write
		entrada_Read			: in std_logic_vector((DATA_WIDTH-1) downto 0);        -- liga com saida operandos
		saida_Operandos		: out std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Write				: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture registerPilha of regPilha is
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regPilha_Saida='1') then
				saida_Operandos <= entrada_Read;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(ctrl_regPilha_Write='1') then
				saida_Write <= entrada_Mux;
			end if;
		end if;
	end process;
end registerPilha;