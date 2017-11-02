#!/usr/bin/perl

package Reaction;

use Common;
use Alias;

use strict;


my %dirs =
(
        "������" => "east", "�����" => "west",
        "�����" => "north", "��" => "south",
        "����" => "down", "�����" => "up",
        "���" => "down", "����" => "up",
);

my %friend_spell =
(
        'hold' => '����� ����������',
        'blind' => '�������� �������',
        'poison' => '������� ��',
        'silence' => '����� ��������',
);

my %spell_volhv =
(
	'hold' => '��������;��������',
	'blind' => '��������;����;����������',
	'poison' => '���������;����������',
	'silence' => '����������;��������',
);

my %death_traps = (
	"������" => 0,
	"�������� ����" => 0,
	"������� ���" => 0,
	"������" => 1,
	"���� ��������" => 0,
	"������ ����" => 0,
	"������ �����" => 0,
	"�������� ���" => 0,
	"�������� �����" => 0,
	"�������� �����" => 0,
	"������� �����" => 0,
	"������" => 0,
	"��������� �����" => 0,
	"������� �����" => 0,
	"�������" => 0,
	"������� � �������" => 0,
	"������� � ������" => 0,
	"������ ���" => 0,
	"��������� �������" => 0,
	"�������� ������" => 0,
	"�� ��������" => 0,
	"��� ��������� ������" => 0,
	"��������� ������ � �������� ��������" => 0,
	"������������� ������" => 0,
	"�����" => 0,
	"�����" => 0,
	"����������� ������" => 0,
	"�������� ����" => 0,
	"�������� �����" => 0,
	"�������� �������� � �������� �����" => 0,
	"������� �����" => 0,
	"��������� �����" => 0,
	"���� ����" => 0,
	"����" => 0,
	"����" => 0,
	"����" => 0,
	"������ ������" => 0,
	"������ �����" => 0,
	"����� � ������" => 0,
	"����� � �������..." => 0,
	"�����-������" => 0,
	"������, ����������� �����" => 0,
	"��������" => 0,
	"����� �����" => 0,
	"������������� �����" => 0,
	"�������������� ������" => 0,
	"��������" => 0,
	"������" => 0,
	"������ ��������� ���" => 0,
	"�������� �����." => 0,
	"���" => 1,
	"��� � �������" => 0,
	"��� � ������" => 0,
	"���������-�������" => 0,
	"������� ������" => 0,
	"������ �����" => 0,
	"��� ����������� �����" => 0,
	"������� �� ��� ����!" => 0,
	"������ � ������" => 0,
	"����� ������ ����" => 0,
	"������ ��� �� ���������� �������" => 0,
	"������� ���" => 0,
	"���������� � �����" => 0,
	"������ ���" => 0,
	"������ ����" => 0,
	"��������� �����" => 0,
	"������ �����" => 1,
	"������ �����" => 0,
	"����" => 0,
	"��������, ���������� ��������" => 0,
	"�������" => 0,
	"� ������ ������" => 0,
	"���� � ��������" => 0,
	"����� ������� ������" => 0,
	"� �������� ����" => 0, 
	"� ������������ ������" => 0,
	"� �������" => 1,
	"� ����" => 1, 
	"������ �����" => 0,
	"������ ���" => 0,
	"����������� ������� ������ �� ����" => 1,
	"�������" => 0,
	"��������" => 0,
	"�����" => 0, 
	"������ ����" => 0,
	"��� � �������" => 0,
	"������� �����." => 1,
);

my $oneofdir = '[��][��][��][��][��][��]|[��][��][��][��][��]|[��][��]|[��][��][��][��][��]|[��][��][��][��]|[��][��][��][��][��]';

my $friend_target = '';
my $attack_type = '';

