library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity datapath is
    port( 
        CLOCK: in std_logic;
        RESET: in std_logic;

        -- register control inputs
        inc_PC: in std_logic;
        load_PC: in std_logic;
        load_AC: in std_logic;
        load_MA: in std_logic; -- memory address register
        load_MD: in std_logic; -- memory data register
        load_I: in std_logic;  -- instruction register
        load_N: in std_logic;
        load_Z: in std_logic;
        load_V: in std_logic;
        load_C: in std_logic;
        load_B: in std_logic;
        
        -- selectors
        sel_MUX_MAR: in std_logic_vector(0 downto 0);  -- selects which data reg_MA should recieve (between reg_PC or reg_MD)
        sel_MUX_MDR: in std_logic_vector(0 downto 0);  -- selects which data reg_MD should recieve (between reg_MEM or reg_AC)
        sel_ALU: in std_logic_vector(3 downto 0);  -- selects which arithmetic operation ALU should execute
        
        -- memory control
        mem_read: in std_logic_vector(0 downto 0);
        mem_write: in std_logic_vector(0 downto 0);
		mem_out: out std_logic_vector(7 downto 0);

        -- ALU flags
        reg_N: out std_logic;
        reg_Z: out std_logic;
        reg_V: out std_logic:= '0';
        reg_C: out std_logic;
        reg_B: out std_logic:= '0';
        
        -- instruction flags (from reg_I)
        instruction_flags: out std_logic_vector(23 downto 0));
    end datapath;

