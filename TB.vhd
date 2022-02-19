library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    COMPONENT processor
    PORT(
          clock:in std_logic;
          reset: in std_logic
        );
    END COMPONENT;

    
   	   	signal clock : std_logic := '0';   
		signal reset : std_logic := '0';   
    
 
BEGIN
   

   uut: processor PORT MAP (
        
        reset => reset,
        clock => clock
        );
    
    reset <= '0' after 2ns;
    
    Clock_gen: process
    begin
    
     clock <= '0';
     wait for  1 ns;
    
    identifier : for i in 0 to 10 loop
        clock <= '1';
        wait for  5 ns;
        clock <= '0';
        wait for 5 ns ;
    end loop ; -- identifier loop
    wait;
    end process Clock_gen; 
  

END;