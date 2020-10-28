library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Author: Ing. Luciano Francisco Vittori
-- VGA Controller
-- Resolution: 640x480 @60Hz
-- Pixel Clock must be 25.175MHz
-- Total Colums	: 800
-- Total Rows	: 525

entity VGA_background is
	generic(
		COLOR_BITS		: natural := 3;
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
		vga_red     	: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
		vga_green   	: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
		vga_blue    	: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0')
	);
end VGA_background;



architecture behavior of VGA_background is

	component VGA_Sync_MMCM is
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

	component VGA_RGB is
		generic(
			COLOR_BITS		: natural := 3;
			COLUMNS			: natural := 800;
			ROWS			: natural := 525;
			H_display		: natural := 640;	-- pixels		
			V_display		: natural := 480	-- lines
		);
		port(
			column_i			: in	natural range 0 to COLUMNS;
			row_i				: in	natural range 0 to ROWS;
			display_enable_i	: in	std_logic;
			vga_red     		: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
			vga_green   		: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
			vga_blue    		: out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0') 
		);
	end component;

signal display_enable_link	: std_logic;
signal column_link			: natural range 0 to COLUMNS;
signal row_link				: natural range 0 to ROWS;

begin

	VGA_Sync_MMCM_inst : VGA_Sync_MMCM
		port map(
			clk_i			=> clk_i,
			rst_i			=> rst_i,
			H_sync			=> H_sync,
			V_sync			=> V_sync,
			display_enable	=> display_enable_link,
			column			=> column_link,
			row				=> row_link
		);

	VGA_RGB_inst : VGA_RGB
		port map(
			column_i			=>	column_link,
			row_i				=>	row_link,
			display_enable_i	=>	display_enable_link,
			vga_red				=>	vga_red,   
			vga_green			=>	vga_green, 
			vga_blue 			=>	vga_blue
		);
end;