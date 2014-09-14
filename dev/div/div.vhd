 -- DIV module for Betty SDR
 -- implements an iterative restoring divider
 -- heavily based on 8-bit Restoring Divider(p.94 U. Meyer-Baese "DSP with FPGA")
 -- file: div.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --	- tested with use cases
 --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div is
	generic (
		WN	: natural;
		WD	: natural
	);
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		num	: in signed(WN-1 downto 0);
		denom	: in signed(WD-1 downto 0);
		quot	: out signed(WN-1 downto 0);
		remaind	: out signed(WD-1 downto 0);
		rdy	: out std_logic
	);
end entity div;

architecture rtl of div is

	type state_t is (init, processing, restoring, establish);
	signal state : state_t;
	signal r, d : signed(WN+WD-1 downto 0) := (others => '0');
	signal q : signed(WN-1 downto 0);
	signal count : integer range 0 to WN;
begin
	process
	begin
		wait until rising_edge(clk);
		case state is
			when init =>
				rdy <= '0';
				if stb = '1' then
					state <= processing;
					count <= 0;
					q <= (others => '0');
					if denom = 0 then
						state <= establish;
						d <= to_signed(1,d'length);
						r <= (others => '0');
					else
						d <= shift_left(resize(denom,d'length),WN-1);
						r <= resize(num,r'length);
					end if;
				end if;

			when processing =>
				r <= r - d;
				state <= restoring;

			when restoring =>
				if r < 0 then
					r <= r + d;
					q <= shift_left(q,1);
				else
					q <= shift_left(q,1) + 1;
				end if;
				count <= count + 1;
				d <= d / 2;
				if count = WN-1 then
					state <= establish;
				else
					state <= processing;
				end if;

			when establish =>
				quot <= q;
				remaind <= resize(r,remaind'length);
				rdy <= '1';
				state <= init;
		end case;
	end process;

end architecture rtl;
