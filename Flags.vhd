library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.MyTypes.all;


entity flag is
  port (
    clock: in std_logic;
    op_code:in optype;
    ins_type: in instr_class_type;
    s_bit: in std_logic;
    carry: in std_logic;
    a: in std_logic_vector(31 downto 0);
    b: in std_logic_vector(31 downto 0);
    result: in std_logic_vector(31 downto 0);
    c_out,v_out,z_out,n_out : out std_logic
  ) ;
end flag ;

architecture arch of flag is
  -- c_out<='0';
  -- v_out<='0';
  -- z_out<='0';
  -- n_out<='0';
begin

  flag : process( clock )
  begin
    if( rising_edge(clock) ) and (s_bit = '1') and (ins_type = DP) then
        z_out <= '1' when result = x"00000000" else '0';
        n_out <= '1' when result(31) = '1' else '0';
        c_out <= carry;
        v_out <= (a(31) and b(31) and (not result(31))) or ((not a(31)) and (not b(31))and (result(31)));
        
      
    end if ;
  end process ; -- flag

end architecture ; -- arch