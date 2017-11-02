#!/usr/bin/perl

package Exchange;

use strict;
use Socket;
use Common;

our $printout = 0;
our $printin = 0 ;
my ($hostout,$portout) = split /:/,$Conf::public_server_out;
my ($hostin,$portin) = split /:/,$Conf::public_server_in;

my $refresh_timeout = 0.5;
my $rin = '';
my $rout;
my $nfound;
my $line;
sub end_process
{
	Common::sparser "killall";
	P::echo "\3PОкончено";
	$printout = 0;
}
sub get_command
{
	return unless $printout;
	$nfound = select ($rout = $rin,undef,undef,0.01);
	return unless $nfound;
	return end_process if ($nfound < 0);
	recv (S, $line, 120, 0);
        P::sendl $line if (length $line);
}

P::alias
{
	my $peer = sockaddr_in ($portout, inet_aton ($hostout));
	socket(S,PF_INET,SOCK_STREAM,0);
	connect (S, $peer);
	vec ($rin,fileno(S),1) = 1;
	$printout = 1;
	P::timeout \&get_command,$refresh_timeout,-1;
} '_вывод_на_сервер_обмена';

P::trig
{
	send(S,MUD::toansi($;)."\r\n",0) if $printout;
} '^(.*)', 'f20000';

P::alias
{
	$printin = 1;
	Common::sparser "${Conf::char}connect $hostin $portin";
} '_подключиться_к_серверу_обмена';

P::alias
{
	$printin = 0;
	Common::sparser "${Conf::char}dc";
} '_отключиться';

1;
