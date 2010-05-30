#!perl -w
use 5.008;
use strict;

print <<"HEAD";
# This lines are automatically generated by $0.
# ANY CHANGES WILL BE LOST!

HEAD

my @ops;
my @lines = <DATA>;
my $code = '';


while(<>) {
    if(/^TXC(\w*) \s* \( (\w+) \)/xms) {
        push @ops, [$2, $1];
    }
}


$code .= <<'CODE';
# make %Text::Xslate::OPS if not exists.
package Text::Xslate;

{
    my $i = 0;

    %Text::Xslate::OPS = map { ( $_ => $i++ ) } qw(
CODE

for my $op ( @ops ) {
    $code .= sprintf( "            %s\n", $op->[0] );
}

$code .=  <<'CODE';
    );
}
CODE


$code .=  <<'CODE';

# make OPARG flag list.
package Text::Xslate::PP;
use strict;

our $tx_oparg = [
CODE

for my $op ( @ops ) {
    my $arg_type = $op->[1];
    my $flags;

    if( $arg_type ) {
        $flags .= "TXCODE" . uc $arg_type;
    }
    else {
        $flags = '0';
    }

    $code .= sprintf( "    %-14s %s\n", $flags . ',', '# ' . $op->[0] );
}


$code .=  <<'CODE';
];
CODE

for my $line ( @lines ) {

    if ( $line =~ /^<<.+?>>$/ ) {
        print $code;
        next;
    }

    print $line;
}

__DATA__
package Text::Xslate::PP::Const;

package Text::Xslate::PP;

use strict;

use constant TXARGf_SV      => 0x01;
use constant TXARGf_INT     => 0x02;
use constant TXARGf_KEY     => 0x04;
use constant TXARGf_VAR     => 0x08;
use constant TXARGf_GOTO    => 0x10;

use constant TXCODE_W_SV    => TXARGf_SV;
use constant TXCODE_W_INT   => (TXARGf_SV | TXARGf_INT);
use constant TXCODE_W_VAR   => (TXARGf_SV | TXARGf_INT | TXARGf_VAR);
use constant TXCODE_W_KEY   => (TXARGf_SV | TXARGf_KEY);
use constant TXCODE_GOTO    => (TXARGf_SV | TXARGf_INT | TXARGf_GOTO);

# template representation, stored in $self->{template}{$file}
use constant TXo_NAME           => 0;
use constant TXo_ERROR_HANDLER  => 1;
use constant TXo_MTIME          => 2;
use constant TXo_CACHEPATH      => 3;
use constant TXo_FULLPATH       => 4;

# vm execution frame
use constant TXframe_NAME       => 0;
use constant TXframe_OUTPUT     => 1;
use constant TXframe_RETADDR    => 2;
use constant TXframe_START_LVAR => 3;

use constant TX_VERBOSE_DEFAULT => 1;


<<This lines will be created by tool/opcode_for_pp.pl>>

1;
__END__

=pod

=head1 NAME

Text::Xslate::PP::Const - Text::Xslate constants in pure Perl

=head1 DESCRIPTION

This module is used by Text::Xslate::PP internally.

=head1 SEE ALSO

L<Text::Xslate>

L<Text::Xslate::PP>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 by Makamaka Hannyaharamitu (makamaka).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

