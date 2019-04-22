library ieee;
use ieee.std_logic_1164.all;

entity pythonProcessor is
	generic
	(
		DATA_WIDTH	: natural := 8;
		DATA_END	: natural := 24
	);

	port
	(
		clk_geral		: in std_logic;
		reset_geral		: in std_logic;
		overflow_geral	: out std_logic
	);
end entity;

architecture processadorPython of pythonProcessor is
-- controle
signal regOp1_ctrl, regOp2_ctrl, regPc_ctrl, regComp_ctrl, regTos_ctrl, regInstr_ctrl, regEnd_ctrl, regOverflow_ctrl, regJump_ctrl	: std_logic;
signal regPilha_WRITE_ctrl, regPilha_SAIDA_ctrl, regMemExt_WRITE_ctrl, regMemExt_READ_ctrl, regArg_ctrl, MuxRegOp1_ctrl	: std_logic;
signal muxOp1_sel, muxOp2_sel, muxPilha_sel	: std_logic_vector(1 downto 0);
signal ULA_sel	: std_logic_vector(2 downto 0);
signal pilha_ctrl, memExt_ctrl	: std_logic;
signal wSaida_regArg_toCtrl		: std_logic_vector((DATA_WIDTH-1) downto 0);
signal reset_ctrl						: std_logic;

-- regPilha
signal wEntrada_regPilha, wSaida_regPilha		: std_logic_vector((DATA_WIDTH-1) downto 0);
-- regOp1
signal wSaida_regOp1	: std_logic_vector((DATA_END-1) downto 0);
-- regOp2
signal wSaida_regOp2	: std_logic_vector((DATA_END-1) downto 0);
-- regPc
signal wSaida_regPc	: std_logic_vector((DATA_END-1) downto 0);
-- regTos
signal wEntrada_regTos, wSaida_regTos	: std_logic_vector((DATA_END-1) downto 0);
-- regEnd
signal wSaida_regEnd	: std_logic_vector((DATA_END-1) downto 0);
-- regMemExt
signal wSaida_regMemExt	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- regComp
signal wSaida_regComp	: std_logic;
-- regInstr
signal wSaida_regInstr	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- pilha
signal wEntrada_pilha, wPilha_write, wPilha_read	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- memExt
signal wMemExt_read, wMemExt_write	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- memInstr
signal wEntrada_regInstr : std_logic_vector((DATA_WIDTH-1) downto 0);
signal wSaida_memInstr	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- ula
signal wEntrada_Ula1, wEntrada_Ula2, wSaida_Ula		: std_logic_vector((DATA_END-1) downto 0);
signal wSaida_UlaComp	: std_logic;
-- regOpArg
signal wEntrada_regOpArg	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- regOverflow
signal wEntrada_regOverflow, wSaida_regOverflow	: std_logic;
-- muxRegOp1
signal wSaida_MuxRegOp1	: std_logic_vector((DATA_WIDTH-1) downto 0);
-- regPc
signal wEntrada_regPc	: std_logic_vector((DATA_END-1) downto 0);
--funcoes
signal muxPc_ctrl, pilhaFuncao_ctrl, soma_sub_ctrl, regTosFuncao_ctrl	: std_logic;
signal wSaida_regTosFuncao, wEntrada_regTosFuncao	: std_logic_vector((DATA_WIDTH-1) downto 0);
signal wSaida_pilhaFuncao	: std_logic_vector((DATA_END-1) downto 0);
-- retorno
signal muxTos_ctrl, regDataReturn_ctrl, pilhaRetorno_ctrl	: std_logic;
signal wSaida_regDataReturn	: std_logic_vector((DATA_WIDTH-1) downto 0);
signal wSaida_muxTos 	: std_logic_vector((DATA_END-1) downto 0);
signal wSaida_pilhaRetorno	: std_logic_vector((DATA_END-1) downto 0);
-- regJump
signal wSaida_regJump	: std_logic_vector((DATA_END-1) downto 0);
signal wEntrada_regJump2	: std_logic_vector(((DATA_WIDTH*2)-1) downto 0);


component regOp1 is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regOp1			: in std_logic;
		entrada_regOp1		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regOp1		: out std_logic_vector(((DATA_WIDTH*3)-1) downto 0)
	);
end component;

