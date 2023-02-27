LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_shiftregister IS
END tb_shiftregister;
 
ARCHITECTURE behavior OF tb_shiftregister IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sd_shiftregister
    PORT(
         clk : IN  std_logic;
         npode_ld : IN  std_logic;
         SHIFT : IN  std_logic;
         reset : IN  std_logic;
         reg_in : IN  std_logic_vector(7 downto 0);
         reg_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal npode_ld : std_logic := '0';
   signal SHIFT : std_logic := '0';
   signal reset : std_logic := '0';
   signal reg_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal reg_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sd_shiftregister PORT MAP (
          clk => clk,
          npode_ld => npode_ld,
          SHIFT => SHIFT,
          reset => reset,
          reg_in => reg_in,
          reg_out => reg_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
	stim_proc: process
	begin		
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
		wait for 100 ns;
		
		reg_in <= "10000000";
		npode_ld <= '1';
		wait for clk_period*5;
		npode_ld <= '0';
		SHIFT <= '1';
		wait for clk_period*5;

      -- insert stimulus here 

      wait;
   end process;

END;
