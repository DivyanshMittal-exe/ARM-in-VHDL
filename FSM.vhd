library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.all;

entity FSM is
    port (
        reset          : in std_logic := '0';
        clock          : in std_logic;
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
        Rscrc          : out std_logic;
        M2R            : out std_logic;
        RW             : out std_logic;
        AW             : out std_logic;
        BW             : out std_logic;
        Asrc1          : out std_logic;
        Asrc2          : out std_logic_vector(1 downto 0);
        Fset           : out std_logic;
        Rew            : out std_logic
    );
end FSM;

architecture behaviour of FSM is
    type type_fstate is (start, ab, strldr, str, ldr, rf_ldr, b, dp, rf_dp);
    signal fstate     : type_fstate;
    signal reg_fstate : type_fstate := start;
begin
    process (clock, reg_fstate)
    begin
        if (rising_edge(clock)) then
            fstate <= reg_fstate;
        end if;
    end process;

    -- DP_subclass Check is reqd or not

    process (fstate, reset)
    begin
        if (reset = '1') then
            reg_fstate <= start;
        else
            PW            <= '0';
            iORd          <= 'X';
            MW            <= '0';
            IW            <= '0';
            DW            <= '0';
            Rscrc         <= 'X';
            M2R           <= 'X';
            RW            <= '0';
            AW            <= '0';
            BW            <= '0';
            Asrc1         <= 'X';
            Asrc2         <= "XX";
            Fset          <= '0';
            Rew           <= '0';

            operation_out <= add;
            case fstate is
                when start =>
                    reg_fstate    <= ab;
                    PW            <= '1';
                    iORd          <= '0';
                    IW            <= '1';
                    Asrc1         <= '0';
                    Asrc2         <= "01";
                    operation_out <= add;
                when ab =>
                    if instr_class = DT then
                        reg_fstate <= strldr;
                    elsif instr_class = BRN then
                        reg_fstate <= b;
                    elsif instr_class = DP then
                        reg_fstate <= dp;
                        -- Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= ab;
                    end if;

                    if (instr_class = DT and load_store = store) then
                        Rscrc <= '1';
                    else
                        Rscrc <= '0';
                    end if;

                    AW <= '1';
                    BW <= '1';

                when strldr =>
                    if ((load_store = store)) then
                        reg_fstate <= str;
                    elsif ((load_store = load)) then
                        reg_fstate <= ldr;
                        -- Inserting 'else' block to prevent latch inference
                    else
                        reg_fstate <= strldr;
                    end if;

                    Asrc1 <= '1';
                    Asrc2 <= "10";
                    Rew   <= '1';

                    if DT_offset_sign = plus then
                        operation_out <= add;
                    else
                        operation_out <= sub;
                    end if;

                when str =>
                    reg_fstate <= start;
                    iORd       <= '1';
                    MW         <= '1';
                when ldr =>
                    reg_fstate <= rf_ldr;
                    iORd       <= '1';
                    DW         <= '1';

                when rf_ldr =>
                    reg_fstate <= start;
                    M2R        <= '1';
                    RW         <= '1';

                when b =>
                    reg_fstate <= start;
                    if p_cond = '1' then
                        PW <= '1';
                    else
                        PW <= '0';
                    end if;

                    Asrc1         <= '0';
                    Asrc2         <= "11";
                    operation_out <= add;
                when dp =>
                    reg_fstate <= rf_dp;
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
                    Rew           <= '1';
                    operation_out <= operation_in;

                when rf_dp =>
                    reg_fstate <= start;
                    M2R        <= '0';
                    RW         <= '1';
                when others =>
                    report "Reach undefined state";
            end case;
        end if;
    end process;
end behaviour;
