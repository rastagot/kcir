#!/usr/bin/perl

package PromptProcessing;

use Common;
use Alias;

use Connect;
use Rescue;
use Dodge;


use Mws;
#use Exchange;
use Group;

use strict;

my $block = 0;
my $prompt = '';

P::hook
{
	$prompt = shift;
	my $ucprompt = CL::strip_colors(CL::parse_colors($prompt));

        if ($ucprompt =~ /^Ћистать : </)
        {
                Common::sparser ";";
                return ' ';
        }

	if ($Connect::atc)
	{
		my $coding = $Conf::windows ? 2:0;
		P::sendl $coding if $ucprompt =~ /Select one/;
		if ($ucprompt =~ /¬ св€зи с проблемами перевода/) {$Connect::atc = 0; Common::eparser ";очк"}
		if ($ucprompt =~ /ѕредставьтесь/)
		{
			if (length $Common::ne && $Common::ne ne "unknown")
			{
				if (length $Connect::pass)
				{
					Common::sparser "$Common::ne $Connect::pass";
				}
				else
				{
					Common::eparser $Common::ne;
				}
			}
		}
		if ($ucprompt =~ /^»м€ : /)
		{
			Common::eparser $Common::ne if (length $Common::ne && $Common::ne ne "unknown");
		}

	}
	if ($Common::inbattle = ($ucprompt =~ /\[/))
	{
		$Common::in_hide = 0;
		if ( $ucprompt !~ /\[$Common::ne:[^\]]*?\] (\[[^\]]*\] >)/ && $Rescue::resc && !$block)
		{
			$ucprompt =~ /\[$Common::ne:[^\]]*?\] \[(.*?):/;
			Rescue::rescue $Rescue::rescmnR{$1} if defined $Rescue::rescmnR{$1};
			$block = 1;
		}
	}
	if ($Dodge::dodgeon && !$Dodge::active && $Common::inbattle)
	{
		Dodge::actswitch;
		Dodge::dodge_timer;
	}
	$Dodge::shutdown = 1 if ($Dodge::dodgeon && $Dodge::active && !$Common::inbattle);
	$Common::ateq = 0;
	$Group::group_spam = 0;
	P::echo "\3P∆дем пенту чтобы влезть" if $Common::triggerpent;
	return '>' if $Exchange::printin;
	$prompt;
} "prompt";

P::alias
{
        Common::sparser "${Conf::char}kill $_" for (0..15);
        Rescue::setup;	
	Mws::windows_setup if $Conf::windows;
	$Dodge::shutdown = $Dodge::active = 0;
	Common::sparser '_спр€татьс€';
} $Alias::values{cmd_killall};


my %dcommands = 
(
	'с' => 1,
	'ю' => 1,
	'з' => 1,
	#'в' => 1,
	'за' => 1,
	'во' => 1,
	'се' => 1,
	'зап' => 1,
	'сев' => 1,
	'вос' => 1,
);
my %tcommands =
(
        'с' => 1,
        'ю' => 1,
        'з' => 1,
        'в' => 1,
	'вве' => 1,
	'вни' => 1,
	'вн' => 1,
	'вв' => 1,
        'за' => 1,
        'во' => 1, 
        'се' => 1,
        'зап' => 1,
        'сев' => 1,
        'вос' => 1,

);


P::hook
{
        my $all = join ' ', @_;
	return $all if $Exchange::printin;

	
	my $mess = '';
        my @words = split /\s+/, $all;
	my @b = @words;
	my $t = shift @b;

	if ( (scalar @words > 1) && !$Common::atc && $Common::connected)
	{
		if ($t != /^\_/ && exists $Alias::rvalues{$t} or exists $Alias::spells{$Alias::prof}{$t})
		{
			my $back = $words[-1];
			$words[-1] = ".$Group::group{$back}" if ( $back =~ /^\d+$/ && $back < $Group::group_number);
		}
	}
        my $first = shift @words;
	
        if ($Alias::values{arda_commands})
        {
		if (exists $dcommands{$first})
		{
			P::echo "\3J[»ƒ»ќ“]\3L так и уход€т в дт!";
			return '';
		}
        	for (keys %Alias::eng_aliases)
        	{
                	if ($first =~ /^$_$/) {$first = $Alias::eng_aliases{$_};last}
        	}

	}
	
	if (exists $tcommands{$first} and length "@words")
	{
		P::echo "\3J[»ƒ»ќ“]\3L так и уход€т в дт!";
		return '';
	}
	

	if (length $first)
	{
		for  my $dir (keys %Common::dt_directions)
		{
			if ($dir =~ /^$first/ and $Common::dt_directions{$dir})
			{
				P::echo "\3J[ћјЌ№я \3J]\3L зачем в дт лезешь? уверен в себе? тогда набирай '$first!'";
				return '';
			}
		}
	}
	
        if (@words)
        { 
                $mess = "$first @words" 
        } 
	else 
        { 
        	$mess = $first;  
	}
	
        return $mess unless $Common::echo && !$Connect::atc;
	
        my $echo = "[$mess]";
	$echo = '' unless length $mess;

        if ($Common::connected)
        {
                P::echo ($prompt ."\3" . chr(ord('A')+$Conf::incolor).$echo) unless $Connect::atc;
        }
        else
        {
                P::echo ("\3" . chr(ord('A')+$Conf::incolor).$echo) unless $Connect::atc;
        }

        $mess;

} 'input';

1;
