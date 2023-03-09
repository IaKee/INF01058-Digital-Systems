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

	-- ALU operation constants
	constant ALUNOP: std_logic_vector(3 downto 0):= "0000";
	constant ALUADD: std_logic_vector(3 downto 0):= "0001";
	constant ALUOR: std_logic_vector(3 downto 0):= "0010";
	constant ALUAND: std_logic_vector(3 downto 0):= "0011";
	constant ALUNOT: std_logic_vector(3 downto 0):= "0100";
	constant ALUSUB: std_logic_vector(3 downto 0):= "0101";
	constant ALUSHR: std_logic_vector(3 downto 0):= "0110";
	constant ALUSHL: std_logic_vector(3 downto 0):= "0111";
	constant ALUROR: std_logic_vector(3 downto 0):= "1000";
	constant ALUROL: std_logic_vector(3 downto 0):= "1001";
	constant ALUY: std_logic_vector(3 downto 0):= "1010";

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

			-- value flags
			reg_N, 
			reg_Z, 
			reg_V, 
			reg_C, 
			reg_B,

			-- instruction flags
			oNOP,
			oSTA,
			oLDA,
			oADD,
			oOR,
			oAND,
			oNOT,
			oSUB,
			oJMP,
			oJN,
			oJP,
			oJV,
			oJNV,
			oJZ,
			oJNZ,
			oJC,
			oJNC,
			oJB,
			oJNB,
			oSHR,
			oSHL,
			oROR,
			oROL,
			oHLT)
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
				sel_ALU <= ALUNOP;  -- default ALU operation
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
						next_state <= S3;
					when S3 =>
						if(oNOP = '1') then
							-- goto S0
							next_state <= S0;
						elsif(oNOT = '1') then
							-- updates ALU operation
							sel_ALU <= ALUNOT;

							-- updates AC value
							load_AC <= '1';

							-- updates flag signals
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';

							-- goto S0
							next_state <= S0;
						elsif(oJN = '1' and reg_N = '0') then -- JN if n=0
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJP = '1' and reg_N = '1') then -- JP if n=1
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJV = '1' and reg_V = '0') then -- JV if v=0
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJNV = '1' and reg_V = '1') then -- JNV if v=1
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;	
						elsif(oJZ = '1' and reg_Z = '0') then -- JZ if z=0
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJNZ = '1' and reg_Z = '1') then -- JNZ if z=1
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJC = '1' and reg_C = '0') then -- JC if c=0
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJNC = '1' and reg_C = '1') then -- JNC if c=1
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJB = '1' and reg_B = '0') then -- JB if b=0
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oJNB = '1' and reg_B = '1') then -- JNB if b=1
							-- conditions does not match for jumping to given addres
							-- goes to the next instruction, going to S0
							inc_PC <= '1';
							next_state <= S0;
						elsif(oSHR = '1') then  -- SHR
							-- updates ALU instruction
							sel_ALU <= ALUSHR;

							-- updates accumulator value
							load_AC <= '1';

							-- updates logic flag signals
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';

							-- goes to S0
							next_state <= S0;
						elsif(oSHL = '1') then  -- SHL
							-- updates ALU instruction
							sel_ALU <= ALUSHL;

							-- updates accumulator value
							load_AC <= '1';

							-- updates logic flag signals
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';

							-- goes to S0
							next_state <= S0;
						elsif(oROR = '1') then  -- ROR
							-- updates ALU instruction
							sel_ALU <= ALUROR;

							-- updates accumulator value
							load_AC <= '1';

							-- updates logic flag signals
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';

							-- goes to S0
							next_state <= S0;
						elsif(oROL = '1') then  -- ROL
							-- updates ALU instruction
							sel_ALU <= ALUROL;

							-- updates accumulator value
							load_AC <= '1';

							-- updates logic flag signals
							load_N <= '1';
							load_Z <= '1';
							load_V <= '1';
							load_C <= '1';
							load_B <= '1';

							-- goes to S0
							next_state <= S0;
						elsif(oHLT = '1') then -- HLT
							-- goto S8 (loop state)
							next_state <= S8;
						else
							-- for any sucessful jumping instruction
							-- sets memory cursor position to current reg_PC value
							sel_MUX_MAR <= "0"; -- reg_MA <= reg_PC
							load_MA <= '1';  -- updates reg_MA with reg_PC

							-- goes to S4
							next_state <= S4;
						end if;
					when S4 =>
						-- enables memory read signal
						mem_read <= '1';
						load_MD <= '1'; -- updates memory data register
						
						-- increments reg_PC for any of the following instructions
						if(oSTA = '1' or oLDA = '1' or oADD = '1' or oOR = '1' or oAND = '1' or oSUB = '1') then
							inc_PC <= '1';
						end if;

						-- goes to S5
						next_state <= S5;
					when S5 =>
						if(oSTA = '1' or oLDA = '1' or oADD = '1' or oOR = '1' or oAND = '1' or oSUB = '1') then
							-- reg_MA recieves data from reg_MD
							sel_MUX_MA <= "1";
							load_MA <= '1';
							
							-- goto S6
							next_state <= S6;
						else  -- for any other instruction (jumps)
							-- updates program counter
							load_PC <= '1';

							-- goto S0
							next_state <= S0;
						end if;
					when S6 =>
						if(oSTA = '1') then  -- STA
							load_MD <= '1';
						else -- for any other instruction
							-- memory read enable pin
							mem_read <= '1';

							-- updates reg_MD value
							load_MD <= '1';
						end if;

						-- goto s7
						next_state <= S7;
					when S7 =>
						if(oSTA = '1') then
							mem_write <= "1";

							-- goto S0
							next_state <= S0;
						elsif(oLDA = '1') then
							-- updates ALU instruction
							sel_ALU <= ALUY;
							
							-- updates ULA_out and by consequence the accumulator with reg_MD
							load_AC <= '1';

							-- updates value flag registers
							load_N <= '1'; 
							load_Z <= '1'; 
							load_V <= '1'; 
							load_C <= '1'; 
							load_B <= '1';

							-- goto S0
							next_state <= S0;
						elsif(oADD = '1') then
							-- updates ALU instruction
							sel_ALU <= ULAADD;

							-- updates the accumulator with ULA_out
							load_AC <= '1';

							-- updates value flag registers
							load_N <= '1'; 
							load_Z <= '1'; 
							load_V <= '1'; 
							load_C <= '1'; 
							load_B <= '1';

							-- goto S0
							next_state <= S0;
						elsif(oOR = '1') then
							-- updates ALU instruction
							sel_ALU <= ALUOR;

							-- updates the accumulator with ULA_out
							load_AC <= '1';

							-- updates value flag registers
							load_N <= '1'; 
							load_Z <= '1'; 
							load_V <= '1'; 
							load_C <= '1'; 
							load_B <= '1';
							
							-- goto S0
							next_state <= S0;
						elsif(oAND = '1') then
							-- updates ALU instruction
							sel_ALU <= ALUAND;

							-- updates the accumulator with ULA_out
							load_AC <= '1';

							-- updates value flag registers
							load_N <= '1'; 
							load_Z <= '1'; 
							load_V <= '1'; 
							load_C <= '1'; 
							load_B <= '1';

							-- goto S0
							next_state <= S0;
						elsif(oSUB = '1') then
							-- updates ALU instruction
							sel_ULA <= ALUSUB;

							-- updates the accumulator with ULA_out
							load_AC <= '1';
							
							-- updates value flag registers
							load_N <= '1'; 
							load_Z <= '1'; 
							load_V <= '1'; 
							load_C <= '1'; 
							load_B <= '1';

							-- goto S0
							next_state <= S0;
						end if;
					when S8 =>
						-- loop state (HALT)
						next_state <= S8;
					when others =>
						next_state <= S0;
				end case;
			end process;
    end Behavioral;