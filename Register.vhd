library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Reg is
    port (
        clock                                                                : in std_logic;
        write_en                                                             : in std_logic;
        r_ad_1, r_ad_2                                                       : in std_logic_vector(3 downto 0);
        write_1                                                              : in std_logic_vector(3 downto 0);
        data                                                                 : in std_logic_vector(31 downto 0);
        r_da_1, r_da_2                                                       : out std_logic_vector(31 downto 0);

        -- Debugging use: Probes registers
        r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 : out std_logic_vector(31 downto 0)
    );
end Reg;

architecture reg_arch of Reg is
    type mem is array(0 to 15) of std_logic_vector(31 downto 0);
    signal Regs : mem := (others => (others => '0'));

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
    r0  <= Regs(0);
    r1  <= Regs(1);
    r2  <= Regs(2);
    r3  <= Regs(3);
    r4  <= Regs(4);
    r5  <= Regs(5);
    r6  <= Regs(6);
    r7  <= Regs(7);
    r8  <= Regs(8);
    r9  <= Regs(9);
    r10 <= Regs(10);
    r11 <= Regs(11);
    r12 <= Regs(12);
    r13 <= Regs(13);
    r14 <= Regs(14);
    r15 <= Regs(15);

end reg_arch; -- reg_arch
