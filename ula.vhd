library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity Ula is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		sel_Ula				: in std_logic_vector(2 downto 0);
		entrada_Op1			: in std_logic_vector((DATA_WIDTH-1) downto 0);     
		entrada_Op2			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Result		: out std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_RegComp		: out std_logic;
		saida_regOverflow	: out std_logic
	);
end entity;

architecture Ula1 of ula is
signal s_add, s_sub, saida_interna	: std_logic_vector((DATA_WIDTH-1) downto 0);
signal saida_comparacao, saida_overflow	: std_logic;
signal s_igual, s_menor, s_maior  : std_logic;
signal s_mult, s_div 	: std_logic_vector(15 downto 0); -- PARA MULTIPLIÇÃO, DOBRO DE DATA_WIDTH
begin
	s_add		<= entrada_Op2 + entrada_Op1;
	s_sub		<= entrada_Op2 - entrada_Op1;
	s_mult	<= entrada_Op2 * entrada_Op1;    
	s_div		<= "0000000000000000"; -- entrada_Op1 / entrada_Op2;     ERRO DIVISÃO!
	
	
	s_igual <= '1' when (entrada_Op2=entrada_Op1) else
	           '0';
	s_menor <= '1' when (entrada_Op2<entrada_Op1) else
	           '0';
	s_maior <= '1' when (entrada_Op2>entrada_Op1) else
	           '0';           
	           
	
	saida_interna <= s_add when (sel_Ula="000") else
						  s_sub when (sel_Ula="001") else
						  s_mult(7 downto 0) when (sel_Ula="010") else
						  s_div(7 downto 0) when (sel_Ula="011") else
						  "00000000";
	saida_comparacao <= s_igual when (sel_Ula="100") else
	                    s_menor when (sel_Ula="101") else
	                    s_maior when (sel_Ula="110") else
	                    '0';				
	saida_overflow <= '1' when ((sel_Ula="010") AND (s_mult(15 downto 8)/="00000000")) else		-- controle de overflow para multiplicação
							'1' when ((entrada_Op2>entrada_Op1) AND (sel_Ula="001")) else       -- controle de overflow para subtração 
							'0';
								
	---------------------------------------------------------------
	
	saida_RegComp <= saida_comparacao when (sel_Ula(2)='1') else
						  '0';
						  
	saida_Result <= saida_interna when (sel_Ula(2)='0') else
						 "00000000";
						 
	saida_regOverflow <= saida_overflow;	
	
end ula1;