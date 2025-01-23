
-- Project: TTCPU 
-- Version: 0.1 
-- Author: Tomáš Pitner (tomas.pitner@gmail.com)
-- Test Description: Test invertujícího multiplexoru s třístavovým výstupem 

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.pkg_fmt.all;
  use work.ttcpu_lib.all;

entity Multiplexer_74258_tb is 
end entity Multiplexer_74258_tb;

-- Architecture of Test
architecture Behavioral of Multiplexer_74258_tb is
    signal i0 : std_logic_vector(3 downto 0);
    signal i1 : std_logic_vector(3 downto 0);
    signal s : std_logic;
    signal g_n : std_logic;
    signal y : std_logic_vector(3 downto 0);
begin
  -- Instantiation of Unit Under Test: Multiplexer_74258
  uut : entity work.Multiplexer_74258 (Behavioral)
    port map (
            I0 => i0,
            I1 => i1,
            S => s,
            G_N => g_n,
            Y => y
    );

  -- Testing process
  main : process is
  begin
    -- Test #1 Výstupy odpojeny G_N=1
    i0 <= "0001";
    i1 <= "1010";
    s <= '0';
    g_n <= '1';
    wait for 10 ns;
    report fmt("I0={} I1={} G_N={} S={} => Y={}", f(i0), f(i1), f(g_n), f(s), f(y)); 
    assert
        Y="ZZZZ"
        report "Failed " & "Výstupy odpojeny G_N=1"
        severity error;
    
    -- Test #2 I0=0000 na vstupu 0
    i0 <= "0000";
    i1 <= "0000";
    s <= '0';
    g_n <= '0';
    wait for 10 ns;
    report fmt("I0={} I1={} G_N={} S={} => Y={}", f(i0), f(i1), f(g_n), f(s), f(y)); 
    assert
        Y="1111"
        report "Failed " & "I0=0000 na vstupu 0"
        severity error;
    
    -- Test #3 I1=1010 na vstupu 1
    i0 <= "0000";
    i1 <= "1010";
    s <= '1';
    g_n <= '0';
    wait for 10 ns;
    report fmt("I0={} I1={} G_N={} S={} => Y={}", f(i0), f(i1), f(g_n), f(s), f(y)); 
    assert
        Y="0101"
        report "Failed " & "I1=1010 na vstupu 1"
        severity error;
    
    -- Test #4 I0=0000 na výstupu
    i0 <= "1111";
    i1 <= "0000";
    s <= '0';
    g_n <= '0';
    wait for 10 ns;
    report fmt("I0={} I1={} G_N={} S={} => Y={}", f(i0), f(i1), f(g_n), f(s), f(y)); 
    assert
        Y="0000"
        report "Failed " & "I0=0000 na výstupu"
        severity error;
    
    wait;
  end process main;
end architecture Behavioral;
