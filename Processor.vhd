
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;


entity processor is
  port (
    clock : in std_logic;
    reset : in std_logic
  );
end processor;

architecture arch of processor is

  component ALU
    port (
      op1, op2 : in std_logic_vector(31 downto 0);
      op_code  : in optype;
      c_in     : in std_logic;
      c_out    : out std_logic;
      res      : out std_logic_vector(31 downto 0)
    );
  end component;

  component data_mem
    port (
      clock : in std_logic;
      ad    : in std_logic_vector(15 downto 0);
      rd    : out std_logic_vector(31 downto 0);
      MW    : in std_logic_vector(3 downto 0);
      wd    : in std_logic_vector(31 downto 0)

    );
  end component;

  component Reg
    port (
      clock          : in std_logic;
      write_en       : in std_logic;
      r_ad_1, r_ad_2 : in std_logic_vector(3 downto 0);
      write_1        : in std_logic_vector(3 downto 0);
      data           : in std_logic_vector(31 downto 0);
      r_da_1, r_da_2 : out std_logic_vector(31 downto 0)
    );
  end component;

  component Decoder
    port (
      instruction    : in word;
      instr_class    : out instr_class_type;
      operation      : out optype;
      DP_subclass    : out DP_subclass_type;
      DP_operand_src : out DP_operand_src_type;
      load_store     : out load_store_type;
      DT_offset_sign : out DT_offset_sign_type;
      cond_code      : out cond_codes;
      set_cond       : out std_logic
    );
  end component;

  component pc
    port (
      clock : in std_logic;
      reset : in std_logic;
      PW    : in std_logic;
      P_in  : in std_logic_vector(31 downto 0);
      P_out : out std_logic_vector(31 downto 0)
    );
  end component;

  component flag
    port (
      f_set                      : in std_logic;
      op_code                    : in optype;
      carry                      : in std_logic;
      a                          : in std_logic_vector(31 downto 0);
      b                          : in std_logic_vector(31 downto 0);
      result                     : in std_logic_vector(31 downto 0);
      c_out, v_out, z_out, n_out : out std_logic

    );
  end component;

  component cond
    port (
      z, c, n, v : in std_logic;
      cond_code  : in cond_codes;
      p          : out std_logic
    );
  end component;

  component FSM
    port (
      reset          : in std_logic := '0';
      clock          : in std_logic;
      instruction    : in std_logic_vector(31 downto 0);
      instr_class    : in instr_class_type;
      DP_subclass    : in DP_subclass_type;
      load_store     : in load_store_type;
      DP_operand_src : in DP_operand_src_type;
      DT_offset_sign : in DT_offset_sign_type;
      p_cond         : in std_logic;
      set_cond       : in std_logic;
      operation_in   : in optype;
      operation_out  : out optype;
      PW             : out std_logic;
      iORd           : out std_logic_vector(1 downto 0);
      MW             : out std_logic_vector(3 downto 0) ;
      IW             : out std_logic;
      DW             : out std_logic_vector(3 downto 0);
      Rscrc          : out std_logic_vector(1 downto 0) ;
      M2R            : out std_logic;
      RW             : out std_logic;
      AW             : out std_logic;
      BW             : out std_logic;
      Asrc1          : out std_logic;
      Asrc2          : out std_logic_vector(1 downto 0);
      Fset           : out std_logic;
      Rew            : out std_logic;
      DDPW           : out std_logic;
      XDPW           : out std_logic;
      signDT          : out std_logic;
      wadMux          : out std_logic


    );
  end component;

  component IDAB_reg
    port (
      clock  : in std_logic;
      IW     : in std_logic;
      DW     : in std_logic_vector(3 downto 0) ;
      AW     : in std_logic;
      BW     : in std_logic;
      ReW    : in std_logic;

      I_in   : in std_logic_vector(31 downto 0);
      D_in   : in std_logic_vector(31 downto 0);
      A_in   : in std_logic_vector(31 downto 0);
      B_in   : in std_logic_vector(31 downto 0);
      Re_in  : in std_logic_vector(31 downto 0);

      I_out  : out std_logic_vector(31 downto 0);
      D_out  : out std_logic_vector(31 downto 0);
      A_out  : out std_logic_vector(31 downto 0);
      B_out  : out std_logic_vector(31 downto 0);
      Re_out : out std_logic_vector(31 downto 0);
      DDPW : in std_logic;
      DDP_in : in std_logic_vector(31 downto 0);
      DDP_out : out std_logic_vector(31 downto 0);
      XDPW : in std_logic;
      XDP_in : in std_logic_vector(31 downto 0);
      XDP_out : out std_logic_vector(31 downto 0);
      signDT : in std_logic
    );
  end component;

  component rotator
    port (
      inp           : in std_logic_vector(31 downto 0);
      oup           : out std_logic_vector(31 downto 0);
      rotated_carry : out std_logic

    );
  end component;

  component shifter
    port (
      B           : in std_logic_vector(31 downto 0);
      X           : in std_logic_vector(31 downto 0);
      Instr       : in std_logic_vector(31 downto 0);

      shifted_out : out std_logic_vector(31 downto 0);
      carry_out   : out std_logic
    );
  end component;

  signal br              : std_logic                     := '0';
  signal ofst            : std_logic_vector(23 downto 0) := "000000000000000000000000";
  signal prog_c          : std_logic_vector(7 downto 0)  := "00000000";
  signal instr_class     : instr_class_type;
  signal DP_subclass     : DP_subclass_type;
  signal DP_operand_src  : DP_operand_src_type;
  signal load_store      : load_store_type;
  signal DT_offset_sign  : DT_offset_sign_type;
  signal cond_cd         : cond_codes;
  signal rad2_port       : std_logic_vector(3 downto 0);
  signal alu_c_out       : std_logic;
  signal c               : std_logic;
  signal v               : std_logic;
  signal z               : std_logic;
  signal n               : std_logic;
  signal p_cond          : std_logic := '0';

  -- New Signals for multi
  signal operation_instr : optype;
  signal operation_alu   : optype;

  signal PW              : std_logic;
  signal iORd            : std_logic_vector(1 downto 0);
  signal MW              : std_logic_vector(3 downto 0);

  signal Rscrc           : std_logic_vector(1 downto 0);
  signal M2R             : std_logic;
  signal RW              : std_logic;
  signal Asrc1           : std_logic;
  signal Asrc2           : std_logic_vector(1 downto 0);
  signal Fset            : std_logic;
  signal IW              : std_logic;
  signal DW              : std_logic_vector(3 downto 0);
  signal AW              : std_logic;
  signal BW              : std_logic;
  signal ReW             : std_logic;
  signal XDPW            : std_logic;
  signal DDPW            : std_logic;
  signal D_in            : std_logic_vector(31 downto 0);
  signal A_in            : std_logic_vector(31 downto 0);
  signal B_in            : std_logic_vector(31 downto 0);
  signal Re_in           : std_logic_vector(31 downto 0);
  signal XDP_in          : std_logic_vector(31 downto 0);
  signal DDP_in          : std_logic_vector(31 downto 0);
  signal I_out           : std_logic_vector(31 downto 0);
  signal D_out           : std_logic_vector(31 downto 0);
  signal A_out           : std_logic_vector(31 downto 0);
  signal B_out           : std_logic_vector(31 downto 0);
  signal Re_out          : std_logic_vector(31 downto 0);
  signal DDP_out         : std_logic_vector(31 downto 0);
  signal XDP_out         : std_logic_vector(31 downto 0);

  signal DDP_MUX         : std_logic;

  signal P_out           : std_logic_vector(31 downto 0);
  signal set_cond        : std_logic;

  signal rd_mem          : std_logic_vector(31 downto 0);
  signal ad_mem          : std_logic_vector(15 downto 0);
  signal wd_mem          : std_logic_vector(31 downto 0);

  signal wd_ref          : std_logic_vector(31 downto 0);

  signal alu_op_2        : std_logic_vector(31 downto 0);
  signal alu_op_1        : std_logic_vector(31 downto 0);

  signal ALU_out         : std_logic_vector(31 downto 0);
  signal rotated_out     : std_logic_vector(31 downto 0);
  signal rotated_carry   : std_logic;

  signal shifted_out     : std_logic_vector(31 downto 0);
  signal data_write_ad     : std_logic_vector(3 downto 0);
  signal shifter_carry   : std_logic;
  signal signDT          : std_logic;
  signal wadMux          : std_logic;
  
