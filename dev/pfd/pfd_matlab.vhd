library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity pfd_matlab is
end entity pfd_matlab;

architecture sim of pfd_matlab is
	signal clk : std_logic := '0';
	signal stb : std_logic;
	signal rdy : std_logic;
	signal i_in : signed(26 downto 0);
	signal q_in : signed(26 downto 0);
	signal i_out : signed(26 downto 0);
	signal q_out : signed(26 downto 0);
begin

	dut : entity work.pfd
		port map(
			clk	=> clk,
			stb	=> stb,
			i_in	=> i_in,
			q_in	=> q_in,
			i_out	=> i_out,
			q_out	=> q_out,
			rdy	=> rdy
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
			i_in <= to_signed(ll, 27);
			readline(input, l);
			read(l, ll);
			q_in <= to_signed(ll, 27);
		end if;
		if rdy = '1' then
			ll := to_integer(i_out);
			write(l, ll);
			writeline(output, l);
			ll := to_integer(q_out);
			write(l, ll);
			writeline(output, l);
		end if;
	end process;

end architecture sim;
