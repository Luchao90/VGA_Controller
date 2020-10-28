library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA_background_tb is
end;

architecture VGA_background_tb_arq of VGA_background_tb is

	component VGA_background is
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
	end component;

constant COLOR_BITS_tb		: natural := 3;

signal clk_i_tb				: std_logic := '1';
signal rst_i_tb				: std_logic	:= '0';
signal H_sync_tb			: std_logic	:= '1';
signal V_sync_tb			: std_logic	:= '1';
signal vga_red_tb     		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');
signal vga_green_tb   		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');
signal vga_blue_tb    		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');


begin

	clk_i_tb	<=	not clk_i_tb	after 4 ns;	-- 125 MHz @Arty Z-20
	rst_i_tb	<=	'1' after 10 ns;

	VGA_background_inst : VGA_background
		generic map(
			COLOR_BITS	=> COLOR_BITS_tb
		)
		port map(
			clk_i		=>	clk_i_tb,
			rst_i		=>	rst_i_tb,
			H_sync		=>	H_sync_tb,
			V_sync		=>	V_sync_tb,
			vga_red     =>	vga_red_tb,
			vga_green   =>	vga_green_tb,
			vga_blue    => 	vga_blue_tb
		);
end;