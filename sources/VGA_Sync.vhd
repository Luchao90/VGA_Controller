library IEEE;
use IEEE.std_logic_1164.all;

-- Author: Ing. Luciano Francisco Vittori
-- VGA Controller
-- Resolution: 640x480 @60Hz
-- Pixel Clock must be 25.175MHz
-- Total Columns	: 800
-- Total Rows	: 525

entity VGA_Sync is
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
end VGA_Sync;

architecture behavior of VGA_Sync is
	-- Parte declarativa:
	constant H_period	: natural := H_display + H_font_porch + H_sync_pulse + H_back_porch;
	constant V_period	: natural := V_display + V_font_porch + V_sync_pulse + V_back_porch;

begin
	-- Parte descriptiva:
	VGA_synchromism: process(clk_i, rst_i)

	variable H_counter	: natural range 0 to H_period := 0;
	variable V_counter	: natural range 0 to V_period := 0;

	begin
		if(rst_i = '0')	then
			H_counter 		:= 0;
			V_counter 		:= 0;
			H_sync			<= '1';
			V_sync			<= '1';
			display_enable	<= '0';
			column			<= 0;
			row				<= 0;

		elsif rising_edge(clk_i) then

			if (H_counter = H_period - 1) then
				H_counter := 0;
				if (V_counter = V_period -1) then -- Vertical are lines, not pixels.
					V_counter := 0;
				else
					V_counter := V_counter + 1;
				end if;
			else
				H_counter := H_counter + 1;
			end if;

			if(	H_counter < (H_display + H_font_porch) or H_counter >= (H_display + H_font_porch + H_sync_pulse)) then
				H_sync	<= '1';
			else
				H_sync	<= '0';
			end if;

			if(	V_counter < (V_display + V_font_porch) or V_counter >= (V_display + V_font_porch + V_sync_pulse)) then
				V_sync	<= '1';
			else
				V_sync	<= '0';
			end if;

			-- Calculate position in screen.
			if(H_counter < H_display) then
				column <= H_counter;
			end if;
			if(V_counter < V_display) then
				row <= V_counter;
			end if;

			-- Display enable for blanking video frame.
			if((H_counter < H_display) and (V_counter < V_display)) then
				display_enable <= '1';
			else
				display_enable <= '0';
			end if;			
			
		end if;
	end process VGA_synchromism;
end;