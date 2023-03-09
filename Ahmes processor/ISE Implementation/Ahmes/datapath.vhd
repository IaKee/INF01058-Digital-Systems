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

        -- ALU flags
        reg_N: out std_logic;
        reg_Z: out std_logic;
        reg_V: out std_logic;
        reg_C: out std_logic;
        reg_B: out std_logic;
        
        -- instruction flags (from reg_I)
        instruction_flags: out std_logic_vector(23 downto 0));
    end datapath;

architecture Behavioral of datapath is
    -- registers
    signal reg_PC: std_logic_vector(7 downto 0);
    signal reg_AC: std_logic_vector (7 downto 0);
    signal reg_MA: std_logic_vector(7 downto 0);
    signal reg_MD: std_logic_vector(7 downto 0);
    signal MA_MUX_out: std_logic_vector(7 downto 0);
    signal MD_MUX_out: std_logic_vector(7 downto 0);
    signal ALU_out: std_logic_vector(7 downto 0);
    signal MEM_out: std_logic_vector(7 downto 0);
    signal IR_DECOD_out: std_logic_vector(23 downto 0);
    
    -- AC flags (for upkeeping internal values until the register update on rising edge)
    signal flag_N: std_logic;
    signal flag_Z: std_logic;
    signal flag_V: std_logic;
    signal flag_C: std_logic;
    signal flag_B: std_logic;

    -- ALU
    signal ALU_X: std_logic_vector(7 downto 0); -- recieves signals from reg_AC
    signal ALU_Y: std_logic_vector(7 downto 0); -- recieves signals from reg_RDM;
	signal ALU_op: std_logic_vector(8 downto 0); -- ALU operational signal
    -- the extra bit is used for the overflow(V) flag

    -- BRAM memory component (mem_ahmes)
    component mem
	    port(
            clka: in std_logic;
            wea: in std_logic_vector(0 downto 0);
            addra: in std_logic_vector(7 downto 0);
            dina: in std_logic_vector(7 downto 0);
            douta: out std_logic_vector(7 downto 0));
	end component;
    
    begin  -- datapath behavioral start
        
        -- hw connections (not clock dependent)
        reg_ALU <= std_logic_vector(ALU_op(7 downto 0));  -- updates ALU output with 7 lsb of ALU_op
        ALU_X <= reg_AC;  -- retrieves ALU X from reg_AC (accumulator)
        ALU_Y <= reg_MD;  -- retrieves ALU Y from reg_MD (memory data)
        flag_C <= ALU_op(8);  -- carry flag
        IR_DECOD_out <= instruction_flags;

        mem_ahmes: mem
            port map(
                clka => CLOCK,
                wea => mem_write,
                addra => reg_rem,
                dina => reg_rem,
                douta => reg_mem);
		
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
				
        AC: process(CLOCK, RESET)  -- accumulator register
            -- standard register, has functions to reset and load values
            -- mainly recieves values from reg_ALU
            -- asynchronous reset
            begin
                if(RESET = '1') then
                    reg_AC <= "00000000";
                elsif(rising_edge(CLOCK) and load_AC = '1') then
                    reg_AC <= std_logic_vector(ALU_out(7 downto 0));
                end if;
            end process;
        
        -- ALU flag registers
        regN: process(CLOCK, RESET)  -- negative flag register
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
        
        regZ: process(CLOCK, RESET)  -- zero flag register
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
		  
        regV: process(CLOCK, RESET) -- overflow flag register
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
				
        regC: process(CLOCK, RESET)  -- carry flag register
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
				
        regB: process(CLOCK, RESET)  -- borrow flag register
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
        		
        IR: process (CLOCK, RESET) -- instruction register
            -- standard register, has functions to reset and load values
            -- recieves values from reg_MD
            -- asynchronous reset    
            begin
                if(RESET = '1') then
                    reg_I <= "00000000";
                elsif(rising_edge(CLOCK) and load_RI = '1') then
                    reg_RI <= reg_MD;
                end if;
            end process;    
        
        MAR: process(CLOCK, RESET) -- memory address register
            -- standard register, has functions to reset and load values
            -- recieves values from MA_MUX_out
            -- asynchronous reset 
            begin
                if (RESET = '1') then
                    reg_MA <= "00000000";
                elsif (rising_edge(CLOCK) and load_REM = '1') then
                    reg_MA <= MA_MUX_out;
                end if;
            end process;

        MDR: process(CLOCK, RESET) -- memory data register
            -- standard register, has functions to reset and load values
            -- recieves values from MD_MUX_out
            -- asynchronous reset 
            begin
                if(RESET = '1') then
                    reg_MD <= "00000000";
                elsif(rising_edge(CLOCK) and load_MD = '1') then
                    reg_MD <= MD_MUX_out;
                end if;
            end process;

        MA_MUX: process(sel_MUX_MAR, reg_PC, reg_MD)  -- MA 2x1 multiplexer
            -- 2x1 MUX, selecting between reg_PC and reg_MD
            begin
                if(sel_MUX_MAR = "0") then
                    MUX_MA_out <= reg_PC;
                else
                    MUX_MA_out <= reg_MD;
                end if;
            end process;

        MD_MUX: process(sel_MUX_MDR, MEM_out, reg_AC)  -- MD 2x1 multiplexer
            -- 2x1 MUX, selecting between MEM_out and reg_AC
            begin
                if(sel_MUX_MDR = "0") then
                    MUX_MDR_out <= MEM_out;
                else
                    MUX_MDR_out <= reg_AC;
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
                -- negative flag
                flag_N <= ALU_op(7); -- accumulator msb
                -- zero flag
                if(unsigned(ALU_op(7 downto 0)) = 0) then
                    flag_Z <= '1';
                else
                    flag_Z <= '0';
                end if;

                case sel_ALU is
                    when "0000" =>  -- ADD
                        ALU_op <= std_logic_vector(unsigned('0' & ALU_X) + unsigned('0' & ALU_Y));
                        -- checks for overflow
                        if (ALU_X(7) = '0' and ALU_Y(7) = '0' and ALU_op(7) = '1') then
                            flag_V <= '1';
                        else
                            flag_V <= '0';
                        end if;
                    when "0001" =>  -- OR
                        ALU_op <= std_logic_vector(('0' & ALU_X) or ('0' & ALU_Y));
                    when "0010" =>  -- AND
                        ALU_op <= std_logic_vector(('0' & ALU_X) and ('0' & ALU_Y));
                    when "0011" =>  -- NOT
                        ALU_op <= std_logic_vector(not('0' & ALU_X));
                    when "0100" =>  -- SUB
                        ALU_op <= std_logic_vector(unsigned('0' & ALU_X) - unsigned('0' & ALU_Y));
                        -- borrow flag
                        flag_B <= ALU_op(7) and ALU_op(8);
                        -- checks for overflow
                        if (ALU_X(7) = '1' and ALU_Y(7) = '1' and ALU_op(7) = '0') then
                            flag_V <= '1';
                        else
                            flag_V <= '0';
                        end if;
                    when "0101" => -- SHR
                        ALU_op(8) <= ALU_X(0);  -- ALU_op, and by consequence carry recieves reg_AC lsb
                        ALU_op(7) <= '0'; -- ULA_out msb recieves 0
                        ALU_op(6) <= ALU_X(7);
                        ALU_op(5) <= ALU_X(6);
                        ALU_op(4) <= ALU_X(5);
                        ALU_op(3) <= ALU_X(4);
                        ALU_op(2) <= ALU_X(3);
                        ALU_op(1) <= ALU_X(2);
                        ALU_op(0) <= ALU_X(1);
                    when "0110" => -- SHL
                        ALU_op(8) <= ALU_X(7);  -- ALU_op, and by consequence carry recieves reg_AC msb
                        ALU_op(7) <= ALU_X(6); 
                        ALU_op(6) <= ALU_X(5); 
                        ALU_op(5) <= ALU_X(4); 
                        ALU_op(4) <= ALU_X(3); 
                        ALU_op(3) <= ALU_X(2); 
                        ALU_op(2) <= ALU_X(1); 
                        ALU_op(1) <= ALU_X(0); 
                        ALU_op(0) <= '0'; -- ULA_out lsb recieves 0
                    when "0111" => -- ROR
                        ALU_op(8) <= ALU_X(0);
                        ALU_op(7) <= flag_C;
                        ALU_op(6) <= ALU_X(7);
                        ALU_op(5) <= ALU_X(6);
                        ALU_op(4) <= ALU_X(5);
                        ALU_op(3) <= ALU_X(4);
                        ALU_op(2) <= ALU_X(3);
                        ALU_op(1) <= ALU_X(2);
                        ALU_op(0) <= ALU_X(1);
                    when "1000" => -- ROL
                        ALU_op(8) <= ALU_X(7);
                        ALU_op(7) <= ALU_X(6);
                        ALU_op(6) <= ALU_X(5);
                        ALU_op(5) <= ALU_X(4);
                        ALU_op(4) <= ALU_X(3);
                        ALU_op(3) <= ALU_X(2);
                        ALU_op(2) <= ALU_X(1);
                        ALU_op(1) <= ALU_X(0);
                        ALU_op(0) <= flag_C;
                    when others => -- NOP
                        ALU_op <= '0' & ALU_Y;  
                end case;
            end process;   
        
        IR_DECOD: process(reg_I)  -- IR_DECOD, used for setting instruction_flags
			-- decodes reg_I signal setting a 24 bits vector, with flags for each of
            -- the processor instructions
            begin
				IR_DECOD_out <= "000000000000000000000000";
				case reg_RI_op is
					when "00000000" => IR_DECOD_out(0)  <= '1'; -- 00 NOP
					when "00010000" => IR_DECOD_out(1)  <= '1'; -- 16 STA
					when "00100000" => IR_DECOD_out(2)  <= '1'; -- 32 LDA
					when "00110000" => IR_DECOD_out(3)  <= '1'; -- 48 ADD
					when "01000000" => IR_DECOD_out(4)  <= '1'; -- 64 OR
					when "01010000" => IR_DECOD_out(5)  <= '1'; -- 80 AND
					when "01100000" => IR_DECOD_out(6)  <= '1'; -- 96 NOT
					when "01110000" => IR_DECOD_out(7)  <= '1'; -- 112 SUB
					when "10000000" => IR_DECOD_out(8)  <= '1'; -- 128 JMP
					when "10010000" => IR_DECOD_out(9)  <= '1'; -- 144 JN
					when "10010100" => IR_DECOD_out(10) <= '1'; -- 148 JP
					when "10011000" => IR_DECOD_out(11) <= '1'; -- 152 JV
					when "10011100" => IR_DECOD_out(12) <= '1'; -- 156 JNV
					when "10100000" => IR_DECOD_out(13) <= '1'; -- 160 JZ
					when "10100100" => IR_DECOD_out(14) <= '1'; -- 164 JNZ
					when "10110000" => IR_DECOD_out(15) <= '1'; -- 176 JC
					when "10110100" => IR_DECOD_out(16) <= '1'; -- 180 JNC
					when "10111000" => IR_DECOD_out(17) <= '1'; -- 184 JB
					when "10111100" => IR_DECOD_out(18) <= '1'; -- 188 JNB
					when "11100000" => IR_DECOD_out(19) <= '1'; -- 224 SHR
					when "11100001" => IR_DECOD_out(20) <= '1'; -- 225 SHL
					when "11100010" => IR_DECOD_out(21) <= '1'; -- 226 ROR
					when "11100011" => IR_DECOD_out(22) <= '1'; -- 227 ROL
					when "11110000" => IR_DECOD_out(23) <= '1'; -- 240 HLT
					when others => IR_DECOD_out <= "000000000000000000000000";  -- 00 NOP
                end case;
			end process;
    end Behavioral;

