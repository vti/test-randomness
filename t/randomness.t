use strict;
use warnings;

use Test::More;
use Test::Randomness;

# Based on example from the Handbook of Applied Cryptography, by A. Menezes, P. van Oorschot, and S. Vanstone, CRC
# Press, 1996. For further information, see www.cacr.math.uwaterloo.ca/hac

my $s = '1110001100010001010011101111001001001001' x 4;

is sprintf('%.4f', Test::Randomness->frequency_test($s)), '0.4000';
is sprintf('%.4f', Test::Randomness->serial_test($s)),    '0.6252';
is sprintf('%.4f', Test::Randomness->poker_test($s)),     '9.6415';
is sprintf('%.4f', Test::Randomness->runs_test($s)),      '31.7913';

is sprintf('%.4f', Test::Randomness->autocorrelation_test($s, d => 8)),
  '3.8933';

done_testing;
