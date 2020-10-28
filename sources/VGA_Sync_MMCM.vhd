library IEEE;
use IEEE.std_logic_1164.all;

-- Author: Ing. Luciano Francisco Vittori
-- VGA Controller
-- Resolution: 640x480 @60Hz
-- Pixel Clock must be 25.175MHz
-- Total Colums	: 800
-- Total Rows	: 525

entity VGA_Sync_MMCM is
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
end VGA_Sync_MMCM;

architecture behavior of VGA_Sync_MMCM is

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

	-- Copy from ip catalog template. MMCM
	component clock_pixel
	port(
		clk_out1	: out    std_logic;
	  	clk_in1		: in     std_logic
	 );
	end component;

signal clk_pixel	: std_logic;

begin

	VGA_Sync_Clock : clock_pixel
		port map ( 
			clk_out1	=> clk_pixel,
			clk_in1		=> clk_i
		);

	VGA_Sync_inst: VGA_Sync
		port map(
			clk_i			=> clk_pixel,
			rst_i			=> rst_i,
			H_sync			=> H_sync,
			V_sync			=> V_sync,
			display_enable	=> display_enable,
			column			=> column,
			row				=> row
		);
end;