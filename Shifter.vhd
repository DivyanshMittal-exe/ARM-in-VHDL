library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity shifter is
  port (
    B : in std_logic_vector(31 downto 0) ;
    X : in std_logic_vector(31 downto 0) ;
    Instr : in std_logic_vector(31 downto 0) ;

    shifted_out: out std_logic_vector(31 downto 0);
    carry_out: out std_logic
  ) ;
end shifter ; 

architecture arch of shifter is
  signal shift_by : std_logic_vector(4 downto 0);
  signal shift1_res : std_logic_vector(31 downto 0) ;
  signal shift2_res : std_logic_vector(31 downto 0) ;
  signal shift4_res : std_logic_vector(31 downto 0) ;
  signal shift8_res : std_logic_vector(31 downto 0) ;
  signal shift16_res : std_logic_vector(31 downto 0) ;
begin
    shift_by_set : process(Instr,B,X)
    begin
      if Instr(4) = '0' or Instr (27 downto 26) = "01" then
        shift_by <=  Instr(11 downto 7);
      else
        shift_by <= X(4 downto 0);
      end if;
    end process ; -- shift_by_set
      
    shift1: entity work.shifter_byi generic map (1) port map (B, shift1_res, shift_by(0), Instr(6 downto 5));
    shift2: entity work.shifter_byi generic map (2) port map (shift1_res, shift2_res, shift_by(1), Instr(6 downto 5));
    shift4: entity work.shifter_byi generic map (4) port map (shift2_res, shift4_res, shift_by(2), Instr(6 downto 5));
    shift8: entity work.shifter_byi generic map (8) port map (shift4_res, shift8_res, shift_by(3), Instr(6 downto 5));
    shift16: entity work.shifter_byi generic map (16) port map (shift8_res, shifted_out, shift_by(4), Instr(6 downto 5));
      
    carry_out <=  B(31-to_integer(unsigned(shift_by))) when Instr(6 downto 5) = "00" and  to_integer(unsigned(shift_by)) /= 0 else
                  B(to_integer(unsigned(shift_by))-1) when to_integer(unsigned(shift_by)) /= 0 else
                  'X';

end architecture ;

