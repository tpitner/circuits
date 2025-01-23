LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.stop;
USE work.TTCPU_lib.ALL;

-- Testbench of Dual D-Type Positive-Edge-Triggered Flip-Flops With Clear and Preset
-- https://www.ti.com/product/SN74HC74

ENTITY DualDFlipFlop_7474_tb IS
END DualDFlipFlop_7474_tb;

ARCHITECTURE Behavioral OF DualDFlipFlop_7474_tb IS
    SIGNAL CLK, D1, D2, PRE1, CLR1, PRE2, CLR2 : STD_LOGIC := '1';
    SIGNAL Q1, Q1N, Q2, Q2N                    : STD_LOGIC;
    SIGNAL enable_CLK                          : BOOLEAN := TRUE;
    -- Clock periods
    CONSTANT CLK_PERIOD : TIME := 10 ns;
BEGIN
    uut : ENTITY work.DualDFlipFlop_7474
        PORT MAP(
            CLK  => CLK,
            D1   => D1,
            D2   => D2,
            PRE1 => PRE1,
            CLR1 => CLR1,
            PRE2 => PRE2,
            CLR2 => CLR2,
            Q1   => Q1,
            Q1N  => Q1N,
            Q2   => Q2,
            Q2N  => Q2N
        );

    -- Generování hodinového signálu
    -- Generator for clk_up signal
    CLK_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            IF enable_CLK THEN
                clk <= '1';
                WAIT FOR CLK_PERIOD / 2;
                clk <= '0';
                WAIT FOR CLK_PERIOD / 2;
            ELSE
                clk <= '1';
                WAIT FOR 10 ns;
            END IF;
        END LOOP;
    END PROCESS;

    -- Testovací scénář
    PROCESS
    BEGIN
        -- Nastavení vstupů
        D1 <= '0';
        D2 <= '1';
        WAIT FOR 20 ns;
        REPORT "D1=0, D2=1 => Q1=" & std_logic'image(Q1) & " Q2=" & std_logic'image(Q2);

        -- Aktivace PRE1 (nastavení na 1)
        PRE1 <= '0';
        WAIT FOR 20 ns;
        PRE1 <= '1';
        REPORT "PRE1 \/ Q1=" & std_logic'image(Q1) & " Q2=" & std_logic'image(Q2);

        -- Aktivace CLR2 (vynulování na 0)
        CLR2 <= '0';
        WAIT FOR 20 ns;
        CLR2 <= '1';
        REPORT "CLR2 \/ Q1=" & std_logic'image(Q1) & " Q2=" & std_logic'image(Q2);

        -- Změna datových vstupů
        D1 <= '1';
        D2 <= '0';
        WAIT FOR 20 ns;
        REPORT "D1=1, D2=0 => Q1=" & std_logic'image(Q1) & " Q2=" & std_logic'image(Q2);

        -- Konec simulace
        STOP;

    END PROCESS;
END Behavioral;