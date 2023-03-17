--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: main_synthesis.vhd
-- /___/   /\     Timestamp: Thu Mar 16 20:41:55 2023
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -ar Structure -tm main -w -dir netgen/synthesis -ofmt vhdl -sim main.ngc main_synthesis.vhd 
-- Device	: xc7a100t-3-csg324
-- Input file	: main.ngc
-- Output file	: D:\Documentos\Escola\UFRGS\Nono semestre\INF01058-Digital-Systems\Ahmes processor\ISE Implementation\Ahmes\netgen\synthesis\main_synthesis.vhd
-- # of Entities	: 1
-- Design Name	: main
-- Xilinx	: D:\Xilinx\14.7\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


-- synthesis translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity main is
  port (
    CLOCK : in STD_LOGIC := 'X'; 
    RESET : in STD_LOGIC := 'X'; 
    mem_out : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end main;

architecture Structure of main is
  component mem_ahmes
    port (
      clka : in STD_LOGIC := 'X'; 
      wea : in STD_LOGIC_VECTOR ( 0 downto 0 ); 
      addra : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
      dina : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
      douta : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
    );
  end component;
  signal CLOCK_BUFGP_0 : STD_LOGIC; 
  signal RESET_IBUF_1 : STD_LOGIC; 
  signal CTRL_current_state_FSM_FFd4_2 : STD_LOGIC; 
  signal CTRL_current_state_FSM_FFd3_3 : STD_LOGIC; 
  signal mem_out_7_OBUF_4 : STD_LOGIC; 
  signal mem_out_6_OBUF_5 : STD_LOGIC; 
  signal mem_out_5_OBUF_6 : STD_LOGIC; 
  signal mem_out_4_OBUF_7 : STD_LOGIC; 
  signal mem_out_3_OBUF_8 : STD_LOGIC; 
  signal mem_out_2_OBUF_9 : STD_LOGIC; 
  signal mem_out_1_OBUF_10 : STD_LOGIC; 
  signal mem_out_0_OBUF_11 : STD_LOGIC; 
  signal DP_MDR_MUX_out : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal DP_reg_MD : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal DP_reg_MA : STD_LOGIC_VECTOR ( 0 downto 0 ); 
begin
  XST_GND : GND
    port map (
      G => DP_reg_MA(0)
    );
  CTRL_current_state_FSM_FFd4 : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => CLOCK_BUFGP_0,
      D => DP_reg_MA(0),
      PRE => RESET_IBUF_1,
      Q => CTRL_current_state_FSM_FFd4_2
    );
  CTRL_current_state_FSM_FFd3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CLR => RESET_IBUF_1,
      D => CTRL_current_state_FSM_FFd4_2,
      Q => CTRL_current_state_FSM_FFd3_3
    );
  DP_reg_MD_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(7),
      Q => DP_reg_MD(7)
    );
  DP_reg_MD_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(6),
      Q => DP_reg_MD(6)
    );
  DP_reg_MD_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(5),
      Q => DP_reg_MD(5)
    );
  DP_reg_MD_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(4),
      Q => DP_reg_MD(4)
    );
  DP_reg_MD_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(3),
      Q => DP_reg_MD(3)
    );
  DP_reg_MD_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(2),
      Q => DP_reg_MD(2)
    );
  DP_reg_MD_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(1),
      Q => DP_reg_MD(1)
    );
  DP_reg_MD_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => CLOCK_BUFGP_0,
      CE => CTRL_current_state_FSM_FFd3_3,
      CLR => RESET_IBUF_1,
      D => DP_MDR_MUX_out(0),
      Q => DP_reg_MD(0)
    );
  DP_Mmux_MDR_MUX_out11 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_0_OBUF_11,
      O => DP_MDR_MUX_out(0)
    );
  DP_Mmux_MDR_MUX_out21 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_1_OBUF_10,
      O => DP_MDR_MUX_out(1)
    );
  DP_Mmux_MDR_MUX_out31 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_2_OBUF_9,
      O => DP_MDR_MUX_out(2)
    );
  DP_Mmux_MDR_MUX_out41 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_3_OBUF_8,
      O => DP_MDR_MUX_out(3)
    );
  DP_Mmux_MDR_MUX_out51 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_4_OBUF_7,
      O => DP_MDR_MUX_out(4)
    );
  DP_Mmux_MDR_MUX_out61 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_5_OBUF_6,
      O => DP_MDR_MUX_out(5)
    );
  DP_Mmux_MDR_MUX_out71 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_6_OBUF_5,
      O => DP_MDR_MUX_out(6)
    );
  DP_Mmux_MDR_MUX_out81 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => CTRL_current_state_FSM_FFd3_3,
      I1 => mem_out_7_OBUF_4,
      O => DP_MDR_MUX_out(7)
    );
  RESET_IBUF : IBUF
    port map (
      I => RESET,
      O => RESET_IBUF_1
    );
  mem_out_7_OBUF : OBUF
    port map (
      I => mem_out_7_OBUF_4,
      O => mem_out(7)
    );
  mem_out_6_OBUF : OBUF
    port map (
      I => mem_out_6_OBUF_5,
      O => mem_out(6)
    );
  mem_out_5_OBUF : OBUF
    port map (
      I => mem_out_5_OBUF_6,
      O => mem_out(5)
    );
  mem_out_4_OBUF : OBUF
    port map (
      I => mem_out_4_OBUF_7,
      O => mem_out(4)
    );
  mem_out_3_OBUF : OBUF
    port map (
      I => mem_out_3_OBUF_8,
      O => mem_out(3)
    );
  mem_out_2_OBUF : OBUF
    port map (
      I => mem_out_2_OBUF_9,
      O => mem_out(2)
    );
  mem_out_1_OBUF : OBUF
    port map (
      I => mem_out_1_OBUF_10,
      O => mem_out(1)
    );
  mem_out_0_OBUF : OBUF
    port map (
      I => mem_out_0_OBUF_11,
      O => mem_out(0)
    );
  CLOCK_BUFGP : BUFGP
    port map (
      I => CLOCK,
      O => CLOCK_BUFGP_0
    );
  DP_mem : mem_ahmes
    port map (
      clka => CLOCK_BUFGP_0,
      wea(0) => DP_reg_MA(0),
      addra(7) => DP_reg_MA(0),
      addra(6) => DP_reg_MA(0),
      addra(5) => DP_reg_MA(0),
      addra(4) => DP_reg_MA(0),
      addra(3) => DP_reg_MA(0),
      addra(2) => DP_reg_MA(0),
      addra(1) => DP_reg_MA(0),
      addra(0) => DP_reg_MA(0),
      dina(7) => DP_reg_MD(7),
      dina(6) => DP_reg_MD(6),
      dina(5) => DP_reg_MD(5),
      dina(4) => DP_reg_MD(4),
      dina(3) => DP_reg_MD(3),
      dina(2) => DP_reg_MD(2),
      dina(1) => DP_reg_MD(1),
      dina(0) => DP_reg_MD(0),
      douta(7) => mem_out_7_OBUF_4,
      douta(6) => mem_out_6_OBUF_5,
      douta(5) => mem_out_5_OBUF_6,
      douta(4) => mem_out_4_OBUF_7,
      douta(3) => mem_out_3_OBUF_8,
      douta(2) => mem_out_2_OBUF_9,
      douta(1) => mem_out_1_OBUF_10,
      douta(0) => mem_out_0_OBUF_11
    );

end Structure;

-- synthesis translate_on
