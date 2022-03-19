
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity TB is
end TB;

architecture behavior of TB is

    component processor
        port (
            clock : in std_logic;
            reset : in std_logic
        );
    end component;
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
begin
    uut : processor port map(

        reset => reset,
        clock => clock
    );

    reset <= '0' after 2 ns;

    Clock_gen : process
    begin

        clock <= '0';
        wait for 1 ns;

        identifier : for i in 0 to 190 loop
            clock <= '1';
            wait for 5 ns;
            clock <= '0';
            wait for 5 ns;
        end loop; -- identifier loop
        wait;
    end process Clock_gen;
end;
