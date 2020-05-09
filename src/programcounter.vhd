----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2020 18:56:56
-- Design Name: 
-- Module Name: programcounter - Behavioral
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

entity programcounter is
    Port ( CLK : in STD_LOGIC;
           I_pcop: in STD_LOGIC_VECTOR(1 downto 0);
           O_PC : out STD_LOGIC_VECTOR (7 downto 0));
end programcounter;

architecture Behavioral of programcounter is
    signal pc : std_logic_vector(7 downto 0) := x"00";
begin
    process(CLK) is
    begin
        if rising_edge(CLK) then
            case I_pcop is
                when "00"=>
                -- nop
                when "01"=>
                --increment
                    pc <= std_logic_vector(unsigned(pc) + 1);
                when others=>
                --reset
                    pc <= x"00";
            end case;
        end if;
    end process;
    O_PC <= pc;
end Behavioral;
