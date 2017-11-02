#!/usr/bin/perl
#��������� �������, �������� ����� �� ������ � ������������ ��������, � ����� �������� ���������� �� ���������
package Common;
use strict;

our $echo = 1;
our $inbattle = 0;
our $in_hide = 0;
our $ne = 'unknown';
our $time = time;
our $autoscan = 0;
our $speedwalk = 0;
our $shield = '';
our $lwp = '';
our $rwp = '';
our $inst = 0;
our $dwp = '';
our $light = '';
our $bashed = 0;
our $clock = '';
our $ateq = 0;
our %dt_directions = ();
our $triggerpent = 0;
our $connected = 0;
our $scheme = 0;
our $lline= "{=-";
our $line= "-=}";
our $autoloot = 1;
our $dodge = '�����';
our $dodge_delay = 1;
our $resccommand = 'rescue';
our $sost = '';
our $heal_command = '';
our $tank = '';

sub screcho($) 
{
        P::echo("\3P                                                         @_")
}


P::trig 
{
	$sost = '������';
} '^(�� ������� ���������|�� ����|�� ���������� � ����|�� ������������ ��������� ��� ������)';

P::trig 
{
	$sost = '';
	$inst = 0;
} '^(�� ���������� �������� � ������|�� ������|�� ������� ����|� �� ��� ������)';

P::trig
{
	$sost = '�����;������';
} '^�� �������';

sub rlower($) 
{
        $_ = shift;
        tr/A-Z��������������������������������'/a-z��������������������������������+/;
        $_;
}

sub rupper($) 
{
	$_ = shift;
        tr/a-z��������������������������������+/A-Z��������������������������������'/;
	$_;
}

sub fupper($)
{
        $_ = shift;
        /(.)(.*)/;
        rupper ($1) . $2;
}

sub parser($) 
{
	Parser::run_commands(shift)
}

sub sparser($) 
{
	$echo = 0; 
	parser shift; 
	$echo = 1
}

sub eparser($)
{
      P::echo "\3" . chr(ord('A')+$Conf::incolor) . "[$_[0]]";
      sparser shift;
}

sub get_color($$) 
{
	return chr(ord(substr($_[0], 2*$_[1]+1, 1))+ord('A'));
}

sub str2mob($)
{
        my $b = $_[0];
        $b =~ s/['"]//g;
        my @words = split / /, $b;
        my $desc = shift @words;
        my $second;
        for (@words)
        {

                $second = shift @words;
                if (length $second > 3)
                {
                        $desc .= ".$second";
                        last;
                }
        }
        return rlower $desc;
}

1;
