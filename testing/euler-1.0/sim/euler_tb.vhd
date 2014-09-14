 -- title:              Testbench for VCORDIC
 -- author:             Sebastian Weiss
 -- last change:        03.12.14

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity euler_tb is
end entity;

architecture behavioral of euler_tb is
constant A	: natural := 16;
constant P	: natural := 24;
constant N	: natural := 15;
signal clk	: std_logic := '0';
signal i	: signed(A-1 downto 0) := (others => '0');
signal q	: signed(A-1 downto 0) := (others => '0');
signal amp	: unsigned(A-1 downto 0);
signal phi	: signed(P-1 downto 0) := (others => '0');
begin

	dut : entity work.euler
		generic map(
			A	=> A,
			P	=> P,
			N	=> N
		)

		port map(
			clk	=> clk,
			i	=> i,
			q	=> q,
			amp	=> amp,
			phi	=> phi
		);

	process
	begin
		wait until rising_edge(clk);
		i <= to_signed(integer(1.0 * 2.0**(A-1)-1.0),A);
		q <= to_signed(integer(1.0 * 2.0**(A-1)-1.0),A);


		wait until rising_edge(clk);
		i <= to_signed(integer(0.7071 * 2.0**(A-1)),A);
		q <= to_signed(integer(0.7071 * 2.0**(A-1)),A);

		wait until rising_edge(clk);
		i <= to_signed(integer(0.5 * 2.0**(A-1)),A);
		q <= to_signed(integer(0.2 * 2.0**(A-1)),A);

		wait until rising_edge(clk);
		i <= to_signed(integer(-0.1 * 2.0**(A-1)),A);
		q <= to_signed(integer(0.9 * 2.0**(A-1)),A);

		wait until rising_edge(clk);
		i <= to_signed(integer(-1.0 * 2.0**(A-1)+1.0),A);
		q <= to_signed(integer(-1.0 * 2.0**(A-1)+1.0),A);


		wait until rising_edge(clk);
		i <= to_signed(integer(-0.7071 * 2.0**(A-1)),A);
		q <= to_signed(integer(0.7071 * 2.0**(A-1)),A);

		wait until rising_edge(clk);
		i <= to_signed(integer(0.5 * 2.0**(A-1)),A);
		q <= to_signed(integer(-0.2 * 2.0**(A-1)),A);

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		i <= to_signed(integer(0.0 * (2.0**(A-1)-1.0)),A);
		q <= to_signed(integer(0.0 * (2.0**(A-1)-1.0)),A);
		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 1.4142 * 2.0**(A-1)),A)) and (amp >= to_unsigned(integer(0.99 * 1.4142 * 2.0**(A-1)),A))
			report "case 1 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(1.0/1.0)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 * atan(1.0/1.0)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 2 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 1.0 * 2.0**(A-1)),A)) and (amp >=to_unsigned(integer(0.99 * 1.0 * 2.0**(A-1)),A))
			report "case 3 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(0.7071/0.7071)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 *  atan(0.7071/0.7071)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 4 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 0.5385 * 2.0**(A-1)),A)) and (amp >=to_unsigned(integer(0.99 * 0.5385 * 2.0**(A-1)),A))
			report "case 5 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(0.5/0.2)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 *  atan(0.5/0.2)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 6 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 0.9055 * 2.0**(A-1)),A)) and (amp >=to_unsigned(integer(0.99 * 0.9055 * 2.0**(A-1)),A))
			report "case 7 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * 1.6815/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 * 1.6815/(MATH_PI) * 2.0**(P-1)),P))
			report "case 8 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 1.4142 * 2.0**(A-1)),A)) and (amp >= to_unsigned(integer(0.99 * 1.4142 * 2.0**(A-1)),A))
			report "case 9 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(1.0/1.0)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 * atan(1.0/1.0)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 10 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 1.0 * 2.0**(A-1)),A)) and (amp >=to_unsigned(integer(0.99 * 1.0 * 2.0**(A-1)),A))
			report "case 11 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(0.7071/0.7071)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 *  atan(0.7071/0.7071)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 12 failed!" severity error;

		wait until rising_edge(clk);

		assert (amp < to_unsigned(integer(1.01 * 0.5385 * 2.0**(A-1)),A)) and (amp >=to_unsigned(integer(0.99 * 0.5385 * 2.0**(A-1)),A))
			report "case 13 failed!" severity error;
		assert (phi < to_signed(integer(1.01 * atan(0.5/0.2)/(MATH_PI) * 2.0**(P-1)),P)) and (phi >= to_signed(integer(0.99 *  atan(0.5/0.2)/(MATH_PI) * 2.0**(P-1)),P))
			report "case 14 failed!" severity error;

		report "all tests finished!";
		wait;
	end process;

	clk <= not clk after 11363 ps;
end behavioral;
