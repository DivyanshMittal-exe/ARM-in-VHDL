library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.ALL;

entity FSM IS
    port (
        reset : in std_logic := '0';
        clock : in std_logic;
		  DP_subclass : in DP_subclass_type;
        instr_class : in instr_class_type;
        load_store : in load_store_type;
        DP_operand_src : in DP_operand_src_type;
        DT_offset_sign : in DT_offset_sign_type;
        p_cond: in std_logic;
        set_cond: in std_logic;
        operation_in : in optype;
        operation_out : out optype;
        PW : out std_logic;
        iORd : out std_logic;
        MW : out std_logic;
        IW : out std_logic;
        DW : out std_logic;
        Rscrc : out std_logic;
        M2R : out std_logic;
        RW : out std_logic;
        AW : out std_logic;
        BW : out std_logic;
        Asrc1 : out std_logic;
        Asrc2 : out std_logic_vector(1 downto 0) ;
        Fset : out std_logic;
        Rew : out std_logic
    );
end FSM;

ARCHITECTURE behaviour OF FSM IS
    type type_fstate IS (start,ab,strldr,str,ldr,rf_ldr,b,dp,rf_dp);
    signal fstate : type_fstate;
    signal reg_fstate : type_fstate;
BEGin
    process (clock,reg_fstate)
    BEGin
        if (rising_edge(clock)) then
            fstate <= reg_fstate;
        end if;
    end process;
		
	 -- DP_subclass Check is reqd or not
	 
    process (fstate,reset,instr_class,load_store)
    BEGin
        if (reset='1') then
            reg_fstate <= start;
        else
            PW <= '0';
            iORd <= 'X';
            MW <= '0';
            IW <= '0';
            DW <= '0';
            Rscrc <= 'X';
            M2R <= 'X';
            RW <= '0';
            AW <= '0';
            BW <= '0';
            Asrc1 <= 'X';
            Asrc2 <= "XX";
            Fset <= '0';
            Rew <= '0';
            operation_out <= add;
            CASE fstate IS
                WHEN start =>
                    reg_fstate <= ab;
                    PW <= '1';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '1';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '0';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "01";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;
                WHEN ab =>
                    IF instr_class = DT THEN
                        reg_fstate <= strldr;
                    ELSIF instr_class = BRN THEN
                        reg_fstate <= b;
                    ELSIF instr_class = DP  THEN
                        reg_fstate <= dp;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= ab;
                    END IF;

                    PW <= '0';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    if (instr_class = DT and load_store = store) then 
                        Rscrc <= '1';
                    else 
                        Rscrc <= '0';
                    end if;
                    
                    M2R <= '0';
                    RW <= '0';
                    AW <= '1';
                    BW <= '1';
                    Asrc1 <= '0';
                    Asrc2 <= "00";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;

                WHEN strldr =>
                    IF ((load_store = store)) THEN
                        reg_fstate <= str;
                    ELSIF ((load_store = load)) THEN
                        reg_fstate <= ldr;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= strldr;
                    END IF;
                    PW <= '0';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '0';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '1';
                    if DP_operand_src = reg then
                        Asrc2 <= "00";  
                    else
                        Asrc2 <= "10";
                    end if ;
                    
                    Fset <= '0';
                    Rew <= '1';
                    if DT_offset_sign = plus then
                    operation_out <= add;
                    else 
                    operation_out <= sub;
                    end if ;

                WHEN str =>
                    reg_fstate <= start;
                    PW <= '0';
                    iORd <= '1';
                    MW <= '1';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '0';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "00";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;


                WHEN ldr =>
                    reg_fstate <= rf_ldr;
                    PW <= '0';
                    iORd <= '1';
                    MW <= '0';
                    IW <= '0';
                    DW <= '1';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '0';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "00";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;

                WHEN rf_ldr =>
                    reg_fstate <= start;
                    PW <= '0';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '1';
                    RW <= '1';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "00";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;

                WHEN b =>
                    reg_fstate <= start;
                    if p_cond = '1' then
                    PW <= '1';
                    else 
                    PW <= '0';
                    end if;
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '1';
                    RW <= '1';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "11";
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;

                    
                WHEN dp =>
                    reg_fstate <= rf_dp;
                    PW <= '0';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '0';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '1';
                    if DP_operand_src = reg then
                        Asrc2 <= "00";  
                    else
                        Asrc2 <= "10";
                    end if ;

                    if set_cond = '1' then
                        Fset <= '1';
                    else
                        Fset <= '0';
                    end if ;
                    Rew <= '1';
                    operation_out <= operation_in;

                WHEN rf_dp =>
                    reg_fstate <= start;
                    PW <= '0';
                    iORd <= '0';
                    MW <= '0';
                    IW <= '0';
                    DW <= '0';
                    Rscrc <= '0';
                    M2R <= '0';
                    RW <= '1';
                    AW <= '0';
                    BW <= '0';
                    Asrc1 <= '0';
                    Asrc2 <= "00";  
                    Fset <= '0';
                    Rew <= '0';
                    operation_out <= add;
                WHEN OTHERS => 
                    report "Reach undefined state";
            END CASE;
        end if;
    end process;
end behaviour;
