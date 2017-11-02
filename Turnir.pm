#!/usr/bin/perl

package Turnir;

use Common;
use Alias;
use MUD;

use strict;


my $howstr = "(|��������|������|������|����� ������|����������� ������|�������|������|����� ������|����������� ������|���������� ������|������|����������)";
my $caststr = "(�������.?.?.? ����� � ���������.?.?.?|��������.?.?.? �� (.*) � ��������.?.?.?|��������.?.?.?|�����������.?.?.?|��������.?.?.? �� (.*) � ������.?.?.?|��������.?.?.?)";
my $weapattack_1 = "(������|�������|��������|�������|������|�����|��������|�������|��������|����������|������|������|�����|������|������|������)";
my $weapattack_2 = "(�������|��������|���������|��������|�������|������|���������|��������|���������|�����������|�������|�������|������|�������|�������|�������)";


my %damagers = ();
my %actors = ();
my %results = ();
my $tell_comand = "#wecho 2";
my @actors_seq = ();
my $curr_actor = '';



P::alias
{
	my $value = shift;
	if (! length $value)
	{
		P::echo '������ ��������';
		$tell_comand = '';
		MUD::disable_trigger 'TURNIR';
	}
	else
	{
		$tell_comand = $value;
		MUD::enable_trigger 'TURNIR';
		P::echo "������ �������. �������: $tell_comand";
	}
} '_������';





P::trig
{
#	return unless scalar keys %damagers;
	my $str =  '';
	for (@actors_seq)
	{
		$str = $str . "$_:";
		$str = $str . "$actors{$_}" unless ($actors{$_} eq '');
		$str = $str . "[���� $damagers{$_}]" unless ($damagers{$_} eq '');
		$results{$_} =~ s/^,//;
		$str = $str . "\($results{$_}\)" unless ($results{$_} eq '');
		$str = $str . " ";
		delete $damagers{$_};
	}

DAMAGERSCYCLE:	for (keys %damagers)
	{
		next DAMAGERSCYCLE if $_ eq '';
		$str = $str . "$_:";
		$str = $str . "[���� $damagers{$_}]" unless ($damagers{$_} eq '');
		$results{$_} =~ s/^,//;
		$str = $str . "\($results{$_}\)" unless ($results{$_} eq '');
		$str = $str . " ";
	}

	%damagers = ();
	%actors = ();
	%results = ();
	@actors_seq = ();
	$curr_actor = '';

	my $str1 = $str;
	my $str2 = '';
	my $str3 = '';
	my $str4 = '';

	if ($str1 =~ m/^(.{250})(.*)/)
	{
		$str1 = $1;
		$str = $2;
		$str2 = $str;
		if ($str2 =~ m/^(.{250})(.*)/)
		{
			$str2 = $1;
			$str = $2;
			$str3 = $str;
			if ($str3 =~ m/^(.{250})(.*)/)
			{
				$str3 = $1;
				$str = $2;
				$str4 = $str;
				if ($str4 =~ m/^(.{250})(.*)/)
				{
					$str4 = $1;
					$str = $2;
				}
			}
		}
	}

	Common::sparser $tell_comand . " " . $str1 unless $str1 eq '';
	Common::sparser $tell_comand . " " . $str2 unless $str2 eq '';
	Common::sparser $tell_comand . " " . $str3 unless $str3 eq '';
	Common::sparser $tell_comand . " " . $str4 unless $str4 eq '';
	

} '^$','1000000-:TURNIR';


####FRAGS###


# Burning Hands

P::trig
{	
	P::echo "triger1";
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����";
	$results{$1} .= ",RIP $2";
} "^(.*) ������� ������ �����.?.? (.*) - .* ������ ������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
	$results{$2} .= ",����!";
} "^(.*) �����.?.? �������� ������� ������� ������������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
} "^(.*) ������.?.? �� ����, ����� (.*) ������ �����",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.����";
	$results{$2} .= ",RIP $1";
} "^(.*) �����.?.? ��������� ������� � (.*) ����. ��� ���� ���������, ��� ",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
	$results{$2} .= ",����! ";
} "^(.*) ����.?.? �������� ����������� ������������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���� �� $2";
} "^(.*) ��������.?.? (.*) ������ �������� ������.",'f1000000-:TURNIR';


