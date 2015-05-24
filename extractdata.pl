# Author: Pato Sáinz
# 20150524

use Modern::Perl '2015'; # strict, warnings, autodie, etc.
use HTML::TableExtract;
use IO::File;
use Data::Dumper; # Am I debugging?

if (!$ARGV[1]) { die "FATAL: File target must be set as ARGV"; }

my $fh = IO::File->new("$ARGV[1]",'r');

print Dumper($fh);
