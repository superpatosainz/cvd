#!/usr/bin/env perl
# Author: Pato Sáinz
# 20150528

use Modern::Perl '2015';
use File::Slurp;


##########################################
use Data::Dumper; # Am I debugging?
##########################################

unless (defined($ARGV[0])) { die "FATAL: UID must be set as argument"; }
my $argvuid = $ARGV[0];