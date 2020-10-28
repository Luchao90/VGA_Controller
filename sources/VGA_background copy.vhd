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
		COLOR_BITS	: natural := 3
	);
	port(
		clk_i		: in	std_logic;
		rst_i		: in	std_logic;
		H_sync		: out	std_logic;
		V_sync		: out	std_logic;
		vga_red     : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
		vga_green   : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
		vga_blue    : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0') 
	);
end VGA_background;

architecture behavior of VGA_background is

	component VGA_Sync_MMCM is
		port(
			clk_i	: in	std_logic;
			rst_i	: in	std_logic;
			H_sync	: out	std_logic;
			V_sync	: out	std_logic
		);
	end component;

	component VGA_RGB is
		port(
			clk_i		: in	std_logic;
			rst_i		: in	std_logic;
			H_sync_i	: in	std_logic;
			V_sync_i	: in	std_logic;
			vga_red     : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
			vga_green   : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0');
			vga_blue    : out	std_logic_vector(COLOR_BITS-1 downto 0) := (others => '0') 
		);
	end component;

signal H_sync_link : std_logic;
signal V_sync_link : std_logic;

begin

	H_sync <= H_sync_link;
	V_sync <= V_sync_link;

	VGA_Sync_MMCM_inst : VGA_Sync_MMCM
		port map(
			clk_i		=> clk_i,
			rst_i		=> rst_i,
			H_sync		=> H_sync,
			V_sync		=> V_sync
		);

	VGA_RGB_inst : VGA_RGB
		port map(
			clk_i		=>	clk_i,
			rst_i		=>	rst_i,
			H_sync_i	=>	H_sync_link,
			V_sync_i	=>	V_sync_link,
			vga_red		=>	vga_red,   
			vga_green	=>	vga_green, 
			vga_blue 	=>	vga_blue
		);
end;