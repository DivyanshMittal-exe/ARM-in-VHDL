library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.all;

entity FSM is
    port (
        reset          : in std_logic := '0';
        clock          : in std_logic;
        instruction    : in std_logic_vector(31 downto 0);
        DP_subclass    : in DP_subclass_type;
        instr_class    : in instr_class_type;
        load_store     : in load_store_type;
        DP_operand_src : in DP_operand_src_type;
        DT_offset_sign : in DT_offset_sign_type;
        p_cond         : in std_logic;
        set_cond       : in std_logic;
        operation_in   : in optype;
        operation_out  : out optype;
        PW             : out std_logic;
        iORd           : out std_logic;
        MW             : out std_logic;
        IW             : out std_logic;
        DW             : out std_logic;
        Rscrc          : out std_logic_vector(1 downto 0);;
        M2R            : out std_logic;
        RW             : out std_logic;
        AW             : out std_logic;
        BW             : out std_logic;
        Asrc1          : out std_logic;
        Asrc2          : out std_logic_vector(1 downto 0);
        Fset           : out std_logic;
        Rew            : out std_logic;
        DDPW            : out std_logic;
        XDPW            : out std_logic;
        DDP_MUX         : out std_logic
    );
end FSM;

architecture behaviour of FSM is
    type state_enum is (start, get_ab, str_or_ldr, str, ldr, rf_ldr,load_xdp,load_ddp, branch, dp, rf_dp);
    signal current_state : state_enum;
    signal next_state    : state_enum := start;
    -- Debug signal helps in debugging which state of FSM I am in currently
    signal Debug         : std_logic_vector(3 downto 0);
begin
    process (clock, next_state)
    begin
        if (rising_edge(clock)) then
            current_state <= next_state;
        end if;
    end process;

    process (current_state, reset, DP_subclass, instr_class, load_store, DP_operand_src, DT_offset_sign, p_cond, set_cond, operation_in,instruction)
    begin
        if (reset = '1') then
            next_state <= start;
        else
            PW            <= '0';
            iORd          <= '0';
            MW            <= '0';
            IW            <= '0';
            DW            <= '0';
            Rscrc         <= "00";
            M2R           <= 'X';
            RW            <= '0';
            AW            <= '0';
            BW            <= '0';
            Asrc1         <= 'X';
            Asrc2         <= "XX";
            Fset          <= '0';
            Rew           <= '0';
            DDPW          <= '0';
            XDPW          <= '0';
            DDP_MUX       <= 'X';

            operation_out <= operation_in;
            case current_state is
                when start =>
                    Debug         <= "0000";
                    next_state    <= get_ab;
                    PW            <= '1';
                    iORd          <= '0';
                    IW            <= '1';
                    Asrc1         <= '0';
                    Asrc2         <= "01";
                    operation_out <= add;
                when get_ab =>
                    Debug <= "0001";
                    if instr_class = DT then
                        next_state <= str_or_ldr;
                    elsif instr_class = BRN then
                        next_state <= branch;
                    elsif instr_class = DP then
                        if instruction(25) = '0' and instruction(4) ='1' then
                                next_state <= load_xdp;
                        else 
                                next_state <= load_ddp;
                        end if;
                    end if;
                    -- if (instr_class = DT and load_store = store) then
                    --     Rscrc <= '01';
                    -- else
                    --     Rscrc <= '00';
                    -- end if;

                    AW <= '1';
                    BW <= '1';

                when str_or_ldr =>
                    Debug <= "0010";

                    if load_store = store then
                        next_state <= str;
                    else
                        next_state <= ldr;
                    end if;

                    Asrc1 <= '1';
                    Asrc2 <= "10";
                    Rew   <= '1';

                    Rscrc <= "01";
                    BW <= '1';


                    if DT_offset_sign = plus then
                        operation_out <= add;
                    else
                        operation_out <= sub;
                    end if;

                when str =>
                    Debug      <= "0011";

                    next_state <= start;
                    iORd       <= '1';
                    MW         <= '1';
                when ldr =>
                    Debug      <= "0100";
                    next_state <= rf_ldr;
                    iORd       <= '1';
                    DW         <= '1';

                when rf_ldr =>
                    Debug      <= "0101";
                    next_state <= start;
                    M2R        <= '1';
                    RW         <= '1';

                when branch =>
                    Debug      <= "0110";
                    next_state <= start;
                    if p_cond = '1' then
                        PW <= '1';
                    else
                        PW <= '0';
                    end if;
                    Asrc1         <= '0';
                    Asrc2         <= "11";
                    operation_out <= add;

                when load_xdp =>
                    next_state <= load_ddp;
                    Rscrc <= "10";
                    XDP    <= '1';
                when load_ddp =>
                    next_state <= dp;
                    DDPW      <= '1';
                    if instruction(25) = '0' then 
                        DDP_MUX <= '1'
                    else 
                        DDP_MUX <= '0'
                    end if;
                        
                when dp =>
                    Debug      <= "0111";
                    next_state <= rf_dp;
                    Asrc1      <= '1';
                    if DP_operand_src = reg then
                        Asrc2 <= "00";
                    else
                        Asrc2 <= "10";
                    end if;

                    if set_cond = '1' then
                        Fset <= '1';
                    else
                        Fset <= '0';
                    end if;
                    if p_cond = '1' then
                        Rew           <= '1';
                    else 
                        Rew           <= '0';
                    end if;
                    operation_out <= operation_in;

                when rf_dp =>
                    Debug      <= "1000";
                    next_state <= start;
                    M2R        <= '0';
                    if DP_subclass = arith or  DP_subclass = logic then 
                        RW         <= '1';
                    else 
                        RW          <= '0';
                    end if;
                when others =>
                    next_state <= start;
            end case;
        end if;
    end process;
end behaviour;