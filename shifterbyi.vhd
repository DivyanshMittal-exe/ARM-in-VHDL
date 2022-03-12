
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity shifter_byi is
    generic (size : integer := 1 );
    port (
        inp  : in std_logic_vector(31 downto 0);
        outp : out std_logic_vector(31 downto 0);
        shift_enb : in std_logic;
        shift_type: in std_logic_vector(1 downto 0) 
    );
  end shifter_byi;
  
  architecture arch of shifter_byi is
    signal leftshift : std_logic_vector(31 downto 0) ;
    signal rightshift : std_logic_vector(31 downto 0) ;
    signal rightshiftsigned : std_logic_vector(31 downto 0) ;
  begin
    identifier : process( inp,shift_enb,shift_type )
    begin
      leftshift <= x"00000000";
      leftshift(31 downto size) <= inp(31-size downto 0);
      rightshift <= x"00000000";
      rightshift(31-size downto 0) <= inp(31 downto size);
    if inp(31) = '1' then
        rightshiftsigned <= x"ffffffff";
    else
        rightshiftsigned <= x"00000000";
    end if;
        rightshiftsigned(31-size downto 0) <= inp(31 downto size);
    end process ; -- identifier
    outp <= leftshift when shift_type = "00" and shift_enb = '1' else
        rightshift when shift_type = "01" and shift_enb = '1' else
        rightshiftsigned when shift_type = "10" and shift_enb = '1' else
        inp(size-1 downto 0) & inp(31 downto size) when shift_type = "11" and shift_enb = '1' else
        inp;
  
  end arch ; -- arch