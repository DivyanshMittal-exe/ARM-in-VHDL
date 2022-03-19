library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity data_mem is
    port (
        clock : in std_logic;
        ad    : in std_logic_vector(15 downto 0);
        rd    : out std_logic_vector(31 downto 0);
        MW    : in std_logic_vector(3 downto 0);
        wd    : in std_logic_vector(31 downto 0);
        signDT : in std_logic
    );
end data_mem;

architecture arch of data_mem is
    type mem is array(0 to 511) of std_logic_vector(31 downto 0);
    signal data : mem := (
        0 => X"E3A00E32",
        1 => X"E3A010AA",
        2 => X"E3A02004",
        3 => X"E0803101",
        4 => X"E0804121",
        5 => X"E0805141",
        6 => X"E0806161",
        7 => X"E0807211",
        8 => X"E0808231",
        9 => X"E0809251",
        10 => X"E080A271",
        11 => X"E3A01020",
        12 => X"E5810006",
        13 => X"E591B006",
        14 => X"E7812082",
        15 => X"E791B082",
        others => X"00000000"
    );
    signal writeBase : std_logic_vector(31 downto 0) := x"00000000";
begin
    WRITING : process( ad,MW,wd,signDT )
    begin
        writeBase <= x"00000000";
        if signDT ='1' then
            if MW(1) = '1' and wd(15) = '1' then
                writeBase <= x"ffffffff";
            elsif MW(1) = '1' and wd(15) = '0' then
                writeBase <= x"00000000";
            elsif MW(0) = '1' and wd(7) = '1' then
                writeBase <= x"ffffffff";
            elsif MW(0) = '1' and wd(7) = '0' then
                writeBase <= x"00000000";      
            end if ;
        end if ;
    end process ; -- WRITING
    rd <= data(to_integer(unsigned(ad)));

    write : process (clock)
    begin
        if rising_edge(clock) then
            if MW = "1111" then
                data(to_integer(unsigned(ad))) <= wd;
            elsif MW = "0011" then
                data(to_integer(unsigned(ad)))(31 downto 16) <= writeBase(31 downto 16);
                data(to_integer(unsigned(ad)))(15 downto 0) <= wd(15 downto 0);
            elsif MW = "0001" then
                data(to_integer(unsigned(ad)))(31 downto 8) <= writeBase(31 downto 8);
                data(to_integer(unsigned(ad)))(7 downto 0) <= wd(7 downto 0);
            end if;
        end if;
    end process;      -- write

end architecture; -- arch