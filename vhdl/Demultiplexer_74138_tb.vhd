
-- Project: TTCPU 
-- Version: 0.1 
-- Author: Tomáš Pitner (tomas.pitner@gmail.com)
-- Test Description: Test jednokanálového demultiplexeru 3:8 

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.pkg_fmt.all;
  use work.ttcpu_lib.all;

entity Demultiplexer_74138_tb is 
end entity Demultiplexer_74138_tb;

-- Architecture of Test
architecture Behavioral of Demultiplexer_74138_tb is
    signal abc : std_logic_vector(2 downto 0);
    signal g1 : std_logic;
    signal g2a_n : std_logic;
    signal g2b_n : std_logic;
    signal y : std_logic_vector(7 downto 0);
begin
  -- Instantiation of Unit Under Test: Demultiplexer_74138
  uut : entity work.Demultiplexer_74138 (Behavioral)
    port map (
      ABC => abc,
      G1 => g1,
      G2A_N => g2a_n,
      G2B_N => g2b_n,
      Y => y
    );

  -- Testing process
  main : process is
  begin
    -- Test #1 enabled select 0
    abc <= "000";
    g1 <= '1';
    g2a_n <= '0';
    g2b_n <= '0';
    wait for 10 ns;
    report fmt("ABC={} G1={} G2A_N={} G2B_N={} => Y={}", f(unsigned(abc)), f(g1), f(G2A_N), f(G2B_N), f(y));
    assert y = "11111110"
      report "enabled select 0 failed, Y != 11111110" severity error;
    
    -- Test #2 disabled G1 select 0
    abc <= "000";
    g1 <= '0';
    g2a_n <= '0';
    g2b_n <= '0';
    wait for 10 ns;
    report fmt("ABC={} G1={} G2A_N={} G2B_N={} => Y={}", f(unsigned(abc)), f(g1), f(G2A_N), f(G2B_N), f(y));
    assert y = "11111111"
      report "disabled G1 select 0 failed, Y != 11111111" severity error;
    
    -- Test #3 disabled G2A_N select 0
    abc <= "000";
    g1 <= '1';
    g2a_n <= '1';
    g2b_n <= '0';
    wait for 10 ns;
    report fmt("ABC={} G1={} G2A_N={} G2B_N={} => Y={}", f(unsigned(abc)), f(g1), f(G2A_N), f(G2B_N), f(y));
    assert y = "11111111"
      report "disabled G2A_N select 0 failed, Y != 11111111" severity error;
    
    -- Test #4 enabled select 1
    abc <= "001";
    g1 <= '1';
    g2a_n <= '0';
    g2b_n <= '0';
    wait for 10 ns;
    report fmt("ABC={} G1={} G2A_N={} G2B_N={} => Y={}", f(unsigned(abc)), f(g1), f(G2A_N), f(G2B_N), f(y));
    assert y = "11111101"
      report "enabled select 1 failed, Y != 11111101" severity error;
    
    -- Test #5 enabled select 7
    abc <= "111";
    g1 <= '1';
    g2a_n <= '0';
    g2b_n <= '0';
    wait for 10 ns;
    report fmt("ABC={} G1={} G2A_N={} G2B_N={} => Y={}", f(unsigned(abc)), f(g1), f(G2A_N), f(G2B_N), f(y));
    assert y = "01111111"
      report "enabled select 7 failed, Y != 01111111" severity error;
    
    wait;
  end process main;
end architecture Behavioral;
