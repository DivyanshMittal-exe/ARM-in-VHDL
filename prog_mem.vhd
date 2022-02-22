Library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity prog_mem is
  port (
    read_loc:in std_logic_vector(15 downto 0);
    read_data:out std_logic_vector(31 downto 0)
  ) ;
end prog_mem ;

architecture arch of prog_mem is
  type mem is array(0 to 512) of std_logic_vector(31 downto 0) ;
  signal data: mem := (0 => X"E3A00000",
                        1 => X"E3A01000",
                        2 => X"E0800001",
                        3 => X"E2811001",
                        4 => X"E3510005",
                        5 => X"1AFFFFFB",
                        others => X"00000000"
                        );
begin
  read_data <= data(to_integer(unsigned(read_loc)));
end architecture ; -- arch