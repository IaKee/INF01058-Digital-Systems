
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sd_fsmprova is
    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           E : in  STD_LOGIC;
           Z : out  STD_LOGIC_VECTOR (1 downto 0));
end sd_fsmprova;

architecture Behavioral of sd_fsmprova is
	type state is (S1, S2, S3);
	signal current_state, next_state: state;
begin

	process(CLOCK, RESET)
		begin
			if(rising_edge(CLOCK)) then
				if(RESET = '1') then
					current_state <= S1;
				else
					current_state <= next_state;
				end if;
			else
				current_state <= current_state;
			end if;
		end process;
		
	process(current_state, E)
		begin
			case current_state is
				when S1 =>
					if(E = '1') then
						Z <= "01";
						next_state <= S2;
					else
						next_state <= next_state;
					end if;
				when S2 =>
					if(E = '1') then
						Z <= "11";
						next_state <= S1;
					else
						Z <= "11";
						next_state <= S3;
					end if;
				when S3 =>
					if(E = '1') then
						Z <= "10";
						next_state <= S3;
					else
						Z <= "00";
						next_state <= S2;
					end if;
				when others => 
					Z <= "00";
			end case;
		end process;

end Behavioral;

