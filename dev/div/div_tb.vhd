library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_tb is
end entity div_tb;

architecture sim of div_tb is
	constant D : natural := 28;
	constant N : natural := 27;
	signal clk : std_logic := '0';
	signal stb : std_logic := '0';
	signal num : signed(N-1 downto 0);
	signal denom : signed(D-1 downto 0);
	signal quot : signed(N-1 downto 0);
	signal remaind : signed(D-1 downto 0);
	signal rdy : std_logic;
begin

	dut : entity work.div
		generic map(
			WN => N,
			WD => D
		)
		port map(
			clk => clk,
			stb => stb,
			num => num,
			denom => denom,
			quot => quot,
			remaind => remaind,
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

	process begin
		num <= to_signed(10,num'length);
		denom <= to_signed(1,denom'length);
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
