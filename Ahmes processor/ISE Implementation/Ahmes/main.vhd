library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

entity main is
	port(
		CLOCK: in std_logic;
		RESET: in std_logic;
		mem_out: out std_logic_vector(7 downto 0));
end main;

architecture Behavioral of main is
	-- control signals for linking datapath and control units
	signal s_instruction_flags: std_logic_vector(23 downto 0);
	signal s_reg_N: std_logic;
	signal s_reg_Z: std_logic;
	signal s_reg_V: std_logic;
	signal s_reg_C: std_logic;
	signal s_reg_B: std_logic;
	signal s_inc_PC: std_logic;
	signal s_load_AC: std_logic;
	signal s_load_PC: std_logic;
	signal s_load_MA: std_logic;
	signal s_load_MD: std_logic;
	signal s_load_I: std_logic;
	signal s_load_N: std_logic;
	signal s_load_Z: std_logic;
	signal s_load_V: std_logic;
	signal s_load_C: std_logic;
	signal s_load_B: std_logic;
	signal s_sel_MUX_MAR: std_logic_vector(0 downto 0);
	signal s_sel_MUX_MDR: std_logic_vector(0 downto 0);
	signal s_sel_ALU: std_logic_vector(3 downto 0);
	signal s_mem_read: std_logic_vector(0 downto 0);
	signal s_mem_write: std_logic_vector(0 downto 0);
	signal o_mem_out: std_logic_vector(7 downto 0);
	
	component control
	port(
		CLOCK: in std_logic;
		RESET: in std_logic;
		instruction_flags: in std_logic_vector(23 downto 0);
		reg_N: in std_logic;
		reg_Z: in std_logic;
		reg_V: in std_logic;
		reg_C: in std_logic;
		reg_B: in std_logic;          
		inc_PC: out std_logic;
		load_AC: out std_logic;
		load_PC: out std_logic;
		load_MA: out std_logic;
		load_MD: out std_logic;
		load_I: out std_logic;
		load_N: out std_logic;
		load_Z: out std_logic;
		load_V: out std_logic;
		load_C: out std_logic;
		load_B: out std_logic;
		sel_MUX_MAR: out std_logic_vector(0 to 0);
		sel_MUX_MDR: out std_logic_vector(0 to 0);
		sel_ALU: out std_logic_vector(3 downto 0);
		mem_read: out std_logic_vector(0 to 0);
		mem_write: out std_logic_vector(0 to 0));
		end component;
	
	component datapath
		port(
			CLOCK: in std_logic;
			RESET: in std_logic;
			inc_PC: in std_logic;
			load_PC: in std_logic;
			load_AC: in std_logic;
			load_MA: in std_logic;
			load_MD: in std_logic;
			load_I: in std_logic;
			load_N: in std_logic;
			load_Z: in std_logic;
			load_V: in std_logic;
			load_C: in std_logic;
			load_B: in std_logic;
			sel_MUX_MAR: in std_logic_vector(0 to 0);
			sel_MUX_MDR: in std_logic_vector(0 to 0);
			sel_ALU: in std_logic_vector(3 downto 0);
			mem_read: in std_logic_vector(0 to 0);
			mem_write: in std_logic_vector(0 to 0);          
			mem_out: out std_logic_vector(7 downto 0);
			reg_N: out std_logic;
			reg_Z: out std_logic;
			reg_V: out std_logic;
			reg_C: out std_logic;
			reg_B: out std_logic;
			instruction_flags: out std_logic_vector(23 downto 0));
		end component;
	
	begin
		-- hw connections
		mem_out <= o_mem_out;
		
		CTRL: control PORT MAP(
			CLOCK => CLOCK,
			RESET => RESET,
			instruction_flags => s_instruction_flags,
			reg_N => s_reg_N,
			reg_Z => s_reg_Z,
			reg_V => s_reg_V,
			reg_C => s_reg_C,
			reg_B => s_reg_B,
			inc_PC => s_inc_PC,
			load_AC => s_load_AC,
			load_PC => s_load_PC,
			load_MA => s_load_MA,
			load_MD => s_load_MD,
			load_I => s_load_I,
			load_N => s_load_N,
			load_Z => s_load_Z,
			load_V => s_load_V,
			load_C => s_load_C,
			load_B => s_load_B,
			sel_MUX_MAR => s_sel_MUX_MAR,
			sel_MUX_MDR => s_sel_MUX_MDR,
			sel_ALU => s_sel_ALU,
			mem_read => s_mem_read,
			mem_write => s_mem_write);
		
		DP: datapath PORT MAP(
			CLOCK => CLOCK,
			RESET => RESET,
			inc_PC => s_inc_PC,
			load_PC => s_load_PC,
			load_AC => s_load_AC,
			load_MA => s_load_MA,
			load_MD => s_load_MD,
			load_I => s_load_I,
			load_N => s_load_N,
			load_Z => s_load_Z,
			load_V => s_load_V,
			load_C => s_load_C,
			load_B => s_load_B,
			sel_MUX_MAR => s_sel_MUX_MAR,
			sel_MUX_MDR => s_sel_MUX_MDR,
			sel_ALU => s_sel_ALU,
			mem_read => s_mem_read,
			mem_write => s_mem_write,
			mem_out => o_mem_out,
			reg_N => s_reg_N,
			reg_Z => s_reg_Z,
			reg_V => s_reg_V,
			reg_C => s_reg_C,
			reg_B => s_reg_B,
			instruction_flags => s_instruction_flags);
	end Behavioral;

