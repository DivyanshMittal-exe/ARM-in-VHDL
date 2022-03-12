library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity rotator is
  port (
    inp: in std_logic_vector(31 downto 0) ;
    oup: out std_logic_vector(31 downto 0);
    rotated_carry: out std_logic
  ) ;
end rotator ; 

architecture arch of rotator is
begin
    oup <= std_logic_vector(rotate_right(signed(x"000000"&inp(7 downto 0)), to_integer(unsigned(inp(11 downto 8)&'0'))));
end architecture ;