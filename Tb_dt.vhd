library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY DT_TB IS
END DT_TB;
 
ARCHITECTURE behavior OF DT_TB IS 
 
    COMPONENT data_mem
    PORT(
        clock: in std_logic;
        read_loc:in std_logic_vector(5 downto 0);
        read_data:out std_logic_vector(31 downto 0);

        write_en: in std_logic_vector(3 downto 0);

        write_loc:in std_logic_vector(5 downto 0);
        write_data:in std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    signal clock : std_logic := '0'; 
    signal read_loc: std_logic_vector(5 downto 0) := "000000";
    signal write_en: std_logic_vector(3 downto 0) := "0000";
    signal write_loc: std_logic_vector(5 downto 0):= "000000";
    signal read_data: std_logic_vector(31 downto 0);
    signal write_data :  std_logic_vector(31 downto 0) :=  "01010101010101010101010101010101";
 
BEGIN
    Clock_gen: process
    begin
    identifier : for i in 0 to 5 loop
        clock <= '0';
        wait for  5 ns;
        clock <= '1';
        wait for 5 ns ;
    end loop ; -- identifier loop
    wait;
    end process Clock_gen; 

   uut: data_mem PORT MAP (
        clock => clock,
        read_loc => read_loc,
        read_data=>read_data,
        write_en => write_en,
        write_loc => write_loc,
        write_data =>write_data
        );


   process
   begin  
   write_data <= "01010101010101010101010101010101";

    read_loc <= "000101";
    write_loc  <= "000101";
    wait for 10 ns;

    write_en<= "0001";
    wait for 10 ns;

    write_en<= "0011";
--     write_data <= "10101010101010101010101010101010";
    wait for 10 ns;

    write_en<= "1111";
--     write_data <= "10101010101010101010101010101010";
    wait for 10 ns;
	
    wait;
   end process;
  

END;