begin

  fsm_label : FSM port map(
    reset          => reset,
    clock          => clock,
    instruction    => I_out,
    instr_class    => instr_class,
    load_store     => load_store,
    DP_subclass    => DP_subclass,
    DP_operand_src => DP_operand_src,
    DT_offset_sign => DT_offset_sign,
    operation_in   => operation_instr,
    operation_out  => operation_alu,

    p_cond         => p_cond,
    set_cond       => set_cond,

    PW             => PW,
    iORd           => iORd,
    MW             => MW,
    IW             => IW,
    DW             => DW,
    Rscrc          => Rscrc,
    M2R            => M2R,
    RW             => RW,
    AW             => AW,
    BW             => BW,
    Asrc1          => Asrc1,
    Asrc2          => Asrc2,
    Fset           => Fset,
    Rew            => Rew,
    DDPW           => DDPW,
    XDPW           => XDPW,
    signDT         => signDT,
    wadMux         => wadMux


  );

  IDAB_reg_label : IDAB_reg port map(
    clock   => clock,
    IW      => IW,
    DW      => DW,
    AW      => AW,
    BW      => BW,
    ReW     => ReW,
    DDPW    => DDPW,
    XDPW    => XDPW,

    signDT => signDT,

    I_in    => rd_mem,
    D_in    => rd_mem,
    A_in    => A_in,
    B_in    => B_in,
    Re_in   => ALU_out,

    XDP_in  => B_in,
    DDP_in  => DDP_in,

    I_out   => I_out,
    D_out   => D_out,
    A_out   => A_out,
    B_out   => B_out,
    XDP_out => XDP_out,
    DDP_out => DDP_out,
    Re_out  => Re_out

  );
  Decoder_label : Decoder port map(
    instruction    => I_out,
    instr_class    => instr_class,
    operation      => operation_instr,
    DP_subclass    => DP_subclass,
    DP_operand_src => DP_operand_src,
    load_store     => load_store,
    DT_offset_sign => DT_offset_sign,
    cond_code      => cond_cd,
    set_cond       => set_cond
  );

  pc_label : pc port map(
    clock => clock,
    reset => reset,
    PW    => PW,
    P_in  => ALU_out,
    P_out => P_out
  );

  data_mem_label : data_mem port map(
    clock => clock,
    rd    => rd_mem,
    MW    => MW,
    ad    => ad_mem,
    wd    => B_out
  );

  Reg_label : Reg port map(
    clock    => clock,
    write_en => RW,
    r_ad_1   => I_out(19 downto 16),
    r_ad_2   => rad2_port,
    write_1  => data_write_ad,
    data     => wd_ref,
    r_da_1   => A_in,
    r_da_2   => B_in
  );

  ALU_label : ALU port map(
    op1     => alu_op_1,
    op2     => alu_op_2,
    op_code => operation_alu,
    c_in    => c,
    c_out   => alu_c_out,
    res     => ALU_out
  );

  flag_label : flag port map(
    f_set   => Fset,
    op_code => operation_alu,
    carry   => alu_c_out,
    a       => alu_op_1,
    b       => alu_op_2,
    result  => ALU_out,
    c_out   => c,
    v_out   => v,
    z_out   => z,
    n_out   => n
  );

  cond_label : cond port map(
    c         => c,
    v         => v,
    z         => z,
    n         => n,
    cond_code => cond_cd,
    p         => p_cond
  );

  rotator_label : rotator port map(
    inp           => I_out,
    oup           => rotated_out,
    rotated_carry => rotated_carry
  );
  shifter_label : shifter port map(
    B           => B_out,
    X           => XDP_out,
    Instr       => I_out,

    shifted_out => shifted_out,
    carry_out   => shifter_carry
  );

  DDP_in <= B_out when instr_class = DTHR else shifted_out;

  data_write_ad <= I_out(19 downto 16) when wadMux = '1' else I_out(15 downto 12);

  ad_mem <= "0000000" & P_out(10 downto 2) when iORd = "00" else
            "0000000" & Re_out(8 downto 0) when iORd = "01" else
            "0000000" & A_out(8 downto 0) when iORd = "10" else
            "0000000000000000";

  rad2_port <= I_out(3 downto 0) when Rscrc = "00" else
              I_out(15 downto 12) when Rscrc = "01" else
              I_out(11 downto 8);
  wd_ref <= D_out when M2R = '1' else
    Re_out;

  alu_op_1 <= P_out when Asrc1 = '0' else
    A_out;
  alu_op_2 <= DDP_out when Asrc2 = "00" else
    x"00000004" when Asrc2 = "01" else
    rotated_out when Asrc2 = "10" and instr_class = DP else
    X"000000" & I_out(11 downto 8)& I_out(3 downto 0) when Asrc2 = "10" and instr_class = DTHI else
    X"00000" & I_out(11 downto 0) when Asrc2 = "10"  else
    std_logic_vector(unsigned("000000" & I_out(23 downto 0) & "00") + 4);

end architecture;