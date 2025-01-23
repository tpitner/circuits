LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TTCPU_lib.ALL;

entity Multiplexer_74157 is
    Port (
        I0  : in  STD_LOGIC_VECTOR(3 downto 0); -- Vstupy I0a až I0d
        I1  : in  STD_LOGIC_VECTOR(3 downto 0); -- Vstupy I1a až I1d
        S   : in  STD_LOGIC;                   -- Výběrový signál
        G   : in  STD_LOGIC;                   -- Povolení výstupu (aktivní nízký)
        Y   : out STD_LOGIC_VECTOR(3 downto 0) -- Výstupy Y0 až Y3
    );
end Multiplexer_74157;

architecture Behavioral of Multiplexer_74157 is
begin
    process(I0, I1, S, G)
    begin
        if G = '1' then
            Y <= (others => 'Z'); -- Třístavový výstup (vysoká impedance)
        else
            if S = '0' then
                Y <= I0; -- Přenesení vstupu I0 na výstup
            else
                Y <= I1; -- Přenesení vstupu I1 na výstup
            end if;
        end if;
    end process;
end Behavioral;