component regOp2 is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk				: in std_logic;
		ctrl_regOp2		: in std_logic;
		entrada_regOp2	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regOp2	: out std_logic_vector(((DATA_WIDTH*3)-1) downto 0)
	);
end component;

component regPc is
	generic
	(
		DATA_WIDTH	: natural := 24
	);

	port
	(
		clk				: in std_logic;
		reset				: in std_logic;
		ctrl_regPc		: in std_logic;
		entrada_regPc	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regPc		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regTos is
	generic
	(
		DATA_WIDTH	: natural := 24
	);

	port
	(
		clk				: in std_logic;
		reset			: in std_logic;
		ctrl_regTos		: in std_logic;
		entrada_regTos	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regTos	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regEnd is
	generic
	(
		DATA_WIDTH	: natural := 24
	);

	port
	(
		clk				: in std_logic;
		ctrl_regEnd		: in std_logic;
		entrada_regEnd	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regEnd	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regPilha is
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
end component;

component regInstr is
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
end component;

component regArg is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);

	port
	(
		clk				: in std_logic;
		ctrl_regArg		: in std_logic;
		entrada_regArg	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regArg_toCtrl	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regArg			: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regComp is
	generic
	(
		DATA_WIDTH	: natural 	:= 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regComp 		: in std_logic;
		entrada_regComp	: in std_logic;
		saida_regComp		: out std_logic
	);
end component;

component muxOp1 is
	generic
	(
		DATA_WIDTH	: natural := 24
	);

	port
	(
		sel_MuxOp1		: in std_logic_vector(1 downto 0);
		entr_regOp1		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regJump	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxOp1	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component muxOp2 is
	generic
	(
		DATA_WIDTH	: natural := 24;
		LENGTH_REG_ARG	: natural := 8
	);

	port
	(
		sel_MuxOp2			: in std_logic_vector(1 downto 0);
		entr_regTos			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regPc			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regOp2			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regArg			: in std_logic_vector((LENGTH_REG_ARG-1) downto 0);
		saida_muxOp2		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component muxPilha is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		sel_muxPilha		: in std_logic_vector(1 downto 0);
		entr_ULA			: in std_logic_vector(((DATA_WIDTH*3)-1) downto 0);
		entr_memInstr		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_memExt			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entr_regDataReturn  : in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxPilha		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

-- component muxRegOp1 is
-- 	generic
-- 	(
-- 		DATA_WIDTH	: natural	:= 8
-- 	);
--
-- 	port
-- 	(
-- 		ctrl_muxRegOp1		: in std_logic;
-- 		entrada_regArg	: in std_logic_vector((DATA_WIDTH-1) downto 0);
-- 		entrada_regOp1	: in std_logic_vector((DATA_WIDTH-1) downto 0);
-- 		saida_muxRegOp1	: out std_logic_vector((DATA_WIDTH-1) downto 0)
-- 	);
-- end component;

component regMemExt is
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
end component;

component ula is
	generic
	(
		DATA_WIDTH	: natural	:= 24
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
end component;

component pilha is
	generic
	(
		DATA_WIDTH	:	natural	:= 8;
		END_WIDTH	:	natural	:= 24
	);

	port
	(
		clk				: in std_logic;
		ctrl_pilha		: in std_logic;
		entrada_tos		: in std_logic_vector((END_WIDTH-1) downto 0);
		entrada_write	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_read		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component memExt is
	generic
	(
		DATA_WIDTH	: natural	:= 8;
		END_WIDTH	: natural 	:= 24
	);

	port
	(
		clk				: in std_logic;
		ctrl_memExt		: in std_logic;
		entrada_write	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_addr	: in std_logic_vector((END_WIDTH-1) downto 0);
		saida_read		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component memInstr is
	generic
	(
		DATA_WIDTH	: natural	:= 16;
		END_WIDTH	: natural	:= 24;
		DATA_OUT	: natural	:= 8
	);

	port
	(
		entrada_pc		: in std_logic_vector((END_WIDTH-1) downto 0);
		saida_opCode	: out std_logic_vector((DATA_OUT-1) downto 0);
		saida_opArg		: out std_logic_vector((DATA_OUT-1) downto 0);
		saida_regJump	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regOverflow is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regOverflow	: in std_logic;
		entrada_regOverflow	: in std_logic;
		saida_regOverflow	: out std_logic
	);
end component;

component control is
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
		ctrl_regDataReturn	: out std_logic;
		ctrl_pilhaRetorno		: out std_logic;
		ctrl_regTosFuncao		: out std_logic;
		ctrl_pilhaFuncao		: out std_logic;
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
		sel_muxPC				: out std_logic;
		sel_ula					: out std_logic_vector(2 downto 0);
		sel_soma_sub			: out std_logic;
		sel_muxTos				: out std_logic;
		ctrl_regJump			: out std_logic
	);
end component;

component pilhaFuncao is
	generic
	(
		DATA_WIDTH	:	natural	:= 24;
		END_WIDTH	:	natural	:= 8
	);

	port
	(
		clk						: in std_logic;
		ctrl_pilhaFuncao		: in std_logic;
		entrada_tosFuncao		: in std_logic_vector((END_WIDTH-1) downto 0);
		entrada_Pc				: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Pc					: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component muxPc is
	generic
	(
		DATA_WIDTH	: natural	:= 24
	);

	port
	(
		ctrl_muxPc		: in std_logic;
		entrada_Ula	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_Pilha	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Pc	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regTosFuncao is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk				: in std_logic;
		reset				: in std_logic;
		ctrl_regTosFuncao		: in std_logic;
		entrada_regTosFuncao	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_regTosFuncao	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component somador_subtrator is
	generic
	(
		DATA_WIDTH	: natural	:= 8
	);

	port
	(
		sel_somaSub				: in std_logic;
		entrada			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component muxTos is
	generic
	(
		DATA_WIDTH	: natural	:= 24
	);

	port
	(
		ctrl_muxTos		: in std_logic;
		entrada_Ula	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		entrada_Tos	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Tos	: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component pilhaRetorno is
	generic
	(
		DATA_WIDTH	:	natural	:= 24;
		END_WIDTH	:	natural	:= 8
	);

	port
	(
		clk				: in std_logic;
		ctrl_pilhaRetorno		: in std_logic;
		entrada_tosRetorno	: in std_logic_vector((END_WIDTH-1) downto 0);
		entrada_Tos	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_Tos		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;

component regDataReturn is
	generic
	(
		DATA_WIDTH	: natural := 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regDataReturn			: in std_logic;
		entrada_readPilha		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		saida_muxPilha		: out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end component;


component regJump is
	generic
	(
		DATA_SAIDA	: natural := 24;
		DATA_HALF	: natural := 8
	);

	port
	(
		clk					: in std_logic;
		ctrl_regJump		: in std_logic;
		entrada_regArg		: in std_logic_vector((DATA_HALF-1) downto 0);
		entrada_memInstr	: in std_logic_vector(((DATA_HALF*2)-1) downto 0);
		saida_regJump		: out std_logic_vector((DATA_SAIDA-1) downto 0)
	);
end component;

begin

comp_regJump	: regJump
	port map
	(
		clk => clk_geral,
		ctrl_regJump => regJump_ctrl,
		entrada_regArg => wSaida_memInstr, -- saida regArg
		entrada_memInstr => wEntrada_regJump2, -- entrada vinda da memInstr
		saida_regJump => wSaida_regJump
	);

comp_regDataReturn	: regDataReturn
	port map
	(
		clk => clk_geral,
		ctrl_regDataReturn => regDataReturn_ctrl,
		entrada_readPilha => wPilha_read,
		saida_muxPilha => wSaida_regDataReturn
	);

comp_pilhaRetorno	: pilhaRetorno
	port map
	(
		clk => clk_geral,
		ctrl_pilhaRetorno => pilhaRetorno_ctrl,
		entrada_tosRetorno => wSaida_regTosFuncao,
		entrada_Tos => wSaida_regTos,
		saida_Tos => wSaida_pilhaRetorno
	);

comp_muxTos	: muxTos
	port map
	(
		ctrl_muxTos => muxTos_ctrl,
		entrada_Ula => wSaida_Ula,
		entrada_Tos => wSaida_pilhaRetorno,
		saida_Tos => wSaida_muxTos
	);

comp_regOp1	: regOp1
	port map
	(
		clk => clk_geral,
		ctrl_regOp1	=> regOp1_ctrl,
		entrada_regOp1	=> wSaida_regPilha,
		saida_regOp1	=> wSaida_regOp1
	);

comp_regOp2	: regOp2
	port map
	(
		clk => clk_geral,
		ctrl_regOp2 => regOp2_ctrl,
		entrada_regOp2 => wSaida_regPilha,
		saida_regOp2 => wSaida_regOp2
	);

comp_regPc	: regPc
	port map
	(
		clk => clk_geral,
		reset => reset_ctrl,
		ctrl_regPc => regPc_ctrl,
		entrada_regPc => wEntrada_regPc,
		saida_regPc => wSaida_regPc
	);

comp_regTos	: regTos
	port map
	(
		clk => clk_geral,
		reset => reset_ctrl,
		ctrl_regTos => regTos_ctrl,
		entrada_regTos => wSaida_muxTos,
		saida_regTos => wSaida_regTos
	);

comp_regEnd	: regEnd
	port map
	(
		clk => clk_geral,
		ctrl_regEnd => regEnd_ctrl,
		entrada_regEnd => wSaida_regJump,
		saida_regEnd => wSaida_regEnd
	);

comp_regPilha	: regPilha
	port map
	(
		clk => clk_geral,
		ctrl_regPilha_WRITE => regPilha_WRITE_ctrl,
		ctrl_regPilha_SAIDA => regPilha_SAIDA_ctrl,
		entrada_Mux => wEntrada_regPilha,
		entrada_Read => wPilha_read,
		saida_write => wPilha_write,
		saida_operandos => wSaida_regPilha
	);

comp_regInstr	: regInstr
	port map
	(
		clk => clk_geral,
		ctrl_regInstr => regInstr_ctrl,
		entrada_regInstr => wEntrada_regInstr,
		saida_regInstr => wSaida_regInstr
	);

comp_regArg		: regArg
	port map
	(
		clk => clk_geral,
		ctrl_regArg => regArg_ctrl,
		entrada_regArg => wEntrada_regOpArg,
		saida_regArg => wSaida_memInstr,
		saida_regArg_toCtrl => wSaida_regArg_toCtrl
	);

comp_regComp	: regComp
	port map
	(
		clk => clk_geral,
		ctrl_regComp => regComp_ctrl,
		entrada_regComp => wSaida_UlaComp,
		saida_regComp => wSaida_regComp
	);

comp_regOverflow	: regOverflow
	port map
	(
		clk => clk_geral,
		ctrl_regOverflow => regOverflow_ctrl,
		entrada_regOverflow => wEntrada_regOverflow,
		saida_regOverflow => wSaida_regOverflow
	);

comp_muxOp1	: muxOp1
	port map
	(
		sel_MuxOp1 => MuxOp1_sel,
		entr_regOp1 => wSaida_regOp1,
		entr_regJump => wSaida_regJump,
		saida_muxOp1 => wEntrada_Ula1
	);

comp_muxOp2	: muxOp2
	port map
	(
		sel_MuxOp2 => muxOp2_sel,
		entr_regOp2 => wSaida_regOp2,
		entr_regTos => wSaida_regTos,
		entr_regPc => wSaida_regPc,
		entr_regArg => wSaida_memInstr,
		saida_muxOp2 => wEntrada_Ula2
	);

comp_muxPilha	: muxPilha
	port map
	(
		sel_MuxPilha => MuxPilha_sel,
		entr_ULA	=> wSaida_Ula,
		entr_memInstr => wSaida_memInstr,
		entr_memExt => wSaida_regMemExt,
		entr_regDataReturn => wSaida_regDataReturn,
		saida_muxPilha => wEntrada_regPilha
	);

comp_regMemExt	: regMemExt
	port map
	(
		clk => clk_geral,
		ctrl_regMemExt_WRITE => regMemExt_WRITE_ctrl,
		ctrl_regMemExt_READ => regMemExt_READ_ctrl,
		entrada_RegPilha => wSaida_regPilha,
		entrada_Mem => wMemExt_read,
		saida_regPilha => wSaida_regMemExt,
		saida_Mem => wMemExt_write
	);

comp_Ula	: ula
	port map
	(
		sel_Ula => Ula_sel,
		entrada_Op1 => wEntrada_Ula1,
		entrada_Op2 => wEntrada_Ula2,
		saida_result => wSaida_Ula,
		saida_regComp => wSaida_UlaComp,
		saida_regOverflow => wEntrada_regOverflow
	);

comp_pilha	: pilha
	port map
	(
		clk => clk_geral,
		ctrl_pilha => pilha_ctrl,
		entrada_tos => wSaida_regTos,
		entrada_write => wPilha_write,
		saida_read => wPilha_read
	);

comp_memExt	: memExt
	port map
	(
		clk => clk_geral,
		ctrl_memExt => memExt_ctrl,
		entrada_write => wMemExt_write,
		entrada_addr => wSaida_regEnd,
		saida_read => wMemExt_read
	);

comp_memInstr	: memInstr
	port map
	(
		entrada_pc => wSaida_regPc,
		saida_opCode => wEntrada_regInstr,
		saida_opArg => wEntrada_regOpArg,
		saida_regJump => wEntrada_regJump2
	);

comp_control	: control
	port map
	(
		clk	=> clk_geral,
		entrada_reset => reset_geral,
		saida_reset	=> reset_ctrl,
		entrada_regComp => wSaida_regComp,
		entrada_regInstr => wSaida_regInstr,
		entrada_regArg => wSaida_regArg_toCtrl,
		entrada_regOverflow => wSaida_regOverflow,
		ctrl_regOp1 => regOp1_ctrl,
		ctrl_regOp2 => regOp2_ctrl,
		ctrl_regPc => regPc_ctrl,
		ctrl_regComp => regComp_ctrl,
		ctrl_regTos => regTos_ctrl,
		ctrl_regInstr => regInstr_ctrl,
		ctrl_regArg => regArg_ctrl,
		ctrl_regEnd => regEnd_ctrl,
		ctrl_regOverflow => regOverflow_ctrl,
		ctrl_regPilha_WRITE => regPilha_WRITE_ctrl,
		ctrl_regPilha_SAIDA => regPilha_SAIDA_ctrl,
		ctrl_regMemExt_WRITE => regMemExt_WRITE_ctrl,
		ctrl_regMemExt_READ => regMemExt_READ_ctrl,
		ctrl_pilha => pilha_ctrl,
		ctrl_memExt => memExt_ctrl,
		sel_MuxOp1 => MuxOp1_sel,
		sel_MuxOp2 => muxOp2_sel,
		sel_MuxPilha => MuxPilha_sel,
		sel_MuxRegOp1 => muxRegOp1_ctrl,
		sel_Ula => Ula_sel,
		sel_soma_sub => soma_sub_ctrl,
		sel_muxPC => muxPc_ctrl,
		ctrl_pilhaFuncao => pilhaFuncao_ctrl,
		ctrl_regTosFuncao => regTosFuncao_ctrl,
		sel_muxTos => muxTos_ctrl,
		ctrl_regDataReturn => regDataReturn_ctrl,
		ctrl_pilhaRetorno => pilhaRetorno_ctrl
	);

-- comp_muxRegOp1	: muxRegOp1
-- 	port map
-- 	(
-- 		ctrl_muxRegOp1 => muxRegOp1_ctrl,
-- 		entrada_regArg => wSaida_memInstr,
-- 		entrada_regOp1 => wSaida_regOp1,
-- 		saida_muxRegOp1 => wSaida_MuxRegOp1
-- 	);

comp_pilhaFuncao	: pilhaFuncao
	port map
	(
		clk => clk_geral,
		ctrl_pilhaFuncao => pilhaFuncao_ctrl,
		entrada_tosFuncao => wSaida_regTosFuncao,
		entrada_Pc => wSaida_regPc,
		saida_Pc => wSaida_pilhaFuncao

	);

comp_muxPC		: muxPc
	port map
	(
		ctrl_muxPc => muxPc_ctrl,
		entrada_Ula => wSaida_Ula,
		entrada_Pilha => wSaida_PilhaFuncao,
		saida_Pc => wEntrada_regPc
	);

comp_regTosFuncao	: regTosFuncao
	port map
	(
		clk => clk_geral,
		reset => reset_geral,
		ctrl_regTosFuncao => regTosFuncao_ctrl,
		entrada_regTosFuncao => wEntrada_regTosFuncao,
		saida_regTosFuncao => wSaida_regTosFuncao
	);

comp_somador_subtrator	: somador_subtrator
	port map
	(
		sel_somaSub => soma_sub_ctrl,
		entrada => wSaida_regTosFuncao,
		saida => wEntrada_regTosFuncao
	);

	overflow_geral <= wSaida_regOverflow;
end processadorPython;
