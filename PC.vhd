library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity pc is
  port (
    clock: in std_logic;
    reset: in std_logic;
    branch: in std_logic;
    offset: in std_logic_vector(31 downto 0);
    counter: out std_logic_vector(7 downto 0)
  ) ;
end pc ; 

architecture arch of pc is
    signal progC: std_logic_vector(7 downto 0) := "00000000";
    begin
        resetting_process : process( reset )
        begin
            if reset = '1' then
                progC <= "00000000";
            end if ;
        end process ; -- resetting_process

        c : process( clock )
        begin
            if rising_edge(clock) then
                if branch = '1' then
                    progC <= std_logic_vector(signed(progC) + signed(offset)+8);
                else
                    progC <= std_logic_vector(signed(progC) + 4);    
                end if ;
            end if ;
        end process ; -- c
        
        counter <= progC;
        
end architecture ;