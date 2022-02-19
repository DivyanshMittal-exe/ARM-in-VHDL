Library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity prog_mem is
  port (
    read_loc:in std_logic_vector(5 downto 0);
    read_data:out std_logic_vector(31 downto 0)
  ) ;
end prog_mem ;

architecture arch of prog_mem is
  type mem is array(0 to 63) of std_logic_vector(31 downto 0) ;
  signal data: mem := (0 => X"E3A0000A",
                        1 => X"E3A01005",
                        2 => X"E5801000",
                        3 => X"E2811002",
                        4 => X"E5801004",
                        5 => X"E5902000",
                        6 => X"E5903004",
                        7 => X"E0434002",
                        others => X"00000000"
                        );
begin
  read_data <= data(to_integer(unsigned(read_loc)));
end architecture ; -- arch