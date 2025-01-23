LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TTCPU_lib.ALL;

-- Dual D-Type Positive-Edge-Triggered Flip-Flops With Clear and Preset
-- https://www.ti.com/product/SN74HC74

ENTITY DualDFlipFlop_7474 IS
    PORT (
        CLK  : IN STD_LOGIC;  -- Hodinový signál (společný pro oba klopné obvody)
        D1   : IN STD_LOGIC;  -- Data vstup pro první klopný obvod
        D2   : IN STD_LOGIC;  -- Data vstup pro druhý klopný obvod
        PRE1 : IN STD_LOGIC;  -- Preset pro první klopný obvod (aktivní LOW)
        CLR1 : IN STD_LOGIC;  -- Clear pro první klopný obvod (aktivní LOW)
        PRE2 : IN STD_LOGIC;  -- Preset pro druhý klopný obvod (aktivní LOW)
        CLR2 : IN STD_LOGIC;  -- Clear pro druhý klopný obvod (aktivní LOW)
        Q1   : OUT STD_LOGIC; -- Výstup Q pro první klopný obvod
        Q1N  : OUT STD_LOGIC; -- Inverzní výstup Q' pro první klopný obvod
        Q2   : OUT STD_LOGIC; -- Výstup Q pro druhý klopný obvod
        Q2N  : OUT STD_LOGIC  -- Inverzní výstup Q' pro druhý klopný obvod
    );
END DualDFlipFlop_7474;

ARCHITECTURE Behavioral OF DualDFlipFlop_7474 IS
    SIGNAL q1_int, q2_int : STD_LOGIC := '0'; -- Interní signály pro ukládání stavu klopných obvodů
BEGIN
    -- První D-klopný obvod
    PROCESS (CLK, PRE1, CLR1)
    BEGIN
        IF CLR1 = '0' THEN -- Clear má nejvyšší prioritu (aktivní LOW)
            q1_int <= '0';
        ELSIF PRE1 = '0' THEN -- Preset má druhou nejvyšší prioritu (aktivní LOW)
            q1_int <= '1';
        ELSIF rising_edge(CLK) THEN -- Při náběžné hraně hodinového signálu
            q1_int <= D1;               -- Na výstup se přenese hodnota D1
        END IF;
    END PROCESS;

    Q1  <= q1_int;     -- Výstup Q
    Q1N <= NOT q1_int; -- Inverzní výstup Q'

    -- Druhý D-klopný obvod
    PROCESS (CLK, PRE2, CLR2)
    BEGIN
        IF CLR2 = '0' THEN -- Clear má nejvyšší prioritu (aktivní LOW)
            q2_int <= '0';
        ELSIF PRE2 = '0' THEN -- Preset má druhou nejvyšší prioritu (aktivní LOW)
            q2_int <= '1';
        ELSIF rising_edge(CLK) THEN -- Při náběžné hraně hodinového signálu
            q2_int <= D2;               -- Na výstup se přenese hodnota D2
        END IF;
    END PROCESS;

    Q2  <= q2_int;     -- Výstup Q
    Q2N <= NOT q2_int; -- Inverzní výstup Q'
END Behavioral;