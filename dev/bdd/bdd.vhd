 -- BDD module for Betty SDR
 -- implements a baseband differentiator demodulator
 -- heavily based on Jes Toft Kristensen "FM radio receiver"
 -- file: bsd.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bdd is
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		i	: in signed(26 downto 0);
		q	: in signed(26 downto 0);
		demod	: out signed(26 downto 0);
		rdy	: out std_logic
	);
end entity bdd;

architecture rtl of bdd is
	signal i_d: signed(26 downto 0);
	signal q_d: signed(26 downto 0);
	signal i_dt : signed(26 downto 0);
	signal q_dt : signed(26 downto 0);
	signal i_p : signed(53 downto 0);
	signal q_p : signed(53 downto 0);
	signal stb_d : std_logic_vector(1 downto 0);
begin
	process
	begin
		wait until rising_edge(clk);
		if stb = '1' then
			i_d <= i;
			q_d <= q;
			i_dt <= i - i_d;
			q_dt <= q - q_d;
		end if;
		i_p <= q_d * i_dt;
		q_p <= i_d * q_dt;

		demod <= q_p(53 downto 27) - i_p(53 downto 27);

		stb_d(0) <= stb;
		stb_d(1) <= stb_d(0);
		rdy <= stb_d(1);
	end process;
end architecture rtl;
