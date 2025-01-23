LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY SRAM_2148_tb IS
    -- Testbench nemá žádné porty
END ENTITY SRAM_2148_tb;

ARCHITECTURE testbench OF SRAM_2148_tb IS
    -- Signály pro propojení s testovanou jednotkou
    SIGNAL ADDRESS  : unsigned(9 DOWNTO 0)         := (OTHERS => '0');
    SIGNAL DATA     : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => 'Z'); -- Sdílená datová sběrnice
    SIGNAL WE_N     : STD_LOGIC                    := '1';             -- Write Enable (aktivní v 0)
    SIGNAL CS_N     : STD_LOGIC                    := '1';             -- Chip Select (aktivní v 0)
    SIGNAL data_in  : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); -- Vstupní data
    SIGNAL data_out : STD_LOGIC_VECTOR(3 DOWNTO 0);                    -- Výstupní data
    SIGNAL data_dir : STD_LOGIC := '0';                                -- Řídí směr sběrnice: '0' = vstup, '1' = výstup

BEGIN

    -- Instance testované jednotky
    UUT : ENTITY work.SRAM_2148
        PORT MAP(
            ADDRESS => ADDRESS,
            DATA    => DATA,
            WE_N    => WE_N,
            CS_N    => CS_N
        );

    -- Simulace směru sběrnice
    DATA <= data_in WHEN data_dir = '0' ELSE
        (OTHERS => 'Z'); -- Vstupní data
    data_out <= DATA WHEN data_dir = '1' ELSE
        (OTHERS => 'Z'); -- Výstupní data

    -- Testovací proces
    PROCESS
    BEGIN
        -- Reset
        CS_N    <= '1';
        WE_N    <= '1';
        ADDRESS <= (OTHERS => '0');
        WAIT FOR 10 ns;

        -- Test zápisu na adresu 0x01
        CS_N     <= '0';
        WE_N     <= '0';
        ADDRESS  <= "0000000001"; -- Adresa 1
        data_in  <= "1100";       -- Data pro zápis
        data_dir <= '0';          -- Přepnutí sběrnice na vstup
        WAIT FOR 0 ns;
        data_dir <= '1'; -- Přepnutí sběrnice na výstup
        WE_N     <= '1'; -- Deaktivace zápisu

        -- Test čtení z adresy 0x01
        WAIT FOR 1 ns;

        -- Kontrola výsledků
        ASSERT data = "1100"
        REPORT "Cteni selhalo na adrese 0x01: DATA_OUT = " & TO_STRING(data_out)
            SEVERITY ERROR;

        -- Test zápisu na adresu 0x02
        CS_N     <= '0';
        WE_N     <= '0';
        ADDRESS  <= "0000000010"; -- Adresa 2
        data_in  <= "1011";       -- Data pro zápis
        data_dir <= '0';
        WAIT FOR 20 ns;
        data_dir <= '1';
        WE_N     <= '1';

        -- Test čtení z adresy 0x02
        WAIT FOR 1 ns;

        -- Kontrola výsledků
        ASSERT data = "1011"
        REPORT "Cteni selhalo na adrese 0x02: DATA_OUT = " & TO_STRING(data_out)
            SEVERITY ERROR;

        -- Test čtení z adresy 0x01
        ADDRESS <= "0000000001";
        WAIT FOR 1 ns;

        -- Kontrola výsledků
        ASSERT data = "1100"
        REPORT "Cteni selhalo na adrese 0x01: DATA_OUT = " & TO_STRING(data_out)
            SEVERITY ERROR;

        -- Konec simulace
        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;