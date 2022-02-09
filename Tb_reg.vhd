library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY Reg_TB IS
END Reg_TB;
 
ARCHITECTURE behavior OF Reg_TB IS 
 
    COMPONENT Reg
    PORT(
        clock: in std_logic;
        write_en: in std_logic;
        r_ad_1, r_ad_2: in std_logic_vector(3 downto 0);
        write_1: in std_logic_vector(3 downto 0);
        data:in std_logic_vector(31 downto 0);
        r_da_1,r_da_2: out std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    signal clock : std_logic := '0'; 
    signal write_en:  std_logic := '0';
    signal r_ad_1: std_logic_vector(3 downto 0) := "0000";
    signal r_ad_2: std_logic_vector(3 downto 0) := "0000";
    signal write_1: std_logic_vector(3 downto 0):= "0000";
    signal data: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal r_da_1 :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal r_da_2:  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

 
BEGIN
    Clock_gen: process
    begin
    identifier : for i in 0 to 5 loop
        clock <= '0';
        wait for  10 ns;
        clock <= '1';
        wait for 10 ns;
    end loop ; -- identifier loop
    wait;
    end process Clock_gen; 

   uut: Reg PORT MAP (
        clock => clock,
        write_en => write_en,
        r_ad_1=>r_ad_1,
        r_ad_2 => r_ad_2,
        write_1 => write_1,
        data =>data,
        r_da_1 =>r_da_1,
        r_da_2 =>r_da_2
        );

   process
   begin  
    write_1 <= "0101";
    r_ad_1 <= "0101";
    r_ad_2 <= "0001";
    wait for 10 ns;

    data <= "00000000000000000000000000000011";
    write_en<= '1';
    write_1 <= "0001";
    
    wait for 10 ns;
    data <= "00000000000000000000000000001001";
    write_en<= '0';
    wait for 10 ns;
	
    r_ad_1 <= "0001";
    r_ad_2 <= "0101";
     wait for 10 ns;
    wait;
   end process;
  

END;