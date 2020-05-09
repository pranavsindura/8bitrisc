----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 14:55:43
-- Design Name: 
-- Module Name: adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is
    Port ( 
           a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           cin : in STD_LOGIC;
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           cout : out STD_LOGIC);
end adder;

architecture Behavioral of adder is
    component full_adder is
        port (
            in1,in2,cin : in std_logic;
            out1, cout: out std_logic
        );
    end component;
    constant n: integer := 8;
    signal temp_carry: std_logic_vector(7 downto 1);
    signal temp_b: std_logic_vector(7 downto 0);
begin
    GEN_XOR_ADDER:
    for i in 0 to n-1 generate
        temp_b(i) <= b(i) xor cin;
    end generate GEN_XOR_ADDER;
    
    ADDER0 : full_adder port map( in1=>a(0), in2=>temp_b(0), cin=>cin, out1=>sum(0), cout=>temp_carry(1) );
    GEN_ADDER:
    for i in 1 to n-2 generate
        ADDERX : full_adder port map( in1=>a(i), in2=>temp_b(i), cin=>temp_carry(i), out1=>sum(i), cout=>temp_carry(i+1) );
    end generate GEN_ADDER;
    ADDER7 : full_adder port map( in1=>a(n-1), in2=>temp_b(n-1), cin=>temp_carry(n-1), out1=>sum(n-1), cout=>cout );
end Behavioral;
