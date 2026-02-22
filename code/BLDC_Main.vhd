library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entidad
entity BLDC_Main is
    generic(
        FPGA_CLK:   natural := 100000000
    );
    port(
        -- señales de sincronización
        clk:        in      std_logic;
        rst:        in      std_logic;
        -- señales del motor BLDC
        HIN_A:      out     std_logic;
        LIN_A:      out     std_logic;
        HIN_B:      out     std_logic;
        LIN_B:      out     std_logic;
        HIN_C:      out     std_logic;
        LIN_C:      out     std_logic;
        -- señales sensorless BEMF
        BEMF_A:     in      std_logic;
        BEMF_B:     in      std_logic;
        BEMF_C:     in      std_logic
    );
end entity;

-- arquitectura
architecture arch of BLDC_Main is

    ------------------------------------------------------------------------
    -- Componente: BLDC_Control 
    ------------------------------------------------------------------------
    component BLDC_Control
    port(
        -- señales de sincronización
        clk:        in      std_logic;
        rst:        in      std_logic;
        -- señales del motor BLDC
        HIN_A:      out     std_logic;
        LIN_A:      out     std_logic;
        HIN_B:      out     std_logic;
        LIN_B:      out     std_logic;
        HIN_C:      out     std_logic;
        LIN_C:      out     std_logic;
        -- señales sensorless BEMF
        BEMF_A:     in      std_logic;
        BEMF_B:     in      std_logic;
        BEMF_C:     in      std_logic;
        -- velocidad del motor BLDC
        BLDC_speed: in      integer
    );
    end component;
    for all: BLDC_Control
    use entity work.BLDC_Control(arch);
    ------------------------------------------------------------------------

    -- señal de reloj dividida
    signal div_clock: std_logic := '0';

    -- señal de control del motor -- min 2500 -- max 4500
    signal speed_ctrl: integer := 4_500;

begin

    ------------------------------------------------------------------------
    -- Proceso: Divir el reloj de entrada de 100MHz a 50MHz
    div_clock_process: process(clk)
    begin
        if (rising_edge(clk)) then
            div_clock <= not div_clock;
        end if;
    end process;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Componente: BLDC_Control -- union de señales
    ------------------------------------------------------------------------
    BLDC_Control_mot1: BLDC_Control
    port map(
        -- señales de sincronización
        clk => div_clock,
        rst => rst,
        -- señales del motor BLDC
        HIN_A => HIN_A,
        LIN_A => LIN_A,
        HIN_B => HIN_B,
        LIN_B => LIN_B,
        HIN_C => HIN_C,
        LIN_C => LIN_C,
        -- señales sensorless BEMF
        BEMF_A => BEMF_A,
        BEMF_B => BEMF_B,
        BEMF_C => BEMF_C,
        -- velocidad del motor BLDC
        BLDC_speed => speed_ctrl
    );
    ------------------------------------------------------------------------    

end architecture;