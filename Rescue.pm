#!/usr/bin/perl

package Rescue;
#���������, ����� ���������� �������� ���� ������, ������ �������� ��� ����� �����

use Common;
use Alias;

use strict;

my @wepmodif =
(
        "������", "�������", "��������", "�������","������", "�����",
        "��������", "�������","��������", "����������","������", "������",
        "�����" , "������","������", "������","����", "����", "��������",
);

my @infwepmodif = ();

for (@wepmodif)
{
        chop (my $elem = $_);
        $elem = "�������.{2,3} $elem��";
        push @infwepmodif, $elem;
        $_ .= ".?";
}

my $wepstr = join "|", @wepmodif;
my $wepstr2 = join "|", @infwepmodif;

my @specwepattmn =
(
        "^(.*?) ��������.? � ���������� ������, �����",
        "^(.*?) �������� ����������� �����, ����� ��������� �������",
        "^(.*?) ������������� ��������",
        "^(.*?) ������ � ��������� �� ���������� �������",
        "^(.*?) ��������.? ��������",
        "^(.*?) .* �� �����",
        "^(.*?) ��������� �� ������� .* �������� ���",
	"^(.*?) �����.? ���������� �� �����",
	"^(.*?) �������",
	"^.*? �� ����.? �������� (.*?) -",
);

my @specwepatt =
(
        "��������.? ��� �� (.*?)\\.",
        "���.?.? ������.? � ����� (.*?)\\.",
        "���� � ����� (.*?)[,\\.]",
        "������ .*? �������.? (.*) �� �����",
        "�������.? (.*?) �� ����� ������ ������",
        "�������� (.*?), �� ��.? ���������",
        "���������� ����� ������ (.*?) ��������� ��������",

);
my @specwepattvor =
(
        "��������� ������� (.*?) ���� � �����",
);

my $howstr = "( | �������� | ������ | ������ | ����� ������ | ����������� ������ | ������� | ������ | ����� ������ | ����������� ������ | ���������� ������ | ������ | ���������� )";


my %autoresc = ();
my %lasthits = ();
my %autoreschits = ();
my %recall = ();
my %rescmn = ();
our %rescmnR = ();
my %tvor = ();
our $resc = 1;
my $resc_mode = 1;
my @infwepmodif = ();

sub rescue($)
{
        return unless $resc;

        if ($autoresc{"@_"} == 1)
        {
                my $mn = "@_";
                $mn = $rescmn{$mn} if defined $rescmn{$mn};
                return if exists $autoreschits{$mn};
                Common::eparser "$Common::resccommand .$mn";
                $autoreschits{$mn} = 2;
        }
        elsif ($autoresc{"@_"} == 0)  {$lasthits{"@_"} = 5}
};

P::alias
{
        my $number = "@_" or 0;
        for (keys %autoresc)
        {
                my $mn = $_;
                $mn = $rescmn{$mn} if defined $rescmn{$mn};
                $mn = ".$mn";
                $mn =~ s/\.~//;
                Common::eparser "$Common::resccommand $mn" if $autoresc{$_} == $number;
        }

} $Alias::values{resc_mode};

P::alias
{
        for (keys %lasthits)
        {
                my $mn = $_;
                $mn = $rescmn{$mn} if defined $rescmn{$mn};
                Common::eparser "$Common::resccommand .$mn";
        }
} $Alias::values{resc_last};


P::trig
{	
	return unless exists $autoresc{"$4"};
        rescue $4;
	$; .= CL::parse_colors (" " x (90 - length $;) . "\3I[ \3J!\3I ]\3H ") if ($resc and $autoresc {$4} == 0);
} "^(.*?)$howstr($wepstr) (.+)\\.",'f2000';

P::trig
{
	return unless exists $autoresc{"$3"};
        rescue $3;
	$; .= CL::parse_colors (" " x (90 - length $;) . "\3I[ \3J!\3I ]\3H ") if ($resc and $autoresc {$3} == 0);
} "^(.*?) ($wepstr2) (.+),",'f2000';


P::trig {rescue $1 if defined $rescmn{$1} } $_, 'f2000' for @specwepatt;
P::trig {rescue $rescmnR{$1} if defined $rescmnR{$1} } $_, 'f2000' for @specwepattmn;
P::trig {rescue $tvor{$1} if defined $tvor{$1} } $_, 'f2000' for @specwepattvor;

sub main_resc;

P::alias
{
        $resc_mode = 1;
        main_resc @_;
} $Alias::values{add_autoresc};

P::alias
{
        $resc_mode = 0;
        main_resc @_;
} $Alias::values{add_butresc};

P::alias
{
        $resc_mode = shift;
        main_resc @_;
} $Alias::values{add_specresc};

