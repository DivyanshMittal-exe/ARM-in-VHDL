library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;


entity multiplier is
  port (
    instr_class    : in instr_class_type;
    A              : IN std_logic_vector(31 downto 0) ;
    B              : IN std_logic_vector(31 downto 0) ;
    C              : IN std_logic_vector(31 downto 0) ;
    D              : IN std_logic_vector(31 downto 0) ;
    MulRes         : out std_logic_vector(63 downto 0)
  ) ;
end multiplier ;

architecture arch of multiplier is
begin

    muler : process( instr_class,A,B,C )
    begin

        if instr_class = MUL then
            MulRes(31 downto 0) <= std_logic_vector(unsigned(A)*unsigned(B))(31 downto 0);
        elsif instr_class = MLA then
            MulRes(31 downto 0) <= std_logic_vector(unsigned(std_logic_vector(signed(A)*signed(B))(31 downto 0)) + unsigned(C));
        elsif instr_class = SMULL then
            MulRes <= std_logic_vector(signed(A)*signed(B));
        elsif instr_class = SMLAL then
            MulRes <= std_logic_vector(signed(A)*signed(B)+signed(C&D));
        elsif instr_class = UMULL then
            MulRes <= std_logic_vector(unsigned(A)*unsigned(B));
        elsif instr_class = UMLAL then
            MulRes <= std_logic_vector(unsigned(A)*unsigned(B)+unsigned(C&D));
        end if ;
    end process ; -- muler

end architecture ; -- arch