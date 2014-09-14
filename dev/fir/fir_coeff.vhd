library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_types.all;

package fir_coeff_lib is
	constant fir_order : natural := 128;
	type integer_vector is array(fir_order downto 0) of integer;

	constant fir_coeff_content : integer_vector := (
		30251,		25860,		4784,		-21256,		-36393,		-29458,		-1554,		32410,
		50644,		37512,		-4503,		-52413,		-74050,		-48513,		16566,		84046,
		107070,		60122,		-38397,		-130080,	-149580,	-69234,		74231,		193160,
		200780,		71802,		-129020,	-276090,	-259370,	-62958,		208440,		381780,
		323340,		36338,		-319910,	-514420,	-390640,	16054,		473460,		680160,
		458700,		-106210,	-685690,	-891130,	-526160,	252490,		985540,		1170900,
		592070,		-491400,	-1436600,	-1577800,	-662630,	904470,		2199700,	2274900,
		763940,		-1750000,	-3862800,	-3974600,	-1129700,	4365600,	10902000,	16178000,
		18199000,	16178000,	10902000,	4365600,	-1129700,	-3974600,	-3862800,	-1750000,
		763940,		2274900,	2199700,	904470,		-662630,	-1577800,	-1436600,	-491400,
		592070,		1170900,	985540,		252490,		-526160,	-891130,	-685690,	-106210,
		458700,		680160,		473460,		16054,		-390640,	-514420,	-319910,	36338,
		323340,		381780,		208440,		-62958,		-259370,	-276090,	-129020,	71802,
		200780,		193160,		74231,		-69234,		-149580,	-130080,	-38397,		60122,
		107070,		84046,		16566,		-48513,		-74050,		-52413,		-4503,		37512,
		50644,		32410,		-1554,		-29458,		-36393,		-21256,		4784,		25860,	30251
	);
	function to_fir_coeff_t(iv: integer_vector) return fir_coeff_t;
end package fir_coeff_lib;

package body fir_coeff_lib is
	function to_fir_coeff_t(iv: integer_vector) return fir_coeff_t is
		variable ret : fir_coeff_t(fir_order downto 0);
	begin
		for i in 0 to fir_order loop
			ret(i) := to_signed(iv(i) ,27);
		end loop;
		return ret;
	end function;
end package body fir_coeff_lib;
