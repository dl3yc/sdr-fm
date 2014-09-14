library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dfir_types.all;

entity dfir_simpletest is
end entity dfir_simpletest;

architecture sim of dfir_simpletest is
	signal clk : std_logic := '0';
	signal stb : std_logic := '0';
	signal d : signed(26 downto 0);
	signal q : signed(26 downto 0);
	constant test_coeff : dfir_coeff_t := (to_signed(1,27),to_signed(2,27),to_signed(3,27),to_signed(4,27),
						to_signed(5,27),to_signed(6,27),to_signed(7,27),to_signed(8,27),
						to_signed(9,27),to_signed(10,27),to_signed(11,27),to_signed(12,27),
						to_signed(13,27),to_signed(14,27),to_signed(15,27),to_signed(16,27));
begin

	dut : entity work.dfir
		generic map(
			dfir_order => 15,
			dfir_coeff => test_coeff
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
		d <= (others => '0');
		wait until stb = '1';
		wait;
	end process;

	process
		variable i : integer := 0;
	begin
		wait until stb = '1';
		i := i + 1;
		assert (i < 40) severity failure;
	end process;

end architecture sim;
