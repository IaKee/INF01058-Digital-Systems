LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ula IS
END tb_ula;
 
ARCHITECTURE behavior OF tb_ula IS 

    COMPONENT cktula2reg
    PORT(
         IN1 : IN  std_logic_vector(7 downto 0);
         IN2 : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         CONT : IN  std_logic;
         LOADX : IN  std_logic;
         LOADY : IN  std_logic;
         LOADZ : IN  std_logic;
         SEL : IN  std_logic_vector(1 downto 0);
         RESP : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN1 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN2 : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal CONT : std_logic := '0';
   signal LOADX : std_logic := '0';
   signal LOADY : std_logic := '0';
   signal LOADZ : std_logic := '0';
   signal SEL : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal RESP : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
   uut: cktula2reg PORT MAP (
          IN1 => IN1,
          IN2 => IN2,
          CLK => CLK,
          RESET => RESET,
          CONT => CONT,
          LOADX => LOADX,
          LOADY => LOADY,
          LOADZ => LOADZ,
          SEL => SEL,
          RESP => RESP
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
      -- hold reset state for 100 ns.
	  RESET <= '1';
      wait for 100 ns;	
	  RESET <= '0';
	  
	  wait for CLK_period*2;
	  
	  -- teste sempre ligado
	  LOADX <= '1';
	  LOADY <= '1';
	  LOADZ <= '1';
	  
	  CONT <= '0';  -- nao conta, bgl esquisito 
	  
	  wait for CLK_period*10;
	  IN1 <= "00001111";  -- entrada 1 - 240
	  IN2 <= "11110000";  -- entrada 2 - 15
	  SEL <= "00";  -- operacao soma
	  -- resultado esperado 1111 1111
	  
	  wait for CLK_period*10;
	  IN1 <= "11111111";  -- entrada 1
	  IN2 <= "10101010";  -- entrada 2 
	  SEL <= "01";  -- operacao sub
	  -- resultado esperado 0101 0101
	  
	  wait for CLK_period*10;
	  IN1 <= "11111111";  -- entrada 1
	  IN2 <= "01010101";  -- entrada 2
	  SEL <= "10";  -- operacao xor
	  -- resultado esperado 1010 1010
	  
	  wait for CLK_period*10;
	  IN1 <= "11111111";  -- entrada 1
	  IN2 <= "11110000";  -- entrada 2
	  SEL <= "11";  -- operacao and
	  -- resultado esperado 1111 0000
	  
      wait;  -- pause
   end process;

END;
