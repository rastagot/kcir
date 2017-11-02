#!/usr/bin/perl
#������ ������������ ����

package Stuff;
use Common;
use Alias;
use Inventory;

use strict;

my $flee_dir = '';
my @random_commands = (
        '��','��','��','���','���','���','��� ����','�����','���','���',
        '���','���','���','���','���','��','���','��','��','��','��','��','��','���','���','���',
	'���','��','��','�� ���','�� ��','�� ��','�� ��','�� ���','�� ���','�� ��','�� ��','��','��','��',
	'���','���','��',
);

my %rdirs =
(
        "������" => "�����", "�����" => "������",
        "�����" => "��", "��" => "�����",
        "����" => "�����", "�����" => "����",
);



our $tank_preffix =  '�� ���� -> ';

P::alias
{
	my $value = shift;
	if (! length $value)
	{
		$tank_preffix =  '�� ���� -> ';
	}
	else
	{
		$tank_preffix =  $value;
	}
} '_�������_�����';




my $scan_command = '���';
my $notopen = 1;
my $director = '';
my $simple_sneak_mode = 0;
my $auto_sneak_mode = 0;
P::alias
{
        Common::eparser "order followers ����� ����;����� ����" ;
        $Common::triggerpent = 0;
} $Alias::values{enterpent};

P::alias
{
        $Common::triggerpent = !$Common::triggerpent;
} $Alias::values{penttrigger};

P::trig 
{
        $Common::triggerpent = 0 || Common::parser "��" if $Common::triggerpent;
        Common::screcho " !pentagramm " unless $Common::triggerpent;
} '^�������� ����������� �������� � �������';

P::trig
{
        $Common::time =  time;
} '^����� ���';

P::alias
{ 
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
        Common::screcho " $tt " ;
} $Alias::values{cmd_totick};

P::alias
{
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
	my %endc = (
		'1' => '�',
		'2' => '�',
		'3' => '�',
		'4' => '�',
	);
	my $fin = ($tt > 10 and $tt < 20)?'':$endc{$tt % 10};
        return Common::eparser "��� $tt ������$fin �� ����";
} $Alias::values{cmd_saytotick};

P::trig {$Common::ice = 1;P::enable 'SHIELDS'} '^������� ���' , 'g5';
P::trig {$Common::air = 1;P::enable 'SHIELDS'} '^��������� ���' , 'g5';

P::trig {
        if ($Common::ice || $Common::air)
        {
                my $vat = CL::unparse_colors($;);
                $vat .= " \3O[ice]" if $Common::ice;
                $vat .= " \3P[air]" if $Common::air;
                $: = "$vat";
                $Common::ice = $Common::air = 0;
        }
	P::disable 'SHIELDS';
} '.', 'f3:SHIELDS';

P::disable 'SHIELDS';


my $exp = 0;
my $nexp = 0;
my $mobexp = 0;
my $mode = 0;

my $totalxp = 0;
my $battlxp = 0;
my $initiated = 0;

P::trig
{
        unless ($initiated)
        {
                $initiated = 1;
                $mobexp = $totalxp = $battlxp = 0;
                $exp = $1;
        }
        else
        {
                $nexp = $1;
                $totalxp =  $nexp - $exp;
                $battlxp = $nexp - $exp - $mobexp;
                $battlxp = 0 if $battlxp < 0;
        }
        P::echo "\3K  ����  (XP)       :   $battlxp/$mobexp";
} '^��� ���� - (.*) ���' , 'f9000';

P::trig
{
        $mobexp += $1;
	$flee_dir = '';
} '^��� ���� ��������� �� (\d+)' , 'f5000';

P::trig
{
        $mobexp++;
} '^��� ���� ��������� �����-���� �� ��������� ��������';

P::alias
{
        $initiated = 0;
        Common::eparser "���";
} $Alias::values{exp_stat_init};

P::bindkey {Common::eparser $tank_preffix . "�����"} $Alias::values{bind_tanknorth};
P::bindkey {Common::eparser $tank_preffix . "�����"} $Alias::values{bind_tankwest};
P::bindkey {Common::eparser $tank_preffix . "������"} $Alias::values{bind_tankeast};
P::bindkey {Common::eparser $tank_preffix . "��"} $Alias::values{bind_tanksouth}; 
P::bindkey {Common::eparser $tank_preffix . "�����"} "C-".$Alias::values{bind_tanknorth};
P::bindkey {Common::eparser $tank_preffix . "����"} "C-".$Alias::values{bind_tanksouth}; 

