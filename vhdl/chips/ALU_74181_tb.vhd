
-- Project: TTCPU 
-- Version: 0.1 
-- Author: Tomáš Pitner (tomas.pitner@gmail.com)
-- Test Description: Test Čtyřbitové aritmeticko-logické jednotky 

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.pkg_fmt.all;
  use work.ttcpu_lib.all;

entity ALU_74181_tb is 
end entity ALU_74181_tb;

-- Architecture of Test
architecture Behavioral of ALU_74181_tb is
    signal a : std_logic_vector(3 downto 0);
    signal b : std_logic_vector(3 downto 0);
    signal s : std_logic_vector(3 downto 0);
    signal m : std_logic;
    signal c_in_n : std_logic;
    signal a_b : std_logic;
    signal x : std_logic;
    signal y : std_logic;
    signal c_out_n4_n : std_logic; 
    signal ff : std_logic_vector(3 downto 0);
begin
  -- Instantiation of Unit Under Test: ALU_74181
  uut : entity work.ALU_74181 (Behavioral)
    port map (
      A => a,
      B => b,
      S => s,
      M => m,
      C_IN_N => c_in_n,
      A_B => a_b,
      X => x,
      Y => y,
      C_OUT_N4_N => c_out_n4_n,
      F => ff
    );

  -- Testing process
  main : process is
  begin
    -- Test #1 A 0001 + B 1110, C_IN_N=1
    a <= "0001";
    b <= "1110";
    s <= "1001";
    m <= '0';
    c_in_n <= '1';
    wait for 10 ns;
    report fmt("A={} B={} S={} M={} C_IN_N={} => X={} Y={} F={}", f(a), f(b), f(s), f(m), f(c_in_n), f(x), f(y), f(ff));
    assert a_b = '1'
      report "A 0001 + B 1110, C_IN_N=1 failed, A_B != 1" severity error;
    assert x = '0'
      report "A 0001 + B 1110, C_IN_N=1 failed, X != 0" severity error;
    assert y = '1'
      report "A 0001 + B 1110, C_IN_N=1 failed, Y != 1" severity error;
    assert c_out_n4_n = '1'
      report "A 0001 + B 1110, C_IN_N=1 failed, C_OUT_N4_N != 1" severity error;
    assert ff = "1111"
      report "A 0001 + B 1110, C_IN_N=1 failed, F != 1111" severity error;
    
    -- Test #2 A 0001 + B 1110 C_IN_N=0
    a <= "0001";
    b <= "1110";
    s <= "1001";
    m <= '0';
    c_in_n <= '0';
    wait for 10 ns;
    report fmt("A={} B={} S={} M={} C_IN_N={} => X={} Y={} F={}", f(a), f(b), f(s), f(m), f(c_in_n), f(x), f(y), f(ff));
    assert a_b = '0'
      report "A 0001 + B 1110 C_IN_N=0 failed, A_B != 0" severity error;
    assert x = '0'
      report "A 0001 + B 1110 C_IN_N=0 failed, X != 0" severity error;
    assert y = '1'
      report "A 0001 + B 1110 C_IN_N=0 failed, Y != 1" severity error;
    assert c_out_n4_n = '0'
      report "A 0001 + B 1110 C_IN_N=0 failed, C_OUT_N4_N != 0" severity error;
    assert ff = "0000"
      report "A 0001 + B 1110 C_IN_N=0 failed, F != 0000" severity error;
    
    -- Test #3 A 1010 - B 1010 C_IN_N=1
    a <= "1010";
    b <= "1010";
    s <= "0110";
    m <= '0';
    c_in_n <= '1';
    wait for 10 ns;
    report fmt("A={} B={} S={} M={} C_IN_N={} => X={} Y={} F={}", f(a), f(b), f(s), f(m), f(c_in_n), f(x), f(y), f(ff));
    assert a_b = '1'
      report "A 1010 - B 1010 C_IN_N=1 failed, A_B != 1" severity error;
    assert x = '0'
      report "A 1010 - B 1010 C_IN_N=1 failed, X != 0" severity error;
    assert y = '1'
      report "A 1010 - B 1010 C_IN_N=1 failed, Y != 1" severity error;
    assert c_out_n4_n = '1'
      report "A 1010 - B 1010 C_IN_N=1 failed, C_OUT_N4_N != 1" severity error;
    assert ff = "1111"
      report "A 1010 - B 1010 C_IN_N=1 failed, F != 1111" severity error;
    
    wait;
  end process main;
end architecture Behavioral;
