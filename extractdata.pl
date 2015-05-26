# Author: Pato Sáinz
# 20150524

use Modern::Perl '2015'; # strict, warnings, autodie, etc.
use HTML::TableExtract;
use File::Slurp;
use String::Util 'trim';
use Mojo::JSON qw(encode_json to_json);

##########################################
use Data::Dumper; # Am I debugging?
##########################################

unless (defined($ARGV[0])) { die "FATAL: File target must be set as argument"; }
my $raw = read_file("$ARGV[0]");

my %notas;

my $TableExtract =  new HTML::TableExtract( headers => ["TRIM", "ASIGNATURA", "Nota1", "Nota2", "Nota3", 
	"Nota4", "Nota5", "Nota6", "Nota7", "Nota8", "Nota9", "Nota10", "Nota11", "Nota13", "Nota12", "Nota14", 
	"Nota15", "Prom. Parcial", "80% Prom. Parcial", "Prueba. Sintesis", "20% Prueba. Sint.", "P.P.final", 
	"P.A.final", "Resp.", "Part.", "Discip."] ); # Cargamos manualmente los nombres de las columnas

$TableExtract->parse($raw);

# Loop principal
foreach my $TableSearch ( $TableExtract->tables ) {


	# my $test = $TableSearch->rows->[1]->[2];

	# Por cada fila
	foreach my $rows ( $TableSearch->rows ) {

		our $currentasig;


		$rows->[12] =~ s/\s+//g; # Normalizar este campo; Trim no funciona con el HTML corrupto de esa columna

		foreach (@$rows) { $_ = trim($_); } # Normalizar los campos de texto

		# Sacamos la asignatura y las notas del primer semestre
		if ($rows->[0] eq '1') {

			# r1: asignatura
			# r2-r16: notas
			# r19: síntesis

			$currentasig = $rows->[1];

			my @notasprimer;
			if ($rows->[2] ne '-') { push(@notasprimer, $rows->[2]); }
			if ($rows->[3] ne '-') { push(@notasprimer, $rows->[3]); }
			if ($rows->[4] ne '-') { push(@notasprimer, $rows->[4]); }
			if ($rows->[5] ne '-') { push(@notasprimer, $rows->[5]); }
			if ($rows->[6] ne '-') { push(@notasprimer, $rows->[6]); }
			if ($rows->[7] ne '-') { push(@notasprimer, $rows->[7]); }
			if ($rows->[8] ne '-') { push(@notasprimer, $rows->[8]); }
			if ($rows->[9] ne '-') { push(@notasprimer, $rows->[9]); }
			if ($rows->[10] ne '-') { push(@notasprimer, $rows->[10]); }
			if ($rows->[11] ne '-') { push(@notasprimer, $rows->[11]); }
			if ($rows->[12] ne '-') { push(@notasprimer, $rows->[12]); }
			if ($rows->[13] ne '-') { push(@notasprimer, $rows->[13]); }
			if ($rows->[14] ne '-') { push(@notasprimer, $rows->[14]); }
			if ($rows->[15] ne '-') { push(@notasprimer, $rows->[15]); }
			if ($rows->[16] ne '-') { push(@notasprimer, $rows->[16]); }


			$notas{$currentasig}{'primersemestre'}{'notas'} = [@notasprimer];
			$notas{$currentasig}{'primersemestre'}{'sintesis'} = undef;

			if ($rows->[19] ne '-') { $notas{$currentasig}{'primersemestre'}{'sintesis'} = $rows->[19]; }

		}

		# Luego las del segundo semestre
		if ($rows->[0] eq '2') {

			my @notassegundo;
			if ($rows->[2] ne '-') { push(@notassegundo, $rows->[2]); }
			if ($rows->[3] ne '-') { push(@notassegundo, $rows->[3]); }
			if ($rows->[4] ne '-') { push(@notassegundo, $rows->[4]); }
			if ($rows->[5] ne '-') { push(@notassegundo, $rows->[5]); }
			if ($rows->[6] ne '-') { push(@notassegundo, $rows->[6]); }
			if ($rows->[7] ne '-') { push(@notassegundo, $rows->[7]); }
			if ($rows->[8] ne '-') { push(@notassegundo, $rows->[8]); }
			if ($rows->[9] ne '-') { push(@notassegundo, $rows->[9]); }
			if ($rows->[10] ne '-') { push(@notassegundo, $rows->[10]); }
			if ($rows->[11] ne '-') { push(@notassegundo, $rows->[11]); }
			if ($rows->[12] ne '-') { push(@notassegundo, $rows->[12]); }
			if ($rows->[13] ne '-') { push(@notassegundo, $rows->[13]); }
			if ($rows->[14] ne '-') { push(@notassegundo, $rows->[14]); }
			if ($rows->[15] ne '-') { push(@notassegundo, $rows->[15]); }
			if ($rows->[16] ne '-') { push(@notassegundo, $rows->[16]); }


			$notas{$currentasig}{'segundosemestre'}{'notas'} = [@notassegundo];
			$notas{$currentasig}{'segundosemestre'}{'sintesis'} = undef;

			if ($rows->[19] ne '-') { $notas{$currentasig}{'segundosemestre'}{'sintesis'} = $rows->[19]; }

		}
		

	}

 }

 print to_json(\%notas);
