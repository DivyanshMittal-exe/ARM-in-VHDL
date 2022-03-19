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
        wd    : in std_logic_vector(31 downto 0)
    );
end data_mem;

architecture arch of data_mem is
    type mem is array(0 to 511) of std_logic_vector(31 downto 0);
    signal data : mem := (
        0 => X"E3A00020",
        1 => X"E3A01001",
        2 => X"E3A02000",
        3 => X"E3A060AA",
        4 => X"E0822006",
        5 => X"E0822406",
        6 => X"E0822806",
        7 => X"E0822C06",
        8 => X"E6802001",
        9 => X"E7A02001",
        10 => X"E7802001",
        11 => X"E08020B1",
        12 => X"E1A020B1",
        13 => X"E18020B1",
        14 => X"E6C02001",
        15 => X"E7E02001",
        16 => X"E7C02001",
        17 => X"E3A00020",
        18 => X"E4903001",
        19 => X"E5F04001",
        20 => X"E1D050B1",
        21 => X"E3A00021",
        22 => X"E1F040D1",
        23 => X"E1D050F1",
        others => X"00000000"
    );
    signal writeBase : std_logic_vector(31 downto 0) := x"00000000";
begin

    rd <= data(to_integer(unsigned(ad)));

    write : process (clock)
    begin
        if rising_edge(clock) then
            if MW = "1111" then
                data(to_integer(unsigned(ad))) <= wd;
            elsif MW = "0011" then
                data(to_integer(unsigned(ad)))(31 downto 16) <= x"0000";
                data(to_integer(unsigned(ad)))(15 downto 0) <= wd(15 downto 0);
            elsif MW = "0001" then
                data(to_integer(unsigned(ad)))(31 downto 8) <= x"000000";
                data(to_integer(unsigned(ad)))(7 downto 0) <= wd(7 downto 0);
            end if;
        end if;
    end process;      -- write

end architecture; -- arch