library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity rotator is
  port (
    inp: in std_logic_vector(31 downto 0) ;
    oup: out std_logic_vector(31 downto 0);
    rotated_carry: out std_logic
  ) ;
end rotator ; 

architecture arch of rotator is
    signal rotated_val : std_logic_vector(31 downto 0):= x"00000000";
    signal shift_by : integer := 0 ;
begin
  rot_p : process(inp)
  begin
    rotated_val <= x"000000"&inp(7 downto 0);
    shift_by <= to_integer(unsigned(inp(11 downto 8)&'0'));
  end process ; -- rot_p
    oup <= std_logic_vector(rotate_right(signed(rotated_val), shift_by));

    rotated_carry <=  rotated_val(shift_by-1) when shift_by /= 0 else
                     'X';
end architecture ;