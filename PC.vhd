library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity pc is
  port (
    clock: in std_logic;
    reset: in std_logic;
    branch: in std_logic;
    offset: in std_logic_vector(31 downto 0);
    counter: out std_logic_vector(7 downto 0):= "00000000"
  ) ;
end pc ; 

architecture arch of pc is
    begin

        c : process( clock,reset )
        begin
        	if reset = '1' then
                counter <= "00000000";
            elsif rising_edge(clock) then
                if branch = '1' then
                    counter <= std_logic_vector(signed(counter) + signed(offset)+8);
                else
                    counter <= std_logic_vector(signed(counter) + 4);    
                end if ;
            end if ;
        end process ; -- c
        
end architecture ;