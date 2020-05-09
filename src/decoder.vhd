----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 22:48:25
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
  Port ( 
    CLK: in std_logic;
    I_en: in std_logic;
    I_instr: in std_logic_vector(15 downto 0);
    O_aluop: out std_logic_vector(3 downto 0);
    O_selA, O_selB, O_selD: out std_logic_vector(2 downto 0);
    O_rDwe: out std_logic;
    O_ImmData: out std_logic_vector(7 downto 0)
   );
end decoder;

architecture Behavioral of decoder is
begin
    process(CLK)
    begin
        if rising_edge(CLK) and I_en='1' then
            O_selA <= I_instr(8 downto 6);
            O_selB <= I_instr(5 downto 3);
            O_selD <= I_instr(11 downto 9);
            O_ImmData <= I_instr(8 downto 1);
            O_aluop <= I_instr(15 downto 12);
            if I_instr(15 downto 12) = "1010"
            then
                O_rDwe <= '0';
            else
                O_rDwe <= '1';
            end if;
        end if;
    end process;

end Behavioral;
