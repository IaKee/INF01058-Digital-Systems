library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_ahmes is
    Port( 
	    CLOCK: in std_logic;
        RESET: in std_logic;

		-- flags das operacoes
		DECOD_RI: in std_logic_vector(23 downto 0);
		  
		-- flags de estado
		reg_N: in std_logic;
        reg_Z: in std_logic;
        reg_V: in std_logic;
        reg_C: in std_logic;
        reg_B: in std_logic;

		-- controle dos registradores
	    inc_PC: out std_logic;
		load_ac: out std_logic;
        load_pc: out std_logic;
		load_REM: out std_logic;
		load_RDM: out std_logic;
        load_RI: out std_logic;
		load_N: out std_logic;
		load_Z: out std_logic;
		load_V: out std_logic;
		load_C: out std_logic;
		load_B: out std_logic;
		
		-- seletores
		sel_ULA: out std_logic_vector(3 downto 0);
		sel_MUXREM: out std_logic;
		sel_MUXRDM: out std_logic;
		
		-- controle da memoria
		--mem_read: out  std_logic; -- nao utilizado
		mem_write: out std_logic);	
	end control_ahmes;

architecture Behavioral of control_ahmes is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
	signal next_state, current_state: state_type;
	signal sel_ULA_op: std_logic_vector(3 downto 0);
	signal inc_PC_op, load_RDM_op: std_logic;  -- para poder ler desse proprio sinal (manter valor)
	
	-- adicionar load_RDM aqui
	
    begin
		-- conexões
		inc_PC <= inc_pc_op;
		load_RDM <= load_RDM_op;
		sel_ULA <= sel_ULA_op;
		
		process(CLOCK, RESET) -- controle dos estados
		    begin
				if(RESET = '1') then
					current_state <= S0;
				elsif(rising_edge(CLOCK)) then
					current_state <= next_state;
				else
					current_state <= current_state;
				end if;	
			end process;

		process(  -- FSM Mealy
			next_state,

			-- flags gerais
			reg_N, 
			reg_Z, 
			reg_V, 
			reg_C, 
			reg_B,
			
			--codigo das operacoes
			DECOD_RI)
			begin
				-- reseta sinais de carga
				inc_PC_op <= '0';
				load_ac <= '0';
				load_pc <= '0';
				load_N <= '0'; 
				load_Z <= '0'; 
				load_V <= '0'; 
				load_C <= '0'; 
				load_B <= '0';
				load_RDM_op <= '0';
				load_REM <= '0';
				sel_MUXREM <= '0';
				sel_MUXRDM <= '0';
				sel_ULA_op <= "0000";
				mem_write <= '0';
				
				case current_state is
					when S0 =>
						load_RDM_op <= '1';
						next_state <= S1;
					when S1 =>
						load_REM <= '0';
						inc_PC_op <= '0';
						next_state <= S2;
					when S2 =>
						load_RDM_op <= '1';
						inc_PC_op <= '1';
						next_state <= S3;
					when S3 =>
						inc_PC_op <= '0';
						load_RDM_op <= '0';
						if(DECOD_RI(0) = '1') then  -- NOP
							next_state <= S0;
						elsif(DECOD_RI(6) = '1') then  -- NOT
							sel_ULA_op <= "0011";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(DECOD_RI(9) = '1' and reg_N = '0') then -- JN quando n=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(10) = '1' and reg_N = '1') then -- JP quando n=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(11) = '1' and reg_V = '0') then -- JV quando v=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(12) = '1' and reg_V = '1') then -- JNV quando v=1
							inc_PC_op <= '1';
							next_state <= S0;	
						elsif(DECOD_RI(13) = '1' and reg_Z = '0') then -- JZ quando z=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(14) = '1' and reg_Z = '1') then -- JNZ quando z=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(15) = '1' and reg_C = '0') then -- JC quando c=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(16) = '1' and reg_C = '1') then -- JNC quando c=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(17) = '1' and reg_B = '0') then -- JB quando b=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(18) = '1' and reg_B = '1') then -- JNB quando b=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(DECOD_RI(19) = '1') then  -- SHR
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(DECOD_RI(20) = '1') then  -- SHL
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(DECOD_RI(21) = '1') then  -- ROR
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(DECOD_RI(22) = '1') then  -- ROL
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(DECOD_RI(23) = '1') then -- HLT
							inc_PC_op <= '0';
							next_state <= S8;
						else  -- qualquer outra operacao
							sel_MUXREM <= '0';
							load_REM <= '1';
							next_state <= S4;
						end if;
					when S4 =>
						sel_MUXREM <= '0';
						inc_PC_op <= '0';
						load_AC <= '0';
						load_REM <= '0';
						load_AC <= '0';
						load_N <= '0';
						load_Z <= '0';
						load_V <= '0';
						load_C <= '0';
						load_B <= '0';
						if(DECOD_RI(1) = '1' or
							DECOD_RI(2) = '1' or
							DECOD_RI(3) = '1' or
							DECOD_RI(4) = '1' or
							DECOD_RI(5) = '1' or
							DECOD_RI(7) = '1' or
							DECOD_RI(8) = '1' or
							DECOD_RI(9) = '1' or
							DECOD_RI(10) = '1' or
							DECOD_RI(11) = '1' or
							DECOD_RI(12) = '1' or
							DECOD_RI(13) = '1' or
							DECOD_RI(14) = '1' or
							DECOD_RI(15) = '1' or
							DECOD_RI(16) = '1' or
							DECOD_RI(17) = '1' or
							DECOD_RI(18) = '1') then
								inc_PC_op <= '1';
						else
							inc_PC_op <= inc_PC_op;  -- mantem
						end if;
						next_state <= S5;
					when S5 =>
						inc_PC_op <= '0';
						if(DECOD_RI(1) = '1' or
						DECOD_RI(2) = '1' or
						DECOD_RI(3) = '1' or
						DECOD_RI(4) = '1' or
						DECOD_RI(5) = '1' or
						DECOD_RI(7) = '1' or
						DECOD_RI(8) = '1' or
						DECOD_RI(9) = '1' or
						DECOD_RI(10) = '1' or
						DECOD_RI(11) = '1' or
						DECOD_RI(12) = '1' or
						DECOD_RI(13) = '1' or
						DECOD_RI(14) = '1' or
						DECOD_RI(15) = '1' or
						DECOD_RI(16) = '1' or
						DECOD_RI(17) = '1' or
						DECOD_RI(18) = '1') then
							sel_MUXREM <= '1';
							load_REM <= '1';
							next_state <= S6;
						else
							load_PC <= '1';
							next_state <= S0;
						end if;
					when S6 =>  -- rever esse aqui
						inc_PC_op <= '0';
						sel_MUXREM <= '0';
						load_REM <= '0';
						load_PC <= '0';
						next_state <= S7;
						if(DECOD_RI(1) = '1') then  -- STA
							load_RDM_op <= '1';
						else
							load_RDM_op <= load_RDM_op;  -- isso nao deve funcionar, arrumar
						end if;
					when S7 =>
						if(DECOD_RI(1) = '1') then
							mem_write <= '1';
							sel_ULA_op <= sel_ULA_op; -- mantem
						elsif(DECOD_RI(2) = '1') then
							sel_ULA_op <= "0100";  -- NOP(ULA Y)
						elsif(DECOD_RI(3) = '1') then
							sel_ULA_op <= "0000";
						elsif(DECOD_RI(4) = '1') then
							sel_ULA_op <= "0001";
						elsif(DECOD_RI(5) = '1') then
							sel_ULA_op <= "0010";
						elsif(DECOD_RI(6) = '1') then
							sel_ULA_op <= "0011";
						elsif(DECOD_RI(7) = '1') then
							sel_ULA_op <= "0100";
						else
							sel_ULA_op <= sel_ULA_op;
						end if;
					when S8 =>
						next_state <= S8;
					when others =>
						next_state <= S0;
				end case;
			end process;
    end Behavioral;