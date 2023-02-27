LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_alt IS
END tb_alt;
 
ARCHITECTURE behavior OF tb_alt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cktula2reg
    PORT(
         INX : IN  std_logic_vector(7 downto 0);
         INY : IN  std_logic_vector(7 downto 0);
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
   signal INX : std_logic_vector(7 downto 0) := (others => '0');
   signal INY : std_logic_vector(7 downto 0) := (others => '0');
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
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cktula2reg PORT MAP (
          INX => INX,
          INY => INY,
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
	  INX <= "00001111";  -- entrada 1 - 240
	  INY <= "11110000";  -- entrada 2 - 15
	  SEL <= "00";  -- operacao add
	  -- resultado esperado 1111 1111
	  
	  wait for CLK_period*10;
	  INX <= "11111111";  -- entrada 1
	  INY <= "10101010";  -- entrada 2 
	  SEL <= "01";  -- operacao sub
	  -- resultado esperado 0101 0101
	  
	  wait for CLK_period*10;
	  INX <= "11111111";  -- entrada 1
	  INY <= "01010101";  -- entrada 2
	  SEL <= "10";  -- operacao xor
	  -- resultado esperado 1010 1010
	  
	  wait for CLK_period*10;
	  INX <= "11111111";  -- entrada 1
	  INY <= "11110000";  -- entrada 2
	  SEL <= "11";  -- operacao and
	  -- resultado esperado 1111 0000
	  
	  wait for CLK_period*10;
	  INX <= "11110000";  -- entrada 1
	  INY <= "00000000";  -- entrada 2
	  SEL <= "00";  -- operacao add
	  LOADX <= '0';
	  LOADY <= '0';
	  CONT <= '1';
	  -- resultado esperado 1111 0000
	  
      wait;  -- pause
   end process;

END;
