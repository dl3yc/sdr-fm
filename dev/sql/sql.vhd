 -- SQL module for Betty SDR
 -- implements a squelch control
 -- file: sql.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sql is
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		tresh	: in unsigned(7 downto 0);
		amp_in	: in unsigned(26 downto 0);
		i_in	: in signed(26 downto 0);
		q_in	: in signed(26 downto 0);

		amp_out	: out unsigned(26 downto 0);
		i_out	: out signed(26 downto 0);
		q_out	: out signed(26 downto 0);
		sql_out	: out std_logic;
		rdy	: out std_logic
	);
end entity sql;

architecture rtl of sql is
alias amplitude : unsigned(7 downto 0) is amp_in(26 downto 19);
begin

	process
	begin
		wait until rising_edge(clk);
		if amplitude < tresh then
			sql_out <= '0';
			i_out <= (others => '0');
			q_out <= (others => '0');
		else
			sql_out <= '1';
			i_out <= i_in;
			q_out <= q_in;
		end if;
		rdy <= stb;
	end process;

end architecture rtl;
