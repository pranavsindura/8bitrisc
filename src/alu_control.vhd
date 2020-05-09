----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 15:26:32
-- Design Name: 
-- Module Name: alu_control - Behavioral
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

entity alu_control is
  Port (
        CLK, I_en, I_dataDwe : in std_logic;
        I_aluop : in std_logic_vector(3 downto 0);
        I_dataA, I_dataB, I_ImmData : in std_logic_vector(7 downto 0);
        O_dataResult   : out std_logic_vector(7 downto 0);
        O_dataDwe: out std_logic
  );
end alu_control;

architecture Behavioral of alu_control is
    constant n : integer := 8;
    component adder is
            Port ( 
           a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           cin : in STD_LOGIC;
           sum : out STD_LOGIC_VECTOR (n-1 downto 0);
           cout : out STD_LOGIC);
    end component;
    
    component xor_big is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;
    
    component and_big is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0)
          );
    end component;
    
    component or_gate is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0)
           );
    end component;
    
    component not_big is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;
    
    component shift_left is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;
    
    component shift_right is
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           res : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;
    signal f: std_logic_vector(n-1 downto 0) := (others=>'0');
    signal carry : std_logic := '0';
    signal sum: std_logic_vector(n-1 downto 0);
    signal sumcarry : std_logic;
    signal sub: std_logic_vector(n-1 downto 0);
    signal subcarry : std_logic;
    signal xor_res: std_logic_vector(n-1 downto 0);
    signal and_res: std_logic_vector(n-1 downto 0);
    signal or_res: std_logic_vector(n-1 downto 0);
    signal not_res: std_logic_vector(n-1 downto 0);
    signal shift_right_res: std_logic_vector(n-1 downto 0);
    signal shift_left_res: std_logic_vector(n-1 downto 0);
begin
    ADDER8: adder port map( a=>I_dataA, b=>I_dataB, cin=>'0', sum=>sum, cout=>sumcarry );
    SUB8 : adder port map( a=>I_dataA, b=>I_dataB, cin=>'1', sum=>sub, cout=>subcarry );
    XOR8 : xor_big port map(a=>I_dataA, b=>I_dataB, res=>xor_res);
    AND8 : and_big port map(a=>I_dataA, b=>I_dataB, res=>and_res);
    OR8 : or_gate port map(a=>I_dataA, b=>I_dataB, res=>or_res);
    NOT8 : not_big port map(a=>I_dataA, res=>not_res);
    SHIFT_RIGHT8 : shift_right port map(a=>I_dataA, res=>shift_right_res);
    SHIFT_LEFT8 : shift_left port map(a=>I_dataA, res=>shift_left_res);  
    process(CLK, I_en) is
    begin
        if rising_edge(CLK) and I_en='1' then
            O_dataDwe <= I_dataDwe;
            if I_aluop="0000" then
                f <= sum;
                carry <= sumcarry;
            elsif I_aluop="0001" then
                f <= sub;
                carry <= subcarry;
            elsif I_aluop="0010" then
                f <= xor_res;
            elsif I_aluop="0011" then
                f <= and_res;
            elsif I_aluop="0100" then
                f <= or_res;
            elsif I_aluop="0101" then
                f <= not_res;
            elsif I_aluop="0110" then
                f <= shift_left_res;
            elsif I_aluop="0111" then
                f <= shift_right_res;
            elsif I_aluop="1000" then
                --LOAD
                f <= I_ImmData;
            elsif I_aluop="1001" then
                --MOV
                f <= I_dataA;
            else
                f <= x"FF";
                carry <= '0';
            end if;
        end if;
    end process;
    O_dataResult <= f;
    
end Behavioral;
