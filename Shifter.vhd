library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

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
  signal shift_by : integer := 0;
begin
    shift_by_set : process(Instr,B,X)
    begin
      if Instr(4) = '0' or Instr (27 downto 26) = "01" then
        shift_by <=  to_integer(unsigned(Instr(11 downto 7)));
      else
        shift_by <= to_integer(unsigned(X));
      end if;
    end process ; -- shift_by_set

    shifted_out <= std_logic_vector(shift_left(unsigned(B), shift_by))  when Instr(6 downto 5) = "00" else
                  std_logic_vector(shift_right(unsigned(B), shift_by)) when Instr(6 downto 5) = "01" else
                  std_logic_vector(shift_right(signed(B), shift_by)) when Instr(6 downto 5) = "10" else
                  std_logic_vector(rotate_right(unsigned(B), shift_by));

      
    carry_out <=  B(31-shift_by) when Instr(6 downto 5) = "00" else
                  B(shift_by-1) when shift_by /= 0 else
                  'X';

end architecture ;