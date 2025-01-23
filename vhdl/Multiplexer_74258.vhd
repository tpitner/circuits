library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity MULTIPLEXER_74258 is
  generic (
    DATA_WIDTH : natural := 4
  );
  port (
    I0         : in    std_logic_vector(DATA_WIDTH - 1 downto 0); -- Vstupy I0a až I0d
    I1         : in    std_logic_vector(DATA_WIDTH - 1 downto 0); -- Vstupy I1a až I1d
    S          : in    std_logic;                                 -- Výběrový signál
    G_N        : in    std_logic;                                 -- Povolení výstupu (aktivní nízký)
    Y          : out   std_logic_vector(DATA_WIDTH - 1 downto 0)  -- Výstupy Y0 až Y3
  );
end entity MULTIPLEXER_74258;

architecture BEHAVIORAL of MULTIPLEXER_74258 is
begin

  Y <= (others => 'Z') when G_N = '1' else
       NOT I0 when S = '0' else
       NOT I1;

end architecture BEHAVIORAL;

architecture BEHAVIORALSEQ of MULTIPLEXER_74258 is
begin

  MAIN : process (I0, I1, S, G_N) is
  begin
    if (G_N = '1') then
      Y <= (others => 'Z'); -- Třístavový výstup (vysoká impedance)
    else
      if (S = '0') then
        Y <= NOT I0;        -- Přenesení vstupu I0 na výstup
      else
        Y <= NOT I1;        -- Přenesení vstupu I1 na výstup
      end if;
    end if;
  end process MAIN;

end architecture BEHAVIORALSEQ;