architecture Behavioral of datapath is
    -- registersf
    signal reg_PC: std_logic_vector(7 downto 0):= "00000000";
    signal reg_AC: std_logic_vector (7 downto 0):= "00000000";
    signal reg_MA: std_logic_vector(7 downto 0):= "00000000";
    signal reg_MD: std_logic_vector(7 downto 0):= "00000000";
	signal reg_I: std_logic_vector(7 downto 0):= "00000000";
    signal MAR_MUX_out: std_logic_vector(7 downto 0):= "00000000";
    signal MDR_MUX_out: std_logic_vector(7 downto 0):= "00000000";
    signal ALU_out: std_logic_vector(7 downto 0):= "00000000";
    signal omem_out: std_logic_vector(7 downto 0):= "00000000";
    signal IR_DECOD_out: std_logic_vector(23 downto 0):= "000000000000000000000000";
    
    -- AC flags (for upkeeping internal values until the register update on rising edge)
    signal flag_N: std_logic:= '0';
    signal flag_Z: std_logic:= '0';
    signal flag_V: std_logic:= '0';
    signal flag_C: std_logic:= '0';
    signal flag_B: std_logic:= '0';

    -- ALU
    signal ALU_X: std_logic_vector(7 downto 0):= "00000000"; -- recieves signals from reg_AC
    signal ALU_Y: std_logic_vector(7 downto 0):= "00000000"; -- recieves signals from reg_RDM;
	signal ALU_op: std_logic_vector(8 downto 0):= "000000000"; -- ALU operational signal
    -- the extra bit is used for the overflow(V) flag

    -- ALU operation constants
	constant ALUNOP: std_logic_vector(3 downto 0):= "0000";
	constant ALUADD: std_logic_vector(3 downto 0):= "0001";
	constant ALUOR:  std_logic_vector(3 downto 0):= "0010";
	constant ALUAND: std_logic_vector(3 downto 0):= "0011";
	constant ALUNOT: std_logic_vector(3 downto 0):= "0100";
	constant ALUSUB: std_logic_vector(3 downto 0):= "0101";
	constant ALUSHR: std_logic_vector(3 downto 0):= "0110";
	constant ALUSHL: std_logic_vector(3 downto 0):= "0111";
	constant ALUROR: std_logic_vector(3 downto 0):= "1000";
	constant ALUROL: std_logic_vector(3 downto 0):= "1001";
	constant ALUY:   std_logic_vector(3 downto 0):= "1010";

    -- intruction number constants to be used with instruction_flags slices
	constant iNOP: std_logic_vector(7 downto 0):= "00000000";
	constant iSTA: std_logic_vector(7 downto 0):= "00010000";
	constant iLDA: std_logic_vector(7 downto 0):= "00100000";
	constant iADD: std_logic_vector(7 downto 0):= "00110000";
	constant iOR:  std_logic_vector(7 downto 0):= "01000000";
	constant iAND: std_logic_vector(7 downto 0):= "01010000";
	constant iNOT: std_logic_vector(7 downto 0):= "01100000";
	constant iSUB: std_logic_vector(7 downto 0):= "01110000";
	constant iJMP: std_logic_vector(7 downto 0):= "10000000";
	constant iJN:  std_logic_vector(7 downto 0):= "10010000";
	constant iJP:  std_logic_vector(7 downto 0):= "10010100";
	constant iJV:  std_logic_vector(7 downto 0):= "10011000";
	constant iJNV: std_logic_vector(7 downto 0):= "10011100";
	constant iJZ:  std_logic_vector(7 downto 0):= "10100000";
	constant iJNZ: std_logic_vector(7 downto 0):= "10100100";
	constant iJC:  std_logic_vector(7 downto 0):= "10110000";
	constant iJNC: std_logic_vector(7 downto 0):= "10110100";
	constant iJB:  std_logic_vector(7 downto 0):= "10111000";
	constant iJNB: std_logic_vector(7 downto 0):= "10111100";
	constant iSHR: std_logic_vector(7 downto 0):= "11100000";
	constant iSHL: std_logic_vector(7 downto 0):= "11100001";
	constant iROR: std_logic_vector(7 downto 0):= "11100010";
	constant iROL: std_logic_vector(7 downto 0):= "11100011";
	constant iHLT: std_logic_vector(7 downto 0):= "11110000";

    -- BRAM memory component (mem_ahmes)
    component mem_ahmes
	    port(
            clka: in std_logic;
            wea: in std_logic_vector(0 downto 0);
            addra: in std_logic_vector(7 downto 0);
            dina: in std_logic_vector(7 downto 0);
            douta: out std_logic_vector(7 downto 0));
	end component;
    
    begin  -- datapath behavioral start
        
        -- hw connections (not clock dependent)
		mem_out <= omem_out;

        mem: mem_ahmes
            port map(
                clka => CLOCK,
                wea => mem_write,
                addra => reg_MA,
                dina => reg_MD,
                douta => omem_out);
		
        PC: process(CLOCK, RESET)  -- program counter register
            -- standard register, has functions to reset, load values and increment internal value by 1
            -- mainly recieves values from reg_MD
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_PC <= "00000000";
                elsif(rising_edge(CLOCK)) then
                    if(load_PC = '1') then
                        reg_PC <= reg_MD;
                    elsif(inc_PC = '1') then
                        reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                    end if;
                end if;
            end process;
				
        AC: process(CLOCK, RESET, load_AC)  -- accumulator register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from reg_ALU
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_AC <= "00000000";
                elsif(rising_edge(CLOCK)) then
					ALU_X <= reg_AC;  -- retrieves ALU X from reg_AC (accumulator)
					if(load_AC = '1') then
						reg_AC <= std_logic_vector(ALU_out(7 downto 0));
					end if;
                end if;
            end process;
        
        -- ALU flag registers
        regN: process(CLOCK, RESET, load_N)  -- negative flag register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from internal signal flag_N
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_N <= '0';
                elsif(rising_edge(CLOCK) and load_N = '1') then
                    reg_N <= flag_N;
                end if;
            end process;
        
        regZ: process(CLOCK, RESET, load_Z)  -- zero flag register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from internal signal flag_Z
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_Z <= '0';
                elsif(rising_edge(CLOCK) and load_Z = '1') then
                    reg_Z <= flag_Z;
                end if;
            end process;
		  
        regV: process(CLOCK, RESET, load_V) -- overflow flag register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from internal signal flag_V
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_V <= '0';
                elsif(rising_edge(CLOCK) and load_V = '1') then
                    reg_V <= flag_V;
                end if;
            end process;
				
        regC: process(CLOCK, RESET, load_C)  -- carry flag register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from internal signal flag_C
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_C <= '0';
                elsif(rising_edge(CLOCK) and load_C = '1') then
                    reg_C <= flag_C;
                end if;
            end process;
				
        regB: process(CLOCK, RESET, load_B)  -- borrow flag register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from internal signal flag_B
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_B <= '0';
                elsif(rising_edge(CLOCK) and load_B = '1') then
                    reg_B <= flag_B;
                end if;
            end process;
        		
        IR: process (CLOCK, RESET, load_I) -- instruction register
            -- standard register, has functions to reset and load values
            -- recieves values from reg_MD
            -- asynchronous reset    
            begin
                if(RESET = '1') then
                    reg_I <= "00000000";
                elsif(rising_edge(CLOCK) and load_I = '1') then
                    reg_I <= reg_MD;
                end if;
            end process;    
        
        MAR: process(CLOCK, RESET, load_MA) -- memory address register
            -- standard register, has functions to reset and load values
            -- recieves values from MA_MUX_out
            -- asynchronous reset 
            begin
                if (RESET = '1') then
                    reg_MA <= "00000000";
                elsif (rising_edge(CLOCK) and load_MA = '1') then
                    reg_MA <= MAR_MUX_out;
                end if;
            end process;

        MDR: process(CLOCK, RESET, load_MD) -- memory data register
            -- standard register, has functions to reset and load values
            -- recieves values from MD_MUX_out
            -- asynchronous reset 
            begin
                if(RESET = '1') then
                    reg_MD <= "00000000";
                elsif(rising_edge(CLOCK)) then
					ALU_Y <= reg_MD;  -- retrieves ALU Y from reg_MD (memory data)
					if(load_MD = '1') then
						reg_MD <= MDR_MUX_out;
					end if;
                end if;
            end process;

        MAR_MUX: process(sel_MUX_MAR, reg_PC, reg_MD)  -- MAR 2x1 multiplexer
            -- 2x1 MUX, selecting between reg_PC and reg_MD
            begin
                if(sel_MUX_MAR = "0") then
                    MAR_MUX_out <= reg_PC;
                else
                    MAR_MUX_out <= reg_MD;
                end if;
            end process;

        MDR_MUX: process(sel_MUX_MDR, oMEM_out, reg_AC, mem_read)  -- MDR 2x1 multiplexer
            -- 2x1 MUX, selecting between MEM_out and reg_AC
            begin
				-- requires 'mem_read' signal to enable memory reading
                if(sel_MUX_MDR = "0" and mem_read = "1") then
                    MDR_MUX_out <= oMEM_out;
                else
                    MDR_MUX_out <= reg_AC;
                end if;
            end process;
				
        ALU: process(sel_ALU, ALU_X, ALU_Y, flag_C, ALU_op) -- arithmetic logic unit
            -- Performs arithmetic and logical operations on two input operands
            -- Output result is stored in ALU_op
            -- Operation selected based on sel_ALU input
            -- Available operations:
            --  ADD - adds ALU_X and ALU_Y
            --  OR - logical OR of ALU_X and ALU_Y
            --  AND - logical AND of ALU_X and ALU_Y
            --  NOT - bitwise complement of ALU_X
            --  SUB - subtracts ALU_Y from ALU_X
            --  SHR - right shift of ALU_X by 1 bit
            --  SHL - left shift of ALU_X by 1 bit
            --  ROR - right rotate of ALU_X by 1 bit
            --  ROL - left rotate of ALU_X by 1 bit
            --  NOP - no operation, ALU_op receives ALU_Y
            begin
                if(unsigned(ALU_op(7 downto 0)) = 0) then
                    flag_Z <= '1';
                else
                    flag_Z <= '0';
                end if;
				
				ALU_out <= std_logic_vector(ALU_op(7 downto 0));  -- updates ALU output with 7 lsb of ALU_op
				flag_V <= '1';
				flag_B <= '1';
				flag_N <= ALU_op(7); -- accumulator msb
				flag_C <= ALU_op(8);  -- carry flag
                case sel_ALU is
                    when ALUADD =>  -- ADD
						ALU_op <= std_logic_vector(unsigned('0' & ALU_X) + unsigned('0' & ALU_Y));
                        
						-- checks for overflow
                        if (ALU_X(7) = '0' and ALU_Y(7) = '0' and ALU_op(7) = '1') then
                            flag_V <= '1';
                        else
                            flag_V <= '0';
                        end if;
						
						-- resets other flag signals
						flag_B <= '0';
                    when ALUOR =>  -- OR
                        ALU_op <= std_logic_vector(('0' & ALU_X) or ('0' & ALU_Y));
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUAND =>  -- AND
                        ALU_op <= std_logic_vector(('0' & ALU_X) and ('0' & ALU_Y));
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUNOT =>  -- NOT
                        ALU_op <= std_logic_vector(not('0' & ALU_X));
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUSUB =>  -- SUB
                        ALU_op <= std_logic_vector(unsigned('0' & ALU_X) - unsigned('0' & ALU_Y));
                        
						-- checks for overflow
                        if (ALU_X(7) = '1' and ALU_Y(7) = '1' and ALU_op(7) = '0') then
                            flag_V <= '1';
                        else
                            flag_V <= '0';
                        end if;
						
						-- borrow flag
                        flag_B <= ALU_op(7) and ALU_op(8);
                    when ALUSHR => -- SHR
                        ALU_op(8) <= ALU_X(0);  -- ALU_op, and by consequence carry recieves reg_AC lsb
                        
                        ALU_op(7) <= '0'; -- ULA_out msb recieves 0
                        ALU_op(6) <= ALU_X(7);
                        ALU_op(5) <= ALU_X(6);
                        ALU_op(4) <= ALU_X(5);
                        ALU_op(3) <= ALU_X(4);
                        ALU_op(2) <= ALU_X(3);
                        ALU_op(1) <= ALU_X(2);
                        ALU_op(0) <= ALU_X(1);
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUSHL => -- SHL
                        ALU_op(8) <= ALU_X(7);  -- ALU_op, and by consequence carry recieves reg_AC msb

                        ALU_op(7) <= ALU_X(6); 
                        ALU_op(6) <= ALU_X(5); 
                        ALU_op(5) <= ALU_X(4); 
                        ALU_op(4) <= ALU_X(3); 
                        ALU_op(3) <= ALU_X(2); 
                        ALU_op(2) <= ALU_X(1); 
                        ALU_op(1) <= ALU_X(0); 
                        ALU_op(0) <= '0'; -- ULA_out lsb recieves 0
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUROR => -- ROR
                        ALU_op(8) <= ALU_X(0);

                        ALU_op(7) <= flag_C;
                        ALU_op(6) <= ALU_X(7);
                        ALU_op(5) <= ALU_X(6);
                        ALU_op(4) <= ALU_X(5);
                        ALU_op(3) <= ALU_X(4);
                        ALU_op(2) <= ALU_X(3);
                        ALU_op(1) <= ALU_X(2);
                        ALU_op(0) <= ALU_X(1);
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUROL => -- ROL
						ALU_op(8) <= ALU_X(7);
                        ALU_op(7) <= ALU_X(6);
                        ALU_op(6) <= ALU_X(5);
                        ALU_op(5) <= ALU_X(4);
                        ALU_op(4) <= ALU_X(3);
                        ALU_op(3) <= ALU_X(2);
                        ALU_op(2) <= ALU_X(1);
                        ALU_op(1) <= ALU_X(0);
                        ALU_op(0) <= flag_C;
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when ALUY => -- ULAY
                        ALU_op <= std_logic_vector('0' & ALU_Y);
						
						-- resets other flag signals
						flag_B <= '0';
						flag_V <= '0';
                    when others => -- NOP (ULAX - reg_AC)
                        ALU_op <= '0' & ALU_X;  
                end case;
            end process;   
        
        IR_DECOD: process(reg_I, IR_DECOD_out)  -- IR_DECOD, used for setting instruction_flags
			-- decodes reg_I signal setting a 24 bits vector, with flags for each of
            -- the processor instructions
            begin
				instruction_flags <= IR_DECOD_out;
				IR_DECOD_out <= "000000000000000000000000";
				case reg_I is
					when iNOP => IR_DECOD_out <= "000000000000000000000001"; -- 00 NOP
					when iSTA => IR_DECOD_out <= "000000000000000000000010"; -- 16 STA
					when iLDA => IR_DECOD_out <= "000000000000000000000100"; -- 32 LDA
					when iADD => IR_DECOD_out <= "000000000000000000001000"; -- 48 ADD
					when iOR  => IR_DECOD_out <= "000000000000000000010000"; -- 64 OR
					when iAND => IR_DECOD_out <= "000000000000000000100000"; -- 80 AND
					when iNOT => IR_DECOD_out <= "000000000000000001000000"; -- 96 NOT
					when iSUB => IR_DECOD_out <= "000000000000000010000000"; -- 112 SUB
					when iJMP => IR_DECOD_out <= "000000000000000100000000"; -- 128 JMP
					when iJN  => IR_DECOD_out <= "000000000000001000000000"; -- 144 JN
					when iJP  => IR_DECOD_out <= "000000000000010000000000"; -- 148 JP
					when iJV  => IR_DECOD_out <= "000000000000100000000000"; -- 152 JV
					when iJNV => IR_DECOD_out <= "000000000001000000000000"; -- 156 JNV
					when iJZ  => IR_DECOD_out <= "000000000010000000000000"; -- 160 JZ
					when iJNZ => IR_DECOD_out <= "000000000100000000000000"; -- 164 JNZ
					when iJC  => IR_DECOD_out <= "000000001000000000000000"; -- 176 JC
					when iJNC => IR_DECOD_out <= "000000010000000000000000"; -- 180 JNC
					when iJB  => IR_DECOD_out <= "000000100000000000000000"; -- 184 JB
					when iJNB => IR_DECOD_out <= "000001000000000000000000"; -- 188 JNB
					when iSHR => IR_DECOD_out <= "000010000000000000000000"; -- 224 SHR
					when iSHL => IR_DECOD_out <= "000100000000000000000000"; -- 225 SHL
					when iROR => IR_DECOD_out <= "001000000000000000000000"; -- 226 ROR
					when iROL => IR_DECOD_out <= "010000000000000000000000"; -- 227 ROL
					when iHLT => IR_DECOD_out <= "100000000000000000000000"; -- 240 HLT
					when others => IR_DECOD_out <= "100000000000000000000000";  -- 00 HLT
                end case;
			end process;
    end Behavioral;

