library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.op_code.all;


ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    COMPONENT ALU
    PORT(
           	op1, op2: in std_logic_vector(31 downto 0);
            op_code:in opc;
            c_in: in std_logic;
            c_out: out std_logic;
            res: out std_logic_vector(31 downto 0)	
        );
    END COMPONENT;
       --Inputs
   signal op1 : std_logic_vector(31 downto 0) := (OTHERS=>'0');
   signal op2 : std_logic_vector(31 downto 0) := (OTHERS=>'0');
   signal c_in : std_logic := '0';
   signal op_code : opc;

  --Outputs
   signal res : std_logic_vector(31 downto 0);
   signal c_out : std_logic;
 
BEGIN
   uut: ALU PORT MAP (
          op1 => op1,
          op2 => op2,
          c_in=>c_in,
          res => res,
          op_code => op_code,
          c_out =>c_out
        );

   process
   begin  
      c_in <= '0';

    op1 <= x"0000000a";
    op2 <= x"0000000d";
    op_code <=s_and;
    wait for 10 ns;
    assert res = x"00000008" report "Fail" severity error;
    op_code <=s_eor;
    wait for 10 ns;
    assert res = x"00000007" report "Fail" severity error;
    op_code <=s_sub;
    wait for 10 ns;
    assert res = x"fffffffd" report "Fail" severity error;
    op_code <=s_rsb;
    wait for 10 ns;
    assert res = x"00000003" report "Fail" severity error;
    op_code <=s_add;
    wait for 10 ns;
    assert res = x"00000017" report "Fail" severity error;
    op_code <=s_adc;
    wait for 10 ns;
    assert res = x"00000017" report "Fail" severity error;
    op_code <=s_sbc;
    wait for 10 ns;
    assert res = x"fffffffc" report "Fail" severity error;
    op_code <=s_rsc;
    wait for 10 ns;
    assert res = x"00000002" report "Fail" severity error;
    op_code <=s_tst;
    wait for 10 ns;
    assert res = x"00000008" report "Fail" severity error;
    op_code <=s_teq;
    wait for 10 ns;
    assert res = x"00000007" report "Fail" severity error;
    op_code <=s_cmp;
    wait for 10 ns;
    assert res = x"fffffffd" report "Fail" severity error;
    op_code <=s_cmn;
    wait for 10 ns;
    assert res = x"00000017" report "Fail" severity error;
    op_code <=s_orr;
    wait for 10 ns;
    assert res = x"0000000f" report "Fail" severity error;
    op_code <=s_mov;
    wait for 10 ns;
    assert res = x"0000000d" report "Fail" severity error;
    op_code <=s_bic;
    wait for 10 ns;
    assert res = x"00000002" report "Fail" severity error;
    op_code <=s_mvn;
    wait for 10 ns;
    assert res = x"fffffff2" report "Fail" severity error;
          wait;
   end process;

END;