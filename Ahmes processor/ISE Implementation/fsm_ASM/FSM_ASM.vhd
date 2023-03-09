library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_ASM is
    Port(
		CLOCK : in  STD_LOGIC;
        RESET : in  STD_LOGIC;
        A : in  STD_LOGIC;
        B : in  STD_LOGIC);
end FSM_ASM;

	architecture Behavioral of FSM_ASM is

	type signal_state is (S0, S1, DONE);
	signal current_state: signal_state := S0;
	signal next_state: signal_state := S0;
	
	signal RST, LDA, CONT, SHR,: std_logic;
	
begin
	state_control: process(CLOCK, RESET)
		begin
			if(RESET = '1') then
				current_state <= S0;
			elsif(rising_edge(CLOCK)) then
				current_state <= next_state;
			end if;
		end process;
	
	control: process(current_state, A, B)
		begin
			case current_state is
				when S0 =>
					RST <= '1';
					
				when S1 =>
				when DONE =>
				when others =>
			end case;
		end process;
end Behavioral;

