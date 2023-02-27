library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

	-- talvez isso seja uma fechadura com senha, controlada pelo sinal de saida OUT1
entity FSM_BUTTON_MEALY is
	Port
	(
		IN1 : in  STD_LOGIC_VECTOR (3 downto 0);  -- input da senha
		RESET : in  STD_LOGIC;  
        BUTTON : in  STD_LOGIC;  -- botao que o usuario pode apertar
		CLK : in  STD_LOGIC;
		OUT1 : out STD_LOGIC  -- trava da fechadura
	);
end FSM_BUTTON_MEALY;

architecture Behavioral of FSM_BUTTON_MEALY is
	type TYPESTATE is (S0, S1, S2, S3);  -- declara um tipo de variavel que contem cada um dos estados
	signal STATE : TYPESTATE;  -- inicializa um signal com o tipo criado acima
	signal COUNT : STD_LOGIC_VECTOR(3 downto 0);  -- signal registrador contador, incrementa enquanto no S3
	signal LOCK : STD_LOGIC;  -- signal registrador que é mandado para a fechadura
begin
	-- implementar com apenas 1 process
	-- tipo mealy
		-- state e outputs viram registradores (para um process unico)
		-- para 2+ process, apenas state vira registrador
		-- para mais de um process, um geralmente controla o fluxo de estados
	process(CLK, RESET)
	begin
		if(RESET = '1') then
			STATE <= S0;
			COUNT <= "0000";
		elsif (rising_edge(CLK)) then
			case STATE is
				when S0 =>
					-- trava, e reseta a contagem
					-- quando o botão é apertado com a combinaçao certa, vai para S1
					
					if(BUTTON = '1' and IN1 = "1010") then  -- isso faz sentido na testbech onde a gente altera o valor de IN1 (senha?)
						COUNT <= LOCK;
						LOCK <= LOCK;
						STATE <= S1;
					else
						COUNT <= "0000";
						LOCK <= '0';
						STATE <= S0;
					end if;
				when S1 =>
					-- espera o botão ser solto, e avança para S2
					if(BUTTON = '1') then
						COUNT <= COUNT;
						LOCK <= LOCK;
						STATE <= S1;
					else
						COUNT <= COUNT;
						LOCK <= LOCK;
						STATE <= S2;
					end if;
				when S2 =>
					-- espera o botão ser pressionado novamente, indo para S3
					if(BUTTON = '1') then
						COUNT <= COUNT;
						LOCK <= LOCK;
						STATE <= S3;
					else
						COUNT <= COUNT;
						LOCK <= LOCK;
						STATE <= S2;
					end if;
				when S3 =>
					-- ativa o sinal da trava
					-- incrementa a contagem até o sinal contador atingir 10 (10 clocks?)
					-- espera o botao ser solto, entao reseta e volta para S0
					if(COUNT >= "1010" and BUTTON = '1') then -- se o contador atingiu 10 e o botao foi solto
						LOCK <= '0';  -- contagem terminou, desativa a trava
						COUNT <= "0000";
						STATE <= S0; -- se o botao for solto, volta para S0
					elsif(COUNT >= "1010" and BUTTON = '0') then -- se o botao ainda nao foi solto apos a contagem
						LOCK <= '0';  -- contagem terminou, desativa a trava
						COUNT <= COUNT;
						STATE <= S3;
					else -- enquanto o contador nao tiver atingido 10, incrementa a contagem com a trava ativa
						LOCK <= '1';
						COUNT <= STD_LOGIC_VECTOR(unsigned(COUNT) + 1);
						STATE <= S3;
					end if;
				when others =>  
					-- quando em um estado indeterminado, apenas mantem o valor das coisas
					COUNT <= COUNT;
					STATE <= STATE;
					LOCK <= LOCK;
			end case;	
		end if;
	end process;	
	OUT1 <= LOCK;  -- o signal da fechadura é sempre atualizado em OUT1
end Behavioral;