# Call Lightning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����";
	$results{$1} .= ",RIP $2";
} "^����� ������, ��������� (.*), �� (.*) �������� ���� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
	$results{$2} .= ",����!";
} "^(.*) ���������.?.? ����� �� ��������� � �.* (.*) ������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
} "^(.*) ��������.?.? �� ����, ����� � �.* ������ ������, ������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����";
	$results{$1} .= ",RIP $2";
} "^������ (.*) ��������� (.*) � ��� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
	$results{$2} .= ",����!";
} "^(.*) �������.?.? �� ������ (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.���� �� $1";
} "^� (.*) ������ ������ (.*)\\.",'f1000000-:TURNIR';


# Chill Touch
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����";
	$results{$1} .= ",RIP $2";
} "^(.*) ������.?.?.? (.*), ��������� .* � ��������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �������� �������.?.?.? ���������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���� �� $2";
} "^(.*) ���������.?.?.? � (.*), �����.* ������ �� ����� �� \"�������� �����\".",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$2 ����";
} "^������ ��� (.*) ��������� �����.",'f1000000-:TURNIR';


# Color Spray
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������";
	$results{$1} .= ",RIP $2";
} "^(.*) ���������.?.?.? (.*) � ������� ������������ ��������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ �� $2";
	$results{$1} .= ",����!";
} "^������������ ������ (.*) ��������� ����� � (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ �� $2";
} "^(.*) ��������.?.?.? (.*), �����.* ������ �������.?.?.? �� ���� ��� �������.",'f1000000-:TURNIR';

# Dispel Evil


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.���";
	$results{$1} .= ",RIP $2";
} "^(.*) p������.?.?.? �� ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����.��� �� $1";
	$results{$2} .= ",����!";
} "^(.*) �������.?.?.?, ����� �� ����������� ������� (.*) �������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.��� �� $2";
} "^(.*) ������.?.?.? �� (.*) ����� ������� ����. �� �������� .* ��� �� ���������.",'f1000000-:TURNIR';
# Energy Drain

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����.��";
	$results{$1} .= ",RIP $2";
} "^(.*) ������.?.?.? ������� ����� � (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����.�� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �������.?.?.? ������ ����� � (.*), �� � �.* ������ �� �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����.�� �� $2";
} "^(.*) �����.?.?.? ����� ����� � (.*)\\.",'f1000000-:TURNIR';


# Fireball
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�������";
	$results{$1} .= ",RIP $2";
} "^��� ��������� ���� (.*) ������� �� (.*) ���� ���������� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������� �� $2";
	$results{$1} .= ",����!";
} "^�������� ��� (.*) �� �������� (.*) �������� �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������� �� $2";
} "^(.*) �������������� �����.?.?.? ���� - .* �������� ��� ������ (.*)!",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������� �� $2";
} "^(.*) ��������.?.?.? �������� ���, ������� ������ �������� ������ ������ (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�������";
	$results{$1} .= ",RIP $2";
} "^����� ��������� ���� (.*) �� (.*) �� �������� � �����.",'f1000000-:TURNIR';




# Harm

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����";
	$results{$2} .= ",RIP $1";
} "^(.*) �� �������.?.?.? �����, ������������ .* (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �������� �������.?.?.? ��������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
} "^�����, ��������� (.*), ��������� (.*) ������������ �� ����.",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����";
	$results{$2} .= ",RIP $1";
} "^(.*) �� �����.?.?.? �����, ����������� .?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �� ����.?.?.? ��������� (.*) ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���� �� $2";
} "^(.*) ����� ��������.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���� �� $2";
} "^(.*) �������� ��������.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.���� �� $2";
} "^(.*) ������ ��������.?.?.? (.*)\\.",'f1000000-:TURNIR';


