library ieee;
use ieee.std_logic_1164.all;

entity teste is
end entity;

architecture teste_PythonProcessor of teste is
component pythonProcessor is
	generic
	(
		DATA_WIDTH	: natural := 8
	);
	
	port
	(
		clk_geral		: in std_logic;
		reset_geral		: in std_logic;
		overflow_geral	: out std_logic
	);
end component;
signal clk  : std_logic   := '0';
signal reset, overflow : std_logic;
begin
  processor : pythonProcessor
    port map
    (
      clk_geral => clk,
      reset_geral => reset,
      overflow_geral => overflow
    );
  clk <= not clk after 5.59 ns;  -- valor definido como a metade do período indicando cada borda
  
  process
  begin
    wait for 2 ns;
    reset <= '1';
    wait for 15 ns;
    reset <= '0';
    wait for 100 ns;
    reset <= '0';
    wait for 500 ns;
    reset <= '0';
    wait for 1000 ns;
    reset <= '0';
end process;
end teste_pythonProcessor;
      

