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
    signal shift_by : std_logic_vector(3 downto 0);
    signal shift2_res : std_logic_vector(31 downto 0) ;
    signal shift4_res : std_logic_vector(31 downto 0) ;
    signal shift8_res : std_logic_vector(31 downto 0) ;
    signal shift16_res : std_logic_vector(31 downto 0) ;
begin
  rot_p : process(inp)
  begin
    rotated_val <= x"000000"&inp(7 downto 0);
    shift_by <= inp(11 downto 8);
  end process ; -- rot_p
    shift2: entity work.shifter_byi generic map (2) port map (rotated_val, shift2_res, shift_by(0), "11");
    shift4: entity work.shifter_byi generic map (4) port map (shift2_res, shift4_res, shift_by(1), "11");
    shift8: entity work.shifter_byi generic map (8) port map (shift4_res, shift8_res, shift_by(2), "11");
    shift16: entity work.shifter_byi generic map (16) port map (shift8_res, oup, shift_by(3), "11");

    rotated_carry <=  rotated_val(to_integer(unsigned(shift_by&'0'))-1) when to_integer(unsigned(shift_by&'0')) /= 0 else
                     'X';
end architecture ;