LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_cktula IS
END tb_cktula;
 
ARCHITECTURE behavior OF tb_cktula IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cktula2reg
		PORT
		(
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
 
	-- Instantiate the Unit Under Test (UUT)
	uut: cktula2reg PORT MAP 
	(
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
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
