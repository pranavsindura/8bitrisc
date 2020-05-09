----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 17:49:35
-- Design Name: 
-- Module Name: not_big - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity not_big is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           res : out STD_LOGIC_VECTOR (7 downto 0));
end not_big;

architecture Behavioral of not_big is
    constant n: integer := 8;
begin
    GEN_NOT:
    for i in 0 to n-1 generate
        res(i) <= not a(i);
    end generate GEN_NOT;

end Behavioral;