# Lightning Bolt

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������";
	$results{$1} .= ",RIP $2";
} "^������� ����� (.*) ������ � (.*) � �������� .* ������� �� �������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ �� $2";
	$results{$1} .= ",����!";
} "^(.*) �����.?.?.? ������� � (.*) ������� �������, �� ��������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ �� $2";
} "^��������� (.*) ������� ������ ������� � ���� (.*)\\.",'f1000000-:TURNIR';

# Magic Missile

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.�����";
	$results{$1} .= ",RIP $2";
} "^���������� ������, ��������� (.*), ��������� (.*) � ������ ���.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����� �� $2";
	$results{$1} .= ",����!";
} "^(.*) ���������.?.?.?, ������� �������� (.*) ���������� �������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����� �� $2";
} "^(.*) ��������.?.?.? � (.*) ���������� ������, ������� �������� ����.",'f1000000-:TURNIR';

# Poison


P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",���� :(";
} "^(.*) �����.?.?.? � ���������, �������, �������.?.?.? � �����",'f1000000-:TURNIR';

# Shocking Grasp

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������";
	$results{$2} .= ",RIP $1";
} "^(.*) ����.?.?.? ����p���, �� � ����� �������� ���������� ������ (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������ �� $1";
	$results{$2} .= ",����!";
} "^(.*) ���p���.?.?.?, � (.*) �� �����.?.?.? ��������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������ �� $1";
} "^(.*) ��������.?.?.?, ����� (.*) ������.?.?.? .* ��������� ������.",'f1000000-:TURNIR';

# Dispel Good


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.����";
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? ��������� ����� ����� � ���� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����.���� �� $1";
	$results{$2} .= ",����!";
} "^(.*) �������.?.?.?, �������� ����������� ������� (.*) ��������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����.���� �� $1";
} "^(.*) �������.?.?.? � ��������.?.?.? �� ���� (.*)\\.",'f1000000-:TURNIR';

#  Chain Lightning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������";
	$results{$1} .= ",RIP $2";
} "^����� ������, ��������� (.*), �� (.*) �������� ���� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������ �� $1";
	$results{$2} .= ",����!";
} "^(.*) ���������.?.?.? ����� �� ��������� � �.?.?.? (.*) ������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������ �� $1";
} "^(.*) ��������.?.?.? �� ����, ����� � �.?.?.? ������ ������, �������� (.*)\\.",'f1000000-:TURNIR';

# Implosion
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����";
	$results{$1} .= ",RIP $2";
} "^���������� (.*) ���� ������� �� (.*) ���� ����� �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
	$results{$1} .= ",����!";
} "^����� ����� (.*) ������ ���� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
} "^(.*) ����������� ��������.?.?.? �� .*. (.*) �������� ����� �������.",'f1000000-:TURNIR';

# Acid blast

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����";
	$results{$1} .= ",RIP $2";
} "^(.*) �����.?.?.? �������� (.*), ������� .* � ���������� �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �� �����.?.?.? ����� �������� � (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����� �� $2";
} "^(.*) �������.?.?.? �������� � (.*), ����� .?.?.? � ������ �� ���.",'f1000000-:TURNIR';

# Sacrifice

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����";
	$results{$1} .= ",RIP $2";
} "^(.*) �����.?.?.? ������� ��������� ����� � (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �������.?.?.? ������ ��������� ���� � (.*), �� � �.?.?.? ������ �� �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� �� $2";
} "^(.*) ���������.?.?.? ����� ��������� ����� � (.*)\\.",'f1000000-:TURNIR';

# Stunning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.�����";
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? (.*)\\. ����� ����� ����� .?.?.? �����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �� �����.?.?.? � (.*) ����� �����������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���.����� �� $1";
} "^(.*) ����� ����� ����� ����, ��� (.*) �������",'f1000000-:TURNIR';


# Cone of cold
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.���";
	$results{$1} .= ",RIP $2";
} "^(.*) ���������.?.?.? (.*) � ���������.?.?.? .?.?.? �� ��������� �������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.��� �� $2";
	$results{$1} .= ",����!";
} "^(.*) �� ����� ����� ����������� � (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.��� �� $2";
} "^(.*) �������.?.?.? ������� �����, ������� ��������� (.*)\\.",'f1000000-:TURNIR';



