library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- prototipos de funciuones
package IR2103_Libreria is

    -- Activar transitores HS o LS del IR2103_A
    procedure IR2103_State_A(
        signal HIN_A, LIN_A: out std_logic;
        n : natural
    );

    -- Activar transitores HS o LS del IR2103_B
    procedure IR2103_State_B(
        signal HIN_B, LIN_B: out std_logic;
        n : natural
    );

    -- Activar transitores HS o LS del IR2103_C
    procedure IR2103_State_C(
        signal HIN_C, LIN_C: out std_logic;
        n : natural
    );

    -- Desactivar todos los transitores
    procedure IR2013_AllSleep(
        signal HIN_A, LIN_A, HIN_B, LIN_B, HIN_C, LIN_C: out std_logic
    );

end package;

-- desarrollo de funciones
package body IR2103_Libreria is

    ------------------------------------------------------------------------
    -- Activar transitores HS o LS del IR2103_A
    procedure IR2103_State_A(
        signal HIN_A, LIN_A: out std_logic;
        n : natural
    ) is

    begin

        -- activar LOW SIDE
        if (n = 0) then
            HIN_A <= '0';
            LIN_A <= '0';

        -- activar HIGH SIDE
        elsif (n = 1) then
            HIN_A <= '1';
            LIN_A <= '1';
        
        -- desactivar transistores
        else
            HIN_A <= '1';
            LIN_A <= '0';

        end if;

    end procedure;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Activar transitores HS o LS del IR2103_B
    procedure IR2103_State_B(
        signal HIN_B, LIN_B: out std_logic;
        n : natural
    ) is

    begin

        -- activar LOW SIDE
        if (n = 0) then
            HIN_B <= '0';
            LIN_B <= '0';

        -- activar HIGH SIDE
        elsif (n = 1) then
            HIN_B <= '1';
            LIN_B <= '1';
        
        -- desactivar transistores
        else
            HIN_B <= '1';
            LIN_B <= '0';

        end if;

    end procedure;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Activar transitores HS o LS del IR2103_C
    procedure IR2103_State_C(
        signal HIN_C, LIN_C: out std_logic;
        n : natural
    ) is

    begin

        -- activar LOW SIDE
        if (n = 0) then
            HIN_C <= '0';
            LIN_C <= '0';

        -- activar HIGH SIDE
        elsif (n = 1) then
            HIN_C <= '1';
            LIN_C <= '1';
        
        -- desactivar transistores
        else
            HIN_C <= '1';
            LIN_C <= '0';

        end if;

    end procedure;
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- Desactivar todos los transitores
    procedure IR2013_AllSleep(
        signal HIN_A, LIN_A, HIN_B, LIN_B, HIN_C, LIN_C: out std_logic
    ) is

    begin

        -- desactivar transistores A
        HIN_A <= '1';
        LIN_A <= '0';

        -- desactivar transistores B
        HIN_B <= '1';
        LIN_B <= '0';

        -- desactivar transistores C
        HIN_C <= '1';
        LIN_C <= '0';

    end procedure;
    ------------------------------------------------------------------------

end package body;