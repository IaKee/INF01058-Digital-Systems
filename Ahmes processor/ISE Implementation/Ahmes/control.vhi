
-- VHDL Instantiation Created from source file control.vhd -- 22:10:44 03/06/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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
		sel_MUXREM : OUT std_logic;
		sel_MUXRDM : OUT std_logic;
		mem_write : OUT std_logic_vector(0 to 0)
		);
	END COMPONENT;

	Inst_control: control PORT MAP(
		CLOCK => ,
		RESET => ,
		DECOD_RI => ,
		reg_N => ,
		reg_Z => ,
		reg_V => ,
		reg_C => ,
		reg_B => ,
		inc_PC => ,
		load_ac => ,
		load_pc => ,
		load_REM => ,
		load_RDM => ,
		load_RI => ,
		load_N => ,
		load_Z => ,
		load_V => ,
		load_C => ,
		load_B => ,
		sel_ULA => ,
		sel_MUXREM => ,
		sel_MUXRDM => ,
		mem_write => 
	);