P::trig
{
        my $tt = 120 - time + $Common::time; 
	$tt -= 60 while $tt > 60;
	$tt += 60 while $tt < 0;
        $; = CL::parse_colors ("               *%*%*%*%*%*%*%*%*     $1 � \3B�����\3H [$tt]    *%*%*%*%*%*%*%*%* [alias 1]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "hold";
} '^([^:\']*) �����(.*?) �� �����','f6000';


P::trig
{
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
	$; = CL::parse_colors ("$1 \3M�������� \3H[\3L$tt\3H]");
} '^([^:\']*) ��������','f6000';

P::trig
{
        $; = CL::parse_colors ("---------> $1 ���� [alias 5]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "sleep";
} '^([^:\']*) ������(.*?) ���������';


P::trig
{
	$; = CL::parse_colors ("---------> $1 � ��� [alias 4]");		
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "poison";
} '^([^:\']*) ���������.? �� �������� ���','f6000';


P::trig
{
        my $tt = 120 - time + $Common::time; 
	$tt -= 60 while $tt > 60;
	$tt += 60 while $tt < 0;
        $; = CL::parse_colors ("               -=-=-=-=-=-=-=-=-     $1 � \3J�����\3H [$tt]     -=-=-=-=-=-=-=-=- [alias 2]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "silence";
} '^([^:\']*) ��������(.*?) ���� !','f6000';


P::trig
{
        $; = CL::parse_colors ("---------> $1 � ������� [alias 3]");
	$friend_target = "." . Common::str2mob $1;
	$attack_type = "blind";
} '^([^:\']+) �����(.*?) !', 'f6000';

P::trig
{
        $; = CL::parse_colors("\3L[>>>]  ") . $;
} '�� (��������|������������) ����� (��� ���)? ��������� (.*)';



P::trig
{
        my $sub;
        my ($thing,$r) = ($1,$2);
        my $colr = Common::get_color($;,1);
	if ($Alias::values{arda_commands})
	{
        $sub = 'west' if $thing =~ /�����/;
        $sub = 'east' if $thing =~ /������/;
        $sub = 'north' if $thing =~ /�����/;
        $sub = 'south' if $thing =~ /��/;
	$sub = 'up' if $thing =~ /�����/;
	$sub = 'down' if $thing =~ /����/;
        $: = "\3${colr}$thing(\3K$sub\3${colr})$r";
	}

	if ($r =~ /^\s*[:-]\s*(.*)$/)
	{
	        my ($ex,$dt) = (Common::rlower $thing,$1);
        	$dt =~ s/(\[\d+\] )//; 
	        if (exists $death_traps{$dt})
	        {
	                my $sign = $death_traps{$dt}?"?":"!";
	                if (exists $Common::dt_directions{$ex}) {return unless $Common::dt_directions{$ex}};            
	                $sign = "!" if $Common::dt_directions{$ex};
	                $Common::dt_directions{$ex} = 1 if $sign eq '!';
	                $; .= CL::parse_colors " \3I<----------------------- \3D��$sign";
		}
	        else
	        {
	                $Common::dt_directions{Common::rlower "$1"} = 0;
	        }
	}
} '^(�����|������|��|�����|����|�����)([\:\- \'].*)', 'f300';

sub HL_part
{
        my $vat = CL::unparse_colors($;);
        my ($w,$p) = ($1,$2);
        $vat =~ /^(.*)\03(.)(.*?)$w$p(.*)$/;
        $: = "$1\3$2$3\3$Alias::highlightpart{$w}$w$p\3$2$4";
}

for (keys %Alias::highlightpart)
{
	P::trig \&HL_part, "($_)([^\\s':;,\.\?!()]*)", "f10";
}

foreach (keys %Alias::highlightstring)
{
        my $word = $_;
        my $sact = '^('.$word.'.*'.')$';
        P::trig
        {
                $: = "\3$Alias::highlightstring{$word}$1"
        } $sact, 'f6500';
}

P::trig
{
	my $last = "$2$3$4$5";
	my $name = $1;

	if ($Alias::values{arda_commands})
	{
	        my $sub = $dirs{$4};
	        $sub = $4 unless length $sub;
	        $last = "$2 � \3C$sub\3H";

	}
	
	my $ok = 0;
	for (keys %Group::group)
        {
           $ok = 1 if ($Group::group{$_} eq $name);
        }
	$ok = 1 if $name =~ /^(�������|�����|����������|�����|���������|��������)/;
	$ok = 1 unless $name =~ /^([^ ]+)$/;
	my $clr = $ok ? "\3H":"\3N";
	$; = CL::parse_colors($clr."$name \3H$last.");

	
} '^(.*) (����.?.?|��������.?|�������.?|�����.?|�������.?|��������.?)( � ?)([^ ]*)([��])\.','f800';


P::trig
{
	my $last = "$2 $3";
	my $name = $1;
     	if ($Alias::values{arda_commands})
	{
		my ($w,$d) = ($2,$3);
		$d = $1 if $d =~ /^�� (.*)/;
      		my $sub = $dirs{$d};
		$sub = $d unless length $sub;
		$last = "$w �� \3C$sub\3H"
		
	}

	my $ok = 0;
	for (keys %Group::group)
        {
           $ok = 1 if ($Group::group{$_} eq $name);
        }
	$ok = 1 if $name =~ /^(�������|�����|����������|�����|���������|��������)^/;
	$ok = 1 unless $name =~ /^([^ ]+)$/;
	my $clr = $ok ? "\3H":"\3H";
	$; = CL::parse_colors($clr."$name \3H$last.");

} '^(.*) (��.?.?|������.?|�����.?|������.?|������.?|�����.?) (�� [^ ]+|�����|����)\.','f800';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- ��������!");
        Common::eparser "~;������"
} '�������.*? ��� �� �����. ������������!';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- ���������!");
        Common::eparser "~;������"
} '����� ������.*? ���, ������ �� ����.';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- �������� �����!!");
        Common::eparser "~;������"
} '^���������� ���� .*? ���� ��� � ���';

