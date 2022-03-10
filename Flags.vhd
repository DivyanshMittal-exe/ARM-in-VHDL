library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.MyTypes.all;
entity flag is
  port (
    f_set                      : in std_logic;
    op_code                    : in optype;
    carry                      : in std_logic;
    a                          : in std_logic_vector(31 downto 0);
    b                          : in std_logic_vector(31 downto 0);
    result                     : in std_logic_vector(31 downto 0);
    c_out, v_out, z_out, n_out : out std_logic
  );
end flag;

architecture arch of flag is
begin
  
  flag : process (f_set, op_code, carry, a, b, result)
  begin
    if f_set = '1' then
      if result = x"00000000" then
        z_out <= '1';
      else
        z_out <= '0';
      end if;
      n_out <= result(31);
      if op_code /= tst and op_code /= teq then 
        c_out <= carry;
      end if;
      if op_code = sub or op_code = cmp or op_code = sbc then
        v_out <= (a(31) and (not b(31)) and (not result(31))) or ((not a(31)) and (not b(31)) and (result(31)));
      elsif op_code = rsb or op_code = rsc then
        v_out <= ((not a(31)) and b(31) and (not result(31))) or ((not a(31)) and (not b(31)) and (result(31)));
      elsif op_code /= tst and op_code /= teq then 
        v_out <= (a(31) and b(31) and (not result(31))) or ((not a(31)) and (not b(31)) and (result(31)));
      end if;

    end if;
  end process;      -- flag

end architecture; -- arch