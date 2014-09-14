library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dfir_types.all;
use work.dfir_coeff_lib.all;
use std.textio.all;

entity dfir_matlab is
end entity dfir_matlab;

architecture sim of dfir_matlab is
	signal clk : std_logic := '0';
	signal stb : std_logic := '0';
	signal d : signed(26 downto 0);
	signal q : signed(26 downto 0);
	signal rdy : std_logic;
begin

	dut : entity work.dfir
		generic map(
			dfir_order => dfir_order,
			dfir_coeff => to_dfir_coeff_t(dfir_coeff_content)
		)
		port map(
			clk => clk,
			stb => stb,
			d   => d,
			q   => q,
			rdy => rdy
		);

	clk <= not clk after 20345 ps;

	process
		variable cnt : unsigned(8 downto 0) := (others => '0');
	begin
		wait until rising_edge(clk);
		if cnt = 511 then
			stb <= '1';
		else
			stb <= '0';
		end if;
		cnt := cnt + 1;
	end process;

	process
		variable l : line;
		variable ll : integer;
	begin
		wait until rising_edge(clk);
		if stb = '1' then
			readline(input, l);
			read(l, ll);
			d <= to_signed(ll, 27);
		end if;
		if rdy = '1' then
			ll := to_integer(q);
			write(l, ll);
			writeline(output, l);
		end if;
	end process;

end architecture sim;
