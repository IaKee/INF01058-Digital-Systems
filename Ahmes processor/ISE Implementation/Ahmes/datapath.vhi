
-- VHDL Instantiation Created from source file datapath.vhd -- 16:03:32 03/09/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT datapath
	PORT(
		CLOCK : IN std_logic;
		RESET : IN std_logic;
		inc_PC : IN std_logic;
		load_PC : IN std_logic;
		load_AC : IN std_logic;
		load_MA : IN std_logic;
		load_MD : IN std_logic;
		load_I : IN std_logic;
		load_N : IN std_logic;
		load_Z : IN std_logic;
		load_V : IN std_logic;
		load_C : IN std_logic;
		load_B : IN std_logic;
		sel_MUX_MAR : IN std_logic_vector(0 to 0);
		sel_MUX_MDR : IN std_logic_vector(0 to 0);
		sel_ALU : IN std_logic_vector(3 downto 0);
		mem_read : IN std_logic_vector(0 to 0);
		mem_write : IN std_logic_vector(0 to 0);          
		mem_out : OUT std_logic_vector(7 downto 0);
		reg_N : OUT std_logic;
		reg_Z : OUT std_logic;
		reg_V : OUT std_logic;
		reg_C : OUT std_logic;
		reg_B : OUT std_logic;
		instruction_flags : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;

	Inst_datapath: datapath PORT MAP(
		CLOCK => ,
		RESET => ,
		inc_PC => ,
		load_PC => ,
		load_AC => ,
		load_MA => ,
		load_MD => ,
		load_I => ,
		load_N => ,
		load_Z => ,
		load_V => ,
		load_C => ,
		load_B => ,
		sel_MUX_MAR => ,
		sel_MUX_MDR => ,
		sel_ALU => ,
		mem_read => ,
		mem_write => ,
		mem_out => ,
		reg_N => ,
		reg_Z => ,
		reg_V => ,
		reg_C => ,
		reg_B => ,
		instruction_flags => 
	);


