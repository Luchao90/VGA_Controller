
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Declaracion de la entidad
entity VGA_RGB_tb is
end;

architecture VGA_RGB_tb_arq of VGA_RGB_tb is

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

constant COLOR_BITS_tb		: natural := 3;
constant COLUMNS_tb			: natural := 800;
constant ROWS_tb			: natural := 525;
constant H_display_tb		: natural := 640;	-- pixels		
constant V_display_tb		: natural := 480;	-- lines

signal display_enable_i_tb	: std_logic := '0';

signal column_i_tb			: natural range 0 to COLUMNS_tb := 0;
signal row_i_tb				: natural range 0 to ROWS_tb := 0;
signal vga_red_tb     		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');
signal vga_green_tb   		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');
signal vga_blue_tb    		: std_logic_vector(COLOR_BITS_tb-1 downto 0) := (others => '0');

signal clk_tb				: std_logic	:= '0';

begin
	-- Parte descriptiva:
	display_enable_i_tb	<=	'1'	after 1 ns;
	clk_tb				<=	not clk_tb after 1 ns;

	colums_generate : process(clk_tb)

	variable column_aux : natural := 1;
	variable row_aux : natural := 1;
	
	begin
		column_i_tb <= column_i_tb + 1;
		column_aux := column_aux + 1;
		if(column_aux = COLUMNS_tb - 1) then
			column_aux	:= 0;
			column_i_tb <= 0;
			row_i_tb <= row_i_tb + 1;
			if(row_aux = ROWS_tb - 1) then
				row_aux	:= 0;
				row_i_tb <= 0;
			end if;
		end if;
	end process colums_generate;

	VGA_RGB_inst: VGA_RGB
		generic map(
			COLOR_BITS	=> COLOR_BITS_tb,
			COLUMNS		=> COLUMNS_tb,	
			ROWS		=> ROWS_tb,		
			H_display	=> H_display_tb,				
			V_display	=> V_display_tb	
		)
		port map(
			column_i			=> column_i_tb,
			row_i				=> row_i_tb,
			display_enable_i	=> display_enable_i_tb,
			vga_red     		=> vga_red_tb,
			vga_green   		=> vga_green_tb,
			vga_blue    		=> vga_blue_tb
		);
end;