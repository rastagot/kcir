#!/usr/bin/perl

package Target;

use Common;
use Alias;

use strict;

our @target = ('ц0','ц1','ц2');
our @attack = ("kill", "ф kill", "bash", "chopoff");
our $curtar = 0;
our $curset = 0;
my @setoftargets = ("@target","@target","@target");
my @setofon = (0,0,0);

our $tname  = $target[$curtar];


sub killtarget
{
        my $stuff = "@_";
        $tname = $target[$curtar] = $stuff if length $stuff;
        Common::parser "$attack[0] $target[$curtar]";
}

sub setattack
{
        if (@_)
        {
                my $number = shift;
                my $nt = "@_";
                my $nt2 = $Alias::spells{$Alias::prof}{$nt};
		$nt2 = '' if $Alias::prof eq 'волхв';
                $nt = "$Alias::values{cast_command} !$nt2!" if length $nt2;
                $attack[$number] = "$nt" if length "$nt";
                P::echo "attack \3I[\3P$number\3I]\3H == $attack[$number]"
        }
        else 
        {
                my $cnt = 0;
                length $attack[$cnt] && P::echo "attack \3I[\3P$cnt\3I]\3H == " . $attack[$cnt++]  while (length $attack[$cnt])
        }
} 


P::alias {setattack} $Alias::values{cmd_setattack};
P::alias {setattack "0" , @_} $Alias::values{cmd_setattack}."0";
P::alias {setattack "1" , @_} $Alias::values{cmd_setattack}."1";
P::alias {setattack "2" , @_} $Alias::values{cmd_setattack}."2";
P::alias {setattack "3" , @_} $Alias::values{cmd_setattack}."3";
P::alias {setattack "4" , @_} $Alias::values{cmd_setattack}."4";
P::alias {setattack "5" , @_} $Alias::values{cmd_setattack}."5";
P::alias {setattack "6" , @_} $Alias::values{cmd_setattack}."6";
P::alias {setattack "7" , @_} $Alias::values{cmd_setattack}."7";
P::alias {setattack "8" , @_} $Alias::values{cmd_setattack}."8";

sub set_targets;
sub set_targets
{
	my $cnt = 1;
	my @thing = ();
	@_ = split /\s+/, "@_";
	for (@_)
	{
		my $obj = $_;
		if (/^\d+$/)
		{
			$cnt = $obj;
		}
		else
		{
			my @toadd = ($obj);
			@toadd = set_targets "@target" if $obj eq 'ц';
			for my $to (@toadd)
			{
				push @thing, $to;
				push @thing, "$_.$to" for 2..$cnt;
			}
			$cnt = 1;
		}
	}
	return @thing;

}

P::alias
{
	my @old;
	my $str = "@_";
	@target = set_targets "@_";
	$setoftargets[$curset] = "@target";
        Common::parser "$Alias::values{cmd_setcurtarget} $setofon[$curset]";
} $Alias::values{cmd_settargets};

P::alias
{
        $curtar = "@_";
        my $maxtar = scalar @target - 1;
        $curtar = 0 if $curtar < 0;
        $curtar = $maxtar if $curtar > $maxtar;
        $tname = $target[$curtar];
} $Alias::values{cmd_setcurtarget};

P::alias
{
        my $stuff = "@_";
        $stuff = $target[$curtar] unless length $stuff;
        Common::sparser "спрятат" unless $Common::in_hide;
	$Common::in_hide = 0;
	Common::sparser "заколоть $stuff";
} $Alias::values{backstab};

P::alias
{	
	my ($attack,$target) = @_;
	Common::eparser "прик двойник.$Common::ne убить $target;прик 2.двойник.$Common::ne спасти $target;$attack $target";
} 'дв1';

P::alias
{	
	my ($attack,$target) = @_;
	Common::eparser "прик 3.двойник.$Common::ne убить $target;прик 4.двойник.$Common::ne спасти $target;$attack $target";
} 'дв2';