P::bindkey {Common::eparser "north"} $Alias::values{bind_gonorth};
P::bindkey {Common::eparser "west"} $Alias::values{bind_gowest};
P::bindkey {Common::eparser "east"} $Alias::values{bind_goeast};
P::bindkey {Common::eparser "south"} $Alias::values{bind_gosouth};

P::trig {$:=''} '^������� :';

P::alias 
{
	Common::eparser "���";
	$notopen = 0;
} $Alias::values{cmd_autodoors};

P::trig
{
	return if $notopen;
        my $door = $2; 
	my $where = $1;
        $door =~ s/�������� //;
        $door =~ s/ .*//;
        $where =~ s/����/�����/;
        $where =~ s/���/����/;
        Common::eparser "����� $door $where; ������� $door $where";
	$notopen = 1;
} '^(.*?):  ������� \((.*?)\)\.$';

P::alias
{
        $_ = "@_"; 
        if (length $_) { Common::parser "${Conf::char}prefix {$_ }" }
        else { Common::parser "#prefix {}" };
} $Alias::values{cmd_prefix};

P::alias 
{
	$director = Common::fupper shift; 
	P::echo "ok, $director"; 
} $Alias::values{cmd_director};


my $patt = '���� ->';

P::trig
{
	return if $2 ne $patt; 
        Common::eparser "$3" if $1 eq $director;
} '^(.+?) �������.? ������ : \'(.*?) (�����|��|������|�����|����|�����)','f2000';

P::alias
{
	$patt = "@_" if length "@_";
	P::echo "ok, pattern is ($patt)"
} '_������_������������';


P::alias
{
        $Alias::values{arda_commands} = !$Alias::values{arda_commands};
        P::echo "\3P����� ���������� ������ " . ($Alias::values{arda_commands}?'�������':'��������');
} $Alias::values{english_commands};

sub rand_command
{
	my $cmd = $random_commands[ int(rand(scalar @random_commands)) ];
	if ($simple_sneak_mode)
	{
		$cmd = '���' if $cmd eq '��';
	}
        Common::eparser $cmd unless $Common::inbattle;
        P::timeout \&rand_command, int(rand(20000)) + 3000, 1;
}

my $random_int = 1000;
my $random_out = 1;

P::alias
{
        P::timeout \&rand_command, $random_int, $random_out;

} $Alias::values{simulation};

P::alias 
{
	return $Common::autoloot = "@_" if length "@_"; 
	P::echo '��� : 0 - �������� 1 - ��� �� ������ 2 - ��� ������ 3 - ��� ������ �������� � ���������';
} $Alias::values{cmd_autoloot};


P::alias
{
        P::echo ("\3${_}Color[ \\3${_} ]") foreach ('B'..'P')
} $Alias::values{cmd_colors};

P::alias
{
        if (@_)
        {
                @Inventory::noflee = @_;
        }
        else
        {
                P::echo "!����� : @Inventory::noflee"
        }
} $Alias::values{cmd_noflee};

my $ldir = '';


P::alias
{
	$Common::autoscan = !$Common::autoscan;
	P::echo "\3K��������������� " . ($Common::autoscan ?"��������":"���������");
} '_�����������';


P::alias
{
        my $dir = $rdirs{$ldir};
        Common::parser "~";
        Common::parser "��� $_" for @Inventory::noflee;
        Common::parser "������ $dir";
} $Alias::values{cmd_flee};

P::alias {%Common::dt_directions = ();Common::eparser "�����"} '�!';
P::alias {%Common::dt_directions = ();Common::eparser "��"} '�!';
P::alias {%Common::dt_directions = ();Common::eparser "������"} '�!';
P::alias {%Common::dt_directions = ();Common::eparser "�����"} '�!';
P::alias {%Common::dt_directions = ();Common::eparser "�����"} '��!';
P::alias {%Common::dt_directions = ();Common::eparser "����"} '��!';



P::alias
{
	$flee_dir = $rdirs{$ldir};
	Common::sparser "������ $flee_dir";
} '����';

P::alias
{
	$flee_dir = $rdirs{$ldir};
	Common::sparser "$flee_dir";
} '�����';

P::alias
{
	my $todir = "@_";
	Common::sparser "�������� $todir;$rdirs{$todir};������ $rdirs{$todir}";
} '��';

my $in_sneak = 0;

P::alias
{
	$auto_sneak_mode = !$auto_sneak_mode;
	my $tt = $auto_sneak_mode?'�������':'��������';
	P::echo "\3KP���� ����������������� $tt";
} '_�������������';


