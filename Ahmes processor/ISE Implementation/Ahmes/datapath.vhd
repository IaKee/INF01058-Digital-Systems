library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity datapath is
    port( 
        CLOCK: in std_logic;
        RESET: in std_logic;

        -- controle dos registradores
        inc_PC: in std_logic;
        load_PC: in std_logic;
        load_AC: in std_logic;
        load_REM: in std_logic;
        load_RDM: in std_logic;
        load_RI: in std_logic;
        load_N: in std_logic;
        load_Z: in std_logic;
        load_V: in std_logic;
        load_C: in std_logic;
        load_B: in std_logic;
        
        -- seletores
        sel_MUXREM: in std_logic;
        sel_MUXRDM: in std_logic;
        sel_ULA: in std_logic_vector(3 downto 0);
        
        -- controle da memoria
        --mem_read: in std_logic_vector(0 downto 0);  -- nao utilizado
        mem_write: in std_logic_vector(0 downto 0);

        -- flags de estado
        reg_N: out std_logic;
        reg_Z: out std_logic;
        reg_V: out std_logic;
        reg_C: out std_logic;
        reg_B: out std_logic;
        
        DECOD_RI: out std_logic_vector(23 downto 0));
    end datapath;

architecture Behavioral of datapath is
    -- registradores
    signal reg_PC: std_logic_vector(7 downto 0);
    signal reg_AC: std_logic_vector (7 downto 0);
    signal reg_REM: std_logic_vector(7 downto 0);
    signal reg_RDM: std_logic_vector(7 downto 0);
    signal reg_RI_op: std_logic_vector(7 downto 0);
    signal reg_MUXREM: std_logic_vector(7 downto 0);
    signal reg_MUXRDM: std_logic_vector(7 downto 0);
    signal reg_DECOD: std_logic_vector(7 downto 0);
    signal reg_mem: std_logic_vector(7 downto 0);
    signal reg_ULA: std_logic_vector(7 downto 0);
    
    -- flags (para evitar erro de nao ser possivel ler de inout)
    signal flag_N: std_logic;
    signal flag_Z: std_logic;
    signal flag_V: std_logic;
    signal flag_C: std_logic;
    signal flag_B: std_logic;

    -- ULA
    signal ULA_X: std_logic_vector(7 downto 0); -- reg_AC
    signal ULA_Y: std_logic_vector(7 downto 0); -- reg_RDM;
	signal ULA_op: std_logic_vector(8 downto 0); -- registrador operacional da ula
	 
    -- decod
    signal reg_DECOD_RI: std_logic_vector(23 downto 0);

    -- memoria (mem_ahmes) -- arrumar
    COMPONENT mem
	  PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
    
    begin -- inicio behavioral
        mem_op : mem -- MEM
            port map(
                clka => CLOCK,
                wea => mem_write,
                addra => reg_rem,
                dina => reg_rem,
                douta => reg_mem);
		  
        process(CLOCK, RESET) -- PC
            begin
                if(RESET = '1') then
                    reg_PC <= "00000000";
                elsif(rising_edge(CLOCK)) then -- na subida do clock
                    if(load_PC = '1') then
                        reg_PC <= reg_RDM;
                    elsif(inc_PC = '1') then
                        reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                    else
                        reg_PC <= reg_PC;
                    end if;
                end if;
            end process;
				
        process(CLOCK, RESET) -- AC
            begin
                if(RESET = '1') then
                    reg_AC <= "00000000";
                elsif(rising_edge(CLOCK)) then -- na subida do clock
                    if(load_AC = '1') then
                        reg_AC <= std_logic_vector(reg_ULA(7 downto 0));
                    else
                        reg_AC <= reg_AC;
                    end if;
                end if;
            end process;
        
        process(CLOCK, RESET) -- reg N
            begin
                if(RESET = '1') then
                    flag_N <= '0';
                elsif(rising_edge(CLOCK)) then -- na subida do clock
                    if(load_N = '1') then
                        flag_N <= ULA_op(7); -- bit de sinal - msb do registrador AC
                    else
                        flag_N <= flag_N;
                    end if;
                end if;
            end process;
        
        process(CLOCK, RESET) -- reg Z
            begin
                if(RESET = '1') then
                    flag_Z <= '0';
                elsif(rising_edge(CLOCK)) then -- na subida do clock
                    if(load_Z = '1') then    
                        flag_Z <= ULA_op(7) 
                            and ULA_op(6)
                            and ULA_op(5)
                            and ULA_op(4)
                            and ULA_op(3)
                            and ULA_op(2)
                            and ULA_op(1)
                            and ULA_op(0);
                    else
                        flag_Z <= flag_Z;
                    end if;
                end if;
            end process;
		  
        process(CLOCK, RESET) -- reg V
            begin
                if(RESET = '1') then
                    flag_V <= '0';
                elsif(rising_edge(CLOCK)) then
                    if(load_V = '1') then
                        -- se uma operacao entre dois numeros positivos gerar um numero negativo
                        -- sem carry - apenas p soma
                        flag_V <= not(reg_AC(7) or reg_RDM(7)) and ULA_op(7) and not(ULA_op(8));
                    else
                        flag_V <= flag_V;
                    end if;
                end if;
            end process;
				
        process(CLOCK, RESET)  -- reg C
            begin
                if(RESET = '1') then
                    flag_C <= '0';
                elsif(rising_edge(CLOCK)) then
                    if(load_C = '1') then
                        flag_C <= ULA_op(8);  -- carry recebe msb de ula_op
                    else
                        flag_C <= flag_C;
                    end if;
                end if;
            end process;
				
        process(CLOCK, RESET)  -- reg B
            begin
                if(RESET = '1') then
                    flag_B <= '0';
                elsif(rising_edge(CLOCK)) then
                    if(load_B = '1') then
                        flag_B <= ULA_op(7) and ULA_op(8);
                    else
                        flag_B <= flag_B;
                    end if;
                end if;
            end process;
					 
        		
        process (CLOCK, RESET) -- RI
            begin
                if(RESET = '1') then
                    reg_RI_op <= "00000000";
                elsif (rising_edge(CLOCK)) then
                    if (load_RI = '1') then
                        reg_RI_op <= reg_RDM;
                    else
                        reg_RI_op <= reg_RI_op;
                    end if;
                end if;
            end process;    
        
        process(CLOCK, RESET) -- REM
            begin
                if (RESET = '1') then
                    reg_REM <= "00000000";
                elsif (rising_edge(CLOCK)) then -- na subida do clock
                    if (load_REM = '1') then
                        reg_REM <= reg_MUXREM;
                    else
                        reg_REM <= reg_REM;
                    end if;
                end if;
            end process;

        process(CLOCK, RESET) -- RDM
            begin
                if(RESET = '1') then
                    reg_RDM <= "00000000";
                elsif(rising_edge(CLOCK)) then
                    if(load_RDM = '1') then
                        reg_RDM <= reg_MUXRDM;
                    else
                        reg_RDM <= reg_RDM;
                    end if;
                end if;
            end process;

        process(sel_MUXREM, reg_PC, reg_MUXRDM) -- MUX_REM
            begin
                if(sel_MUXREM = '0') then
                    reg_MUXREM <= reg_PC;
                else
                    reg_MUXREM <= reg_MUXRDM;
                end if;
            end process;

        process(sel_MUXRDM, reg_mem, reg_AC) -- MUX_RDM
            begin
                if(sel_MUXRDM = '0') then
                    reg_MUXRDM <= reg_mem;
                else
                    reg_MUXRDM <= reg_AC;
                end if;
            end process;
				
        process(sel_ULA, ULA_X, ULA_Y, flag_C) -- ULA
            begin
                case sel_ULA is
                    when "0000" =>  -- operacao ADD
                        ULA_op <= std_logic_vector(unsigned('0' & ULA_X) + unsigned('0' & ULA_Y));
                    when "0001" =>  -- operacao OR
                        ULA_op <= std_logic_vector(('0' & ULA_X) or ('0' & ULA_Y));
                    when "0010" =>  -- operacao AND
                        ULA_op <= std_logic_vector(('0' & ULA_X) and ('0' & ULA_Y));
                    when "0011" =>  -- operacao NOT
                        ULA_op <= std_logic_vector(not('0' & ULA_X));
                    when "0100" =>  -- operacao SUB
                        ULA_op <= std_logic_vector(unsigned('0' & ULA_X) - unsigned('0' & ULA_Y));
                    when "0101" => -- operacao SHR
                        -- equivalente a divisao por 2
                        ULA_op(8) <= ULA_X(0);  -- carry recebe bit 0 do acumulador
                        ULA_op(7) <= '0'; -- msb recebe 0
                        ULA_op(6) <= ULA_X(7);
                        ULA_op(5) <= ULA_X(6);
                        ULA_op(4) <= ULA_X(5);
                        ULA_op(3) <= ULA_X(4);
                        ULA_op(2) <= ULA_X(3);
                        ULA_op(1) <= ULA_X(2);
                        ULA_op(0) <= ULA_X(1);
                    when "0110" => -- operacao SHL
                        -- equialente a multiplicacao por 2
                        ULA_op(8) <= ULA_X(7);  -- carry recebe bit 7
                        ULA_op(7) <= ULA_X(6); 
                        ULA_op(6) <= ULA_X(5); 
                        ULA_op(5) <= ULA_X(4); 
                        ULA_op(4) <= ULA_X(3); 
                        ULA_op(3) <= ULA_X(2); 
                        ULA_op(2) <= ULA_X(1); 
                        ULA_op(1) <= ULA_X(0); 
                        ULA_op(0) <= '0';  -- lsb recebe 0
                    when "0111" => -- operacao ROR
                        ULA_op(8) <= ULA_X(0);  -- carry recebe bit 0 do acumulador
                        ULA_op(7) <= flag_C; -- msb recebe carry
                        ULA_op(6) <= ULA_X(7);
                        ULA_op(5) <= ULA_X(6);
                        ULA_op(4) <= ULA_X(5);
                        ULA_op(3) <= ULA_X(4);
                        ULA_op(2) <= ULA_X(3);
                        ULA_op(1) <= ULA_X(2);
                        ULA_op(0) <= ULA_X(1);
                    when "1000" => -- operacao ROL
                        ULA_op(8) <= ULA_X(7);  -- carry recebe bit 7
                        ULA_op(7) <= ULA_X(6);
                        ULA_op(6) <= ULA_X(5);
                        ULA_op(5) <= ULA_X(4);
                        ULA_op(4) <= ULA_X(3);
                        ULA_op(3) <= ULA_X(2);
                        ULA_op(2) <= ULA_X(1);
                        ULA_op(1) <= ULA_X(0);
                        ULA_op(0) <= flag_C;  -- lsb recebe carry
                    when others => -- operacao NOP
                        ULA_op <= '0' & ULA_Y;  
                end case;
            end process;   
        
        process(reg_RI_op)  -- reg_DECOD_RI
			begin
				reg_DECOD_RI <= "000000000000000000000000";
				case reg_RI_op is
					when "00000000" => reg_DECOD_RI(0)  <= '1'; -- 00 NOP
					when "00010000" => reg_DECOD_RI(1)  <= '1'; -- 16 STA
					when "00100000" => reg_DECOD_RI(2)  <= '1'; -- 32 LDA
					when "00110000" => reg_DECOD_RI(3)  <= '1'; -- 48 ADD
					when "01000000" => reg_DECOD_RI(4)  <= '1'; -- 64 OR
					when "01010000" => reg_DECOD_RI(5)  <= '1'; -- 80 AND
					when "01100000" => reg_DECOD_RI(6)  <= '1'; -- 96 NOT
					when "01110000" => reg_DECOD_RI(7)  <= '1'; -- 112 SUB
					when "10000000" => reg_DECOD_RI(8)  <= '1'; -- 128 JMP
					when "10010000" => reg_DECOD_RI(9)  <= '1'; -- 144 JN
					when "10010100" => reg_DECOD_RI(10) <= '1'; -- 148 JP
					when "10011000" => reg_DECOD_RI(11) <= '1'; -- 152 JV
					when "10011100" => reg_DECOD_RI(12) <= '1'; -- 156 JNV
					when "10100000" => reg_DECOD_RI(13) <= '1'; -- 160 JZ
					when "10100100" => reg_DECOD_RI(14) <= '1'; -- 164 JNZ
					when "10110000" => reg_DECOD_RI(15) <= '1'; -- 176 JC
					when "10110100" => reg_DECOD_RI(16) <= '1'; -- 180 JNC
					when "10111000" => reg_DECOD_RI(17) <= '1'; -- 184 JB
					when "10111100" => reg_DECOD_RI(18) <= '1'; -- 188 JNB
					when "11100000" => reg_DECOD_RI(19) <= '1'; -- 224 SHR
					when "11100001" => reg_DECOD_RI(20) <= '1'; -- 225 SHL
					when "11100010" => reg_DECOD_RI(21) <= '1'; -- 226 ROR
					when "11100011" => reg_DECOD_RI(22) <= '1'; -- 227 ROL
					when "11110000" => reg_DECOD_RI(23) <= '1'; -- 240 HLT
					when others => reg_DECOD_RI <= reg_DECOD_RI;
					end case;
			end process;
        
        -- conexões
        reg_N <= flag_N;
        reg_Z <= flag_Z;
        reg_V <= flag_V;
        reg_C <= flag_C;
        reg_B <= flag_B;
        DECOD_RI <= reg_DECOD_RI;
        reg_ULA <= std_logic_vector(ULA_op(7 downto 0));
        ULA_X <= reg_AC;  -- recupera valor X do acumulador
        ULA_Y <= reg_RDM;  -- recupera valor Y de uma posicao da mem?ria
    end Behavioral;

