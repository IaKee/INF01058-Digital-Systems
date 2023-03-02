
-- VHDL Instantiation Created from source file datapath_ahmes.vhd -- 11:28:55 03/02/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT datapath_ahmes
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
		sel_MUXREM : IN std_logic;
		sel_MUXRDM : IN std_logic;
		sel_ULA : IN std_logic_vector(3 downto 0);
		mem_write : IN std_logic_vector(0 to 0);          
		reg_N : OUT std_logic;
		reg_Z : OUT std_logic;
		reg_V : OUT std_logic;
		reg_C : OUT std_logic;
		reg_B : OUT std_logic;
		DECOD_RI : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;

	Inst_datapath_ahmes: datapath_ahmes PORT MAP(
		CLOCK => ,
		RESET => ,
		inc_PC => ,
		load_PC => ,
		load_AC => ,
		load_REM => ,
		load_RDM => ,
		load_RI => ,
		load_N => ,
		load_Z => ,
		load_V => ,
		load_C => ,
		load_B => ,
		sel_MUXREM => ,
		sel_MUXRDM => ,
		sel_ULA => ,
		mem_write => ,
		reg_N => ,
		reg_Z => ,
		reg_V => ,
		reg_C => ,
		reg_B => ,
		DECOD_RI => 
	);


