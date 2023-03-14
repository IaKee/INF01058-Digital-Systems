
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ahmes_tb is
end ahmes_tb;
 
ARCHITECTURE behavior OF ahmes_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
		PORT(
			 CLOCK : IN  std_logic;
			 RESET : IN  std_logic;
			 mem_out : OUT  std_logic_vector(7 downto 0));
		END COMPONENT;
    

	--Inputs
	signal CLOCK: std_logic := '0';
	signal RESET: std_logic := '0';

 	--Outputs
	signal mem_out: std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant CLOCK_period : time := 10 ns;
 
	BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: main PORT MAP (
		CLOCK => CLOCK,
        RESET => RESET,
        mem_out => mem_out);

   -- Clock process definitions
	CLOCK_process :process
		begin
			CLOCK <= '0';
			wait for CLOCK_period/2;
			CLOCK <= '1';
			wait for CLOCK_period/2;
		end process;
 

	-- Stimulus process
	stim_proc: process
		begin		
			-- hold reset state for 100 ns.
			RESET <= '1';
			
			wait for 100 ns;	
			RESET <= '0';
			wait for CLOCK_period*50;
			wait;
	end process;
END;