#MASSFRAG


# Earthquake
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����";
} "^(.*) �������.?.?.? ����, � ����� ��������� !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",RIP $2";
} "^(.*) ������� ������� ����� ������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 ��������";
} "^(.*) �������� �� �����.",'f1000000-:TURNIR';




# Armageddon

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���";
} "^(.*) �����.?.?.? ���� � ������������ �����, � ��� ���������� !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",RIP $2";
} "^(.*) ��������.?.?.? (.*) �� �������� � �����.",'f1000000-:TURNIR';

# mass blind

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.�����";
} "^����� ��� ������� (.*) �������� ����� �������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.����";
} "^��� ��������� ������� ����, ��������� (.*)\\.",'f1000000-:TURNIR';


P::trig
{	
	$results{$curr_actor} .= ",$1 ����";
} "^(.*) �����",'f1000000-:TURNIR';


# Mass Deafness

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.����";
} "^��� ������ (.*) �������.?.?.? ������, �������� ���������� ������.",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 �����";
} "^(.*) �����.?.?.? !",'f1000000-:TURNIR';


P::trig
{	
	$results{$curr_actor} .= ",$1 �����";
} "^(.*) ����.?.?.? ������� ������.",'f1000000-:TURNIR';

P::trig
{	
	P::echo ">" . $curr_actor;
	$results{$curr_actor} .= ",$1 � �����";
} "^(.*) �����.?.?.? �� ����� !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 � �����";
} "^(.*) ��������.?.?.? ���� !",'f1000000-:TURNIR';




# Fire blast

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���.�����";
} "^�� ������� (.*) ��������� ����� ����� !",'f1000000-:TURNIR';

# ice storm

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����";
} "^(.*) ������.?.?.? ���� � ����, � ������ ������ ������� ������� ���� !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 ��������";
} "^(.*) ��������.",'f1000000-:TURNIR';


# Mass Fear

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.�����";
} "^(.*) �������.?.?.? ������� ����������� ��������.",'f1000000-:TURNIR';


# chain Lighting

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����.����";
} "^(.*) ������.?.?.? ���� � ���� � ��� ���������� ������ ��������� !",'f1000000-:TURNIR';

# Earthfall
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����";
} "^(.*) ������ ���������.?.?.? ����� �����, �������, ������������ �� ������, ���� ������ ����.",'f1000000-:TURNIR';

# Sonicwave
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����";
} "^��������� ������ (.*) ������� ��������� �����, ����������� ��� �� ����� ����.",'f1000000-:TURNIR';


