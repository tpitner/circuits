LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.stop;
USE work.Counter_74193;
USE work.TTCPU_lib.ALL;

ENTITY Counter_74193_tb IS
    -- Testbench has no ports
END ENTITY Counter_74193_tb;

ARCHITECTURE behavior OF Counter_74193_tb IS

    -- Signals for connecting to the tested counter
    SIGNAL clk_up          : STD_LOGIC                    := '1';
    SIGNAL clk_down        : STD_LOGIC                    := '1';
    SIGNAL clr             : STD_LOGIC                    := '0';
    SIGNAL ld              : STD_LOGIC                    := '1';
    SIGNAL d               : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q               : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL rco             : STD_LOGIC := '1';
    SIGNAL rbo             : STD_LOGIC := '1';
    SIGNAL enable_clk_up   : BOOLEAN   := FALSE; -- Signal to enable clk_up
    SIGNAL enable_clk_down : BOOLEAN   := FALSE; -- Signal to enable clk_down

    -- Clock periods
    CONSTANT CLK_PERIOD_UP   : TIME := 20 ns;
    CONSTANT CLK_PERIOD_DOWN : TIME := 25 ns;

BEGIN

    -- Instance of the tested counter
    uut : ENTITY work.Counter_74193
        PORT MAP(
            clk_up   => clk_up,
            clk_down => clk_down,
            clr      => clr,
            ld       => ld,
            d        => d,
            q        => q,
            rco      => rco,
            rbo      => rbo
        );

    -- Generator for clk_up signal
    clk_up_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            IF enable_clk_up THEN
                clk_up <= '1';
                WAIT FOR CLK_PERIOD_UP / 2;
                clk_up <= '0';
                WAIT FOR CLK_PERIOD_UP / 2;
            ELSE
                clk_up <= '1';
                WAIT FOR 10 ns;
            END IF;
        END LOOP;
    END PROCESS;

    -- Generator for clk_down signal
    clk_down_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            IF enable_clk_down THEN
                clk_down <= '1';
                WAIT FOR CLK_PERIOD_DOWN / 2;
                clk_down <= '0';
                WAIT FOR CLK_PERIOD_DOWN / 2;
            ELSE
                clk_down <= '1';
                WAIT FOR 10 ns;
            END IF;
        END LOOP;
    END PROCESS;

    -- Test process
    stimulus : PROCESS
    BEGIN
        -- Counter reset
        REPORT "Starting counter reset.";
        clr <= '1';
        WAIT FOR 20 ns;
        clr <= '0';
        REPORT "Reset complete. Current value of q: " & to_string(q);

        -- Loading value with ld = '0'
        REPORT "Loading value: " & to_string(d) & " with ld = '0'.";
        ld <= '0';
        d  <= "1010"; -- Set value on input d
        WAIT FOR 20 ns;
        ld <= '1'; -- Deactivate ld
        REPORT "Loading complete. Current value of q: " & to_string(q);

        -- Testing count up
        REPORT "Starting count up test.";
        enable_clk_up <= TRUE;
        WAIT FOR 100 ns;
        enable_clk_up <= FALSE;
        REPORT "Count up test complete. Current value of q: " & to_string(q);

        -- Testing overflow (rco)
        REPORT "Starting overflow (rco) test.";
        d <= "1111"; -- Load maximum value
        WAIT FOR 1 ns;
        ld <= '0';
        WAIT FOR 20 ns;
        ld            <= '1';
        enable_clk_up <= TRUE;      -- Enable counting up
        WAIT FOR CLK_PERIOD_UP * 2; -- Wait for overflow
        enable_clk_up <= FALSE;
        REPORT "Overflow test complete. rco: " & STD_LOGIC'image(rco) & ", current value of q: " & to_string(q);

        -- Testing count down
        REPORT "Starting count down test.";
        enable_clk_down <= TRUE;
        WAIT FOR 100 ns;
        enable_clk_down <= FALSE;
        REPORT "Count down test complete. Current value of q: " & to_string(q);

        -- Testing underflow (rbo)
        REPORT "Starting underflow (rbo) test.";
        ld <= '0';
        d  <= "0000"; -- Load minimum value
        WAIT FOR 20 ns;
        ld              <= '1';
        enable_clk_down <= TRUE;      -- Enable counting down
        WAIT FOR CLK_PERIOD_DOWN * 2; -- Wait for underflow
        enable_clk_down <= FALSE;
        REPORT "Underflow test complete. rbo: " & STD_LOGIC'image(rbo) & ", current value of q: " & to_string(q);

        -- Loading another value and testing combinations
        REPORT "Loading another value with ld = '0'.";
        d  <= "0110";
        ld <= '0';
        WAIT FOR 20 ns;
        ld <= '1';
        REPORT "Loading " & to_string(d) & " complete. Now q: " & to_string(q);

        -- Stopping clock signals
        REPORT "Simulation complete.";
        WAIT FOR 50 ns;

        -- Ukončení simulace
        STOP;

    END PROCESS;

END ARCHITECTURE behavior;