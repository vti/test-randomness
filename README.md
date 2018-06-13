# NAME

Test::Randomness - randomness tests

# SYNOPSIS

    use Test::Randomness;

    Test::Randomness->frequency_test($s);
    Test::Randomness->serial_test($s);
    Test::Randomness->poker_test($s);
    Test::Randomness->runs_test($s);
    Test::Randomness->autocorrelation_test($s, d => 8);

# DESCRIPTION

Test::Randomness is randomness testing module. It can be used to analyze a sequence, calculate randomness metrics and
compare it to statistical data in order to consider a random data generator actually more random than not.

# METHODS

## `frequency_test`

Frequency or monobit test calculates if number of 1s is approximately the same as number of 0s.

## `serial_test`

Serial or two-bit test calculates if number of sequences 00, 01, 10 and 11 is approximately the same.

## `poker_test`

Poker test calculates if number of sequences 000, 001 .. 111 is approximately the same.

## `runs_test`

Runs test calculates if the number of blocks of 1s or gaps of 0s is of expected values.

## `autocorrelation_test`

Autocorrelation test calculates the correlation between initial sequence and its shifted value.

# LICENSE

Copyright (C) Viacheslav Tykhanovskyi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

vti <viacheslav.t@gmail.com>
