----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:11:02 12/20/2022 
-- Design Name: 
-- Module Name:    sd_memoria - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sd_memoria is
	Port
	(
		RESET : in  STD_LOGIC;
		START : in  STD_LOGIC;
		DOUT : out  STD_LOGIC_VECTOR (7 downto 0);
		CLK : in  STD_LOGIC;
		V : in  STD_LOGIC
	);
end sd_memoria;

architecture Behavioral of sd_memoria is
	signal addr : STD_LOGIC_VECTOR(3 downto 0);
	signal din, doutint : STD_LOGIC_VECTOR(7 downto 0);
	signal wr : STD_LOGIC_VECTOR(3 downto 0);
	
	type FSM_STATE is (S0, S1, S2, END1, END2);
	signal FSM_STATE STATE;
	
begin
	COMPONENT bram1
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	-- COMP_TAG_END ------ End COMPONENT Declaration ------------

	-- The following code must appear in the VHDL architecture
	-- body. Substitute your own instance name and net names.

	------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
	your_instance_name : bram1
	  PORT MAP (
		 clka => clka,
		 wea => wea,
		 addra => addra,
		 dina => dina,
		 douta => douta
	  );

end Behavioral;

