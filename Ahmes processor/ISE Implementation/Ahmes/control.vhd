library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity control is
    Port( 
	    CLOCK: in std_logic;
        RESET: in std_logic;

		instruction_flags: in std_logic_vector(23 downto 0);
		  
		-- ALU flags
		reg_N: in std_logic;
        reg_Z: in std_logic;
        reg_V: in std_logic;
        reg_C: in std_logic;
        reg_B: in std_logic;

		-- register control outputs
	    inc_PC: out std_logic;
		load_AC: out std_logic;
        load_PC: out std_logic;
		load_MA: out std_logic;
		load_MD: out std_logic;
        load_I: out std_logic;
		load_N: out std_logic;
		load_Z: out std_logic;
		load_V: out std_logic;
		load_C: out std_logic;
		load_B: out std_logic;
		
		-- selectors
		sel_MUX_MAR: out std_logic_vector(0 downto 0);
		sel_MUX_MDR: out std_logic_vector(0 downto 0);
		sel_ALU: out std_logic_vector(3 downto 0);
		
		-- memory control
		mem_read: out  std_logic_vector(0 downto 0);
		mem_write: out std_logic_vector(0 downto 0));	
	end control;

architecture Behavioral of control is
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
	signal next_state, current_state: state_type;

	-- intruction signals to be used with instruction_flags slices
	signal oNOP: std_logic;
	signal oSTA: std_logic;
	signal oLDA: std_logic;
	signal oADD: std_logic;
	signal oOR: std_logic;
	signal oAND: std_logic;
	signal oNOT: std_logic;
	signal oSUB: std_logic;
	signal oJMP: std_logic;
	signal oJN: std_logic;
	signal oJP: std_logic;
	signal oJV: std_logic;
	signal oJNV: std_logic;
	signal oJZ: std_logic;
	signal oJNZ: std_logic;
	signal oJC: std_logic;
	signal oJNC: std_logic;
	signal oJB: std_logic;
	signal oJNB: std_logic;
	signal oSHR: std_logic;
	signal oSHL: std_logic;
	signal oROR: std_logic;
	signal oROL: std_logic;
	signal oHLT: std_logic;
	
    begin		
		-- hw connections (slices instruction_flags to internal instruction signals)
		oNOP	<= instruction_flags(0);
		oSTA	<= instruction_flags(1);
		oLDA	<= instruction_flags(2);
		oADD	<= instruction_flags(3);
		oOR		<= instruction_flags(4);
		oAND	<= instruction_flags(5);
		oNOT	<= instruction_flags(6);
		oSUB	<= instruction_flags(7);
		oJMP	<= instruction_flags(8);
		oJN		<= instruction_flags(9);
		oJP		<= instruction_flags(10);
		oJV		<= instruction_flags(11);
		oJNV	<= instruction_flags(12);
		oJZ		<= instruction_flags(13);
		oJNZ	<= instruction_flags(14);
		oJC		<= instruction_flags(15);
		oJNC	<= instruction_flags(16);
		oJB		<= instruction_flags(17);
		oJNB	<= instruction_flags(18);
		oSHR	<= instruction_flags(19);
		oSHL	<= instruction_flags(20);
		oROR	<= instruction_flags(21);
		oROL	<= instruction_flags(22);
		oHLT	<= instruction_flags(23);

		SC: process(CLOCK, RESET) -- FSM state control
		    begin
				if(RESET = '1') then
					current_state <= S0;
				elsif(rising_edge(CLOCK)) then
					current_state <= next_state;
				end if;	
			end process;

		FSM: process(
			current_state,
			reg_N, 
			reg_Z, 
			reg_V, 
			reg_C, 
			reg_B,
			instruction_flags)
			-- FSM description
			begin
				-- resets signals
				inc_PC <= '0';
				load_AC <= '0';
				load_PC <= '0';
				load_MA <= '0';
				load_MD <= '0';
				load_I <= '0';
				load_N <= '0'; 
				load_Z <= '0'; 
				load_V <= '0'; 
				load_C <= '0'; 
				load_B <= '0';
				sel_MUX_MAR <= "0";
				sel_MUX_MDR <= "0";
				sel_ALU <= "0000";
				mem_write <= "0";
				mem_read <= "0";
				case current_state is
					when S0 =>
						-- used by all instructions
						-- sets MA to recieve data from reg_PC
						-- updates MA value
						sel_MUX_MAR <= '0';  
						load_MA <= '1';
						next_state <= S1;
					when S1 =>
						-- reads from memory
						-- increments reg_PC
						mem_read <= '1';
						inc_PC <= '1';
						next_state <= S2;
					when S2 =>
						-- updates instruction value (reg_I)
						load_I <= '1';
						--load_RDM_op <= '1';
						--inc_PC_op <= '1';
						next_state <= S3;
					when S3 =>
						inc_PC_op <= '0';
						load_RDM_op <= '0';
						if(oNOP = '1') then
							next_state <= S0;
						elsif(oNOT = '1') then
							sel_ULA_op <= "0011";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(oNOT = '1' and reg_N = '0') then -- JN quando n=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJP = '1' and reg_N = '1') then -- JP quando n=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJV = '1' and reg_V = '0') then -- JV quando v=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJNV = '1' and reg_V = '1') then -- JNV quando v=1
							inc_PC_op <= '1';
							next_state <= S0;	
						elsif(oJZ = '1' and reg_Z = '0') then -- JZ quando z=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJNZ = '1' and reg_Z = '1') then -- JNZ quando z=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJC = '1' and reg_C = '0') then -- JC quando c=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJNC = '1' and reg_C = '1') then -- JNC quando c=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJB = '1' and reg_B = '0') then -- JB quando b=0
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oJNB = '1' and reg_B = '1') then -- JNB quando b=1
							inc_PC_op <= '1';
							next_state <= S0;
						elsif(oSHR = '1') then  -- SHR
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(oSHL = '1') then  -- SHL
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(oROR = '1') then  -- ROR
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(oROL = '1') then  -- ROL
							sel_ULA_op <= "0101";
							load_AC <= '1';
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';
							next_state <= S0;
						elsif(oHLT = '1') then -- HLT
							inc_PC_op <= '0';
							next_state <= S8;
						else  -- qualquer outra operacao
							sel_MUXREM <= "0";
							load_REM <= '1';
							next_state <= S4;
						end if;
					when S4 =>
						sel_MUXREM <= "0";
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
							sel_MUXREM <= "1";
							load_REM <= '1';
							next_state <= S6;
						else
							load_PC <= '1';
							next_state <= S0;
						end if;
					when S6 =>  -- rever esse aqui
						inc_PC_op <= '0';
						sel_MUXREM <= "0";
						load_REM <= '0';
						load_PC <= '0';
						next_state <= S7;
						if(DECOD_RI(1) = '1') then  -- STA
							load_RDM_op <= '1';
						end if;
					when S7 =>
						if(DECOD_RI(1) = '1') then
							mem_write <= "1";
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
						end if;
					when S8 =>
						next_state <= S8;
					when others =>
						next_state <= S0;
				end case;
			end process;
    end Behavioral;