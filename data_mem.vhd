Library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity data_mem is
  port (
    clock: in std_logic;
    ad:in std_logic_vector(15 downto 0);
    rd:out std_logic_vector(31 downto 0);
    MW: in std_logic_vector(3 downto 0);
    wd:in std_logic_vector(31 downto 0)
  ) ;
end data_mem ;

architecture arch of data_mem is
    type mem is array(0 to 511) of std_logic_vector(31 downto 0);
    signal data: mem := (others => (others => '0'));
begin
    rd <= data(to_integer(unsigned(ad)));
    
    write : process(clock)
    begin
        if rising_edge(clock) then
            if MW(3) = '1' then
                data(to_integer(unsigned(ad)))(31 downto 24) <= wd(31 downto 24);
            end if ;
            if MW(2) = '1' then
                data(to_integer(unsigned(ad)))(23 downto 16) <= wd(23 downto 16);
            end if ;
            if MW(1) = '1' then
                data(to_integer(unsigned(ad)))(15 downto 8) <= wd(15 downto 8);
            end if ;
            if MW(0) = '1' then
                data(to_integer(unsigned(ad)))(7 downto 0) <= wd(7 downto 0);
            end if ;
        end if ;
    end process ; -- write

end architecture ; -- arch