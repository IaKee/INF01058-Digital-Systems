library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity cktula2reg is
	Port (
		-- registradores
		INX: in  STD_LOGIC_VECTOR (7 downto 0);  -- entrada 1 do circuito
		INY: in  STD_LOGIC_VECTOR (7 downto 0);  -- entrada 2 do circuito
		CLK : in  STD_LOGIC;  -- relogio dos registradores
		RESET : in  STD_LOGIC;  -- reset dos registradores
		CONT : in  STD_LOGIC; -- quando ligado, registrador incrementa com o tempo
		
		-- entradas para carregamento de valores nos registradores X, Y e Z
		LOADX : in STD_LOGIC;
		LOADY : in STD_LOGIC;
		LOADZ : in STD_LOGIC;
		
		SEL : in  STD_LOGIC_VECTOR (1 downto 0);  -- seletor da ula
		RESP : out  STD_LOGIC_VECTOR (7 downto 0) -- saida do circuito
	);
end cktula2reg;
			 
architecture Behavioral of cktula2reg is
	-- valores de saida dos registradores X, Y e Z
	signal REGX : STD_LOGIC_VECTOR (7 downto 0);
	signal REGY : STD_LOGIC_VECTOR (7 downto 0);
	signal REGZ : STD_LOGIC_VECTOR (7 downto 0);
	
	-- portas da ula
	signal ULAX : STD_LOGIC_VECTOR (7 downto 0);
	signal ULAY : STD_LOGIC_VECTOR (7 downto 0);
	signal ULAS : STD_LOGIC_VECTOR (7 downto 0);
	
begin  -- inicio do behavioral
	-- conexoes fixas
	ULAX <= REGX;
	ULAY <= REGY;
	RESP <= REGZ;

	process(CLK, RESET)  -- registrador X
		begin
			if(RESET = '1') then  -- se o sinal de reset estiver ligado
				REGX <= "00000000";	-- reseta (ja eh conectado a saida)
			else  -- se o sinal de reset estiver desligado
				if(rising_edge(CLK)) then -- no pulso de subida do clock
					if(LOADX = '1') then
						REGX <= INX;  -- carrega o valor da entrada
					else
						if(CONT = '1') then
							REGX <= STD_LOGIC_VECTOR(unsigned(REGX) + 1);  -- incrementa a contagem
						else
							REGX <= REGX;  -- mantem o valor
						end if;
					end if;
				end if;
			end if;
	end process;
	
	process(CLK, RESET)  -- registrador Y
		begin
			if(RESET = '1') then  -- se o sinal de reset estiver ligado
				REGY <= "00000000";	-- reseta (ja eh conectado a saida)
			else  -- se o sinal de reset estiver desligado
				if(rising_edge(CLK)) then -- no pulso de subida do clock
					if(LOADY = '1') then
						REGY <= INY;  -- carrega o valor da entrada
					else
						if(CONT = '1') then
							REGY <= STD_LOGIC_VECTOR(unsigned(REGY) + 1);  -- incrementa a contagem
						else
							REGY <= REGY;  -- mantem o valor
						end if;
					end if;
				end if;
			end if;
	end process;
	
	
	process(CLK, RESET)  -- registrador Z (n tem contador)
		begin
			if(RESET = '1') then  -- se o sinal de reset estiver ligado
				REGZ <= "00000000";	-- reseta (ja eh conectado a saida)
			else  -- se o sinal de reset estiver desligado
				if(rising_edge(CLK)) then -- no pulso de subida do clock
					if(LOADZ = '1') then
						REGZ <= ULAS;  -- carrega o valor da entrada
					else
						REGZ <= REGZ;  -- mantem o valor
					end if;
				end if;
			end if;
	end process;

	process(ULAX, ULAY, SEL) -- processo da ula
		begin
			case SEL is
				when "00" =>
					ULAS <= STD_LOGIC_VECTOR (unsigned(ULAX) + unsigned(ULAY));
				when "01" =>
					ULAS <= STD_LOGIC_VECTOR (unsigned(ULAX) - unsigned(ULAY));
				when "10" =>
					ULAS <= STD_LOGIC_VECTOR (ULAX XOR ULAY);
				when "11" =>
					ULAS <= STD_LOGIC_VECTOR (ULAX AND ULAY);
				when others =>
					ULAS <= "XXXXXXXX";
		end case;
	end process;

end Behavioral;

