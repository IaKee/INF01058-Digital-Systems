library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library work;
--use work.control.control.all;

entity main is
	Port(
		CLOCK: in std_logic;
		RESET: in std_logic;
		mem_out: out std_logic_vector(7 downto 0));
end main;

architecture Behavioral of main is
	-- registradores
	signal DECOD_RI: std_logic_vector(23 downto 0);
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
	signal mem_write: std_logic_vector(0 downto 0);
	
	COMPONENT control
		PORT(
			CLOCK : IN std_logic;
			RESET : IN std_logic;
			DECOD_RI : IN std_logic_vector(23 downto 0);
			reg_N : IN std_logic;
			reg_Z : IN std_logic;
			reg_V : IN std_logic;
			reg_C : IN std_logic;
			reg_B : IN std_logic;          
			inc_PC : OUT std_logic;
			load_ac : OUT std_logic;
			load_pc : OUT std_logic;
			load_REM : OUT std_logic;
			load_RDM : OUT std_logic;
			load_RI : OUT std_logic;
			load_N : OUT std_logic;
			load_Z : OUT std_logic;
			load_V : OUT std_logic;
			load_C : OUT std_logic;
			load_B : OUT std_logic;
			sel_ULA : OUT std_logic_vector(3 downto 0);
			sel_MUXREM : OUT std_logic_vector(0 downto 0);
			sel_MUXRDM : OUT std_logic_vector(0 downto 0);
			mem_write : OUT std_logic_vector(0 to 0)
			);
		END COMPONENT;
	
	COMPONENT datapath
		PORT(
			CLOCK : IN std_logic;
			RESET : IN std_logic;
			inc_PC : IN std_logic;
			load_PC : IN std_logic;
			load_AC : IN std_logic;
			load_REM : IN std_logic;
			load_RDM : IN std_logic;
			load_RI : IN std_logic;
			load_N : IN std_logic;
			load_Z : IN std_logic;
			load_V : IN std_logic;
			load_C : IN std_logic;
			load_B : IN std_logic;
			sel_MUXREM : IN std_logic_vector(0 downto 0);
			sel_MUXRDM : IN std_logic_vector(0 downto 0);
			sel_ULA : IN std_logic_vector(3 downto 0);
			mem_write : IN std_logic_vector(0 to 0);          
			reg_N : OUT std_logic;
			reg_Z : OUT std_logic;
			reg_V : OUT std_logic;
			reg_C : OUT std_logic;
			reg_B : OUT std_logic;
			DECOD_RI : OUT std_logic_vector(23 downto 0));
		END COMPONENT;
	
	
begin
	-- instancia��o da parte de controle
	PC: control PORT MAP(
		CLOCK => CLOCK,
		RESET => RESET,
		DECOD_RI => DECOD_RI,
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
	
	-- instancia��o da parte operativa
	PO: datapath PORT MAP(
		CLOCK => CLOCK,
		RESET => RESET,
		inc_PC => inc_PC,
		load_PC => load_PC,
		load_AC => load_AC,
		load_REM => load_REM,
		load_RDM => load_REM,
		load_RI => load_REM,
		load_N => load_N,
		load_Z => load_Z,
		load_V => load_V,
		load_C => load_C,
		load_B => load_B,
		sel_MUXREM => sel_MUXREM,
		sel_MUXRDM => sel_MUXRDM,
		sel_ULA => sel_ULA,
		mem_write => mem_write,
		reg_N => reg_N,
		reg_Z => reg_Z,
		reg_V => reg_V,
		reg_C => reg_C,
		reg_B => reg_B,
		DECOD_RI => DECOD_RI);
		
end Behavioral;