######DAMAGE

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^�� ����� (.*) (.*) ��������.?.?.? � ��� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) �����.?.?.? ���������� �� ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$2} = $1;
	$results{$2} .= ",RIP $1";
} "^(.*) �������.?.?.? ��������� ����� ����������� ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) �������.?.?.? �� ����� (.*)\\.",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? (.*) �� ������ �������. ��� ��� ������!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? �������� (.*) - ��������.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������.?.?.? ����� � (.*)\\. .* ����� ������ � .* �������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �� ����.?.?.? �������� (.*) - .* ������ ��������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? (.*) - �������, .* ��� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ����� �������� ������ �����.?.?.? (.*) �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) �������.?.?.? �� ������� (.*) ���������",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? .* � ����. ��� ����� (.*) ��������.?.?.? �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? �������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? .*. �� (.*) �������� ������ �������� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? �������� (.*), �� ���� ���� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������.?.?.? � ��� (.*), ������.* �� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ������.?.?.? ������ ���� ������.",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? ������ (.*), ������ ���������� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ���� ������ �������.?.?.? ������.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �����.?.?.? .*. ����� (.*) ���� �������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������ (.*), �� ���������",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �����.?.?.? .*. ����� ������ ����� ���� ��� �������. (.*) �� ����.?.?.? �����������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������ (.*), �� .?.?.? ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$2} = $1;
	$results{$2} .= ",RIP $1";
} "^(.*) �������� ��������.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� .?.?.? ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ���������� ��������.?.?.? .*. ������ .?.?.? (.*) ����� ��� � ������ �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? (.*), �������� ��� �� .?.?.? ����",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? �������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? .*. �� ����� ����� (.*) ��������.?.?.? ��������� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? �������� (.*), �� .?.?.? ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? (.*) ������ �������. �� ������ ����� ��� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� .* ������.*��������.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ���������� ��������.?.?.? .*. (.*) ����.?.?.? �� �������� ������ �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^������ ������� (.*) ������ (.*) � ��� ����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ����������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^������ (.*) �������� ����� (.*)\\. ������ �� �� ��!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ����������� (.*), �� .?.?.? ������ �� �������� ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������� ��������.?.?.? (.*) �� ��������� ������, ����",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������� ������.?.?.? .*\\. (.*) ������� � �������� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� .?.?.? ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? (.*) �������� � .?.?.? ������������ ���� ����� �� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? .* ��������. � �������� ����� (.*) ����",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ��������� (.*), �� .?.?.? ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������ �����.?.?.? (.*), ������ ���������� ������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������ (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��� ������ �����.?.?.? (.*), ��� .* �� ���������� ������, ����� ��� �������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������ (.*), �� .* ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ����� ������ ������.?.? .*. ������, ��� (.*) �� ��������.* ����� � �����",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ����� ������ ������.?.?.? .*\\. (.*) �� �����.* ������ ����� � �������.* �� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.* ������� (.*), �� .* ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.*��������. ����.?.?.? (.*)!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� ���������",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������� �������.?.?.? (.*). ������ .* ���� �������!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� .* ���� �� ������ ����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������� ��������.?.?.? (.*)\\. ��� ��� ��������!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� .* �������� �� �������� ����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) �������.?.?.? ������� (.*), �� .* �������� �� �������� ����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $3;
} "^(.*) �������.?.?.? $weapattack_2 (.*), �� ���������.?.?.?.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) �������� $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	return if $1 =~ /(��������|������|������|����� ������|����������� ������|�������|������|����� ������|����������� ������|���������� ������|������|����������)/;
	$damagers{$1} = $3;

} "^(.*) $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	return if $1 =~ /(�����|�����������)/;
	$damagers{$1} = $3;
} "^(.*) ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ����� ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ����������� ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ������� $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	return if $1 =~ /(�����|�����������|����������)/;
	$damagers{$1} = $3;
} "^(.*) ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ����� ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ����������� ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ���������� ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ������ $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ���������� $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';


####OTHER

# Suffering

P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",���� :(";
} "^(.*) �����.?.?.?, �������, �� �����, ���� �� �������� ����� � .?.?.? ������� ����.",'f1000000-:TURNIR';
P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",���� :(";
} "^(.*) �������.?.?.? ����� ����� � �����",'f1000000-:TURNIR';


####NPC ATTACK
P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? �� (.*) ���� ����� �����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) ��������.?.?.? � ���������� ������, ����� (.*) ������.?.?.? �� .?.?.? �����.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ����.?.?.? (.*) ���������� ������ �� �",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) ��������.?.?.? ��� �� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ������ �� (.*) ����� ����.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) �������� ����������� �����, ����� ��������� ������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ��������.?.?.? .* �������� � ���������. (.*) �������...",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) ������ � ��������� �� ���������� ������� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) ����.?.?.? (.*) ����������� ��������.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) ��������.?.?.? �������� (.*)\\.",'f1000000-:TURNIR';


#***************************************************************************
#*                          Offensive Skills                               *
#***************************************************************************

# Throw
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������";
	$results{$1} .= ",RIP $2";
} "^������ ������ (.*) �������� (.*) �������� ��� ������� ���.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "������ � $1";
	$results{$2} .= "����";
} "^(.*) �����.?.?.? ���������� �� ������ (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ � $2";
} "^������ ������ (.*) �������� (.*) ��������� �� ����.",'f1000000-:TURNIR';