P::trig
{
        $; .= CL::parse_colors("\3J          <---------- ��������!");
        Common::eparser "~;������"
} '^�� �������� �� ����� �� ������� �����';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- ����");
	Common::eparser "~;������";
} '^�� ���������� ����� (.*?), �� ����� ����\. �������\.';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- ����");
	Common::eparser "~;������";
} '^�� ���������� ������� (.*?), �� ����� ����\.\.\.';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- ����");
	Common::eparser "~;������";
} '^([^:]+) ��������� �� ������ �����, � �� ���� �������������';



P::trig
{
        $; .= CL::parse_colors("\3J          <---------- ����� ������!");
        my $disarmed = Baze::alias $2;
        Common::parser "����� $disarmed;��� $disarmed" if $disarmed eq $Common::lwp;
        Common::parser "����� $disarmed;���� $disarmed" if $disarmed eq $Common::rwp;
} '^([^\']*)����� �����.? (.*?) �� ����� ���';

P::alias
{
        Common::parser "��� $Common::rwp;���� $Common::rwp";
        Common::parser "��� $Common::lwp;��� $Common::lwp" if length $Common::lwp;
} $Alias::values{cmd_getweapons};


P::trig
{
        $; .= CL::parse_colors("\3P          <----------  �������� $2 ������!");
} '^([^:]+) �������...? �� ������� (.*?) �������� �..?\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 �����!");
} '^([^:]+) �����.? �������� ���, ��, �� ��������� ���, ����';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- ��������!");
	Common::eparser "~;������";
} '^�� �������� �� ����� �� ������� �����';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ��������!");
} '^([^:]+) �������.? (.*?) �� ����� ������ ������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 �����!");
} '^([^:]+) �������...? ����� ��� � ���, ��, � �����, ���������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 �����!");
} '^([^:]+) �������...? �������� (.*?), ��';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $2 ������� :)");
} '^([^:]+) ������� ������� (.*?) �������� ���';


