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

			#removemos las notas "vacías" ( - )
			for (my $i=2; $i <= 16; $i++) {
				if ($rows->[$i] ne '-') { push(@notasprimer, $rows->[$i]); } else {
					push(@notasprimer, undef);
				}
			}


			$notas{$currentasig}{'primersemestre'}{'notas'} = [@notasprimer];
			$notas{$currentasig}{'primersemestre'}{'sintesis'} = undef;

			if ($rows->[19] ne '-') { $notas{$currentasig}{'primersemestre'}{'sintesis'} = $rows->[19]; }

		}

		# Luego las del segundo semestre
		if ($rows->[0] eq '2') {

			my @notassegundo;

			#removemos las notas "vacías" ( - )
			for (my $i=2; $i <= 16; $i++) {
				if ($rows->[$i] ne '-') { push(@notassegundo, $rows->[$i]); } else {
					push(@notassegundo, undef);
				}
			}


			$notas{$currentasig}{'segundosemestre'}{'notas'} = [@notassegundo];
			$notas{$currentasig}{'segundosemestre'}{'sintesis'} = undef;

			if ($rows->[19] ne '-') { $notas{$currentasig}{'segundosemestre'}{'sintesis'} = $rows->[19]; }

		}
		

	}

 }

 print to_json(\%notas);