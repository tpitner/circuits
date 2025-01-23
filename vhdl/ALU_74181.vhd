LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_74181 IS
    PORT (
        -- INPUTS
        -- active-high inputs and outputs
        -- A, B: 4-bit inputs
        A : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        -- S: 4-bit function selector
        S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        -- M: mode (H=logic, L=arithmetic)
        M : IN STD_LOGIC;
        -- carry in, active-low
        C_IN_N : IN STD_LOGIC;

        -- OUTPUTS
        -- equivalence: active-high if A = B
        A_B : OUT STD_LOGIC;
        -- carry propagate, active-low
        X : OUT STD_LOGIC;
        -- carry generator, active-low
        Y : OUT STD_LOGIC;
        -- carry out, active-low
        C_OUT_N4_N : OUT STD_LOGIC;
        -- active-high 4-bit outputs
        F : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF ALU_74181 IS
    CONSTANT logic_mode : STD_LOGIC := '1';
    CONSTANT arith_mode : STD_LOGIC := '0';

BEGIN
    main : PROCESS (ALL)
        VARIABLE carry_in_num : NATURAL;
        VARIABLE a_num        : unsigned(4 DOWNTO 0);
        VARIABLE b_num        : unsigned(4 DOWNTO 0);
        VARIABLE result_num   : unsigned(4 DOWNTO 0);
        VARIABLE result       : STD_LOGIC_VECTOR (4 DOWNTO 0);

        VARIABLE leftbits  : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE rightbits : STD_LOGIC_VECTOR(3 DOWNTO 0);

        VARIABLE prop : STD_LOGIC;
        VARIABLE gen  : STD_LOGIC;
        -- interpreted as A, B, F: active-high
    BEGIN
        IF M = logic_mode THEN -- logic mode (no carry, bitwise ops)
            CASE S IS
                    -- 0..7
                WHEN "0000" => F <= NOT(A); -- NOT A
                WHEN "0001" => F <= NOT(A) OR NOT(B);
                WHEN "0010" => F <= NOT(A) AND B;
                WHEN "0011" => F <= "0000";       -- 0
                WHEN "0100" => F <= NOT(A AND B); -- A NAND B
                WHEN "0101" => F <= NOT(B);       -- NOT B
                WHEN "0110" => F <= A XOR B;      -- A XOR B
                WHEN "0111" => F <= A AND NOT(B);
                    -- 8..15
                WHEN "1000" => F <= NOT(A) OR B;
                WHEN "1001" => F <= NOT(A) XOR NOT(B); -- A XOR B
                WHEN "1010" => F <= B;                 -- B
                WHEN "1011" => F <= A AND B;           -- A AND B
                WHEN "1100" => F <= "1111";            -- 1
                WHEN "1101" => F <= A OR NOT(B);
                WHEN "1110" => F <= A OR B; -- A OR B
                WHEN "1111" => F <= A;      -- A

                WHEN OTHERS => F <= "UUUU"; -- undefined
            END CASE;
        ELSE -- arithmetic mode
            a_num := unsigned("0" & A);
            b_num := unsigned("0" & B);
            CASE S IS
                    -- 0..7
                WHEN "0000" => result_num := a_num; -- A|A++ (INC A)
                WHEN "0001" => result_num := unsigned(a OR b);
                WHEN "0010" => result_num := unsigned(a OR NOT(b));
                WHEN "0011" => result_num := "11111"; -- -1|0 (constants 1111, 0000)
                WHEN "0100" => result_num := a_num + unsigned(a AND NOT(b));
                WHEN "0101" => result_num := unsigned(a OR b) + unsigned(a AND NOT(b));
                WHEN "0110" => result_num := a_num - b_num - 1; -- A-B-1|A-B (A SBC B)
                WHEN "0111" => result_num := unsigned(a AND b) - 1;
                    -- 8..15
                WHEN "1000" => result_num := a_num + unsigned(a AND b);
                WHEN "1001" => result_num := a_num + b_num; -- A+B|A+B+1 (A ADC B)
                WHEN "1010" => result_num := unsigned(a OR NOT(b)) + unsigned(a AND b);
                WHEN "1011" => result_num := unsigned(a AND b) - 1;
                WHEN "1100" => result_num := a_num + a_num; -- A+A|A+A+1 (SHL A)
                WHEN "1101" => result_num := unsigned(a OR b) + a_num;
                WHEN "1110" => result_num := unsigned(a OR NOT(b)) + a_num;
                WHEN "1111" => result_num := a_num - 1; -- A--|A (DEC A)

                WHEN OTHERS => result_num := "00000"; -- undefined
            END CASE;

            carry_in_num := 0 WHEN C_IN_N = '1' ELSE
                1;
            result := STD_LOGIC_VECTOR(result_num + carry_in_num);
            F <= result(3 DOWNTO 0);

            -- Výpočet jednotlivých bitů L a R
            FOR i IN 0 TO 3 LOOP
                leftbits(i)  := NOT(a(i) OR (b(i) AND S(0)) OR (NOT(b(i)) AND S(1)));
                rightbits(i) := NOT((NOT(b(i)) AND S(2) AND a(i)) OR (a(i) AND b(i) AND S(3)));
            END LOOP;

            -- Propagate (~P, X)
            prop := rightbits(3) AND rightbits(2) AND rightbits(1) AND rightbits(0);
            X <= NOT(prop);

            -- Generate (~G, Y)
            gen := (leftbits(0) AND rightbits(1) AND rightbits(2) AND rightbits(3))
                OR (leftbits(1) AND rightbits(2) AND rightbits(3))
                OR (leftbits(2) AND rightbits(3))
                OR (leftbits(3));
            Y <= NOT(gen);

            C_OUT_N4_N <= (prop AND C_IN_N) OR gen;

            A_B <= '1' WHEN result(3 DOWNTO 0) = "1111" ELSE
                '0';
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;