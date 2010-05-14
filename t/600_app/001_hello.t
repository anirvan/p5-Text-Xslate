use strict;
use Test::More (tests => 4);
use File::Path ();

File::Path::rmtree( "t/600_app/out" );

system $^X, (map { "-I$_" } @INC), "bin/xslate",
    '--suffix', 'tx=txt',
    '--dest=t/600_app/out',
    't/600_app/simple/hello.tx'
;

is $?, 0, "command executed successfully";

ok -f 't/600_app/out/hello.txt', 'correct file generated';

my $fh;
ok open($fh, '<', 't/600_app/out/hello.txt'), 'file opened';

my $content = do { local $/; <$fh> };

like $content, qr/Hello, Perl world!/;
