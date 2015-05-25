# Author: Pato Sáinz
# 20150524

use Modern::Perl '2015'; # strict, warnings, autodie, etc.
use HTML::TableExtract;
use File::Slurp;
use String::Util 'trim';

##########################################
use Data::Dumper; # Am I debugging?
##########################################

unless (defined($ARGV[0])) { die "FATAL: File target must be set as argument"; }
my $raw = read_file("$ARGV[0]");

my $TableExtract =  new HTML::TableExtract( headers => ["TRIM", "ASIGNATURA", "Nota1", "Nota2", "Nota3", 
	"Nota4", "Nota5", "Nota6", "Nota7", "Nota8", "Nota9", "Nota10", "Nota11", "Nota13", "Nota12", "Nota14", 
	"Nota15", "Prom. Parcial", "80% Prom. Parcial", "Prueba. Sintesis", "20% Prueba. Sint.", "P.P.final", 
	"P.A.final", "Resp.", "Part.", "Discip."] );

$TableExtract->parse($raw);

foreach my $TableSearch ( $TableExtract->tables ) {


#	my $test = $TableSearch->rows->[1]->[2];

	foreach my $rows ( $TableSearch->rows ) {

		$rows->[12] =~ s/\s+//g; # Trim no funciona con el cagazo de HTML de esa columna

		foreach (@$rows) { $_ = trim($_); } # Normalizar los campos de texto

		if ($rows->[0] eq '1') {
			print "$rows->[1]: ".
			"$rows->[2] $rows->[3] $rows->[4] $rows->[5] $rows->[6] ".
			"$rows->[7] $rows->[8] $rows->[9] $rows->[10] $rows->[11] $rows->[12] ".
			"$rows->[13] $rows->[14] $rows->[15] $rows->[16] ";
		}

		if ($rows->[0] eq '2') {
			print "$rows->[2] $rows->[3] $rows->[4] $rows->[5] $rows->[6] ".
			"$rows->[7] $rows->[8] $rows->[9] $rows->[10] $rows->[11] $rows->[12] ".
			"$rows->[13] $rows->[14] $rows->[15] $rows->[16]"."\n";
		}
		

	}

 }
