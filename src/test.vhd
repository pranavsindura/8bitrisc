----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2020 14:39:44
-- Design Name: 
-- Module Name: test - Behavioral
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

entity test is
--  Port ( );
end test;

architecture Behavioral of test is

    constant CLK_FREQ : integer := 100e6; --100MHz
    constant CLK_PER : time := 1000ms / CLK_FREQ; --10ns
    constant n : integer := 8; -- 8 bit processor
    signal CLK : std_logic := '1';
    
    component alu_control is
      Port (
        CLK, I_en, I_dataDwe : in std_logic;
        I_aluop : in std_logic_vector(3 downto 0);
        I_dataA, I_dataB, I_ImmData : in std_logic_vector(7 downto 0);
        O_dataResult   : out std_logic_vector(7 downto 0);
        O_dataDwe: out std_logic
     );
    end component alu_control;
    
    component registerbank is
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
    end component registerbank;
    
    component decoder is
      Port ( 
        CLK: in std_logic;
        I_en: in std_logic;
        I_instr: in std_logic_vector(15 downto 0);
        O_aluop: out std_logic_vector(3 downto 0);
        O_selA, O_selB, O_selD: out std_logic_vector(2 downto 0);
        O_rDwe: out std_logic;
        O_ImmData: out std_logic_vector(7 downto 0)
    );
    end component decoder;
    
    component control is
        Port ( CLK : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           O_state : out STD_LOGIC_VECTOR (4 downto 0)
           );
    end component control;
    
    component memorybank is
      Port ( 
            CLK: in std_logic;
            I_we: in std_logic;
            I_addr : in std_logic_vector(7 downto 0);
            I_data: in std_logic_vector(15 downto 0);
            O_data: out std_logic_vector(15 downto 0)
       );
    end component memorybank;
    component programcounter is
    Port ( CLK : in STD_LOGIC;
           I_pcop: in STD_LOGIC_VECTOR(1 downto 0);
           O_PC : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component programcounter;
    
    signal ram_we: std_logic := '0';
    signal ram_addr : std_logic_vector(7 downto 0) := x"00";
    signal ram_data_in, ram_data_out : std_logic_vector(15 downto 0) := x"0000";
    signal pcop : std_logic_vector(1 downto 0) := "00";
    signal instr: std_logic_vector(15 downto 0) := (others=>'0');
    
    signal en_pc, en_reg, dataDwe_reg, en_decode, en_alu, en_regRead, en_regWrite, dataDwe_decoder,dataDwe_alu : std_logic := '0';
    signal aluop : std_logic_vector(3 downto 0);
    signal state : std_logic_vector(4 downto 0) := "00001";
    signal dataA, dataB, PC, ImmData : std_logic_vector(7 downto 0);
    signal dataResult   : std_logic_vector(7 downto 0);
    signal reset : std_logic := '1';
    signal selA, selB, selD : std_logic_vector(2 downto 0);
    
begin 
    CLK <= not CLK after CLK_PER/2;
    uut_control : control port map(
        CLK => CLK,
        I_reset => reset,
        O_state => state
    );
    en_pc <= state(0);
    en_decode <= state(1);
    en_regread <= state(2);
    en_alu <= state(3);
    en_regwrite <= state(4);
    uut_decoder : decoder port map(
        CLK=>CLK,
        I_en => en_decode,
        I_instr=>instr,
        O_aluop => aluop,
        O_selA=>selA,
        O_selB=>selB,
        O_selD=>selD,
        O_rDwe=>dataDwe_decoder,
        O_ImmData=>ImmData
    );
    uut_alu : alu_control port map(
            CLK=>CLK,
            I_en=>en_alu,
            I_dataDwe=>dataDwe_decoder,
            I_aluop => aluop,
            I_dataA =>dataA,
            I_dataB => dataB,
            I_PC => PC,
            I_ImmData => ImmData,
            O_dataResult => dataResult,
            O_dataDwe => dataDwe_alu  
    );
    dataDwe_reg <= dataDwe_alu and en_regWrite;
    en_reg <= en_regRead or en_regWrite;
    uut_registerbank : registerbank port map(
        CLK=>CLK,
        I_we=>dataDwe_reg,
        I_en=> en_reg,
        I_selA => selA,
        I_selB => selB,
        I_selD => selD,
        O_dataA => dataA,
        O_dataB => dataB,
        I_dataD => dataResult
    );
    
    uut_memorybank : memorybank port map(
        CLK => CLK,
        I_we => ram_we,
        I_addr => ram_addr,
        I_data => ram_data_in,
        O_data => ram_data_out
    );
    
    uut_programcounter : programcounter port map(
        CLK => CLK,
       I_pcop => pcop,
       O_PC => pc
    );
    ram_addr <= pc;
    instr <= ram_data_out;
    pcop <= "11" when reset='1' --reset
            else "01" when state(4)='1' --increment
            else "00"; --nop
    process is
    begin   
        wait for 100 ns; 
        reset <= '1'; 
        --start control unit
        wait for CLK_PER;
        reset <= '0';
        --load r0 with 26
        --load r1 with 44
        --add r1 = r1 + r0
        --move r4 <- r1
        --move r7 <- r4
        --stored in memorybank
        
        wait;
    end process;
end Behavioral;