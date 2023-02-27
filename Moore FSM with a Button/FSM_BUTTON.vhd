library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

	-- talvez isso seja uma fechadura com senha, controlada pelo sinal de saida OUT1
entity FSM_BUTTON is
	Port
	(
		IN1 : in  STD_LOGIC_VECTOR (3 downto 0);  -- input da senha
		RESET : in  STD_LOGIC;  
        BUTTON : in  STD_LOGIC;  -- botao que o usuario pode apertar
		CLK : in  STD_LOGIC;
		OUT1 : out STD_LOGIC  -- trava da fechadura
	);
end FSM_BUTTON;

architecture Behavioral of FSM_BUTTON is
	type TYPESTATE is (S0, S1, S2, S3, S4);  -- declara um tipo de variavel que contem cada um dos estados
	signal STATE : TYPESTATE;  -- inicializa um signal com o tipo criado acima
	signal COUNT : STD_LOGIC_VECTOR(3 downto 0);  -- signal registrador contador, incrementa enquanto no S3
	signal LOCK : STD_LOGIC;  -- signal registrador que é mandado para a fechadura
begin
	-- implementar com apenas 1 process
	-- tipo moore
		-- os valores de saida sao determinados pelo estado atual da FSM
		-- nessas maquinas, geralmente o input influencia o proximo estado
		-- no diagrama de estados os valores de saida que são associados a cada um dos estados
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
					COUNT <= "0000";
					LOCK <= '0';
					if(BUTTON = '1' and IN1 = "1010") then  -- isso faz sentido na testbech onde a gente altera o valor de IN1 (senha?)
						STATE <= S1;
					else
						STATE <= S0;
					end if;
				when S1 =>
					-- espera o botão ser solto, e avança para S2
					COUNT <= COUNT;
					LOCK <= LOCK;
					if(BUTTON = '1') then
						STATE <= S1;
					else
						STATE <= S2;
					end if;
				when S2 =>
					-- espera o botão ser pressionado novamente, indo para S3
					COUNT <= COUNT;
					LOCK <= LOCK;
					if(BUTTON = '1') then
						STATE <= S3;
					else
						STATE <= S2;
					end if;
				when S3 =>
					-- ativa o sinal da trava
					-- incrementa a contagem até o sinal contador atingir 10 (10 clocks?)
					-- após isso vai para S4
					COUNT <= STD_LOGIC_VECTOR(unsigned(COUNT) + 1);
					LOCK <= '1';
					if(COUNT <= "1010") then -- até o contador atingir 10
						STATE <= S3;
					else
						STATE <= S4;
					end if;
				when S4 =>
					-- desativa o sinal da trava
					-- reinicia o contador
					-- espera o botao ser solto para retornar a S0
					COUNT <= "0000";
					LOCK <= '0';
					if(BUTTON = '0') then
						STATE <= S0;
					else
						STATE <= S4;
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

