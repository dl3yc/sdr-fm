 -- FIR module for Betty SDR
 -- implements a FIR filter for universal filter order without symmetry presumption
 -- file: fir.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --		 - functional testing with dirac impulse
 --		 - test for linear phase with complex carrier
 --
 -- needs generics with definition of fir_order and fir_coeff
 -- with fir_order+1 elements in Q0.26 signed fixed point format

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fir_types is
	type fir_coeff_t is array(natural range <>) of signed(26 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_types.all;

entity fir is
	generic (
		fir_order : natural;
		fir_coeff : fir_coeff_t
	);
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		d	: in signed(26 downto 0);
		q	: out signed(26 downto 0);
		rdy	: out std_logic
	);
end entity fir;

architecture rtl of fir is
	 -- shift register
	type shift_t is array(fir_order downto 0) of signed(26 downto 0);
	type sr_t is record
		input : signed(26 downto 0);
		shift : shift_t;
		sel : std_logic;
		en : std_logic;
	end record;
	constant sr_default : sr_t := (
		input => (others => '0'),
		shift => (others => (others => '0')),
		sel => '0',
		en => '0'
	);
	signal sr : sr_t := sr_default;

	 -- coeff ROM
	signal rom : fir_coeff_t(fir_order downto 0) := fir_coeff;
	signal coeff : signed(26 downto 0);
	signal coeff_index : natural range 0 to fir_order;

	 -- MAC unit
	type mac_t is record
		in_a : signed(26 downto 0);
		in_b : signed(26 downto 0);
		mult_out : signed(53 downto 0);
		acc_out : signed(53 downto 0);
		mac_out : signed(26 downto 0);
		clr : std_logic;
		stb : std_logic;
	end record;
	signal mac : mac_t;

	 -- finite state machine
	type state_t is (reset, prolog, multiply_and_add, epilog);
	signal state : state_t;
	signal fsm_index : natural range 0 to fir_order;
begin

	rom_register : process
	begin
		wait until rising_edge(clk);
		coeff <= rom(coeff_index);
	end process rom_register;

	shift_register : process
	begin
		wait until rising_edge(clk);
		if sr.en = '1' then
			sr.shift(sr.shift'high downto sr.shift'low+1) <= sr.shift(sr.shift'high-1 downto sr.shift'low);
			if sr.sel = '1' then
				sr.shift(sr.shift'low) <= sr.input;
			else
				sr.shift(sr.shift'low) <= sr.shift(sr.shift'high);
			end if;
		end if;
	end process shift_register;
	sr.input <= d;

	mac_unit : process
	begin
		wait until rising_edge(clk);
		mac.in_a <= coeff;
		mac.in_b <= sr.shift(sr.shift'high);
		mac.mult_out <= mac.in_a * mac.in_b;
		if mac.clr = '1' then
			mac.acc_out <= (others => '0');
		else
			mac.acc_out <= mac.acc_out + mac.mult_out;
		end if;
		if mac.stb = '1' then
			mac.mac_out <= mac.acc_out(52 downto 26);
		end if;
	end process mac_unit;

	fsm : process
	begin
		wait until rising_edge(clk);
		case state is
			when reset =>
				rdy <= '0';
				mac.stb <= '0';
				sr.en <= '0';
				fsm_index <= 0;
				if stb = '1' then
					sr.en <= '1';
					sr.sel <= '1';
					state <= prolog;
				end if;

			when prolog =>
				sr.sel <= '0';
				fsm_index <= fsm_index + 1;
				coeff_index <= fsm_index;
				if fsm_index = 0 then
					sr.en <= '0';
				else
					sr.en <= '1';
				end if;
				if fsm_index = 2 then
					mac.clr <= '1';
				end if;
				if fsm_index = 3 then
					mac.clr <= '0';
					state <= multiply_and_add;
				end if;

			when multiply_and_add =>
				coeff_index <= fsm_index;
				if fsm_index = fir_order then
					state <= epilog;
					fsm_index <= 0;
				else
					fsm_index <= fsm_index + 1;
				end if;

			when epilog =>
				fsm_index <= fsm_index + 1;
				if fsm_index = 1 then
					sr.en <= '0';
				end if;
				if fsm_index = 3 then
					mac.stb <= '1';
					state <= reset;
					rdy <= '1';
				end if;

		end case;
	end process fsm;
	q <= mac.mac_out;

end architecture rtl;
