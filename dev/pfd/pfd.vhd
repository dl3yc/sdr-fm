 -- PFD module for Betty SDR
 -- implements a polar frequency discriminator
 -- file: pfd.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --	- tested with matlab against reference implementation
 --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pfd is
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		i_in	: in signed(26 downto 0);
		q_in	: in signed(26 downto 0);

		i_out	: out signed(26 downto 0);
		q_out	: out signed(26 downto 0);
		rdy	: out std_logic
	);
end entity pfd;

architecture rtl of pfd is
	signal i_delay : signed(26 downto 0);
	signal q_delay : signed(26 downto 0);
	signal i_prod0 : signed(26 downto 0);
	signal i_prod1 : signed(26 downto 0);
	signal q_prod0 : signed(26 downto 0);
	signal q_prod1 : signed(26 downto 0);
	signal stb_d : std_logic;
begin

	process
	begin
		wait until rising_edge(clk);
		if stb = '1' then
			i_delay <= i_in;
			q_delay <= q_in;

			i_prod0 <= resize(shift_right(i_in * i_delay,26),27);
			i_prod1 <= resize(shift_right(q_in * q_delay,26),27);

			q_prod0 <= resize(shift_right(-i_in * q_delay,26),27);
			q_prod1 <= resize(shift_right(q_in * i_delay,26),27);
		end if;

		i_out <= i_prod0 + i_prod1;
		q_out <= q_prod0 + q_prod1;

		stb_d <= stb;
		rdy <= stb_d;
	end process;

end architecture rtl;
