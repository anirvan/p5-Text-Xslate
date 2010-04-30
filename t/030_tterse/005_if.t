#!perl -w
use strict;
use Test::More;

use t::lib::TTSimple;

my @data = (
    [<<'T', <<'X', "if-end (true)"],
[% IF lang == "Xslate" -%]
    ok
[% END -%]
T
    ok
X

    [<<'T', <<'X', "if-end (false)"],
[% IF lang != "Xslate" -%]
    ok
[% END -%]
T
X

    [<<'T', <<'X', "if-else-end (true)"],
[% IF lang == "Xslate" -%]
    foo
[% ELSE -%]
    bar
[% END -%]
T
    foo
X

    [<<'T', <<'X', "if-else-end (false)"],
[% IF lang != "Xslate" -%]
    foo
[% ELSE -%]
    bar
[% END -%]
T
    bar
X

);

foreach my $d(@data) {
    my($in, $out, $msg) = @$d;

    my %vars = (
        lang => 'Xslate',
        void => '',

        value => 10,
    );
    is render_str($in, \%vars), $out, $msg or diag($in);
}

done_testing;