library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.MyTypes.all

entity ALU is
  Port (
  	 op1, op2: in std_logic_vector(31 downto 0);
    op_code:in optype;
    c_in: in std_logic;
    c_out: out std_logic;
    res: out std_logic_vector(31 downto 0)
    );

 end ALU;
 
 architecture alu_arch of ALU is
   
 begin
    operation : process(op1,op2,op_code,c_in)


	variable  res_33 : std_logic_vector(32 downto 0) := "000000000000000000000000000000000";
    begin
         c_out <= '0';
        case(op_code)is
            when andop =>
               res <= (op1 and op2);
            when eor =>
               res <= (op1 xor op2);
               
            when sub  =>
               res_33 := std_logic_vector( unsigned('0'&(op1)) + unsigned('0'& not op2) + 1);
               c_out <=  res_33(32);
               res <= res_33(31 downto 0);
               
            when rsb =>
              res_33 := std_logic_vector( unsigned('0'&(not op1)) + unsigned('0'&op2) + 1);
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
            
            when add =>
               res_33 := std_logic_vector(unsigned('0'&op1)+unsigned('0'&op2)); 
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
            when adc =>
            	if (c_in = '1') then
            		res_33 := std_logic_vector(unsigned('0'&op1) + unsigned('0'&op2) + 1);
                  res <= res_33(31 downto 0);
                  c_out <=  res_33(32);
               else
               res_33 :=  std_logic_vector(unsigned('0'&op1) + unsigned('0'&op2) + 0);
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
                 end if;
            when sbc =>
               if (c_in = '1') then
                  res_33 := std_logic_vector(unsigned('0'&op1) +  unsigned('0'&(not op2)) + 1);
                  res <= res_33(31 downto 0);
                  c_out <=  res_33(32);
               else
               res_33 := std_logic_vector(unsigned('0'&op1) +  unsigned('0'&(not op2)) + 0);
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
                  end if;
            when rsc =>
               if (c_in = '1') then
                  res_33 := std_logic_vector( unsigned('0'&(not op1)) +  unsigned('0'& op2) + 1);
                  res <= res_33(31 downto 0);
                  c_out <=  res_33(32);
               else
               res_33 := std_logic_vector( unsigned('0'&(not op1)) +  unsigned('0'& op2) + 0);
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
               end if;
            when tst =>
               res <= op1 and op2;
            when teq =>
               res <= op1 xor op2;     
            when cmp =>
               res_33 := std_logic_vector(unsigned('0'&op1) +  unsigned('0'&(not op2)) + 1);
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
            when cmn =>
               res_33 := std_logic_vector(unsigned('0'&op1) + unsigned('0'&op2));
               res <= res_33(31 downto 0);
               c_out <=  res_33(32);
            when orr =>
               res <= op1 or op2;
            when mov =>
               res <= op2;
            when bic =>
               res <= op1 and  not (op2);
            when mvn =>
               res <= not (op2);
            when others =>
               res <= "00000000000000000000000000000000";
        end case ;
    end process ; -- operation
 
 end alu_arch ; -- alu_archs