Library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity data_mem is
  port (
    clock: in std_logic;
    read_loc:in std_logic_vector(5 downto 0);
    read_data:out std_logic_vector(31 downto 0);

    write_en: in std_logic_vector(3 downto 0);

    write_loc:in std_logic_vector(5 downto 0);
    write_data:in std_logic_vector(31 downto 0)
  ) ;
end data_mem ;

architecture arch of data_mem is
    type mem is array(0 to 63) of std_logic_vector(31 downto 0);
    signal data: mem := (others => (others => '0'));
begin
    read_data <= data(to_integer(unsigned(read_loc)));
    
    write : process(clock)
    begin
        if rising_edge(clock) then
            if write_en(3) = '1' then
                data(to_integer(unsigned(write_loc)))(31 downto 24) <= write_data(31 downto 24);
            end if ;
            if write_en(2) = '1' then
                data(to_integer(unsigned(write_loc)))(23 downto 16) <= write_data(23 downto 16);
            end if ;
            if write_en(1) = '1' then
                data(to_integer(unsigned(write_loc)))(15 downto 8) <= write_data(15 downto 8);
            end if ;
            if write_en(0) = '1' then
                data(to_integer(unsigned(write_loc)))(7 downto 0) <= write_data(7 downto 0);
            end if ;
        end if ;
    end process ; -- write

end architecture ; -- arch