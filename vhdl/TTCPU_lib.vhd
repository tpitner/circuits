LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE TTCPU_lib IS
    SUBTYPE BIT IS STD_LOGIC;
    SUBTYPE nibble IS STD_LOGIC_VECTOR (3 DOWNTO 0);
    SUBTYPE byte IS STD_LOGIC_VECTOR (7 DOWNTO 0);
    SUBTYPE word IS STD_LOGIC_VECTOR (15 DOWNTO 0);
    SUBTYPE address10 IS UNSIGNED (9 DOWNTO 0);
    FUNCTION to_string (a    : STD_LOGIC_VECTOR) RETURN STRING;
    FUNCTION to_string2 (slv : STD_LOGIC_VECTOR) RETURN STRING;
END PACKAGE TTCPU_lib;

PACKAGE BODY TTCPU_lib IS
    -- Funkce to_string pro převod std_logic_vector na string
    FUNCTION to_string2(slv : STD_LOGIC_VECTOR) RETURN STRING IS
        VARIABLE result         : STRING(1 TO slv'length) := (OTHERS => NUL);
        VARIABLE stri           : INTEGER                 := 1;
    BEGIN
        FOR i IN slv'RANGE LOOP
            CASE slv(i) IS
                WHEN '0'    => result(stri)    := '0';
                WHEN '1'    => result(stri)    := '1';
                WHEN 'Z'    => result(stri)    := 'Z';
                WHEN 'X'    => result(stri)    := 'X';
                WHEN '-'    => result(stri)    := '-';
                WHEN OTHERS => result(stri) := '?'; -- Neznámý stav
            END CASE;
            stri := stri + 1;
        END LOOP;
        RETURN result;
    END FUNCTION;

    FUNCTION to_string (a : STD_LOGIC_VECTOR) RETURN STRING IS
        VARIABLE b            : STRING (1 TO a'length) := (OTHERS => NUL);
        VARIABLE stri         : INTEGER                := 1;
    BEGIN
        FOR i IN a'RANGE LOOP
            b(stri) := STD_LOGIC'image(a((i)))(2);
            stri    := stri + 1;
        END LOOP;
        RETURN b;
    END FUNCTION;
END PACKAGE BODY;