P::trig
{
	$; .= CL::parse_colors("\3J          <---------- ��������!");
	Common::eparser "~;������";
} '^([^:]+) �������.? ��� �� �����. ������������!';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $1 ��������!");
} '^����� ������ .*? �������.? (.*?) �� �����\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- ���� �� � ���� �������!");
} '^�� ������ ���������� �� ������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 �� ���� �������!");
} '^([^:]+) �����.? ���������� �� ������ (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- ����� ������� � $2!");
} '^������ ������ (.*?) �������� (.*?) ��������� �� ����';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� ������!");
} '^([^:]+) �������.? � ��� ���� ������, �� ���������';


P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� ������!");
} '^������ (.*?) ������ ���� ������ ������ �� ����� (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ��������� �����!");
} '^([^:]+) ������� (.*?) �� ���� ������. (.*?) ������ ������ ��������� �� �������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- �������!");
} '^([^:]+) �������...? ������� ��� ���� � �����, �� ��� ��������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� �������!");
} '^([^:]+) �������...? ������� (.*?) ���� � �����, ��';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- ���������!");
} '^�������� (.*?) ������.? ��� � �����';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ���������!");
} '^([^:]+) �������.? ���� ������ � ����� (.*?)\. ��';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ��������� �����!");
} '^���������� ������ � �����, (.*?) ��������.? (.*?) � ��������';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- ���������� �� $1!");
} '^��� ������� ���������� �� ��������� ����� (.*?)\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� �������!");
} '^([^:]+) �� �����.? ����� ������� � ����� (.*?)\.';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- ���������!");
} '^([^:]+) �����.?.? ��� ���� ����� �������, � ���� ���� ��� �� ������\.';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ���������!");
} '^([^:]+) �����.?.? ���� ����� ������� � ����� (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� ���������!");
} '^([^:]+) �������...? ������� ���, �� ����';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ����� ���������!");
} '^([^:]+) ��������� ������� (.*?) �� ����';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- ��������!");
	Common::eparser "~;������";
} '^([^:]+) ����� ������.?.? ���, ������ �� ����';
P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 ��������!");
} '^([^:]+) ����� ������.?.? (.*?), ������';

P::trig
{
	Common::sparser "������";
} '^��� ����� ������ �� ����';

P::trig {} '^[^:\']+����� �����.? (�����|���) �� ���', 2000;

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- ��������!");
        return unless $Alias::values{wepassist};
        my $colr = Common::get_color($;,1);
        if ($colr eq 'H')
        {
                my $desc = Baze::alias $1;
                Common::eparser "��� $desc;���� $desc .$2";
        }
        else
        {
                Common::eparser "���";
                P::echo "\3P����� ��������, ������� ������";
                $Alias::values{wepassist} = 0;
        }
} '^[^:\']+����� �����.? (.*?) �� ��� (...).*\.' , 'f1000';

P::alias
{
        $Alias::values{wepassist} = !$Alias::values{wepassist};
        my $tt = $Alias::values{wepassist}?'�������':'��������';
        P::echo "\3P����� ������� ������� �� ��� ���� $tt";
} $Alias::values{cmd_autogetweapons};


P::bindkey
{
	if ($Alias::prof eq '�����')
	{
		Alias::take_rune $_ for split /;/,$spell_volhv{$attack_type};
	}
        Common::parser "$Alias::values{cast_command} !$friend_spell{$attack_type}! $friend_target";
} $Alias::values{bind_grouptarget};

my $at_get = 0;

P::trig
{

	return if $1 =~ /(�������|���������)/;
        for (keys %Group::group)
        {       
           return if ($Group::group{$_} eq $1);
        }
	

	$at_get++;
	if ($Common::autoloot eq 3)
	{
		my $value = $at_get;
		P::timeout sub {Common::eparser "order followers ��� ���.����" if $value eq $at_get;} , 1000, 1 if $Common::autoloot eq 3;	
	}

        Common::sparser("��� ���") if $Common::autoloot eq 2;
        Common::sparser("��� ��� ���.���� �") if $Common::autoloot eq 1;
	

} '(.*) ����.*? ���� �������� ���������� � ������\.'; 

