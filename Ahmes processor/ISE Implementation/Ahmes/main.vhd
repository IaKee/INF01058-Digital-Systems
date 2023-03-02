library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main is
	Port(
		CLOCK: std_logic;
		RESET: std_logic);
end main;

architecture Behavioral of main is
	-- registradores
	signal reg_RI: std_logic_vector(7 downto 0);
	signal reg_N: std_logic;
	signal reg_Z: std_logic;
	signal reg_V: std_logic;
	signal reg_C: std_logic;
	signal reg_B: std_logic;
	signal inc_PC: std_logic;
	signal load_ac: std_logic;
	signal load_pc: std_logic;
	signal load_REM: std_logic;
	signal load_RDM: std_logic;
	signal load_RI: std_logic;
	signal load_N: std_logic;
	signal load_Z: std_logic;
	signal load_V: std_logic;
	signal load_C: std_logic;
	signal load_B: std_logic;
	signal sel_ULA: std_logic_vector(3 downto 0);
	signal sel_MUXREM: std_logic_vector(0 downto 0);
	signal sel_MUXRDM: std_logic_vector(0 downto 0);
	signal mem_write: std_logic;
	
	-- instanciação da parte de controle
	control: control_ahmes PORT MAP(
		CLOCK => CLOCK,
		RESET => RESET,
		reg_RI => reg_RI,
		reg_N => reg_N,
		reg_Z => reg_Z,
		reg_V => reg_V,
		reg_C => reg_C,
		reg_B => reg_B,
		inc_PC => inc_PC,
		load_ac => load_ac,
		load_pc => load_pc,
		load_REM => load_REM,
		load_RDM => load_RDM,
		load_RI => load_RI,
		load_N => load_N,
		load_Z => load_Z,
		load_V => load_V,
		load_C => load_C,
		load_B => load_B,
		sel_ULA => sel_ULA,
		sel_MUXREM => sel_MUXREM,
		sel_MUXRDM => sel_MUXRDM,
		mem_write => mem_write);
	
begin
	-- vazio

	
end Behavioral;

