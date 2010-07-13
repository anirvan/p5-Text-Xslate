#!perl -w
use strict;
use Test::More;

use t::lib::TTSimple;

my @data = (
    [<<'T', <<'X'],
%% FOR i IN [1, 2, 3]
    [% i %]
%% END
T
    1
    2
    3
X

    [<<'T', <<'X'],
    [% { a => 1, b => 2, c => 3 }.a %]
    [% { a => 1, b => 2, c => 3 }.b %]
    [% { a => 1, b => 2, c => 3 }.c %]
T
    1
    2
    3
X

    [<<'T', <<'X', 'with keywords'],
    [% { if  => 42 }.if  %]
    [% { not => 42 }.not %]
    [% { for => 42 }.for %]
T
    42
    42
    42
X

);

foreach my $pair(@data) {
    my($in, $out, $msg) = @$pair;

    my %vars = (lang => 'Xslate', foo => "<bar>", '$lang' => 'XXX');

    is render_str($in, \%vars), $out, $msg
        or diag $in;
}

done_testing;