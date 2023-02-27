library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity sd_ula4op is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
           A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           ULA_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
end sd_ula4op;

architecture Behavioral of sd_ula4op is
	signal ula_op: std_logic_vector(7 downto 0);
begin
	process(A, B, sel)
		begin
			case sel is
				when "00" => -- soma
					ula_op <= std_logic_vector(unsigned(A) + unsigned(B));
				when "01" => -- sub
					ula_op <= std_logic_vector(unsigned(A) - unsigned(B));
				when "10" => -- inc
					ula_op <= std_logic_vector(unsigned(A) + 1);
				when "11" => -- dec
					ula_op <= std_logic_vector(unsigned(A) - 1);
				when others => ula_op <= ula_op;
			end case;
		end process;
	ULA_OUT <= ula_op;
end Behavioral;

