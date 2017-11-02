#!/usr/bin/perl

package Mws;

use Common;
use Alias;

use strict;

our %name2pid= ();
my $fname = ".$$";
my $my_ident = $Common::ne;
 
my $s_delay = 3000;
my $s_out = 1;
my $mws_file = ".mws";
my $online = 0;

sub setup
{
 	return ($online = 1 and P::timeout \&setup,$s_delay,$s_out) unless $online; 
	open FECHO, ">>$mws_file";
        print FECHO "$$:$Common::ne\n";
	close FECHO;
}

sub unsetup
{
	return P::timeout \&unsetup,$s_delay,$s_out unless (-e $mws_file);

	my %all_mmcs = ();

	if (!$Conf::windows)
	{
		my @tmp = `ps | grep kcir | grep -v grep | grep -v sh`;
		chomp @tmp;
		s/^\s+(\d+).+$/$1/ for @tmp;
		$all_mmcs{$_} = 1 for @tmp;
	}

	open FFROM, "$mws_file";
	my @data = <FFROM>;
	close FFROM;
	open FTO, ">$mws_file";

	for (@data)
	{
		/^(\d+):/;
		if (!$Conf::windows)
		{
			next unless exists $all_mmcs{$1};
		}
		print FTO $_ if $1 != $$;
	}
	close FTO;
	$online = 0;
}

unsetup;

P::alias 
{
	P::echo "\3J$$"
} $Alias::values{showpid};

sub message ($$)
{
        return unless exists $name2pid{$_[0]};
        my $pid2 = $name2pid{$_[0]};
	my $filename = ".$pid2";
        open MSG, ">>$filename";
        print MSG "$_[1]\n";
        close MSG;
        kill 'USR1', $pid2 if !$Conf::windows;
};

P::alias 
{ 
	my $obj = shift; 
	message $obj, "@_" 
} $Alias::values{cmd_mws_force};

sub check
{
	return unless (-e $fname);
	open MSG, "<$fname";
	my @all = <MSG>;
	close MSG;
	unlink $fname;
	for (@all)
	{
		chomp;
		next unless length $_;
		Common::parser $_;
	}
}

sub windows_setup
{
	P::timeout \&check, 200, -1;
}

if ($Conf::windows)
{
	windows_setup;
}
else
{
	$SIG{USR1} = \&check;
}

P::bindkey
{
	for (keys %name2pid)
	{	
		Common::sparser "${Conf::char}unalias $_";
	}
	%name2pid = ();
	open FFROM, "<$mws_file";
	for (<FFROM>)
	{
		chomp;
		close UECHO;
		my ($pid,$name) = split /:/;
		if ($pid != $$ and $name ne $Common::ne)
		{

			$name2pid{$name} = $pid;

                	P::alias 
			{
				Common::eparser "$Alias::values{cmd_mws_force} $name @_" 
			} "$name";


		}
	}
	
        P::echo "\3J[$name2pid{$_}] -> $_" for keys %name2pid;
} $Alias::values{bind_window};
 
P::alias
{
        my $command = "@_";
        Common::eparser "$Alias::values{cmd_mws_force} $_ $command" and sleep 1 for (keys %name2pid);
        Common::eparser "$command";
} $Alias::values{cmd_mws_waitforceall};

P::alias
{
        my $command = "@_";
        Common::eparser "$Alias::values{cmd_mws_force} $_ $command" for (keys %name2pid);
        Common::eparser "$command";
} $Alias::values{cmd_mws_forceall};

P::alias
{
        my $dir = shift @_;
	for my $what (@_)
	{
        	P::alias 
		{
			my $th = ''; 
			$th = " @_" if length "@_"; 
			Common::eparser "f $dir $what$th"
		} $what;
	}
} $Alias::values{cmd_mws_redirect};


P::bindkey
{
        Common::eparser "$Alias::values{cmd_mws_force} $_ $Alias::values{recallem} $Common::ne" for (keys %name2pid);
        Common::eparser "~;зач возврат;взя возврат $Alias::values{locker}";
} $Alias::values{bind_recall};

1;
