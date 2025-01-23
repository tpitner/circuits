LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.stop;
USE work.TTCPU_lib.ALL;

entity Multiplexer_74157_tb is
end Multiplexer_74157_tb;

architecture Behavioral of Multiplexer_74157_tb is
    signal I0, I1 : STD_LOGIC_VECTOR(3 downto 0);
    signal S, G   : STD_LOGIC;
    signal Y      : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Instance multiplexeru
    uut: entity work.Multiplexer_74157
        port map (
            I0 => I0,
            I1 => I1,
            S  => S,
            G  => G,
            Y  => Y
        );

    -- Testovací proces
    stim_proc: process
    begin
        -- Test 1: Výstupy odpojeny (G = '1')
        I0 <= "0001"; I1 <= "1010"; S <= '0'; G <= '1';
        wait for 10 ns;
        REPORT "G = '1' => Y = " & to_string(Y);

        -- Test 2: I0 na výstupu (G = '0', S = '0')
        G <= '0'; S <= '0';
        wait for 10 ns;

        -- Test 3: I1 na výstupu (G = '0', S = '1')
        S <= '1';
        wait for 10 ns;

        -- Test 4: Změna vstupů
        I0 <= "1111"; I1 <= "0000"; S <= '0';
        wait for 10 ns;

        -- Ukončení simulace
        STOP;
        
    end process;
end Behavioral;
