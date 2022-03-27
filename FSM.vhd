library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;


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
        iORd           : out std_logic_vector(1 DOWNTO 0);
        MW             : out std_logic_vector(3 downto 0);
        IW             : out std_logic;
        DW             : out std_logic_vector(3 downto 0);
        Rscrc          : out std_logic_vector(1 downto 0);
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
        signDT          : out std_logic;
        wadMux          : out std_logic;
        AMUX          : out std_logic
    );
end FSM;

architecture behaviour of FSM is
    type state_enum is (start, get_ab, str_or_ldr, str, ldr, rf_ldr,load_xdp,load_ddp, branch, dp, rf_dp,mulmuliplynow,mulmode,muliplynow2);
    signal current_state : state_enum;
    signal next_state    : state_enum := start;
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
            iORd          <= "00";
            MW            <= "0000";
            IW            <= '0';
            DW            <=  "0000";
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
            signDT        <= 'X';
            wadMux        <= '0';
            AMUX          <= '0';
            -- DDP_MUX       <= 'X';

            operation_out <= operation_in;
            case current_state is
                when start =>
                    
                    next_state    <= get_ab;
                    PW            <= '1';
                    iORd          <= "00";
                    IW            <= '1';
                    Asrc1         <= '0';
                    Asrc2         <= "01";
                    operation_out <= add;
                when get_ab =>
                    
                    if instr_class = DT then
                        if instruction(25) = '1' and instruction(4) ='0' then 
                            next_state <= load_ddp;
                        else
                            next_state <= str_or_ldr;
                        end if;
                    elsif instr_class = BRN then
                        next_state <= branch;
                    elsif instr_class = DP then
                        if instruction(25) = '0' and instruction(4) ='1' then
                            next_state <= load_xdp;
                        elsif instruction(25) = '0' and instruction(4) ='0' then 
                            next_state <= load_ddp;
                        else
                            next_state <= dp;    
                        end if;
                    elsif instr_class = DTHR then
                        next_state <= load_ddp;
                    elsif instr_class = DTHI then 
                        next_state <= str_or_ldr;
                    elsif instr_class = MUL or  instr_class = MLA or  instr_class = SMULL or  instr_class = SMLAL or  instr_class = UMULL or  instr_class = UMLAL then
                        next_state <= mulmode;
                    end if;


                    AW <= '1';
                    BW <= '1';

                when str_or_ldr =>
                    if load_store = store then
                        next_state <= str;
                    else
                        next_state <= ldr;
                    end if;

                    Asrc1 <= '1';
                    if instr_class = DT and instruction(25) = '0' then
                        Asrc2 <= "10";
                    elsif instr_class = DT and instruction(25) = '1' then 
                        Asrc2 <= "00";
                    elsif instr_class = DTHR then
                        Asrc2 <= "00";
                    elsif instr_class = DTHI then 
                        Asrc2 <= "10";
                         
                    end if;
                    Rew   <= '1';

                    Rscrc <= "01";
                    BW <= '1';


                    if DT_offset_sign = plus then
                        operation_out <= add;
                    else
                        operation_out <= sub;
                    end if;

                when str =>
                    next_state <= start;

                    if instruction(24) = '1' then
                        iORd       <= "01";
                    else
                        iORd       <= "10";   
                    end if;

                    if instruction(21) = '1'  or instruction(24) = '0' then
                        RW <= '1';
                        wadMux        <= '1';
                        M2R <= '0';
                    end if;
                    
                    if instr_class = DT and instruction(22) = '0' then
                        MW         <= "1111";
                        signDT     <=  '0';
                    elsif instr_class = DT and instruction(22) = '1' then
                        MW         <= "0001";
                        signDT     <=  '0';
                    elsif instr_class = DTHR or instr_class = DTHI then
                        if instruction(6 downto 5) = "01" then 
                            MW         <= "0011";
                            signDT     <=  '0';
                        elsif instruction(6 downto 5) = "10" then
                            MW         <= "0001";
                            signDT     <=  '1'; 
                        elsif instruction(6 downto 5) = "11" then 
                            MW         <= "0011";
                            signDT     <=  '1';
                        end if;
                    end if; 

                when ldr =>
                    
                    next_state <= rf_ldr;
                    
                    if instruction(24) = '1' then
                        iORd       <= "01";
                    else
                        iORd       <= "10";   
                    end if;

                    if instruction(21) = '1'  or instruction(24) = '0' then
                        RW <= '1';
                        wadMux        <= '1';
                        M2R <= '0';
                    end if;
                    
                    
                    if instr_class = DT and instruction(22) = '0' then
                        DW         <= "1111";
                        signDT     <=  '0';
                    elsif instr_class = DT and instruction(22) = '1' then
                        DW         <= "0001";
                        signDT     <=  '0';
                    elsif instr_class = DTHR or instr_class = DTHI then
                        if instruction(6 downto 5) = "01" then 
                            DW         <= "0011";
                            signDT     <=  '0';
                        elsif instruction(6 downto 5) = "10" then
                            DW         <= "0001";
                            signDT     <=  '1'; 
                        elsif instruction(6 downto 5) = "11" then 
                            DW         <= "0011";
                            signDT     <=  '1';
                        end if;
                    end if; 

                when rf_ldr =>
                    
                    next_state <= start;
                    M2R        <= '1';
                    RW         <= '1';

                when branch =>
                    
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
                    XDPW    <= '1';
                when load_ddp =>
                    if instr_class = DT or instr_class = DTHR or instr_class = DTHI  then
                        next_state <= str_or_ldr;
                    else
                        next_state <= dp;
                    end if;

                    DDPW      <= '1';
                        
                when dp =>
                    
                    next_state <= rf_dp;
                    Asrc1      <= '1';
                    if DP_operand_src = reg then
                        Asrc2 <= "00";
                    else
                        Asrc2 <= "10";
                    end if;

                    if set_cond = '1' then
                        Fset <= '1';
                    elsif DP_subclass = comp or DP_subclass = test then
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
                    
                    next_state <= start;
                    M2R        <= '0';
                    if DP_subclass = arith or  DP_subclass = logic then 
                        RW         <= '1';
                    else 
                        RW          <= '0';
                    end if;
                
                    when mulmode => 
                        next_state => muliplynow
                        AMUX  <= '1';
                        Rscrc <= "01";
                        DDPW  <= '1';
                        XDPW  <= '1';
                    when muliplynow => 
                     if instr_class = MUL or  instr_class = MLA then
                        next_state <= start;         
                    elsif instr_class = SMULL or  instr_class = SMLAL or  instr_class = UMULL or  instr_class = UMLAL then
                        next_state <= muliplynow2;
                     end if;      
                        wadMux <= '1';
                        RW <= '1';     
                     when muliplynow2 =>    
                        next_state <= start;         
                        wadMux <= '0';
                        RW <= '1';
                when others =>
                    next_state <= start;
            end case;
        end if;
    end process;
end behaviour;