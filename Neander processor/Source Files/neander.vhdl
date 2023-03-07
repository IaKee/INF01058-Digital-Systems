library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity neander is
    Port 
    ( 
        CLOCK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        DOUT : out STD_LOGIC_VECTOR (7 downto 0);
        N : out STD_LOGIC;
        Z : out STD_LOGIC
    );
end neander;

architecture Behavioral of neander is
    
    -- PC
    signal regPC: std_logic_vector (7 downto 0);
    signal cargaPC: std_logic := '0';
    signal incrementaPC: std_logic := '0';
    
    -- AC
    signal regAC: std_logic_vector (7 downto 0);
    signal saidaAC: std_logic_vector (7 downto 0);
    signal cargaAC: std_logic := '0';
    
    -- ULA
    signal ULAX: std_logic_vector (7 downto 0);
    signal ULAY: std_logic_vector (7 downto 0);
    signal saidaULA: std_logic_vector (7 downto 0);
    signal selULA: std_logic_vector (7 downto 0);
    
    -- FLAGS N E Z
    signal regN: std_logic := '0';
    signal regZ: std_logic := '1';
    signal cargaNZ: std_logic := '0';

    -- REM
    signal regREM: std_logic_vector (7 downto 0);
    signal cargaREM: std_logic := '0';

    -- RDM
    signal regRDM: std_logic_vector (7 downto 0);
    signal cargaRDM: std_logic := '0';

    -- RI
    signal regRI: std_logic_vector (7 downto 4);
    signal cargaRI: std_logic := '0';

    -- MUX2x1
    signal saidaMUX: std_logic_vector (7 downto 0);
    signal selMUX: std_logic :='0';

    -- DECOD
    signal instrucao: std_logic_vector(15 downto 0);
    signal decod: std_logic_vector(3 downto 0);

    -- MEMORY
    signal memOut: std_logic_vector (7 downto 0);
    signal writeMem: std_logic := '0';

    -- STATES
    type state_type is (S0, S1, S2, S3, S4, S5, S6, S8);
    signal estado_atual, proximo_estado: state_type;

    component memoria
        PORT 
        (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
    end component;
    
    begin -- inicio behavioral
    -- MEM
    MEM: memoria
        PORT MAP 
        (
            clka => CLOCK,
            wea => writeMEM,
            addra => regREM,
            dina => regAC,
            douta => regMEM
        );

    -- PC
    process (CLOCK, RESET)
        begin
            if (RESET ='1') then
                regPC <= "00000000";
            elsif (CLOCK'event and CLOCK='1') then -- na subida do clock
                if (cargaPC='1') then
                    regPC<= regRDM;
                elsif(incrementaPC='1') then
                    regPC <= std_logic_vector(unsigned(regPC) + 1);
                else
                    regPC <= regPC;
                end if;
            end if;
        end process;

    -- AC
    process (CLOCK, RESET)
        begin
            if (RESET='1') then
                regAC <= "00000000";
            elsif (CLOCK'event and CLOCK='1') then -- na subida do clock
                if (cargaAC='1') then
                regAC <= saidaULA;
                else
                regAC <= regAC;
                end if;
            end if;
        end process;
    
    -- ULA
    ULAX <= regAC;  -- recupera valor X do acumulador
    ULAY <= saidaMEM;  -- recupera valor Y de uma posicao da memória
    process(selULA, ULAX, ULAY)
        begin
            case selULA is
                when "000" => saidaULA <= (ULAX + ULAY); -- operacao ADD
                when "001" => saidaULA <= (ULAX AND ULAY); -- operacao AND
                when "010" => saidaULA <= (ULAX OR ULAY); -- operacao OR
                when "011" => saidaULA <= (NOT ULAX); -- operacao NOT
                when "100" => saidaULA <= ULAY; -- operacao NOP
                when "110" => saidaULA <= (ULAX - ULAY); -- operacao SUB
                when "111" => saidaULA <= (ULAX XOR ULAY); -- operacao XOR
                when others => saidaULA <= "00000000";
            end case;
        end process;   

    -- FLAGS N E Z
    process (CLOCK, RESET)
        begin
            if (RESET='1') then
                regN <= '0';
                regZ <= '0';
                elsif(CLOCK'event and CLOCK='1') then -- na subida do clock
                    if regAC = "00000000" then
                        regZ <= '1';
                    else
                        regZ <= '0';
                    end if;
                    regN <= regAC(7); -- msb do registrador AC
                    end if;
        end process;

    -- REM
    process(CLOCK, RESET)
        begin
            if (RESET='1') then
                regREM <= "00000000";
            elsif (CLOCK'event and CLOCK='1') then -- na subida do clock
                if (cargaREM ='1') then
                    regREM <= saidaMUX;
                else
                    regREM<= regREM;
                end if;
            end if;
        end process;

    -- RDM
    process (CLOCK, RESET)
        begin
            if (RESET='1') then
                regRDM <= "00000000";
            elsif (CLOCK'event and CLOCK='1') then
                if (cargaRDM='1') then
                    regRDM <= regAC;
                else
                    regRDM <= saidaMem;
                end if;
            end if;
        end process;

    -- RI
    process (CLOCK, RESET)
        begin
            if (RESET='1') then
                regRI<= "0000";
            elsif (CLOCK'event and CLOCK='1') then
                if (cargaRI='1') then
                    regRI <= saidaMem(7 DOWNTO 4);
                else
                    regRI <= regRI;
                end if;
            end if;
        end process    

    -- MUX2x1
    process (selMUX, regPC, regRDM)
        begin
            if (selMUX = '0') then
                saidaMUX <= regPC;
            else
                saidaMUX <= regRDM;
            end if;
        end process;

    -- DECOD
    decod <= regRDM(7 downto 4); -- bits mais significativos

    process(decod)
        begin
            instrucao <= "0000000000000000";
            case decod is
                when "0000" => instrucao(0) <= '1'; -- instrucao 00 NOP
                when "0001" => instrucao(1) <= '1'; -- instrucao 16 STA
                when "0010" => instrucao(2) <= '1'; -- instrucao 32 LDA
                when "0011" => instrucao(3) <= '1'; -- instrucao 48 ADD
                when "0100" => instrucao(4) <= '1'; -- instrucao 64 OR
                when "0101" => instrucao(5) <= '1'; -- instrucao 80 AND
                when "0111" => instrucao(6) <= '1'; -- instrucao 96 NOT
                when "1000" => instrucao(8) <= '1'; -- instrucao 128 JMP
                when "1001" => instrucao(9) <= '1'; -- instrucao 144 JN
                when "1010" => instrucao(10) <= '1'; -- instrucao 160 JZ
                when "1011" => instrucao(11) <= '1'; -- instrucao 176 SUB
                when "1100" => instrucao(12) <= '1'; -- instrucao 192 XOR
                when "1101" => instrucao(13) <= '1'; -- instrucao 208 NOP - nao utilizado
                when "1110" => instrucao(14) <= '1'; -- instrucao 224 NOP - nao utilizado
                when "1111" => instrucao(15) <= '1'; -- instrucao 240 HLT
                when others => instrucao <= "0000000000000000";
            end case;
        end process;
    
    -- NEANDER FSM - maquina de estados mealy
    process(CLOCK, RESET)
        begin
            if(RESET = '1') then
                estado_atual <= S0;
            elsif(CLOCK'event and CLOCK = '1') then
                estado_atual <= proximo_estado;
            end if;
        end process;

    -- UNIDADE DE CONTROLE
    process(saidaMEM, instrucao, proximo_estado, regZ, regN)
        begin
            -- reseta
            cargaAC <= '0';
            cargaPC <= '0';
            incrementaPC <= '0';
            cargaNZ <= '0';
            cargaRDM <= '0';
            cargaREM <= '0';
            writeMEM <= '0';
            selMUX <= '0';
            selULA <= "00000000";

            case estado_atual is
                when S0 => 
                    cargaREM <= '1';
                    proximo_estado <= S1;
                when S1 =>
                    cargaREM <= '0';
                    incrementaPC <= '0';
                    proximo_estado <= S2;
                when S2 =>
                    incrementaPC <= '0';
                    cargaRDM <= '1';
                    proximo_estado <= S3;
                when S3 =>
                    incrementaPC <= '0'
                    cargaRDM <= '0';
                    
                    if(instrucao(0) = '1') then --NOP
                        proximo_estado <= S0;
                    elsif(instrucao(6) = '1') then --NOT
                        selULA <= "011";
                        cargaNZ <= '1';
                        cargaAC <= '1';
                    elsif(intrucao(9) = '1' and regN = '0') then --JN quando falso
                        incrementaPC <= '1';
                        proximo_estado <= S0;
                    elsif(instrucao(10) = '1' and regZ = '0') then --JZ quando falso
                        incrementaPC <= '1';
                        proximo_estado <= S0;
                    elsif(instrucao(15) = '1') then --HLT
                        incrementaPC <= '0'
                        proximo_estado <= S8;
                    else
                        selMUX <= '0';
                        cargaREM <= '1';
                        proximo_estado <= S4;
                    end if;
                when S4 =>
                    selMUX <= '0';
                    incrementaPC <= '0';
                    cargaAC <= '0';
                    cargaNZ <= '0';
                    cargaREM <= '0';
                    
                    if(instrucao(1) = '1'
                    or instrucao(2) = '1'
                    or instrucao(3) = '1'
                    or instrucao(4) = '1'
                    or instrucao(5) = '1'
                    or instrucao(11) = '1'
                    or instrucao(12) = '1') then
                        incrementaPC <= '1';
                    end if;
                    proximo_estado <= S5;
                when S5 =>
                    incrementaPC <= '0'

                    if(instrucao(1) = '1'
                    or instrucao(2) = '1'
                    or instrucao(3) = '1'
                    or instrucao(4) = '1'
                    or instrucao(5) = '1'
                    or instrucao(11) = '1'
                    or instrucao(12) = '1') then
                        selMUX <= '1';
                        cargaREM <= '1';
                        proximo_estado <= S6;
                    else
                        cargaPC <= '1';
                        proximo_estado <= S0;
                    end if;
                when S6 =>
                    incrementaPC <= '0';
                    selMUX <= '0';
                    cargaREM <= '0';
                    cargaPC <= '0';
                    proximo_estado <= S7;
                when S7 =>
                    if(instrucao(1) = '1') then
                        writeMEM <= '1';
                    elsif(intrucao(2) = '1') then
                        selULA <= "100";
                    elsif(intrucao(3) = '1') then
                        selULA <= "000";
                    elsif(intrucao(4) = '1') then
                        selULA <= "010";
                    elsif(intrucao(5) = '1') then
                        selULA <= "001";
                    elsif(intrucao(11) = '1') then
                        selULA <= "101";
                    elsif(intrucao(12) = '1') then
                        selULA <= "110";
                    end if;
                when S8 => --HLT
                    proximo_estado <= S8;
                when others =>
                    proximo_estado <= S0;
                end case;
            end process;
        end process;
        DOUT <= saidaAC;
        N <= regN;
        Z <= regZ;
end Behavioral;

