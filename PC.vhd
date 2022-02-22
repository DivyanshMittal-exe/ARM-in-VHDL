library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
  port (
    reset : in std_logic;
    PW    : in std_logic;
    P_in  : in std_logic_vector(31 downto 0);
    P_out : out std_logic_vector(31 downto 0)

  );
end pc;

architecture arch of pc is
  signal P : std_logic_vector(31 downto 0) := x"00000000";

begin
  P_out <= P;
  c : process (reset, clock, PW, P_in)
  begin
    if reset = '1' then
      P <= x"00000000";
    elsif PW = '1' and rising_edge(clock) then
      P <= P_in;
    end if;
  end process; -- c

end architecture;