P::alias
{
	$simple_sneak_mode = !$simple_sneak_mode;
	my $tt = $simple_sneak_mode?'�������':'��������';
	P::echo "\3KP���� �������� ������������� $tt";
	Common::sparser "_����������" if $simple_sneak_mode;
} '������';

my $lasttime = (localtime)[0];

P::alias
{
	return unless $simple_sneak_mode;
	Common::sparser "�����������" unless $in_sneak;	
	my $nowtime = (localtime)[0];
	unless ($Common::in_hide)
	{
		if ($nowtime != $lasttime)
		{
			Common::sparser "�������";
			$lasttime = $nowtime;
		}
	}
} '_����������';

P::alias
{
	P::echo "\3KP���� �������� ������������� ��������" if $simple_sneak_mode;
        $simple_sneak_mode = 0;
 	Common::sparser '����';
} '���';

P::trig 
{
	Common::sparser "�����������" if $simple_sneak_mode;
} '^���� ������������ ����� �������';

P::trig 
{
	$Common::in_hide = 1; 
} '^���� �� ��� ������ ����������, ��� ������ �������� ?';

P::trig
{
	Common::sparser "_����������" if $simple_sneak_mode;
} '^�������� ������ � �����', 'f9000';

P::trig
{
	$in_sneak = 0;
} '^�� �� ������ ���������� ���������';

P::trig
{
	$in_sneak = 1;
} '^������, �� ����������� ��������� ��������';

P::trig
{
	$Common::in_hide = 1;
} '^���������  : !���������!';

P::trig
{
	$in_sneak = 1;
} '^���������  : !��������!'; 

P::trig
{
	$Common::in_sneak = 0;
	Common::sparser "_����������" if $simple_sneak_mode;
} '^�� ����� ������� ����������';

P::trig
{
	$Common::in_hide = 0;
	Common::sparser "_����������" if $simple_sneak_mode;
} '^�� ���������� ���������';

P::trig
{
	$Common::in_hide = 0;
	Common::sparser "_����������" if $simple_sneak_mode;
} '^�� �� ������ �������� ����������';

P::trig
{
	$Common::in_hide = 1;
} '^������, �� ����������� ����������';

P::alias
{
	Common::sparser "����" unless $Common::in_hide;
	Common::sparser "�� $_[0]";
} '_��������';

P::alias {if($auto_sneak_mode){Common::sparser "�������� north"}else {Common::sparser "n";}} '�';
P::alias {if($auto_sneak_mode){Common::sparser "�������� west"}else {Common::sparser "w";}} '�';
P::alias {if($auto_sneak_mode){Common::sparser "�������� south"}else {Common::sparser "s";}} '�';
P::alias {if($auto_sneak_mode){Common::sparser "�������� east"}else {Common::sparser "e";}} '�';

P::alias {if($auto_sneak_mode){Common::sparser "�������� down"}else {Common::sparser "dow";}} '��';
P::alias {if($auto_sneak_mode){Common::sparser "�������� up"}else {Common::sparser "u";}} '���';

P::alias {Common::sparser "�"} '�����';
P::alias {Common::sparser "�"} 'west';
P::alias {Common::sparser "�"} 'east';
P::alias {Common::sparser "�"} '������';
P::alias {Common::sparser "�"} 'south';
P::alias {Common::sparser "�"} '��';
P::alias {Common::sparser "�"} 'north';
P::alias {Common::sparser "�"} '�����';
P::alias {Common::sparser "���"} 'up';
P::alias {Common::sparser "���"} '�����';
P::alias {Common::sparser "��"} 'down';
P::alias {Common::sparser "��"} '����';

P::alias
{
	Common::eparser "���� @_;���" for (1..10)
} '_���';

P::alias
{
	Common::eparser "#6000:6000 ���� @_";
} '_����';

P::trig
{
	return unless length $flee_dir;
	$ldir = $rdirs{$flee_dir};
	Common::sparser "~;_����������" if $simple_sneak_mode;
	Common::sparser $ldir;
	$flee_dir = '';
} '^�� ������ ������� � ���� �����';

P::bindkey {Common::eparser "~;killall"} $Alias::values{bind_tilde};
P::bindkey {Common::eparser "~;killall"} '`';


P::alias {$scan_command = '���';Common::sparser "������"} '���';


my $scan_key = $Alias::values{bind_scan};
$scan_key = $Conf::windows ? "M-$scan_key" : "C-]";

