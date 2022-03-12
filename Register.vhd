library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity Reg is
    port (
        clock          : in std_logic;
        write_en       : in std_logic;
        r_ad_1, r_ad_2 : in std_logic_vector(3 downto 0);
        write_1        : in std_logic_vector(3 downto 0);
        data           : in std_logic_vector(31 downto 0);
        r_da_1, r_da_2 : out std_logic_vector(31 downto 0)
    );

end Reg;

architecture reg_arch of Reg is
    type mem is array(0 to 15) of std_logic_vector(31 downto 0);
    signal Regs                                                                 : mem := (others => (others => 'X'));
begin
    r_da_1 <= Regs(to_integer(unsigned(r_ad_1)));
    r_da_2 <= Regs(to_integer(unsigned(r_ad_2)));
    process (clock)
    begin
        if rising_edge(clock) then
            if write_en = '1' then
                Regs(to_integer(unsigned(write_1))) <= data;
            end if;
        end if;
    end process; -- 
    -- Debugging use

end reg_arch; -- reg_arch