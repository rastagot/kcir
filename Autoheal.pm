#!/usr/bin/perl 

package Autoheal;
use Common;
use Alias;
use strict;

our $autoheal_on = 0;

P::alias
{
	my $value = shift;
	if (! length $value)
	{
		P::echo 'Команда автохил используется так - один параметр (число)';
		P::echo 'означающее степень повреждения согрупника на котором его';
		P::echo 'надо хилять';
		P::echo '3 - Ранен. 2 - Тяж.Ранен. 1 - Оч.Тяж.Ран.';
		P::echo '0 - отключить эту фичу';
	}
	else
	{
		$autoheal_on = $value;	
	}
} $Alias::values{cmd_autoheal};

P::alias
{
	$Common::heal_command = "@_";
} $Alias::values{cmd_setautohealcommand};



sub check($$$)
{
	my ($obj,$health,$colr) = @_;
	$health =~ s/^\s*([^ ]+)\s*$/$1/;
	if ( ($health eq 'Ранен' && $colr eq 'L' && $autoheal_on >= 3) || 
	     ($health eq 'Тяж.ранен' && $colr eq 'J' && $autoheal_on >= 2) ||
	     ($health eq 'Оч.тяж.ран' && $colr eq 'B' && $autoheal_on >= 1) ||
	     ($health eq 'При смерти' && $colr eq 'B')
	   )
	{	
		Common::sparser $Alias::values{cmd_toup};
		Common::sparser "$Common::heal_command .$obj";
	}

};


1;
