library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
use work.MyTypes.all;

entity cond is
  port (
    z,c,n,v : in std_logic;
    cond_code: in cond_codes;
    p: out std_logic 
  ) ;
end cond ; 

architecture arch of cond is
begin

    c_pro : process(cond_code,z,c,v,n)
    begin
        case(cond_code) is
        
            when eq=>
                p <= z;
            when ne=>
                p <= not z;
            when cs=>
                p <= c;
            when cc=>
                p <= not c;
            when mi=>
                p <= n;
            when pl=>
                p <= not n;
            when vs=>
                p <= v;
            when vc=>
                p <= not v;
            when hi=>
                p <= c and (not z);
            when ls=>
                p <= not (c and (not z));
            when ge=>
                p<= v xnor n;
            when lt=>
                p<= v xor n;
            when gt=>
                p <= ((not z) and (n xnor v));
            when le=>
                p <= not ((not z) and (n xnor v));
            when al=>
                p <='1';
            when others =>
                p <= '0';  
        end case ;
        
    end process ; -- c

end architecture ;