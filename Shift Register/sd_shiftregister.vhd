library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sd_shiftregister is
    Port ( clk : in  STD_LOGIC;
           npode_ld : in  STD_LOGIC;
           SHIFT : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           reg_in : in  STD_LOGIC_VECTOR (7 downto 0);
           reg_out : out  STD_LOGIC_VECTOR (7 downto 0));
end sd_shiftregister;

architecture Behavioral of sd_shiftregister is
	signal reg: std_logic_vector(7 downto 0);
begin
	process(reset, clk)
		begin
			if(rising_edge(clk)) then
				if(npode_ld = '1') then
					reg <= reg_in;
				elsif(SHIFT = '1') then -- shift right
					reg <= std_logic_vector(shift_right(unsigned(reg), 1));
				else  -- shift left
					reg <= std_logic_vector(shift_left(unsigned(reg), 1));
				end if;
			end if;
		end process;
	reg_out <= reg;

end Behavioral;

