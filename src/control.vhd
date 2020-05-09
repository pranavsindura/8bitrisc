----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2020 14:45:29
-- Design Name: 
-- Module Name: control - Behavioral
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

entity control is
    Port ( CLK : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           O_state : out STD_LOGIC_VECTOR (4 downto 0)
           );
end control;

architecture Behavioral of control is
    signal state : std_logic_vector(4 downto 0) := "00001";
begin
    process(CLK) is
    begin
        if rising_edge(CLK) then
            if I_reset='1' then
                state <= "00001";
            else
                case state is
                    when "00001" => 
                        state <= "00010";
                    when "00010" => 
                        state <= "00100";
                    when "00100" => 
                        state <= "01000";  
                    when "01000" => 
                        state <= "10000"; 
                    when "10000" =>
                        state <= "00001";
                    when others =>
                        state <= "00001";
                end case;  
            end if;
        end if;
    end process;
    O_state <= state;
end Behavioral;
