--------------------------------------------------------------------------------
-- Company:        Xilinx
-- Engineer:       Steven Elzinga
--
-- Create Date:    12:23:44 01/27/05
-- Design Name:    stopwatch
-- Module Name:    stopwatch - stopwatch_arch
-- Project Name:   ISE in Depth Tutorial
-- Target Device:  xc3s200-4ft256
-- Tool versions:  ISE 7.1i
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    port ( clk : in STD_LOGIC; -- clock signal
           rst : in STD_LOGIC; -- reset signal
           enable : in STD_LOGIC; -- enable signal
           seg      : out std_logic_vector(6 downto 0);
           dp       : out std_logic;
           an       : out std_logic_vector(3 downto 0));
end display;

architecture display_arch of display is

  component hex2led is
    port ( HEX : in std_logic_vector(3 downto 0);
           LED : out std_logic_vector(6 downto 0));
  end component;

  component led_control is
    Port ( CLK : in std_logic;
         DISP0 : in std_logic_vector(6 downto 0);
         DISP1 : in std_logic_vector(6 downto 0);
         DISP2 : in std_logic_vector(6 downto 0);
         DISP3 : in std_logic_vector(6 downto 0);
         AN : out std_logic_vector(3 downto 0);
         DP : out std_logic;
         SEVEN_SEG : out std_logic_vector(6 downto 0));
  end component;
  
  component chronometer
      port (
        clk : in STD_LOGIC; -- clock signal
        rst : in STD_LOGIC; -- reset signal
        enable : in STD_LOGIC; -- enable signal
        out_secondes  : out STD_LOGIC_VECTOR (5 downto 0); -- counter signal
        out_minutes : out STD_LOGIC_VECTOR (5 downto 0) -- counter signal
      );
  end component;
    
  -- chrono variables
  signal out_secondes_value, out_minutes_value : STD_LOGIC_VECTOR (5 downto 0);
  
  -- display variables
  signal DISP0, DISP1, DISP2, DISP3 : std_logic_vector (6 downto 0);
  signal hex2led_int1, hex2led_int2, hex2led_int3, hex2led_int4 : std_logic_vector (3 downto 0) := (others=>'0');

begin
  chronometer_component : chronometer port map (clk=>clk, rst=>rst, enable=>enable, out_secondes=>out_secondes_value, out_minutes=>out_minutes_value);
  hex2led_int1 <= std_logic_vector(resize((unsigned(out_secondes_value) mod 10),4));
  hex2led_int2 <= std_logic_vector(resize((unsigned(out_secondes_value) / 10),4));
  hex2led_int3 <= std_logic_vector(resize((unsigned(out_minutes_value) mod 10),4));
  hex2led_int4 <= std_logic_vector(resize((unsigned(out_minutes_value) / 10),4));

  HEX2LED_1 : hex2led port map (
    HEX => hex2led_int1,
    LED => DISP0);

  HEX2LED_2 : hex2led port map (
    HEX => hex2led_int2,
    LED => DISP1);

  HEX2LED_3 : hex2led port map (
    HEX => hex2led_int3,
    LED => DISP2);

  HEX2LED_4 : hex2led port map (
    HEX => hex2led_int4,
    LED => DISP3);

   LEDCONTROL_1 : led_control port map (
    CLK => clk,
    DISP0 => DISP0,
    DISP1 => DISP1,
    DISP2 => DISP2,
    DISP3 => DISP3,
    AN => AN,
    SEVEN_SEG => seg,
    dp => dp);

end display_arch;
