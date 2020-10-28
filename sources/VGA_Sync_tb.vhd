
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Declaracion de la entidad
entity VGA_Sync_tb is
end;

architecture VGA_Sync_tb_arq of VGA_Sync_tb is
	
	component VGA_Sync is
		generic(
			COLUMNS			: natural := 800;
			ROWS			: natural := 525;
			H_display		: natural := 640;	-- pixels		
			H_font_porch	: natural := 16;	-- pixels	
			H_sync_pulse	: natural := 96;	-- pixels	
			H_back_porch	: natural := 48;	-- pixels	
			V_display		: natural := 480;	-- lines
			V_font_porch	: natural := 10;	-- lines
			V_sync_pulse	: natural := 2;		-- lines
			V_back_porch	: natural := 33		-- lines
		);
		port(
			clk_i			: in	std_logic;
			rst_i			: in	std_logic;
			H_sync			: out	std_logic;
			V_sync			: out	std_logic;
			display_enable	: out	std_logic;
			column			: out	natural range 0 to COLUMNS;
			row				: out	natural range 0 to ROWS
		);
	end component;

constant COLUMNS_tb : natural := 800;
constant ROWS_tb	: natural := 525;

signal clk_tb		: std_logic	:= '1';
signal rst_tb		: std_logic := '0';
signal H_sync_tb	: std_logic;
signal V_sync_tb	: std_logic;
signal column_tb	: natural range 0 to COLUMNS_tb;
signal row_tb		: natural range 0 to ROWS_tb;

begin
	-- Parte descriptiva:
	--clk_tb	<=	not clk_tb	after 19.86 ns;	-- 25.175 MHz
	clk_tb	<=	not clk_tb	after 10 ps;	-- 500 MHz @Only for simulation
	rst_tb	<=	'1' after 10 ns;

	DUT: VGA_Sync
		generic map(
			COLUMNS	=> COLUMNS_tb,
			ROWS	=> ROWS_tb
		)
		port map(
			clk_i	=> clk_tb,
			rst_i	=> rst_tb,
			H_sync	=> H_sync_tb,
			V_sync	=> V_sync_tb,
			column	=> column_tb,
			row		=> row_tb
		);
end;