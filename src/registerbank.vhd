----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 22:48:25
-- Design Name: 
-- Module Name: registerbank - Behavioral
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

entity registerbank is
  Port ( 
    CLK: in std_logic;
    I_we: in std_logic;
    I_en: in std_logic;
    I_selA : in std_logic_vector(2 downto 0);
    I_selB : in std_logic_vector(2 downto 0);
    I_selD : in std_logic_vector(2 downto 0);
    O_dataA: out std_logic_vector(7 downto 0);
    O_dataB: out std_logic_vector(7 downto 0);
    I_dataD: in std_logic_vector(7 downto 0)
   );
end registerbank;

architecture Behavioral of registerbank is
    type BANK is array (7 downto 0) of std_logic_vector(7 downto 0);
    signal RBANK : BANK := (others => (others=>'0'));
    --8 registers
begin
    process(CLK)
    begin
        if rising_edge(CLK) and I_en='1' then
            if I_we='1' then
                RBANK(to_integer(unsigned(I_selD))) <= I_dataD;
            end if;
            O_dataA <= RBANK(to_integer(unsigned(I_selA)));
            O_dataB <= RBANK(to_integer(unsigned(I_selB)));
        end if;
    end process;

end Behavioral;