sub main_resc
{
        return Common::parser $Alias::values{showrescmodes} unless length "@_";
        my ($mainname,$ad1,$ad2,$ad3) = split /\s+/, "@_";
	my $added;
	my $tvorp;

        if (length $ad2)
        {
                $added = $mainname.$ad2;
                $mainname = $mainname.$ad1;
        }
        else
        {
                $added = $mainname.$ad1;
        }
        if ($mainname =~ /^(.*)[��������]$/) {$tvorp = "$1�"}
        elsif ($mainname =~ /^(.*)�$/) {$tvorp = "$1�"}
        elsif ($mainname =~ /^(.*)�$/) {$tvorp = $mainname}
        else {$tvorp = "$mainname�"}
        $mainname =~ s/^\.//;
        $added =~ s/^\.//;
        $mainname = "~$mainname" if ($mainname =~ /\./);
        if (exists $autoresc{$added})
        {
                if ($autoresc{$added} == $resc_mode)
                {
                        P::echo "\3Iresc_delete $added";
                        delete $autoresc{$added};
                        delete $rescmnR { $rescmn{$added} };
                        delete $rescmn {$added};
			delete $tvor{$tvorp};
			delete $recall{$mainname};
                }
                else
                {
                        $autoresc{$added} = $resc_mode;
                        P::echo "\3Iresc_mode_set for $added : $resc_mode"
                }
        }
        else
        {
                P::echo "\3Iresc_add for $added, mode : $resc_mode";
                $autoresc{$added} = $resc_mode;
                $rescmn{$added} = $mainname;
                $rescmnR{$mainname} = $added;
                $tvor{$tvorp} = $added;
		$recall{$mainname} = 1 if ($mainname ne (Common::fupper $Common::ne) ) ;
        }
};

P::alias
{
        %autoresc = ();%rescmnR = ();%tvor = ();
        %recall = ();%rescmn = ();
        P::echo ("\3Iautoresc & recall list cleared");
} $Alias::values{cmd_clearresc};

P::alias
{
        my $torecall = "@_";
        return Common::parser $Alias::values{showrescmodes} unless length $torecall;
        $torecall =~ s/\.//;

        if ($recall{$torecall})
        {
                P::echo ("\3Irecall\3P-\3I[\3P$torecall\3I]"); delete $recall{$torecall};
        }
        else
        {
                P::echo ("\3Irecall\3P+\3I[\3P$torecall\3I]"); $recall{$torecall} = 1;
        }

} $Alias::values{add_recallresc};

my $clone_number = 1;

P::alias
{
 	my $clone_name = $clone_number . ".�������." . $Common::ne;
	my $target = "@_";

	$target = '.'.$Common::ne unless length $target;
	Common::sparser "���� ������� $clone_name;order $clone_name ��� ������� $target";
	$clone_number = $clone_number + 1;
	$clone_number = 1 if ($clone_number eq 5);
} '���������_������';

P::bindkey
{
	Common::sparser $Alias::values{recallall};
} $Alias::values{bind_recallall};

P::alias
{
        if ($Alias::prof eq '�����' or $Alias::prof eq '������')
        {
                Common::eparser "���������";
        }
        elsif ($Alias::prof eq '������')
        {
                $clone_number = 1;
                my $nor = 1 + scalar keys %recall;
                Common::eparser "~;��� $nor ������� $Alias::values{locker}";
                Common::eparser "���������_������ .$_" for (keys %recall);
                Common::eparser "��� �������";
        }
        else
        {
                my $nor = 1 + scalar keys %recall;
                Common::eparser "~;��� $nor ������� $Alias::values{locker}";
                Common::eparser "��� ������� .$_" for (keys %recall);
                Common::eparser "��� �������";
        }
} $Alias::values{recallall};

P::alias
{
	my $target = "@_";
	return Common::eparser "��� �������;��� ������� $Alias::values{locker}" unless length $target;
	$target =~ s/\.//g;
	$target = Common::fupper $target;
	Common::eparser "~";
	SEARCH : while (1)
	{
		for (keys %Group::group)
		{
			last SEARCH if $Group::group{$_} =~ /^$target/;
		}
		Common::eparser "���� .$target";
		last;
	}
        Common::eparser "��� ������� .$target;��� ������� $Alias::values{locker};��� �������";
	
} $Alias::values{recallem};

P::alias
{
        my $rescstr = join ",", keys %autoresc;
        my %modecall =
        ( '1' => 'auto',
          '0' => 'bf5',
          '3' => 'bf3',
          '4' => 'bf4',
        );

        P::echo "resccommand : \3I[\3P$Common::resccommand\3I]";
        for (keys %autoresc)
        {
                my $mn = $_;
                $mn = $rescmn{$mn} if defined $rescmn{$mn};
                $mn = ".$mn";
                $mn =~ s/\.~//;
                my $call = $modecall { $autoresc{$_} };
                P::echo "mode \3I[\3P$call\3I]\3H for \3I[\3P$mn\3I]";
        }
        my $recallstr = join ",", keys %recall;
        P::echo ("recall\3I[\3P$recallstr\3I]");

} $Alias::values{showrescmodes};

P::bindkey {Common::parser "����_���������"} $Alias::values{bind_resclast};
P::bindkey {Common::eparser "$Common::resccommand .$Common::ne"} $Alias::values{bind_rescmode1};
P::alias {return $resc = 0 if $resc; $resc = 1} $Alias::values{cmd_autoresc_switch};


my $timett = 1;
my $checktime_timeout = 1000;
my $clock_out = -1;

sub checktime
{
        unless (--$timett)
        {
                my @time =  (localtime)[2,1];
                for my $chunk (@time) {$chunk = "0$chunk" if $chunk =~ /^\d$/}
                $Common::clock = join ":", @time;
                $timett = 60;
        }
        --$lasthits{$_} or delete $lasthits{$_} for (keys %lasthits);
        --$autoreschits{$_} or delete $autoreschits{$_} for (keys %autoreschits);
}

sub setup
{
        P::timeout \&checktime, $checktime_timeout, $clock_out;
        checktime;
}

setup;

1;
