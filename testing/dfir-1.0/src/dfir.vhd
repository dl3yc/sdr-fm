 -- DFIR module for Betty SDR
 -- implements a decimating FIR filter for odd filter order without symmetry presumption
 -- file: dfir.vhd
 -- author: Sebastian Weiss DL3YC <dl3yc@darc.de>
 -- version: 1.0
 --
 -- change log:
 --	- release implementation	1.0
 --		 - functional testing with dirac impulse
 --		 - test for linear phase with complex carrier
 --
 -- needs generics with definition of dfir_order and dfir_coeff
 -- with dfir_order+1 elements in Q0.26 signed fixed point format

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dfir_types is
	type dfir_coeff_t is array(natural range <>) of signed(26 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dfir_types.all;

entity dfir is
	generic (
		dfir_order : natural;
		dfir_coeff : dfir_coeff_t
	);
	port (
		clk	: in std_logic;
		stb	: in std_logic;
		d	: in signed(26 downto 0);
		q	: out signed(26 downto 0);
		rdy	: out std_logic
	);
end entity dfir;

architecture rtl of dfir is
	 -- shift register
	type shift_t is array(dfir_order/2 downto 0) of signed(26 downto 0);
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
	signal sr0 : sr_t := sr_default;
	signal sr1 : sr_t := sr_default;
	signal sr_en : std_logic;
	signal sr_sel : std_logic := '0';

	 -- coeff ROM
	signal rom : dfir_coeff_t(dfir_order downto 0) := dfir_coeff;
	signal coeff : signed(26 downto 0);
	signal coeff_index : natural range 0 to dfir_order;

	 -- MAC unit
	type mac_t is record
		in_a : signed(26 downto 0);
		in_b : signed(26 downto 0);
		mult_out : signed(53 downto 0);
		acc_out : signed(53 downto 0);
		mac_out : signed(26 downto 0);
		clr : std_logic;
		stb : std_logic;
		en : std_logic;
	end record;
	constant mac_default : mac_t := (
		in_a => (others => '0'),
		in_b => (others => '0'),
		mult_out => (others => '0'),
		acc_out => (others => '0'),
		mac_out => (others => '0'),
		clr =>  '0',
		stb => '0',
		en => '0'
	);
	signal mac : mac_t := mac_default;

	 -- finite state machine
	type state_t is (reset, prolog, multiply_and_add, epilog);
	signal state : state_t;
	signal fsm_index : natural range 0 to dfir_order/2;
	signal phase : std_logic := '0';
begin

	rom_register : process
	begin
		wait until rising_edge(clk);
		coeff <= rom(coeff_index);
	end process rom_register;

	shift_register0 : process
	begin
		wait until rising_edge(clk);
		if sr0.en = '1' and phase = '0' then
			sr0.shift(sr0.shift'high downto sr0.shift'low+1) <= sr0.shift(sr0.shift'high-1 downto sr0.shift'low);
			if sr0.sel = '1' then
				sr0.shift(sr0.shift'low) <= sr0.input;
			else
				sr0.shift(sr0.shift'low) <= sr0.shift(sr0.shift'high);
			end if;
		end if;
	end process shift_register0;
	sr0.input <= d;
	sr0.en <= sr_en when phase = '0' else '0';
	sr0.sel <= sr_sel;

	shift_register1 : process
	begin
		wait until rising_edge(clk);
		if sr1.en = '1' and phase = '1' then
			sr1.shift(sr1.shift'high downto sr1.shift'low+1) <= sr1.shift(sr1.shift'high-1 downto sr1.shift'low);
			if sr1.sel = '1' then
				sr1.shift(sr1.shift'low) <= sr1.input;
			else
				sr1.shift(sr1.shift'low) <= sr1.shift(sr1.shift'high);
			end if;
		end if;
	end process shift_register1;
	sr1.input <= d;
	sr1.en <= sr_en when phase = '1' else '0';
	sr1.sel <= sr_sel;

	mac_unit : process
	begin
		wait until rising_edge(clk);
		mac.in_a <= coeff;
		if phase = '0' then
			mac.in_b <= sr0.shift(sr0.shift'high);
		else
			mac.in_b <= sr1.shift(sr1.shift'high);
		end if;
		mac.mult_out <= mac.in_a * mac.in_b;
		if mac.clr = '1' then
			mac.acc_out <= (others => '0');
		else
			if mac.en = '1' then
				mac.acc_out <= mac.acc_out + mac.mult_out;
			end if;
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
				sr_en <= '0';
				rdy <= '0';
				mac.stb <= '0';
				fsm_index <= 0;
				if stb = '1' then
					sr_en <= '1';
					sr_sel <= '1';
					state <= prolog;
				end if;

			when prolog =>
				sr_sel <= '0';
				fsm_index <= fsm_index + 1;
				if phase = '0' then
					coeff_index <= 2 * fsm_index + 1;
				else
					coeff_index <= 2 * fsm_index;
				end if;
				if fsm_index = 0 then
					sr_en <= '0';
				else
					sr_en <= '1';
				end if;
				if fsm_index = 2 and phase = '0' then
					mac.clr <= '1';
				end if;
				if fsm_index = 3 then
					mac.clr <= '0';
					mac.en <= '1';
					state <= multiply_and_add;
				end if;

			when multiply_and_add =>
				if phase = '0' then
					coeff_index <= 2 * fsm_index + 1;
				else
					coeff_index <= 2 * fsm_index;
				end if;
				if fsm_index = dfir_order/2 then
					state <= epilog;
					fsm_index <= 0;
				else
					fsm_index <= fsm_index + 1;
				end if;

			when epilog =>
				fsm_index <= fsm_index + 1;
				if fsm_index = 1 then
					sr_en <= '0';
				end if;
				if fsm_index = 3 then
					phase <= not phase;
					state <= reset;
					mac.en <= '0';
					if phase = '1' then
						mac.stb <= '1';
						rdy <= '1';
					end if;
				end if;

		end case;
	end process fsm;
	q <= mac.mac_out;

	assert (dfir_order mod 2 = 1) report("only odd filter order are supported") severity failure;

end architecture rtl;
