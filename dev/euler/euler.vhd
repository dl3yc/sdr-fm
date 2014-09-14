 -- EULER module for Betty SDR
 -- implements a rectangle to polar conversion
 -- file: euler.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 -- depends on: vcordic.vhd
 --
 -- change log:
 --	- release implementation	1.0
 --

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity euler is
	generic
	(
		A	: natural;
		P	: natural;
		N	: natural
	);

	port
	(
		clk	: in std_logic;
		i	: in signed(A-1 downto 0);
		q	: in signed(A-1 downto 0);
		amp	: out unsigned(A-1 downto 0);
		phi	: out signed(P-1 downto 0)
	);
end entity;

architecture behavioral of euler is
	signal cordic_i : signed(A-1 downto 0);
	signal cordic_q : signed(A-1 downto 0);
	signal cordic_phi : signed(P-1 downto 0);
	alias i_sign : std_logic is i(i'high);
	alias q_sign : std_logic is q(q'high);
	type quadrant_t is array(N+1 downto 0) of bit_vector(1 downto 0);
	signal quadrant : quadrant_t;
	alias actual_quadrant : bit_vector(1 downto 0) is quadrant(0);
	alias last_quadrant : bit_vector(1 downto 0) is quadrant(N+1);
begin

	cordic : entity work.vcordic
		generic map(
			A	=> A,
			P	=> P,
			N	=> N
		)
		port map(
			clk	=> clk,
			i	=> cordic_i,
			q	=> cordic_q,
			amp	=> amp,
			phi	=> cordic_phi
		);

	process
	begin
		wait until rising_edge(clk);
		quadrant(N+1 downto 1) <= quadrant(N downto 0);
	end process;
	quadrant(0) <= to_bit(i_sign) & to_bit(q_sign);

	process
	begin
		wait until rising_edge(clk);
		case actual_quadrant is
			when "11" =>		-- 1st quadrant
				cordic_i <= i;
				cordic_q <= q;
			when "10" => 		-- 2nd quadrant
				cordic_i <= i;
				cordic_q <= -q;
			when "00" =>		-- 3rd quadrant
				cordic_i <= -i;
				cordic_q <= -q;
			when "01" => 		-- 4th quadrant
				cordic_i <= -i;
				cordic_q <= q;
		end case;
	end process;

	process
	begin
		wait until rising_edge(clk);
		case last_quadrant is
			when "11" => phi <= cordic_phi; -- 1st quadrant
			when "10" => phi <= 2**(P-1) - cordic_phi; -- 2nd quadrant
			when "00" => phi <= 2**(P-1) + cordic_phi; -- 3rd quadrant
			when "01" => phi <= -cordic_phi; -- 4th quadrant
		end case;
	end process;

end behavioral;