# Backstab
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����";
	$results{$1} .= ",RIP $2";
} "^(.*) �������.?.?.? .* �� ���� ������. (.*) ������ ������ ��������� �� �������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� � $2";
	$results{$1} .= "����";
} "^(.*) �������.?.?.? ������� (.*) ���� � �����, �� .?.?.? ��������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� � $2";
} "^(.*) �������.?.?.? ���� ������ � ����� (.*)\\. �� �������� ��������.",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����";
	$results{$1} .= ",RIP $2";
} "^���������� ������ � �����, (.*) ��������.?.?.? (.*) � ��������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� � $2";
	$results{$1} .= "����";
} "^(.*) �� �����.?.?.? ����� ������� � ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� � $2";
} "^(.*) �����.?.?.? ���� ����� ������� � ����� (.*)\\.",'f1000000-:TURNIR';

# bash
P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���";
	$results{$2} .= ",RIP $1";
} "^(.*) �������.?.?.? �� ����� �� ����� (.*), �� ��� � �����.?.?.? ������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "��� � $1";
	$results{$2} .= "����";
} "^(.*) �������.?.?.? �� ������� (.*) ��������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "��� � $2";
} "^(.*) �������.?.?.? (.*) �� ����� ������ ������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "���";
	$results{$2} .= ",RIP $1";
} "^(.*) ������.?.?.? �� ����� � ��������.?.?.? ����� ������� ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "��� � $2";
	$results{$1} .= "����";
} "^(.*) �������.?.?.? �������� (.*), �� .?.?.? �������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "��� � $1";
	$results{$2} .= "����";
} "^(.*) �������.?.?.? ������� (.*) ��������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "��� � $2";
	$results{$1} .= "����";
} "^(.*) �������.?.?.? �������� (.*), �� �� ���-�� ����.",'f1000000-:TURNIR';



P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "��� � $2";
} "^����� ������ (.*) �������.?.?.? (.*) �� �����.",'f1000000-:TURNIR';


# kick
P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "�����";
	$results{$2} .= ",RIP $1";
} "^(.*) �����.?.?.? �� ������� ����� ���� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����� � $2";
	$results{$1} .= "����";
} "^(.*) �������.?.?.? ����� (.*)\\. ������� �� .?.?.? ��������.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����� � $3";
} "^(.*) $howstr ����.?.?.? (.*)\\. ���� .* ����������� � ������� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�����";
	$results{$1} .= ",RIP $2";
} "^(.*) ����.?.?.? (.*) ����� ������� ������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "����� � $1";
	$results{$2} .= "����";
} "^(.*) �������.?.?.? �� ������� ����� (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "����� � $3";
} "^(.*) $howstr ����.?.?.? .*\\. ������ (.*) ���� ������� ������� �� ����.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "���� $2";
} "^(.*) ���������� ����.?.?.? (.*)!",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "������ $2";
} "^(.*) ����� ������.?.?.? (.*), ������",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "�������� $2";
	$results{$1} .= "����";
} "^(.*) �������.?.?.? ������� (.*), �� ����",'f1000000-:TURNIR';


###OTHER SPELLS


