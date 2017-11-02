#o!/usr/bin/perl 
#коннект, втч и проксевый

package Connect;

use Common;
use Alias;
use Mws;
use Baze;

use strict;

my @proxl = ();

open PROXYFILE, $Conf::config_rc_proxy_file;
while (<PROXYFILE>)
{
	chomp;
	s/:/ /;
	push @proxl, $_;
};
close PROXYFILE;

our $pass = '';
our $atc = 0;
my $host = '';
my $port = '';
my $try_count = 0;
my $proxy = 0;

sub mud_connect
{
	P::timeout \&mud_connect, $Alias::values{conn_timeout}*1000, 1; 
	CL::msg "Connecting to $host:$port, try " . $try_count++;
	Common::sparser "${Conf::char}connect $host $port";
}

sub generic_mud_connect
{
        my ($lhost, $lport, $lname, $lpass) = @_;
        $host = $lhost if defined $lhost;
        $port = $lport if defined $lport;

	if (defined $lname)
	{
		$Common::ne = $lname;
	}
	else {$Common::ne = ''}

	if (defined $lpass)
	{
        	$pass = $lpass
	} else {$pass = ''}

        CMD::cmd_dc if $Common::connected;
        Common::sparser $Alias::values{cmd_killall} if $atc;
        $atc = 1;
	$try_count = 0;
	mud_connect;
}

sub proxy_connect
{
        $proxy = 1;
        my $number = shift;
        return if $number > scalar @proxl;
        generic_mud_connect split (/ /, $proxl[$number]), @_
}; 

P::alias
{
	$proxy = 1;
	my ($host,$port) = split /[: ]/, "@_";
	generic_mud_connect $host, $port;
} 'connect';

for (0..(scalar @proxl - 1) )
{
	my $n = $_;
	P::alias {proxy_connect $n,@_} "$Alias::values{cmd_proxy_connect}$n";
}

P::alias 
{
	generic_mud_connect $Alias::values{conn_host}, $Alias::values{conn_port}, @_ 
} $Alias::values{cmd_connect};

P::alias 
{
	generic_mud_connect "localhost",  $Alias::values{local_port}, @_ 
} $Alias::values{cmd_connect_local};


P::trig 
{
	$atc = 0; 
	Common::eparser 'очк'
} '^(Пересоединяемся|Ваша душа вновь вернулась в тело, которое так ждало ее возвращения !)';

P::hook
{
	if ($Alias::values{log})
	{
		my ($day, $mon, $year) = (localtime)[3,4,5];
		$year += 1900;
		$mon += 1;
		$day = '0'.$day if $day < 10;
		$mon = '0'.$mon if $mon < 10;
		my $logname = $Conf::logs_folder . Common::rlower $Common::ne . "\#$day-$mon-$year.log";
		MUD::logopen $logname;
	}
        $Common::connected = 1;
        Common::sparser $Alias::values{cmd_killall};
	if ($proxy)
	{
        	CL::msg "Redirecting to mud.ru..." if $proxy;
        	Common::sparser "CONNECT 194.87.5.70 HTTP/1.0;;;" if $proxy;
        	$proxy = 0;
	}
	Mws::setup;
} "connect";

P::hook
{
        MUD::logopen() if $Alias::values{log};	
	Mws::unsetup;
	Baze::reload;
        $Common::connected = 0;
} "disconnect";



1;
