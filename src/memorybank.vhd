----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 23:20:31
-- Design Name: 
-- Module Name: memorybank - Behavioral
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

entity memorybank is
  Port ( 
        CLK: in std_logic;
        I_we: in std_logic;
        I_addr : in std_logic_vector(7 downto 0);
        I_data: in std_logic_vector(15 downto 0);
        O_data: out std_logic_vector(15 downto 0)
   );
end memorybank;

architecture Behavioral of memorybank is
    -- 2^8 x 16 bit memory
    type MEM is array(0 to 2**8-1) of std_logic_vector(15 downto 0);
    signal RAM: MEM := (
        "1000" & "000" & x"26" & "0",
        "1000" & "001" & x"44" & "0",
        "0000" & "001" & "001" & "000" & "000",
        "1001" & "100" & "001" & "000" & "000",
        "1001" & "111" & "100" & "000" & "000",
        others=> "1010" & x"000"
    );
begin
    process(CLK)
    begin
        if rising_edge(CLK)then
            if I_we='1' then
                RAM(to_integer(unsigned(I_addr))) <= I_data;
            else
                O_data <= RAM(to_integer(unsigned(I_addr)));
            end if;
        end if;
    end process;

end Behavioral;
