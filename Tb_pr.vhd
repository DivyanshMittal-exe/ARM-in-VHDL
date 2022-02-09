library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY PR_TB IS
END PR_TB;
 
ARCHITECTURE behavior OF PR_TB IS 
 
    COMPONENT prog_mem
    PORT(
        read_loc:in std_logic_vector(5 downto 0);
        read_data:out std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    
    signal read_loc: std_logic_vector(5 downto 0) := "000000";
    
    signal read_data: std_logic_vector(31 downto 0);
    
 
BEGIN
   

   uut: prog_mem PORT MAP (
        read_data => read_data,
        read_loc => read_loc
        );


   process
   begin  
    
    read_loc <= "000101";
    wait for 10ns;
    
    wait;
   end process;
  

END;