P::bindkey {Common::eparser "$attack[0] $target[$curtar]" } $Alias::values{bind_attack0};
P::bindkey {Common::eparser "$attack[1] $target[$curtar]"} $Alias::values{bind_attack1};
P::bindkey {Common::eparser "$attack[2] $target[$curtar]"} $Alias::values{bind_attack2};
P::bindkey {Common::eparser "$attack[3] $target[$curtar]"} $Alias::values{bind_attack3};
P::bindkey {Common::eparser "$attack[4] $target[$curtar]"} $Alias::values{bind_attack4};
P::bindkey {Common::eparser "$attack[5] $target[$curtar]"} $Alias::values{bind_attack5};
P::bindkey {Common::eparser "$attack[6] $target[$curtar]"} $Alias::values{bind_attack6};
P::bindkey {Common::eparser "$attack[7] $target[$curtar]"} $Alias::values{bind_attack7};
P::bindkey {Common::eparser "$attack[8] $target[$curtar]"} $Alias::values{bind_attack8};

P::bindkey {Common::sparser "$attack[0] $_" for @target}'C-'.$Alias::values{bind_attack0};
P::bindkey {Common::sparser "$attack[1] $_" for @target} 'C-'.$Alias::values{bind_attack1};
P::bindkey {Common::sparser "$attack[2] $_" for @target} 'C-'.$Alias::values{bind_attack2};
P::bindkey {Common::sparser "$attack[3] $_" for @target} 'C-'.$Alias::values{bind_attack3};
P::bindkey {Common::sparser "$attack[4] $_" for @target} 'C-'.$Alias::values{bind_attack4};
P::bindkey {Common::sparser "$attack[5] $_" for @target} 'C-'.$Alias::values{bind_attack5};
P::bindkey {Common::sparser "$attack[6] $_" for @target} 'C-'.$Alias::values{bind_attack6};
P::bindkey {Common::sparser "$attack[7] $_" for @target} 'C-'.$Alias::values{bind_attack7};
P::bindkey {Common::sparser "$attack[8] $_" for @target} 'C-'.$Alias::values{bind_attack8};

P::bindkey {Common::sparser "$attack[0] $_" for reverse @target}'M-'.$Alias::values{bind_attack0};
P::bindkey {Common::sparser "$attack[1] $_" for reverse @target} 'M-'.$Alias::values{bind_attack1};
P::bindkey {Common::sparser "$attack[2] $_" for reverse @target} 'M-'.$Alias::values{bind_attack2};
P::bindkey {Common::sparser "$attack[3] $_" for reverse @target} 'M-'.$Alias::values{bind_attack3};
P::bindkey {Common::sparser "$attack[4] $_" for reverse @target} 'M-'.$Alias::values{bind_attack4};
P::bindkey {Common::sparser "$attack[5] $_" for reverse @target} 'M-'.$Alias::values{bind_attack5};
P::bindkey {Common::sparser "$attack[6] $_" for reverse @target} 'M-'.$Alias::values{bind_attack6};
P::bindkey {Common::sparser "$attack[7] $_" for reverse @target} 'M-'.$Alias::values{bind_attack7};
P::bindkey {Common::sparser "$attack[8] $_" for reverse @target} 'M-'.$Alias::values{bind_attack8};

P::bindkey {$curtar--; Common::parser "$Alias::values{cmd_setcurtarget} $curtar"} $Alias::values{bind_prevtar};
P::bindkey {$curtar++; Common::parser "$Alias::values{cmd_setcurtarget} $curtar"} $Alias::values{bind_nextar};
P::bindkey 
{
	$setofon[$curset] = $curtar;
	$curset-- if $curset > 0; 
	Common::parser "$Alias::values{cmd_settargets} $setoftargets[$curset]"
} $Alias::values{bind_prevsettar};

P::bindkey 
{
	$setofon[$curset] = $curtar;
	$curset++ if $curset < @setoftargets - 1; 
	Common::parser "$Alias::values{cmd_settargets} $setoftargets[$curset]"
} $Alias::values{bind_nextsettar};

1;
