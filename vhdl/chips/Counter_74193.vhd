LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TTCPU_lib.ALL;

ENTITY counter_74193 IS
    PORT (
        clk_up   : IN STD_LOGIC := '1';              -- Hodinový signál pro čítání nahoru
        clk_down : IN STD_LOGIC := '1';              -- Hodinový signál pro čítání dolů
        clr      : IN STD_LOGIC := '0';              -- Asynchronní resetovací signál
        ld       : IN STD_LOGIC := '1';              -- Paralelní načítání (aktivní na logické '0')
        d        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Datové vstupy
        q        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Výstup čítače
        rco      : OUT STD_LOGIC := '1';             -- Ripple Carry Out (přetečení nahoru, active-low)
        rbo      : OUT STD_LOGIC := '1'              -- Ripple Borrow Out (přetečení dolů, active-low)
    );
END ENTITY counter_74193;

ARCHITECTURE behavior OF counter_74193 IS
    SIGNAL counter : unsigned(3 DOWNTO 0) := (OTHERS => '0'); -- Vnitřní čítač
    SIGNAL rco_reg : STD_LOGIC            := '1';             -- Interní registr pro RCO
    SIGNAL rbo_reg : STD_LOGIC            := '1';             -- Interní registr pro RBO
BEGIN
    -- Proces pro řízení čítače
    PROCESS (clk_up, clk_down, clr, ld)
    BEGIN
        -- Asynchronní reset (CLR)
        IF clr = '1' THEN
            counter <= (OTHERS => '0');
            rco_reg <= '1';
            rbo_reg <= '1';

            -- Paralelní načtení hodnoty (LD má přednost před čítáním)
        ELSIF ld = '0' THEN
            counter <= unsigned(d);
            rco_reg <= '1';
            rbo_reg <= '1';

            -- Čítání nahoru (CLK_UP)
        ELSIF rising_edge(clk_up) THEN
            rco_reg <= '1';
            rbo_reg <= '1';

            IF counter = 15 THEN
                counter <= (OTHERS => '0'); -- Přetečení nahoru (z 1111 na 0000)
            ELSE
                counter <= counter + 1;
            END IF;

            -- Čítání dolů (CLK_DOWN)
        ELSIF rising_edge(clk_down) THEN
            rco_reg <= '1';
            rbo_reg <= '1';

            IF counter = 0 THEN
                counter <= "1111"; -- Přetečení dolů (z 0000 na 1111)
            ELSE
                counter <= counter - 1;
            END IF;
        END IF;
    END PROCESS;

    -- Proces pro aktualizaci RCO a RBO při sestupné hraně hodin
    PROCESS (clk_up, clk_down)
    BEGIN
        IF falling_edge(clk_up) THEN
            rco_reg <= '0' WHEN counter = 15 ELSE
                '1';
        END IF;

        IF falling_edge(clk_down) THEN
            rbo_reg <= '0' WHEN counter = 0 ELSE
                '1';
        END IF;
    END PROCESS;

    -- Výstupy
    q   <= STD_LOGIC_VECTOR(counter); -- Výstup čítače
    rco <= rco_reg;                   -- Ripple Carry Out (active-low: 0 při přetečení nahoru)
    rbo <= rbo_reg;                   -- Ripple Borrow Out (active-low: 0 při přetečení dolů)
END ARCHITECTURE behavior;