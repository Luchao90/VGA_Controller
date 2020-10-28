library IEEE;
use IEEE.std_logic_1164.all;

-- Author: Ing. Luciano Francisco Vittori
-- VGA RGB signals

entity VGA_RGB is
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
end VGA_RGB;

architecture behavior of VGA_RGB is

begin

	VGA_RGB_Outputs: process(column_i)
	begin
		if(display_enable_i = '0' or column_i >= H_display or row_i >= V_display) then
			-- Blackout
			vga_red 	<= (others => '0');
			vga_green	<= (others => '0');
			vga_blue	<= (others => '0');
		elsif(column_i < 80 ) then
			-- Red
			vga_red 	<= (others => '1');
			vga_green	<= (others => '0');
			vga_blue	<= (others => '0');
		elsif(column_i < 80*2 ) then
			-- Magenta
			vga_red 	<= (others => '1');
			vga_green	<= (others => '0');
			vga_blue	<= (others => '1');
		elsif(column_i < 80*3 ) then
			-- Blue	
			vga_red 	<= (others => '0');
			vga_green	<= (others => '0');
			vga_blue	<= (others => '1');					
		elsif(column_i < 80*4 ) then
			-- Cyan
			vga_red 	<= (others => '0');
			vga_green	<= (others => '1');
			vga_blue	<= (others => '1');	
		elsif(column_i < 80*5 ) then
			-- Green
			vga_red 	<= (others => '0');
			vga_green	<= (others => '1');
			vga_blue	<= (others => '0');	
		elsif(column_i < 80*6 ) then
			-- Yellow
			vga_red 	<= (others => '1');
			vga_green	<= (others => '1');
			vga_blue	<= (others => '0');	
		elsif(column_i < 80*7 ) then
			-- Black
			vga_red 	<= (others => '0');
			vga_green	<= (others => '0');
			vga_blue	<= (others => '0');
		elsif(column_i < 80*8 ) then
			-- White
			vga_red 	<= (others => '1');
			vga_green	<= (others => '1');
			vga_blue	<= (others => '1');	
			end if;
	end process VGA_RGB_Outputs;
end;