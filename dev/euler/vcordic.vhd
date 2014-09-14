 -- VCORDIC module for Betty SDR
 -- implements CORDIC in Vector Mode
 -- file: vcordic.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	 - release implementation	1.0
 --	 - functional testing with matlab as reference implementation
 --
 -- delay: N+2 clock cycles
 --
 -- !!! because of the arctan table used in the CORDIC algorithm
 -- !!! it only converges in the range of -1(rad) to +1(rad)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity vcordic is
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

architecture behavioral of vcordic is
type alpha_t	is array(0 to N-1) of signed(P-1  downto 0); -- -180°..180°
type xy_vector	is array(natural range <>) of signed(A+2 downto 0); -- -3.999..+3.999
type z_vector	is array(natural range <>) of signed(P-1 downto 0); -- -180°..180°
constant K	: signed(A-1 downto 0) := to_signed(integer(0.6073*2**(A-1)),A);

signal alpha    : alpha_t;
signal x,y      : xy_vector(N downto 0) := (others => (others => '0'));
signal z        : z_vector(N downto 0)  := (others => (others => '0'));
begin

	table: for i in 0 to N-1 generate
		alpha(i) <= to_signed(integer( atan(1.0/real(2**i)) * (real(2**(P-1))-1.0) / math_pi ),P);
	end generate;

	process begin
		wait until rising_edge(clk);
		if i >= 0 then
			x(0) <= resize(i,A+3);
			y(0) <= resize(q,A+3);
			z(0) <= (others => '0');
			elsif q >= 0 then
			x(0) <= resize(q,A+3);
			y(0) <= resize(-i,A+3);
			z(0) <= to_signed(2**(P-2),P);-- 90° ??? TODO: TEST
		else
			x(0) <= resize(-q,A+3);
			y(0) <= resize(i,A+3);
			z(0) <= to_signed(-2**(P-2),P);-- -90° ??? TODO: TEST
		end if;
		for i in 1 to N loop
			if x(i-1) >= 0 then
				x(i) <= x(i-1) - y(i-1) / 2**(i-1);
				y(i) <= y(i-1) + x(i-1) / 2**(i-1);
				z(i) <= z(i-1) + alpha(i-1);
			else
				x(i) <= x(i-1) + y(i-1) / 2**(i-1);
				y(i) <= y(i-1) - x(i-1) / 2**(i-1);
				z(i) <= z(i-1) - alpha(i-1);
			end if;
		end loop;
		amp <= resize(unsigned(shift_right((y(N) * K), (A-1))),A);
		phi <= z(N);
	end process;
end behavioral;
