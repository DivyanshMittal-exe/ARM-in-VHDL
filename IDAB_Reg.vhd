library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IDAB_reg is
    port (
        clock: in std_logic;
        IW     : in std_logic;
        DW     : in std_logic;
        AW     : in std_logic;
        BW     : in std_logic;
        ReW    : in std_logic;
        I_in   : in std_logic_vector(31 downto 0);
        D_in   : in std_logic_vector(31 downto 0);
        A_in   : in std_logic_vector(31 downto 0);
        B_in   : in std_logic_vector(31 downto 0);
        Re_in  : in std_logic_vector(31 downto 0);
        I_out  : out std_logic_vector(31 downto 0);
        D_out  : out std_logic_vector(31 downto 0);
        A_out  : out std_logic_vector(31 downto 0);
        B_out  : out std_logic_vector(31 downto 0);
        Re_out : out std_logic_vector(31 downto 0)
    );
end IDAB_reg;

architecture IDAB_reg_arch of IDAB_reg is
    signal I  : std_logic_vector(31 downto 0) := x"00000000";
    signal D  : std_logic_vector(31 downto 0) := x"00000000";
    signal A  : std_logic_vector(31 downto 0) := x"00000000";
    signal B  : std_logic_vector(31 downto 0) := x"00000000";
    signal Re : std_logic_vector(31 downto 0) := x"00000000";
begin
    I_out  <= I;
    D_out  <= D;
    A_out  <= A;
    B_out  <= B;
    Re_out <= Re;

    process (clock, IW, I_in)
    begin
        if IW = '1' and rising_edge(clock) then
            I <= I_in;
        end if;
    end process;

    process (clock, DW, D_in)
    begin
        if DW = '1' and rising_edge(clock) then
            D <= D_in;
        end if;
    end process;

    process (clock, AW, A_in)
    begin
        if AW = '1' and rising_edge(clock) then
            A <= A_in;
        end if;
    end process;
    process (clock, BW, B_in)
    begin
        if BW = '1' and rising_edge(clock) then
            B <= B_in;
        end if;
    end process;

    process (clock, ReW, Re_in)
    begin
        if ReW = '1' and rising_edge(clock) then
            Re <= Re_in;
        end if;
    end process;

end IDAB_reg_arch; -- IDAB_reg_arch
