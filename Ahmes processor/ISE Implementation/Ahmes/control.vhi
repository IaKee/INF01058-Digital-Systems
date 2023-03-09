
-- VHDL Instantiation Created from source file control.vhd -- 16:21:48 03/09/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT control
	PORT(
		CLOCK : IN std_logic;
		RESET : IN std_logic;
		instruction_flags : IN std_logic_vector(23 downto 0);
		reg_N : IN std_logic;
		reg_Z : IN std_logic;
		reg_V : IN std_logic;
		reg_C : IN std_logic;
		reg_B : IN std_logic;          
		inc_PC : OUT std_logic;
		load_AC : OUT std_logic;
		load_PC : OUT std_logic;
		load_MA : OUT std_logic;
		load_MD : OUT std_logic;
		load_I : OUT std_logic;
		load_N : OUT std_logic;
		load_Z : OUT std_logic;
		load_V : OUT std_logic;
		load_C : OUT std_logic;
		load_B : OUT std_logic;
		sel_MUX_MAR : OUT std_logic_vector(0 to 0);
		sel_MUX_MDR : OUT std_logic_vector(0 to 0);
		sel_ALU : OUT std_logic_vector(3 downto 0);
		mem_read : OUT std_logic_vector(0 to 0);
		mem_write : OUT std_logic_vector(0 to 0)
		);
	END COMPONENT;

	Inst_control: control PORT MAP(
		CLOCK => ,
		RESET => ,
		instruction_flags => ,
		reg_N => ,
		reg_Z => ,
		reg_V => ,
		reg_C => ,
		reg_B => ,
		inc_PC => ,
		load_AC => ,
		load_PC => ,
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
		mem_write => 
	);


