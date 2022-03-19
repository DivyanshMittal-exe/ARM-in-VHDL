library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;


entity IDAB_reg is
    port (
        clock: in std_logic;
        IW     : in std_logic;
        DW     : in std_logic_vector(3 downto 0);
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
        Re_out : out std_logic_vector(31 downto 0);

        DDPW : in std_logic;
        DDP_in : in std_logic_vector(31 downto 0);
        DDP_out : out std_logic_vector(31 downto 0);
        XDPW : in std_logic;
        XDP_in : in std_logic_vector(31 downto 0);
        XDP_out : out std_logic_vector(31 downto 0);
        signDT : in std_logic

    );
end IDAB_reg;

architecture IDAB_reg_arch of IDAB_reg is
    signal I  : std_logic_vector(31 downto 0) := x"00000000";
    signal D  : std_logic_vector(31 downto 0) := x"00000000";
    signal A  : std_logic_vector(31 downto 0) := x"00000000";
    signal B  : std_logic_vector(31 downto 0) := x"00000000";
    signal Re : std_logic_vector(31 downto 0) := x"00000000";
    signal DDP : std_logic_vector(31 downto 0) := x"00000000";
    signal XDP : std_logic_vector(31 downto 0) := x"00000000";
    signal writeBase : std_logic_vector(31 downto 0) := x"00000000";

begin
    I_out  <= I;
    D_out  <= D;
    A_out  <= A;
    B_out  <= B;
    Re_out <= Re;
    XDP_out <= XDP;
    DDP_out <= DDP;

    process (clock, IW, I_in)
    begin
        if IW = '1' and rising_edge(clock) then
            I <= I_in;
        end if;
    end process;

    DREG_SET : process(  DW, D_in,signDT )
    begin
        writeBase <= x"00000000";
        if signDT ='1' then
            if DW(1) = '1' and D_in(15) = '1' then
                writeBase <= x"ffffffff";
            elsif DW(1) = '1' and D_in(15) = '0' then
                writeBase <= x"00000000";
            elsif DW(0) = '1' and D_in(7) = '1' then
                writeBase <= x"ffffffff";
            elsif DW(0) = '1' and D_in(7) = '0' then
                writeBase <= x"00000000";      
            end if ;
        end if ;
    end process ; -- DREG_SET
    
    process (clock, DW, D_in,signDT)
    begin
        writeBase <= x"00000000";

            if signDT ='1' then
                if DW(1) = '1' and D_in(15) = '1' then
                    writeBase <= x"ffffffff";
                elsif DW(1) = '1' and D_in(15) = '0' then
                    writeBase <= x"00000000";
                elsif DW(0) = '1' and D_in(7) = '1' then
                    writeBase <= x"ffffffff";
                elsif DW(0) = '1' and D_in(7) = '0' then
                    writeBase <= x"00000000";      
                end if ;
            end if ;

        if rising_edge(clock) then
            D <= writeBase;

            if DW = "1111" then
                D <= D_in;
            elsif DW = "0011" then
                D(15 downto 0) <= D_in(15 downto 0);
            elsif DW = "0001" then
                D(7 downto 0) <= D_in(7 downto 0);
            end if;
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

    process (clock, DDPW, DDP_in)
    begin
        if DDPW = '1' and rising_edge(clock) then
            DDP <= DDP_in;
        end if;
    end process;


    process (clock, XDPW, XDP_in)
    begin
        if XDPW = '1' and rising_edge(clock) then
            XDP <= XDP_in;
        end if;
    end process;
end IDAB_reg_arch; -- IDAB_reg_arch
