library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use work.MyTypes.all


entity processor is
  port (
    clock:in std_logic;
    reset: in std_logic
  ) ;
end processor ; 

architecture arch of processor is

  component ALU
  port(
          op1, op2: in std_logic_vector(31 downto 0);
          op_code:in optype;
          c_in: in std_logic;
          c_out: out std_logic;
          res: out std_logic_vector(31 downto 0)	
      );
  end component;

  component data_mem
    port(
        clock: in std_logic;
        read_data:out std_logic_vector(31 downto 0);

        write_en: in std_logic_vector(3 downto 0);

        locn:in std_logic_vector(5 downto 0);
        write_data:in std_logic_vector(31 downto 0)
        );
    end component;

    component prog_mem
    port(
        read_loc:in std_logic_vector(5 downto 0);
        read_data:out std_logic_vector(31 downto 0)
        );
    end component;

    component Reg
    port(
        clock: in std_logic;
        write_en: in std_logic;
        r_ad_1, r_ad_2: in std_logic_vector(3 downto 0);
        write_1: in std_logic_vector(3 downto 0);
        data:in std_logic_vector(31 downto 0);
        r_da_1,r_da_2: out std_logic_vector(31 downto 0)
        );
    end component;

    component Decoder
    port (
      instruction : in word;
      instr_class : out instr_class_type;
      operation : out optype;
      DP_subclass : out DP_subclass_type;
      DP_operand_src : out DP_operand_src_type;
      load_store : out load_store_type;
      DT_offset_sign : out DT_offset_sign_type
      );
      end component;

      component pc
        port (
          clock: in std_logic;
          reset: in std_logic;
          branch: in std_logic;
          offset: in std_logic_vector(31 downto 0);
          counter: out std_logic_vector(7 downto 0)
        ) ;
      end component ; 

      component flag
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
      end component ;

      component cond
        port (
          z,c,n,v : in std_logic;
          cond_code: in cond;
          p: out std_logic 
        ) ;
      end component ;   

      signal br: std_logic := '0';
      signal ofst: std_logic_vector(23 downto 0) := "000000000000000000000000";
      signal prog_c: std_logic_vector(7 downto 0):="00000000";
      signal instruction: std_logic_vector(31 downto 0) ;
      signal instr_class : instr_class_type;
      signal operation : optype;
      signal DP_subclass : DP_subclass_type;
      signal DP_operand_src : DP_operand_src_type;
      signal load_store : load_store_type;
      signal DT_offset_sign : DT_offset_sign_type;


      signal Zflag, predicate : std_logic; 
      -- Sign extension for branch address
       signal Sext : std_logic_vector (5 downto 0);
      -- Instruction fields
       signal Cond : std_logic_vector (1 downto 0);
       signal Imm : std_logic_vector (7 downto 0); 
       signal Offset : std_logic_vector (11 downto 0); 
       signal S_offset : std_logic_vector (23 downto 0);
       signal Rd, Rn, Rm : integer range 0 to 15,
       signal d1,d2: std_logic_vector(31 downto 0):= "00000000" ;
       signal alu_op_2: std_logic_vector(31 downto 0) ;
       signal c: std_logic;

       signal ALU_out : std_logic_vector(31 downto 0) ;
       signal dm_out : std_logic_vector(31 downto 0) ;
       signal reg_data: std_logic_vector(31 downto 0) ;
       signal MW : std_logic_vector(3 downto 0) := "0000" ;
       signal rad2_port:std_logic_vector(3 downto 0) ;
       signal alu_c_out: std_logic;
       signal c: std_logic;
       signal v: std_logic;
       signal z: std_logic;
       signal n: std_logic;
       signal p_cond: std_logic:='0';
begin
  
  pc port map(
      clock => clock,
      reset => reset,
      branch => br,
      offset => S_ext & S_offset & "00",
      counter => prog_c
  );

  br <= '1' when instr_class =BRN and p_cond = '1' else
        '0';

  prog_mem PORT MAP (
    read_data => prog_c(7 downto 2),
    read_loc => instruction
    );

    S_ext <= "111111" when (DT_offset_sign = plus) else "000000";
    Cond <= instruction (29 downto 28);
    Imm <= instruction (7 downto 0); 
    Offset <= instruction (11 downto 0); 
    S_offset <= instruction (23 downto 0);
   
  
    Rd <= to_integer (unsigned(instruction (15 downto 12)));
    Rn <= to_integer (unsigned(instruction (19 downto 16)));
    Rm <= to_integer (unsigned(instruction (3 downto 0)));


  Decoder port map(
    instruction => instruction;
    instr_class => instr_class;
    operation => operation;
    DP_subclass => DP_subclass;
    DP_operand_src => DP_operand_src;
    load_store => load_store;
    DT_offset_sign => DT_offset_sign
  );
  -- rsrc

  rad2_port <= Rd when (instr_class = DT and load_store = store)  else
              Rm;

   Reg port map (
      clock => clock,
      write_en: in std_logic;
      r_ad_1 => Rn,
      r_ad_2 => rad2_port,
      write_1 => Rd,
      data 
      r_da_1 => d1,
      r_da_2 => d2
      );
    
      -- asrc port
      alu_op_2 <= "00000000000000000000"&Offset when instr_class = DT else 
                  x"000000"&Imm when instr_class = DP and DP_operand_src = imm else
                  d2;

    ALU port map(
      op1 => d1,
      op2 => alu_op_2,
      op_code => operation,
      c_in => c,
      c_out => alu_c_out,
      res => ALU_out,
    );

      MW <= '1' when (instr_class = DT and load_store = load) else '0';


      data_mem port map (
        clock => clock,
        read_data => dm_out,

        write_en => MW,

        locn => ALU_out(5 downto 0),
        write_data => d2
        );
      );

      reg_data <= ALU_out when instr_class = DP else "00000000000000000000"&Offset
            DP_subclass <= arith when "001" | "010" | "011",
            RW <= '1' when (instr_class = DP and DP_subclass = arith) or (instr_class = DT and load_store = load) else
                  '0';
            
      flag port map (
        clock => clock,
        op_code => operation,
        ins_type => instr_class,
        s_bit => instruction(20),
        carry => alu_c_out,
        a => d1,
        b => alu_op_2,
        result => ALU_out,
        c_out => c,
        v_out => v,
        z_out => z,
        n_out => n
      ) ;
      
      cond port map (
        c => c,
        v => v,
        z => z,
        n => n,
        cond_code => instruction(31 downto 28),
        p =>  p_cond
      ) ;
    


end architecture ;