sub analyze_cast(@)
{	
 my $caster = shift;
 my $spell = shift;
 my $victim = shift; 

 push @actors_seq, $caster;
 $curr_actor = $caster;


 if ($spell eq '')
 {
	$actors{$caster} = "�������";
 	return;
 };

 if ($spell eq '�����')
 {
	$actors{$caster} = "�����";
 	return;
 };


 if ($spell =~ /(�������, ����� ���������)|(������ �� ����� � ������ �� ��������)|(��������� ���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����, ����� ���������)|(���� �������, ��� �������� �����)|(�������� ���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������, ����� ���������)|(� ���� � ��� ����������� ����� � �� �����)|(������� ���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� �� ���������)|(�� - ������ ���� � ������ ����)|(������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������� ��� ���������)|(���� ����� �������� � ����)|(��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }


 if ($spell =~ /(����� ����� ����� ����)|(� ���������, � ������ ����������)|(������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
 	return;
 }
 if ($spell =~ /(������ �����������)|(������ ��������� ����, ����� �� ��� �����)|(�������� ������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��������.���";
 	return;
 }
 if ($spell =~ /(�������� �����)|(��� ����, ������� ������� ��� ��� � ����)|(������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.���";
 	return;
 }
 if ($spell =~ /(������� ������)|(� ������� ����� ����)|(������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ������)|(� ������� �� ���� � ����� ����� ������)|(�������� �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������� ������ ����)|(�� ��������� ���� ����)|(������ ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������ �����)|(� ������� ����� �� ������, ��� ������� �������� ���� �� ������)|(����������� ������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ��������)|(��� ��� ������ �������, ��� �� ��������� �� �����)|(������ ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �������)|(��������, ����� �������������)|(����������� �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ��������)|(�� ������ �� ������� ��)|(����������� ���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ��� ���)|(���� ������, ������)|(���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(��� ���)|(�� ����������� ������ ����)|(����������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�������� �������)|(��� ������� ��������, � ��������� �����)|(�����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�������� ����)|(����, ������� � ����, �� ������� ����)|(������ �� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.��.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �����)|(�� ��������� ���� ����������� ����)|(����� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(��� �� ������, �����)|(������ �����, ��� ������� ��� ����)|(��������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.����";
 	return;
 }
 if ($spell =~ /(��� �� ������)|(���� ������, ��� ������� ��� ����)|(���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �����)|(� ������� �������� ��������� ���� ����)|(����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�����-����)|(� ������� �� ��� � �������� ���)|(��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(� ���� ����� �������)|(������ � �����)|(����� ��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ��������)|(������ ������, ������� �������� �� ����)|(������� ��)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.��";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ������)|(��� ��� ������ ������������, ��� �� ������������ ��)|(����������� �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(��������� �����)|(��� ��� ���, ����� �������, � ��� ������, ����� ���� ������)|(��������� ������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.���";
 	return;
 }
 if ($spell =~ /(�����, ��� ���)|(��� ������, ��������)|(��������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��";
 	return;
 }
 if ($spell =~ /(��������� � ���� ����)|(��� ������, �������� � �����)|(��������� �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.�����";
 	return;
 }
 if ($spell =~ /(������ ����)|(�� ���������� ���� ����)|(��������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ������)|(� ���� ��� ������� ����)|(��������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.����";
 	return;
 }
 if ($spell =~ /(������ ��������)|(� �������, � ������� �� ������� �����)|(�����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ����� ��� ������)|(��������� �� ������ ��������� ����)|(�������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� �������)|(����� ��� �������� �����)|(�������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�����, �������� �������)|(�������� ���� ������� ���� ����. �, ������ ���, ��� ����� ��������)|(��������� �����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.�����";
 	return;
 }
 if ($spell =~ /(�������� � ����)|(� ����� �������)|(����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ����� ��� ������)|(������, � ����)|(����� ����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ����� ��������)|(������� ���� ����� ���������� ���������)|(��������� �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���������)|(����� �� ��� ������� - ���������)|(����� ��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �� ���������)|(� ��� �������� �� ���� ��)|(��������� �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.�����";
 	return;
 }
 if ($spell =~ /(�����, ��������� ������� ����)|(������� ��, �������� ����� �����)|(��������� ��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ����)|(�� ����� � ���� �� ��������, �� �������������)|(��������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �����)|(���� ������ ����, � ���� - ������)|(���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�� ������� ����� ������)|(��� �����, ��� �����)|(������ �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������ ��� �������� ����)|(� ��� ������ ��� ����� �� �����)|(��������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(���� ��� ������)|(�������� ��� ����� � �������, � �� ������ ������� �� ����)|(���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����, ������ ����)|(����, ��������)|(�������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(��� ����������)|(�� ��� ��� ���� ���� � ������ ���� - ��������)|(��������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��������������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� �������)|(�����, ��� ��������)|(�������� �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������� ��� �� ������)|(��� ��������� ����� ��������� ��������)|(������� ��������������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�������, ����� ���������)|(����� ��� � ����, � �� �������� ��� �����)|(�������� ��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.��������";
 	return;
 }
 if ($spell =~ /(������, ����� ���������)|(� ����������� �������� ���)|(��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��������";
 	return;
 }
 if ($spell =~ /(���� ��� ��� ����)|(����� �� ��� ���������)|(����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� ���� �������)|(������ �� �� ����� ��, �� ���� ��������� ��)|(���������� �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�������";
 	return;
 }
 if ($spell =~ /(������ ������� ����)|(���� ��� �������� � ���, � ����� ��� ������� ���)|(�������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�����, ���� �������� �������)|(������� �� ������, � �������� ������������ ��)|(��������� �������������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.�����";
 	return;
 }
 if ($spell =~ /(������� �������)|(������ ������ � ������)|(�������������� ����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(��� �������)|(� �� ������� �� ����)|(���� ���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�������)|(� ������� ������� ����)|(�������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�������";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(������ ���� ���)|(������ ����� ���)|(����� �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(�� ������ ��� ����)|(� ���� ������ �������)|(���������� �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(����� � ������ �������)|(����������� ���� ������ �� ��� ��������)|(������ �����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��";
 	return;
 }
 if ($spell =~ /(����� ��� ������ ����)|(� ������� ��� � ���)|(����������� ������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.������ �� $victim";
 	return;
 }
 if ($spell =~ /(���� �������)|(� ���� ������� ���������)|(��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�������� �� $victim";
 	return;
 }
 if ($spell =~ /(����� ��)|(�������� �� ���� ����� �������)|(�������� ���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����.�����";
 	return;
 }
 if ($spell =~ /(�����)|(������� �� ���� ����� �������)|(���������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����� �� $victim";
 	return;
 }
 if ($spell =~ /(��� �������)|(�� ���� ���� ������� ��������)|(���)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��� �� $victim";
 	return;
 }
 if ($spell =~ /(����� ��� ������)|(����� �������)|(���������� ����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.���� �� $victim";
 	return;
 }
 if ($spell =~ /(�� �������)|(�������)|(�������� ����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��";
 	return;
 }
 if ($spell =~ /(��� ������)|(�����)|(����������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���� �� $victim";
 	return;
 }
 if ($spell =~ /(����� ���� �� ����!)|(�� ��������� ���� ����)|(��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "���� �� $victim";
 	return;
 }
 if ($spell =~ /(����� ������� �����)|(������� ���� ������� �������� �������)|(������ �������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.����� �� $victim";
 	return;
 }
 if ($spell =~ /(����� �� �������)|(��������� �� ��� �����, �� �� ��������� �����)|(���������� ��������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "��.���� �� $victim";
 	return;
 }
 if ($spell =~ /(���� ���� ����� �������!)|(������� ���� ������� ��������)|(�������)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "����� �� $victim";
 	return;
 }
 if ($spell =~ /(��������)|(� ����� �� ��� ���� ������ � �� ��������� �� �����)|(��)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�� �� $victim";
 	return;
 }

 if ($spell =~ /(������ � ������)|(������ ����, ��� �� ������� �������� � ������)|(�����)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "�����";
	$actors{$caster} .= " �� $victim" unless $victim eq '';
 	return;
 }
	
# $actors{$caster} = "�������";


}


P::trig
{
 my @params;
 push @params, $1;
 push @params, "�����";
 analyze_cast @params;
} "^(.*) ������.?.?.? ����, ������� ��������� ����� ��������." , 'f1000000-:TURNIR';

P::trig
{
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) �������.?.?.? ����� � ���������.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 my @params;
 push @params, $1;
 push @params, $3;
 push @params, $2;
 analyze_cast  @params;
} "^(.*) ��������.?.?.? �� (.*) � ��������.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 return if $1 =~ /��������.?.?.? ��/;
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) ��������.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';

P::trig
{
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) �����������.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 my @params;
 push @params, $1;
 push @params, $3;
 push @params, $2;
 analyze_cast  @params;
} "^(.*) ��������.?.?.? �� (.*) � ������.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';

#P::trig
#{
# analyze_cast $1,'','';
#} "^(.*) �����.?.?.? ���������� ����" , 'f1000000-:TURNIR';



1;



