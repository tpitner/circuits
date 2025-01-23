LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY SRAM_2148 IS
    PORT (
        ADDRESS    : IN unsigned(9 DOWNTO 0);
        DATA       : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        WE_N, CS_N : IN STD_LOGIC);
END ENTITY SRAM_2148;

ARCHITECTURE simple_ram OF SRAM_2148 IS
    TYPE ram_type IS ARRAY (0 TO 2 ** 10 - 1) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ram1 : ram_type := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS
    BEGIN
        DATA <= (OTHERS => 'Z'); -- chip is not selected
        IF (CS_N = '0') THEN
            IF rising_edge(WE_N) THEN -- write
                ram1(conv_integer(ADDRESS'delayed)) <= DATA;
                WAIT FOR 0 ns;
            END IF;
            IF WE_N = '1' THEN -- read
                DATA <= ram1(conv_integer(ADDRESS));
            ELSE
                DATA <= (OTHERS => 'Z');
            END IF;
        END IF;
        WAIT ON CS_N, WE_N, ADDRESS;
    END PROCESS;
END simple_ram;