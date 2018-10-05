library ieee;
use ieee.std_logic_1164.all;

entity control is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);
	
	port
	(
		clk						: in std_logic;
		entrada_reset			: in std_logic;
		saida_reset 			: out std_logic;
		entrada_regComp		: in std_logic;
		entrada_regInstr		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_regArg			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_regOverflow	: in std_logic;
		ctrl_regOp1				: out std_logic;
		ctrl_regOp2				: out std_logic;
		ctrl_regPc				: out std_logic;
		ctrl_regComp			: out std_logic;
		ctrl_regOverflow		: out std_logic;
		ctrl_regTos				: out std_logic;
		ctrl_regInstr			: out std_logic;
		ctrl_regArg				: out std_logic;
		ctrl_regEnd				: out std_logic;
		ctrl_regPilha_WRITE	: out std_logic;
		ctrl_regPilha_SAIDA	: out std_logic;
		ctrl_regMemExt_WRITE	: out std_logic;
		ctrl_regMemExt_READ	: out std_logic;
		ctrl_pilha				: out std_logic;
		ctrl_memExt				: out std_logic;
		sel_MuxOp1				: out std_logic_vector(1 downto 0);
		sel_MuxOp2				: out std_logic_vector(1 downto 0);
		sel_MuxPilha			: out std_logic_vector(1 downto 0);
		sel_MuxRegOp1			: out std_logic;
		sel_ula					: out std_logic_vector(2 downto 0)
	);
end entity;

architecture arcControl	of control is

