#!/usr/bin/env perl
# Author: Pato Sáinz
# 20150528

use Modern::Perl '2015';
use File::Slurp;
use Mojo::UserAgent;

#sub fetch {

	my $ua = Mojo::UserAgent->new;
	$ua   = $ua->transactor(Mojo::UserAgent::Transactor->new);
	$ua->transactor->name('Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.18 Safari/537.36');
	$ua     = $ua->max_redirects(3);
	my $cookie_jar = $ua->cookie_jar;
	$ua = $ua->cookie_jar(Mojo::UserAgent::CookieJar->new);

	my ($usuario, $passowrd) = @_;

	my $tx = $ua->post('http://genesis.cvd.cl/colegio/alumnos.asp' => form => {Usuario => $usuario, Password => $password, Submit => 'Aceptar'});

	if (my $res = $tx->success) {
		
		if ($res->body =~ /ACTUALIZAR LOS DATOS EN TODOS LOS ALUMNOS/) {
			#
			#
			#
			#
			#
			#
			#
			#
			...;
	 	}
		elsif ($res->body =~ /Error de Autenticacion/) { die "Usuario/Clave incorrecto(s)." }
		else { die "Error desconocido (fetch)."; }

	} else {
  	my $err = $tx->error;
  	die "$err->{code} response: $err->{message}" if $err->{code};
  	die "Connection error: $err->{message}";
	}

# }

# 1;