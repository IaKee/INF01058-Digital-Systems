LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_FSMBUTTON IS
END tb_FSMBUTTON;
 
ARCHITECTURE behavior OF tb_FSMBUTTON IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSM_BUTTON
		PORT
		(
			 IN1 : IN  std_logic_vector(3 downto 0);
			 RESET : IN  std_logic;
			 BUTTON : IN  std_logic;
			 CLK : IN  std_logic;
			 OUT1 : OUT  std_logic
		);
    END COMPONENT;
    

   --Inputs
   signal IN1 : std_logic_vector(3 downto 0) := (others => '0');
   signal RESET : std_logic := '0';
   signal BUTTON : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT1 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSM_BUTTON PORT MAP 
		(
			IN1 => IN1,
			RESET => RESET,
			BUTTON => BUTTON,
			CLK => CLK,
			OUT1 => OUT1
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
	stim_proc: process
	begin		
		BUTTON <= '0';  -- reseta o estado do botao
		RESET <= '1';
		wait for 100 ns;
		RESET <= '0';
		wait for 100 ns;

		wait for CLK_period*3;
		IN1 <= "1010";  -- coloca a senha correta em IN1
		wait for CLK_period*3;
		BUTTON <= '1';  -- aperta o botao por 10 ciclos do relogio
		wait for CLK_period*3;
		BUTTON <= '0';  -- solta o botao
		wait for CLK_period*3;
		BUTTON <= '1';  -- aperta o botao
		-- nos proximos 10 clocks a trava da fechadura vai estar ativa
		wait for CLK_period*10;
		BUTTON <= '0';  -- solta o botao
		wait for CLK_period*3;
		
		-- resetou a maquina de estados
		
		wait for CLK_period*3;
		IN1 <= "1111";  -- coloca a senha incorreta em IN1
		wait for CLK_period*3;
		BUTTON <= '1';  -- aperta o botao por 10 ciclos do relogio
		wait for CLK_period*3;
		BUTTON <= '0';  -- solta o botao
		wait for CLK_period*3;
		BUTTON <= '1';  -- aperta o botao
		-- nos proximos 10 clocks a trava da fechadura vai estar ativa
		wait for CLK_period*10;
		BUTTON <= '0';  -- solta o botao
		wait for CLK_period*3;

		wait;
	end process;

END;
