LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TTCPU_lib.ALL;

ENTITY Demultiplexer_74138 IS
    PORT (
        ABC          : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Výběrový signál
        G1           : IN STD_LOGIC;                    -- Povolení výstupu (aktivní H)
        G2A_N, G2B_N : IN STD_LOGIC;                    -- Povolení výstupu (aktivní L)
        Y            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Výstupy Y0 až Y7
    );
END Demultiplexer_74138;

ARCHITECTURE Behavioral OF Demultiplexer_74138 IS
BEGIN
    main : PROCESS (ALL)
    BEGIN
        IF G1 = '1' AND (G2A_N = '0' AND G2B_N = '0') THEN
            WITH ABC SELECT
                Y <= "11111110" WHEN "000",
                "11111101" WHEN "001",
                "11111011" WHEN "010",
                "11110111" WHEN "011",
                "11101111" WHEN "100",
                "11011111" WHEN "101",
                "10111111" WHEN "110",
                "01111111" WHEN "111",
                "11111111" WHEN OTHERS;
        ELSE
            Y <= "11111111";
        END IF;
    END PROCESS;
END Behavioral;