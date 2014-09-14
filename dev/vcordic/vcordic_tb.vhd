 -- title:              Testbench for VCORDIC
 -- author:             Sebastian Weiss
 -- last change:        03.12.14

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity vcordic_tb is
end entity;

architecture behavioral of vcordic_tb is
constant A	: natural := 16;
constant P	: natural := 24;
constant N	: natural := 15;
signal clk	: std_logic := '0';
signal i	: signed(A-1 downto 0);
signal q	: signed(A-1 downto 0);
signal amp	: unsigned(A-1 downto 0);
signal phi	: signed(P-1 downto 0) := (others => '0');
begin

	dut : entity work.vcordic
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

	i <= x"7FFF";
	q <= x"7FFF";

	clk <= not clk after 11363 ps;
end behavioral;
