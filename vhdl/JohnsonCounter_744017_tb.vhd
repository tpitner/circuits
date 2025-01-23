library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.env.stop;
  use work.johnsoncounter_744017;
  use work.ttcpu_lib.all;

entity JOHNSONCOUNTER_744017_TB is
-- Testbench has no ports
end entity JOHNSONCOUNTER_744017_TB;

architecture BEHAVIOR of JOHNSONCOUNTER_744017_TB is
  signal cp0            : std_logic := '0';
  signal cp1_n          : std_logic := '0';
  signal mr             : std_logic := '0';
  signal q              : std_logic_vector(9 downto 0);
  signal q5_9_n         : std_logic;
begin

  -- Instance čítače
  UUT : entity work.johnsoncounter_744017
    port map (
      CP0    => cp0,
      CP1_N  => cp1_n,
      MR     => mr,
      Q      => q,
      Q5_9_N => q5_9_n
    );

  -- Testovací proces
  process is
  begin
    -- Reset čítače
    mr <= '1';
    wait for 10 ns;
    mr <= '0';
    report "MR /\ Q=" & to_string2(q) & " Q/5-9=" & std_logic'image(q5_9_n);

    -- Test CP0 clock (CP1_N = '0')
    cp1_n <= '0';

    for i in 0 to 9 loop

      cp0 <= '1';
      wait for 10 ns;
      cp0 <= '0';
      wait for 10 ns;
      report "/\ CP0 & /CP1_N Q=" & to_string2(q) & " Q/5-9=" & std_logic'image(q5_9_n);

    end loop;

    -- Test CP1_N clock (CP0 = '1')
    cp0 <= '1';

    for i in 0 to 9 loop

      cp1_n <= '0';
      wait for 10 ns;
      cp1_n <= '1';
      wait for 10 ns;
      report "CP0 & \/ CP1_N Q=" & to_string2(q) & " Q/5-9=" & std_logic'image(q5_9_n);

    end loop;

    -- Ukončení simulace
    STOP;
  end process;

end architecture BEHAVIOR;
