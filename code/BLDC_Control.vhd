library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.IR2103_Libreria.all;

-- entidad
entity BLDC_Control is
    generic(
        FPGA_CLK_50MHz: natural := 50_000_000
    );
    port(
        -- señales de sincronización
        clk:        in      std_logic;
        rst:        in      std_logic;
        -- señales del motor BLDC
        HIN_A:       out     std_logic;
        LIN_A:       out     std_logic;
        HIN_B:       out     std_logic;
        LIN_B:       out     std_logic;
        HIN_C:       out     std_logic;
        LIN_C:       out     std_logic;
        -- señales sensorless BEMF
        BEMF_A:     in      std_logic;
        BEMF_B:     in      std_logic;
        BEMF_C:     in      std_logic;
        -- velocidad del motor BLDC
        BLDC_speed: in      integer
    );
end entity;

-- arquitectura
architecture arch of BLDC_Control is

    -- maquina de estados
    type machine is (STATE_INIT,
                    STATE_SEQUENCE_1_SLEEP, STATE_SEQUENCE_1_ACTION, 
                    STATE_SEQUENCE_2_SLEEP, STATE_SEQUENCE_2_ACTION, 
                    STATE_SEQUENCE_3_SLEEP, STATE_SEQUENCE_3_ACTION, 
                    STATE_SEQUENCE_4_SLEEP, STATE_SEQUENCE_4_ACTION, 
                    STATE_SEQUENCE_5_SLEEP, STATE_SEQUENCE_5_ACTION, 
                    STATE_SEQUENCE_6_SLEEP, STATE_SEQUENCE_6_ACTION, 
                    STATE_REPOSE);
    signal state: machine := STATE_INIT;

    -- contador para los delays
    signal wait_counter: unsigned(31 downto 0) := (others => '0');

begin

    -- maquina de estados
    state_machine_process: process(clk)
    begin
        if (rising_edge(clk)) then

            case state is 

                ------------------------------------------------------------------------
                -- estado de inicio
                when STATE_INIT =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5 segundos (5000000 us) antes de iniciar
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (5_000_000))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_1_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 1 ( A+ B- )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_1_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_1_ACTION;
                    end if;

                when STATE_SEQUENCE_1_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>1); -- A+
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>0); -- B-
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>2); -- C0

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_2_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 2 ( B- C+ )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_2_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_2_ACTION;
                    end if;

                when STATE_SEQUENCE_2_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>2); -- A0
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>0); -- B-
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>1); -- C+

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_3_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 3 ( C+ A- )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_3_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_3_ACTION;
                    end if;

                when STATE_SEQUENCE_3_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>0); -- A-
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>2); -- B0
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>1); -- C+

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_4_SLEEP;
                    end if;

                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 4 ( A- B+ )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_4_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_4_ACTION;
                    end if;

                when STATE_SEQUENCE_4_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>0); -- A-
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>1); -- B+
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>2); -- C0

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_5_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 5 ( B+ C- )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_5_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_5_ACTION;
                    end if;

                when STATE_SEQUENCE_5_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>2); -- A0
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>1); -- B+
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>0); -- C-

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_6_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de la secuencia 6 ( C- A+ )
                ------------------------------------------------------------------------
                when STATE_SEQUENCE_6_SLEEP =>
                    IR2013_AllSleep(HIN_A=>HIN_A, LIN_A=>LIN_A, HIN_B=>HIN_B, LIN_B => LIN_B, HIN_C=>HIN_C, LIN_C => LIN_C);

                    -- esperar 5us del dead time
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (20))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_6_ACTION;
                    end if;

                when STATE_SEQUENCE_6_ACTION => 
                    IR2103_State_A(HIN_A=>HIN_A, LIN_A=>LIN_A, n=>1); -- A+
                    IR2103_State_B(HIN_B=>HIN_B, LIN_B=>LIN_B, n=>2); -- B0
                    IR2103_State_C(HIN_C=>HIN_C, LIN_C=>LIN_C, n=>0); -- C-

                    -- esperar un tiempo antes del siguiente estado
                    if (wait_counter < ((FPGA_CLK_50MHz / 1_000_000) * (BLDC_speed))) then
                        wait_counter <= wait_counter + 1; 
                    else
                        wait_counter <= (others => '0');
                        state <= STATE_SEQUENCE_1_SLEEP;
                    end if;
                ------------------------------------------------------------------------

                ------------------------------------------------------------------------
                -- estado de reposo
                when STATE_REPOSE =>
                    state <= STATE_INIT;
                ------------------------------------------------------------------------

            end case;
        end if;
    end process;
end architecture;