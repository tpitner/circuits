LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.ttcpu_lib.ALL;

ENTITY JOHNSONCOUNTER_744017 IS
    PORT (
        CP0    : IN STD_LOGIC;                     -- Clock input 0
        CP1_N  : IN STD_LOGIC;                     -- Clock input 1 (active LOW)
        MR     : IN STD_LOGIC;                     -- Master reset (active HIGH)
        Q      : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Decoded outputs Q0 to Q9
        Q5_9_N : OUT STD_LOGIC                     -- Q5-9 output (LOW for states 5-9)
    );
END ENTITY JOHNSONCOUNTER_744017;

ARCHITECTURE BEHAVIORAL OF JOHNSONCOUNTER_744017 IS
    SIGNAL state : INTEGER RANGE 0 TO 9 := 0; -- Internal state variable
BEGIN

    -- Process to handle clocking and reset
    PROCESS (CP0, CP1_N, MR) IS
    BEGIN
        -- Asynchronous Master Reset
        IF (MR = '1') THEN
            state <= 0; -- Reset state to 0
        ELSIF (rising_edge(CP0) AND CP1_N = '0') THEN
            -- Advance on CP0 rising edge when CP1_N is active (LOW)
            state <= (state + 1) MOD 10;
        ELSIF (falling_edge(CP1_N) AND CP0 = '1') THEN
            -- Advance on CP1_N falling edge when CP0 is active (HIGH)
            state <= (state + 1) MOD 10;
        END IF;

        -- Decoded outputs Q0 to Q9
        Q        <= (OTHERS => '0'); -- Initialize all outputs to LOW
        Q(state) <= '1';             -- Set the active state output to HIGH

        -- Q5-9 output
        Q5_9_N <= '0' WHEN state >= 5 ELSE
            '1';
    END PROCESS;

END ARCHITECTURE BEHAVIORAL;