-- lc (LOAD_CONST), lf (LOAD_FAST), sf (STORE_FAST), co (COMPARE_OP), ja (JUMP_ABSOLUTE), jf (JUMP_FORWARD), b (BINARY_), pj_stay (FICA!), pj_jump (PULA!), pj_end (FINALIZA)
type state_type is (first, sAUX, lc1, lc2, lc3, lf1, lf2, lf3, lf4, sf1, sf2, sf3, sf4, sf5, pj_jump, pj_stay, pj_end, co1, co2, co3, co4, co4_AUX, co5_1, co5_2, co5_3, co5_AUX, co6, co7, co7_AUX, co8, jf1, jf2, b1, b2, b3, b3_AUX, b4_1, b4_2, b4_3, b4_4, b4_AUX, b5, b6, ja1, ja2);
signal atual 	: state_type;
signal verif_muxOp1, verif_muxOp2	: std_logic_vector(1 downto 0);
--signal sEntrada_regComp, sEntrada_regOverflow	: std_logic;
signal sEntrada_regInstr, sEntrada_regArg 	: std_logic_vector(7 downto 0);
begin	
	sEntrada_regArg <= entrada_regArg;
	--sEntrada_regComp <= entrada_regComp;
	sEntrada_regInstr <= entrada_regInstr;
	--sEntrada_regOverflow <= entrada_regOverflow;

	saida_reset <= entrada_reset;
	
	process(clk, entrada_reset, entrada_regComp, sEntrada_regInstr, sEntrada_regArg, entrada_regOverflow)
   begin
		if(entrada_reset='1') then
            atual <= first;
      elsif(rising_edge(clk)) then
			case atual is
				when first =>
					atual <= sAUX;
				when sAUX => 
					case sEntrada_regInstr is
						when "00001100" =>
							 atual <= lc1;
						when "00001101" =>
							 atual <= lf1;
						-- GLOBAL!
						when "00001111" =>
							 atual <= sf1;
						when "00000010" =>
							 atual <= co1;
						when "00110000" =>
							 if(entrada_regComp='0') then
								  atual <= pj_jump;
							 else
									atual <= pj_stay;
							 end if;
								when "00110001" => 
									 if(entrada_regComp='1') then
										  atual <= pj_jump;
									 else
										  atual <= pj_stay;
									 end if;
								when "00110010" =>
									 atual <= jf1;
								when "00110011" => 
									 atual <= ja1;
								-- INPLACE ADD
								when "00100000" =>
									 atual <= b1;
								when "00100001" =>
									 atual <= b1;
								when "00100010" =>
									 atual <= b1;
								when "00100011" =>
									 atual <= b1;
								-- CALL E RETURN
								when others =>
									 atual <= first;
						  end case;
					 when lc1 =>
						  atual <= lc2;
					 when lc2 => 
						  atual <= lc3;
					 when lc3 =>
						  atual <= first;
					 --                          FINAL LOAD CONST
					 when lf1 =>
						  atual <= lf2;
					 when lf2 =>
						  atual <= lf3;
					 when lf3 =>
						  atual <= lf4;
					 when lf4 =>
						  atual <= first;
					 --                        FINAL LOAD LOAD_FAST
					 when sf1 =>
						  atual <= sf2;
					 when sf2 =>
						  atual <= sf3;
					 when sf3 =>
						  atual <= sf4;
					 when sf4 =>
						  atual <= sf5;
					 when sf5 =>
						  atual <= first;
					 --                      FINAL STORE FAST
					 when pj_jump =>
						  atual <= pj_end;
					 when pj_stay =>
						  atual <= pj_end;
					 when pj_end =>
						  atual <= first;
					 --                      FINAL POP JUMP
					 when co1 =>
						  atual <= co2;
					 when co2 => 
						  atual <= co3;
					 when co3 =>
						  atual <= co4;
					 when co4 =>
						  atual <= co4_AUX;
					 when co4_AUX =>
						  case sEntrada_regArg is
								when "00011000" =>
									 atual <= co5_3; -- igual
								when "00011001" => 
									 atual <= co5_1; -- menor
								when "00011010" =>
									 atual <= co5_2; -- maior
								when others => 
									atual <= first;
						  end case;
					 when co5_1 =>
						  atual <= co5_AUX;
					 when co5_2 =>
						  atual <= co5_AUX;
					 when co5_3 =>
						  atual <= co5_AUX;
					 when co5_AUX =>
						  atual <= co6;
					 when co6 =>
						  atual <= co7;
					 when co7 =>
						  atual <= co7_AUX;
					 when co7_AUX =>
						  atual <= co8;
					 when co8 =>
						  atual <= first;
					 --                  FINAL COMPARE OP
					 when jf1 =>
						  atual <= jf2;
					 when jf2 =>
						  atual <= first;
					 --                  FINAL JUMP FORWARD
					 when ja1 =>
						  atual <= ja2;
					 when ja2 =>
						  atual <= first;
					 --                  FINAL JUMP ABSOLUTE
					 when b1 =>
						  atual <= b2;
					 when b2 =>
						  atual <= b3;
					 when b3 =>
						  atual <= b3_AUX;
					 when b3_AUX =>
						  case sEntrada_regInstr is
								when "00100000" =>
									 atual <= b4_1;
								when "00100001" =>
									 atual <= b4_2;
								when "00100010" =>
									 atual <= b4_3;
								when "00100011" =>
									 atual <= b4_4;
								when others => 
									atual <= first;
						  end case;
					 when b4_1 =>
						  atual <= b4_AUX;
					 when b4_2 =>
						  atual <= b4_AUX;
					 when b4_3 =>
						  atual <= b4_AUX;
					 when b4_4 =>
						  atual <= b4_AUX;
					 when b4_AUX =>
						  atual <= b5;
					 when b5 =>
						  atual <= b6;
					 when b6 =>
						  atual <= first;
				end case;
		  end if;
	 end process;
	 
	 process(atual, sEntrada_regInstr, sEntrada_regArg)
	 begin
		  case atual is
				when first =>
					 ctrl_regPc <= '0';
					 ctrl_regInstr <= '1';
					 ctrl_regArg <= '1';
					 -- ---------------------------
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "00";
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
					 sel_ula <= "000";
				when sAUX =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 -- ---------------------------
					 ctrl_regOp1 <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "00";
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
					 sel_ula <= "000";
				when lc1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxPilha <= "11";
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxRegOp1 <= '0';
				when lc2 =>
					 ctrl_regPilha_WRITE <= '1';
					 ctrl_regTos <= '1';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "11";
					 sel_MuxRegOp1 <= '0';
				when lc3 =>
					 ctrl_pilha <= '1';
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when lf1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '1';
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "00";
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
					 sel_ula <= "000";
				when lf2 =>
					 ctrl_regEnd <= '0';
					 ctrl_regMemExt_READ <= '1';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_MuxPilha <= "01";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxRegOp1 <= '0';
				when lf3 =>
					 ctrl_regMemExt_READ <= '0';
					 ctrl_regPilha_WRITE <= '1';
					 ctrl_regTos <= '1';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "01";
					 sel_MuxRegOp1 <= '0';
				when lf4 =>
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regTos <= '0';
					 ctrl_pilha <= '1';
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when sf1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '1';
					 ctrl_regPilha_SAIDA <= '1';
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "00";
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
					 sel_ula <= "000";
				when sf2 =>
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "00";
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
					 sel_ula <= "000";
				when sf3 =>
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_memExt <= '1';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when sf4 =>
					 ctrl_memExt <= '0';
					 ctrl_regTos <= '1';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regPc <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when sf5 =>
					 ctrl_regTos <= '0';
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when pj_jump =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "10";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when pj_stay =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when pj_end =>
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when co1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regPilha_SAIDA <= '1';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when co2 =>
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regTos <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when co3 =>
					 ctrl_regTos <= '0';
					 ctrl_regOp1 <= '1';
					 -- ---------------------------
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when co4 =>
					 ctrl_regOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
					 sel_MuxRegOp1 <= '0';
				when co4_AUX =>
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp2 <= '1';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 -- ---------------------------
					 ctrl_regOp2 <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_ula <= "001";
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co5_1 =>
					 ctrl_regOp2 <= '0';
					 sel_ula <= "101";
					 -- ---------------------------
					 sel_MuxRegOp1 <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co5_2 =>
					 ctrl_regOp2 <= '0';
					 sel_ula <= "110";
					 -- ---------------------------
					 sel_MuxRegOp1 <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co5_3 =>
					 ctrl_regOp2 <= '0';
					 sel_ula <= "100";
					 -- ---------------------------
					 sel_MuxRegOp1 <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co5_AUX =>
					 case sEntrada_regArg is
							when "00011000" =>
								 sel_ula <= "100"; -- igual
							when "00011001" => 
								 sel_ula <= "101"; -- menor
							when "00011010" =>
								 sel_ula <= "110"; -- maior
							when others => 
								sel_ula <= "100";
					 end case;
					 ctrl_regComp <= '1';
					 -- ---------------------------
					 ctrl_regOp1 <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co6 =>
					 ctrl_regComp <= '0';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 -- ---------------------------
					 ctrl_regOp1 <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co7 =>
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '1';
					 -- ---------------------------
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co7_AUX =>
					 ctrl_regTos <= '0';
					 -- ---------------------------
					 ctrl_regComp <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when co8 =>
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 ctrl_regTos <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regComp <= '0';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 ctrl_regOp2 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when jf1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 sel_MuxRegOp1 <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when jf2 =>
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 sel_MuxRegOp1 <= '1';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when ja1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "10";
					 sel_ula <= "000";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when ja2 =>
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxOp1 <= "00";
					 sel_MuxOp2 <= "10";
					 sel_ula <= "000";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b1 =>
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regPilha_SAIDA <= '1';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b2 =>
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp1 <= '1';
					 ctrl_regTos <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 sel_MuxOp1 <= "10";
					 sel_MuxOp2 <= "01";
					 sel_ula <= "001";
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b3 =>
					 ctrl_regOp1 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regPilha_SAIDA <= '1';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_ula <= "001";
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 sel_MuxRegOp1 <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b3_AUX =>
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp2 <= '1';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 -- ---------------------------
					 ctrl_regOverflow <= '0';
					 ctrl_regTos <= '0';
					 sel_ula <= "001";
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b4_1 =>    -- SOMA
					 ctrl_regOp2 <= '0';
					 sel_ula <= "000";
					 sel_MuxPilha <= "00";
					 -- ---------------------------
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
				when b4_2 => -- SUBTRAÃ‡ÃƒO
					 ctrl_regOp2 <= '0';
					 sel_ula <= "001";
					 sel_MuxPilha <= "00";
					 -- ---------------------------
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
				when b4_3 => -- MULTIPLICAÃ‡ÃƒO
					 ctrl_regOp2 <= '0';
					 sel_ula <= "010";
					 sel_MuxPilha <= "00";
					 -- ---------------------------
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
				when b4_4 => -- DIVISÃƒO
					 ctrl_regOp2 <= '0';
					 sel_ula <= "011";
					 sel_MuxPilha <= "00";
					 -- ---------------------------
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
				when b4_AUX =>
					 ctrl_regPilha_WRITE <= '1';
					 ctrl_regOverflow <= '1';
					 -- ---------------------------
					 ctrl_regOp1 <= '0';
					 sel_MuxOp1 <= "11";
					 sel_MuxOp2 <= "11";
					 case sEntrada_regInstr is
						when "00100000" =>
						sel_ula <= "000";
						when "00100001" =>
						sel_ula <= "001";
						when "00100010" =>
						sel_ula <= "010";
						when "00100011" =>
						sel_ula <= "011";
					   when others =>
						sel_ula <= "000";
					 end case;
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b5 =>
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regOverflow <= '0';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 -- ---------------------------
					 sel_MuxRegOp1 <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp2 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regPc <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_pilha <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
				when b6 =>
					 ctrl_regPilha_WRITE <= '0';
					 ctrl_regOverflow <= '0';
					 ctrl_pilha <= '1';
					 ctrl_regPc <= '1';
					 -- ---------------------------
					 ctrl_regOp2 <= '0';
					 sel_MuxOp1 <= "01";
					 sel_MuxOp2 <= "00";
					 sel_ula <= "000";
					 sel_MuxRegOp1 <= '0';
					 ctrl_regPilha_SAIDA <= '0';
					 ctrl_regOp1 <= '0';
					 ctrl_regTos <= '0';
					 ctrl_regInstr <= '0';
					 ctrl_regArg <= '0';
					 ctrl_regEnd <= '0';
					 ctrl_regComp <= '0';
					 ctrl_regMemExt_WRITE <= '0';
					 ctrl_regMemExt_READ <= '0';
					 ctrl_memExt <= '0';
					 sel_MuxPilha <= "00";
			  end case;
		end process;	  
		
end arcControl;