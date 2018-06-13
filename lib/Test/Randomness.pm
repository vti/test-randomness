package Test::Randomness;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

sub frequency_test {
    my $class = shift;
    my ($s) = @_;

    my $n    = length $s;
    my @bits = split //, $s;
    my $n0   = grep { $_ eq '0' } @bits;
    my $n1   = grep { $_ eq '1' } @bits;

    return ($n0 - $n1) * ($n0 - $n1) / $n;
}

sub serial_test {
    my $class = shift;
    my ($s) = @_;

    my @bits = split //, $s;

    my $n = @bits;

    my $n0 = grep { $_ eq '0' } @bits;
    my $n1 = grep { $_ eq '1' } @bits;

    my $n00 = 0;
    my $n01 = 0;
    my $n11 = 0;
    my $n10 = 0;

    my $first = shift @bits;
    while (@bits) {
        my $second = $bits[0];

        my $seq = "$first$second";

        if ($seq eq '00') {
            $n00++;
        }
        elsif ($seq eq '01') {
            $n01++;
        }
        elsif ($seq eq '10') {
            $n10++;
        }
        elsif ($seq eq '11') {
            $n11++;
        }

        $first = shift @bits;
    }

    return (4 / ($n - 1)) * ($n00**2 + $n01**2 + $n11**2 + $n10**2) -
      (2 / $n) * ($n0**2 + $n1**2) + 1;
}

sub poker_test {
    my $class = shift;
    my ($s) = @_;

    my $n = length $s;
    my $m = 1;

    while ($n / $m >= 5 * (2**$m)) {
        $m++;
    }

    $m-- unless $m == 1;

    my $k = int($n / $m);

    my $to = unpack 'N', pack 'B32', substr('0' x 32 . ('1' x $m), -32);

    my %parts;
    for (0 .. $to) {
        my $part = substr(unpack('B32', $_), -$m);

        $parts{$part} = 0;
    }

    while (length(my $substr = substr($s, 0, $m, '')) == 3) {
        $parts{$substr}++;
    }

    my $sum = 0;
    foreach my $part (keys %parts) {
        $sum += $parts{$part}**2;
    }

    return ((2**$m) / $k) * $sum - $k;
}

sub runs_test {
    my $class = shift;
    my ($s) = @_;

    my $n = length $s;

    my $ei = sub { my $i = shift; ($n - $i + 3) / (2**($i + 2)) };

    my $k = 0;
    my $e;
    do {
        $e = $ei->(++$k);
    } while ($e > 5);

    my $blocks_sum = 0;
    my $gaps_sum   = 0;

    for (1 .. $k) {
        my $ki = $_;

        my $ei = $ei->($_);

        my $blocks = grep { length $_ eq $ki } split /0+/, $s;
        my $gaps   = grep { length $_ eq $ki } split /1+/, $s;

        $blocks_sum += ($blocks - $ei)**2 / $ei;
        $gaps_sum   += ($gaps - $ei)**2 / $ei;
    }

    return $blocks_sum + $gaps_sum;
}

sub autocorrelation_test {
    my $class = shift;
    my ($s, %params) = @_;

    my $n = length $s;
    my $d = $params{d} // ($n / 2);

    my $a_sum = 0;
    for (0 .. $n - $d - 1) {
        if (substr($s, $_, 1) ne substr($s, $_ + $d, 1)) {
            $a_sum++;
        }
    }

    return 2 * ($a_sum - ($n - $d) / 2) / sqrt($n - $d);
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Randomness - randomness tests

=head1 SYNOPSIS

    use Test::Randomness;

    Test::Randomness->frequency_test($s);
    Test::Randomness->serial_test($s);
    Test::Randomness->poker_test($s);
    Test::Randomness->runs_test($s);
    Test::Randomness->autocorrelation_test($s, d => 8);

=head1 DESCRIPTION

Test::Randomness is randomness testing module. It can be used to analyze a sequence, calculate randomness metrics and
compare it to statistical data in order to consider a random data generator actually more random than not.

=head1 METHODS

=head2 C<frequency_test>

Frequency or monobit test calculates if number of 1s is approximately the same as number of 0s.

=head2 C<serial_test>

Serial or two-bit test calculates if number of sequences 00, 01, 10 and 11 is approximately the same.

=head2 C<poker_test>

Poker test calculates if number of sequences 000, 001 .. 111 is approximately the same.

=head2 C<runs_test>

Runs test calculates if the number of blocks of 1s or gaps of 0s is of expected values.

=head2 C<autocorrelation_test>

Autocorrelation test calculates the correlation between initial sequence and its shifted value.

=head1 LICENSE

Copyright (C) Viacheslav Tykhanovskyi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

vti E<lt>viacheslav.t@gmail.comE<gt>

=cut