P::trig
{
	return if $1 =~ /(�������|���������)/;
        Common::sparser("��� ���") if ($Common::autoloot > 0 and $Common::autoloot < 3);
} '(.*) ��������.? � ��������.?.?.? � ����\.'; 

P::trig
{
} '^���� (.*) ����.$', 'g1';

P::trig
{
} '^������, ����� ������ ���.$', 'g1';


P::trig
{
        return if $1 eq "���������";
        return if $1 =~ /^(�������|��������|������|������|�����)/;
	return if $1 eq "���-��";

	my $thing = $1;
	$thing =~ s/^(.*).$/$1/;
        Common::eparser ("����� $thing");
} '^([^ :-]+) ���������[��]? ��������� �� ';

P::trig
{
	my $thing = $1;
	$thing =~ s/^(.*?)..$/$1/;
	Common::eparser ("����� $thing");
} '^�� ���������� ��������� �� ([^:-\s]*)\.';

P::trig
{
	my $colr = Common::get_color($;,1);
        if ($colr eq 'H') 
        {
        	$; = CL::parse_colors("\3H$1 \3O$2 \3H�� ����� $3");
	}
} '^([^:]+ ����.?) (.*?) �� ����� (.*)$';

my $nowname;
my $full;


P::trig 
{
	P::echo $full if length $full;
	my $str = $1;
	if ($str =~ /^(.*),/)
	{
		$str = $1;
	}
	my @words = split /\s+/ , $str;
	$nowname = $words[-1];
	$full = CL::unparse_colors($;);
} '^(.*) (����� �����\.|������ �����\.|���� �����\.|�������� �����\.|����� �����\.|����� �����, ��� ������\.|����� �����, ��� ��������\.|����� �����, � ��������\.|��������� �)' , 'g1000:SHIT';


P::trig
{
	P::echo $full if length $full; $full = '';
} '^\s*$', 'f9000:SHIT';

my %affcolors = 
(
	'�����������' => 'G',
	'������������' => 'G',
	'������������' => 'G',
	'����' => 'P',
	'�����' => 'P',
	'�����' => 'P',
	'���' => 'B',
	'����' => 'B',
	'����' => 'B',
);


P::trig
{
	my ($spl,$data) = ($1,"$1$2");
	$spl =~ s/\./\\./g;
	my @aff = split /$spl/, $data;
	
	my $result = '';
	for (@aff)
	{
		next unless length;
		my $color = $affcolors{$_};
		$color = "\3$color" if length $color;
		$result .= "$color ...$_\3H";
	}
	$full .= $result;
	P::echo $result;
} '^([\. ]\.\.\.)(.*)$', 'gf1000';


P::trig
{
	my $data = $2;
	my @aff = split /, / , $data;
	
	my $result = "";
	my $sym = '*';
	if ($3 =~ /���/) {$sym = '#'};

	for (@aff)
	{
		next unless length;

		my $s;
		if (/������/) {$s = "\3J$sym"} elsif
		   (/������/) {$s = "\3P$sym"} elsif 
		   (/�����/) {$s = "\3O$sym"} elsif
                   (/������/) {$s = "\3L!$sym!"} else 
		{
			my @daff = split / \.\.\./;
			for (@daff) 
			{
				if (/�������� ����� �������/) {$s .= "\3P\:"} elsif 
				   (/������������ ����� �������/) {$s .= "\3G\:"} elsif 
				   (/������ ���������� �������/) {$s .= "\3Pi"}
			}
		};


		$result .= $s;
	}

	$full .= "$result ";
} '^([\. ]\.\.)(.*?)( ����| ����| �����| ������|)\s*$', 'g1001:SHIT';
P::disable 'SHIT';

P::alias
{
        Common::eparser "�����_���������� @_";
} '1';

P::alias
{
        Common::eparser "�����_�������� @_";
} '2';

P::alias
{
        Common::eparser "��������_������� @_";
} '3';

P::alias
{
        Common::eparser "�������_�� @_";
} '4';

1;