P::bindkey {$scan_command = '���';Common::eparser "���"} $scan_key;
P::bindkey {Common::eparser $scan_command} $Alias::values{bind_scan};

P::bindkey {return Common::eparser "������" if $Common::inbattle; Common::eparser "���"} $Alias::values{bind_assist};

my $ll = 0;

P::alias
{
	Common::eparser "�������;��� $Common::ne";
} '����';


P::alias
{
	return if $Common::inst;
	$Common::inst = 1;
	Common::sparser '���'
} '������';

P::alias
{
	$Common::inst = 0;
	MUD::sendl ('~')
} '~';

my $lock_room = 0;
my $activate_lock = 0;

my $tank_direction = '';
P::trig
{
        $ldir = $3;
	%Common::dt_directions = ();

	if ( $lock_room eq 2 || ( $activate_lock && $lock_room eq 1 ) )
	{
		Common::sparser "����������_�������";
		$activate_lock = 0;
	}

	Common::sparser "$scan_command" if ($Common::autoscan and $Common::speedwalk eq 0);
	$Common::speedwalk-- if $Common::speedwalk > 0;
	$Common::tank_direction = '';
} "^�� ��������� (������ �� .*? )?(�� )?(.*)\.";

P::alias
{
        my $value = shift;
        if (! length $value)
        {
                P::echo '������� ������������ ��� - ���� �������� (�����)';
                P::echo '���������� ��� ����� ��������';
                P::echo '2 - ������ 1 - ������ ���� ���� ����';
                P::echo '0 - ��������� ��� ����';
        }
        $lock_room = $value;
} '_��������';

P::trig
{
	return unless $lock_room;
	Common::sparser "����������_�������";
} '^�����, �������������� �����, �������.';

P::trig
{
	return unless $lock_room;
	Common::sparser "����������_�������";
} '^�����, �������������� �����, �������.';



P::trig
{
	if ($Common::tank eq $1)
	{
	
        	$activate_lock = 1 if ($lock_room eq '1');
		$tank_direction = $3;
		$tank_direction =~ s/^�(����|���)$/$1/;
	        Common::sparser "look $tank_direction";
	}
} '^([�����������娸����������������������������������������������������]+) (����|����|������.?|�����.?|�����.?) �?�? ?(.*)\.','f700';

open TABLES, "<$Conf::tables_rc_proxy_file";

my @randt = <TABLES>;
chomp @randt;
close TABLES;

sub random_table {$randt[rand scalar @randt]}

P::alias { Common::parser "�� ������� " . random_table . " � �������� '@_'" } '��������';
P::alias { Common::parser "�� ������ " . random_table . " � �������� '@_'" } '���������';

P::trig
{
        my $colr = Common::get_color($;,1);
        return if (not ($colr eq 'H'));
        for (keys %Group::group)
        {
           return if ($Group::group{$_} eq $1);
        }

        $; = CL::parse_colors("\3N$1 \3H����$2 ���� $3");

} '^([�������������+����������������������������������������������������]+) ����(.?) ���� ([�����������就����������������������������������������������������]+)$';


P::trig
{
        for (keys %Group::group)
        {
           return if ($Group::group{$_} eq $1);
        }
        return if $1 =~ /^(�������|�����|����������|�����|���������)/;
        $; = CL::parse_colors("\3N$1 \3H������$2 �� �����������.");

} '^([�������������+����������������������������������������������������]+) ������(.?.?.?) �� �����������\.','f700';

P::bindkey
{
	Common::sparser "����������_�������";
} "�";

P::bindkey
{
	Common::sparser "$scan_command";
} "k5";

P::bindkey {$scan_command = '���';Common::sparser "���"} 'C-k5';

P::bindkey
{
	$tank_direction =~ s/^(����|���)$/�$1/;
	Common::sparser "$tank_direction" if length $tank_direction;
	$tank_direction = '';
} "k7";

P::alias
{
	Common::sparser "look $tank_direction";
} "��������_��_������";


my $achtung = 0;
P::alias
{
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
	if ($tt < 15 && !$achtung)
	{
		P::echo "\3L�� ���� �������. ������� ���� �� ����. ��� ������ ��� ���";
		P::echo "";
		$achtung = 1;
		return
	}
	Common::sparser "_������� @_";
	$achtung = 0;
} '�������';



unless ($Conf::windows)
{
	P::alias
	{	
		system 'mmcb&';
	} 'mmcb'
}

1;
