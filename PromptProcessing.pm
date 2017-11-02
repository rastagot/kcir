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

        if ($ucprompt =~ /^������� : </)
        {
                Common::sparser ";";
                return ' ';
        }

	if ($Connect::atc)
	{
		my $coding = $Conf::windows ? 2:0;
		P::sendl $coding if $ucprompt =~ /Select one/;
		if ($ucprompt =~ /� ����� � ���������� ��������/) {$Connect::atc = 0; Common::eparser ";���"}
		if ($ucprompt =~ /�������������/)
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
		if ($ucprompt =~ /^��� : /)
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
	P::echo "\3P���� ����� ����� ������" if $Common::triggerpent;
	return '>' if $Exchange::printin;
	$prompt;
} "prompt";

P::alias
{
        Common::sparser "${Conf::char}kill $_" for (0..15);
        Rescue::setup;	
	Mws::windows_setup if $Conf::windows;
	$Dodge::shutdown = $Dodge::active = 0;
	Common::sparser '_����������';
} $Alias::values{cmd_killall};


my %dcommands = 
(
	'�' => 1,
	'�' => 1,
	'�' => 1,
	#'�' => 1,
	'��' => 1,
	'��' => 1,
	'��' => 1,
	'���' => 1,
	'���' => 1,
	'���' => 1,
);
my %tcommands =
(
        '�' => 1,
        '�' => 1,
        '�' => 1,
        '�' => 1,
	'���' => 1,
	'���' => 1,
	'��' => 1,
	'��' => 1,
        '��' => 1,
        '��' => 1, 
        '��' => 1,
        '���' => 1,
        '���' => 1,
        '���' => 1,

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
			P::echo "\3J[�����]\3L ��� � ������ � ��!";
			return '';
		}
        	for (keys %Alias::eng_aliases)
        	{
                	if ($first =~ /^$_$/) {$first = $Alias::eng_aliases{$_};last}
        	}

	}
	
	if (exists $tcommands{$first} and length "@words")
	{
		P::echo "\3J[�����]\3L ��� � ������ � ��!";
		return '';
	}
	

	if (length $first)
	{
		for  my $dir (keys %Common::dt_directions)
		{
			if ($dir =~ /^$first/ and $Common::dt_directions{$dir})
			{
				P::echo "\3J[������\3J]\3L ����� � �� ������? ������ � ����? ����� ������� '$first!'";
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
