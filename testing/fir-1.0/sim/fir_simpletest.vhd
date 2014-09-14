library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_types.all;

entity fir_simpletest is
end entity fir_simpletest;

architecture sim of fir_simpletest is
	signal clk : std_logic := '0';
	signal stb : std_logic := '0';
	signal d : signed(26 downto 0);
	signal q : signed(26 downto 0);
	constant test_coeff : fir_coeff_t := (to_signed(1,27),to_signed(1,27),to_signed(1,27),to_signed(1,27),
						to_signed(1,27),to_signed(1,27),to_signed(1,27),to_signed(1,27),
						to_signed(1,27),to_signed(1,27),to_signed(1,27),to_signed(1,27),
						to_signed(1,27),to_signed(1,27),to_signed(1,27),to_signed(1,27));
begin

	dut : entity work.fir
		generic map(
			fir_order => 15,
			fir_coeff => test_coeff
		)
		port map(
			clk => clk,
			stb => stb,
			d   => d,
			q   => q
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

	process begin
		d <= (others => '0');
		wait until stb = '1';
		d <= "000000000000000000000000001";
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		wait until stb = '1';
		d <= (others => '0');
		wait until stb = '1';
		wait;
	end process;

	process
		variable i : integer := 0;
	begin
		wait until stb = '1';
		i := i + 1;
		assert (i < 30) severity failure;
	end process;

end architecture sim;
