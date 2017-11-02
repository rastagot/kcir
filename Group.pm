#!/usr/bin/perl

package Group;

use Common;
use Alias;
use Autoheal;

use strict;

my @messages = (
	'(=-','-=)',
	'<=','=>',
	'(=','=)',
	'(-','-)',
	'*','*',
	'<','>',
	'---->','',
	'','<----',
	'*>','<*',
	'<*','*>',
	'[>','<]',
	'<-','->',
	'@->','<-@',

);

my @close_messages = (
	'!' , '',
	'','!',
	'!','!',
);

our $group_number = 0;
our $group_spam = 0;
our %group = ();


P::trig 
{
	$group_number = 0;
	%group = ();
} '^(�� �� �� �� ���� \(� ������ ������ ����� �����\) ������!|�� ���������� ��������� ��|�� ���������� ������|�� ��������� �� ������)';

P::alias
{
	my $f = 2*(int (rand 8));
	my $left = $messages[$f];
	my $right = $messages[$f+1];
	$f = 2*(int (rand 3));
	my $close_left = $close_messages[$f];
	my $close_right = $close_messages[$f+1];
	my $message = $left.' '.$close_left."@_".$close_right.' '.$right;
        return Common::sparser "�� $message" if $group_number > 0;
        Common::screcho "$message";
} '���';

P::bindkey
{
	Common::sparser "��";
} $Alias::values{bind_group};

P::trig 
{
	$group_spam = 1;
	$group_number = 0;
	%group = ();
} '^���� ������ ������� ��:', 'f5000';

P::trig 
{
	$group_spam = 0;
} '^(���� �������������|������������� ������)';
 
P::trig
{
	return unless $group_spam;

	my ($name,$sps,$health,$ener,$here,$mem,$aff,$who,$pos) = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
	my %mvcl = (' ����� ' => "\3C",'������.' => "\3C",'������ ' => "\3K",'�.�����' => "\3L",' ����� ' => "\3J",'�.�����' => "\3B",'�������' => "\3B");
	my $ln = (length $1) + (length $2);

	if ($name =~ /^��������/)
	{
		$; = CL::parse_colors ( "��������            | N | �������� |�������|�����|�����| N | ������ | ��� | ���������");
	}
	else
	{
		my $colr = Common::get_color($;,$ln+1);
		Autoheal::check($name,$health,$colr) if $here =~ /��/;

		my $gn = $group_number>9 ? ($group_number) : ($group_number . ' '); 
		my $hlcl = "\3B"; $hlcl = "\3C" if ($here =~ /��/);
		my $mmcl = "\3B"; $mmcl = "\3C" if ($mem =~ /\d/);
	
		my @af = split // , $aff;

		$; = CL::parse_colors (
	        "\3M$name\3H$sps| \3J$gn\3H|\3".$colr."$health\3H|".$mvcl{$ener}.
                "$ener\3H|".$hlcl."$here\3H|".$mmcl."$mem\3H| \3J$gn\3H| \3J$af[1]\3C$af[2]\3O$af[3]\3L$af[4]\3M$af[5]\3D$af[6]\3H |$who|$pos"
                );
		$group{$group_number++} = $name;
	}
} '^([^ ]+)(.*?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+)';



P::trig {Common::parser "��� armor" } "^�� ������������� ���� ����� ���������.";
P::trig {Common::parser "��� bless" } "^�� ������������� ���� ����� ���������.";
P::trig {Common::parser "��� blind" } "^�� ������� !";
P::trig {Common::parser "��� curse" } "^���� ������ ��������� �� ���";
P::trig {Common::parser "��� detect invisible" } "^�� �� � ��������� ������ ������ ���������.";
P::trig {Common::parser "��� energy drain" } "^�� ������������� ���� ������ !";
P::trig {Common::parser "��� invis" } "^�� ����� ������\.";
P::trig {Common::parser "��� protect evil" } "^�� ����� �������� ����� ����� �����.";
P::trig {Common::parser "��� sanctuary"} "^����� ���� ������ ������ ���� ������.";
P::trig {Common::parser "��� strength" } "^�� ���������� ���� ������� ������";
P::trig {Common::parser "��� sense life" } "^�� ������ �� ������ ����������� �����\.";
P::trig {Common::parser "��� waterwalk" } "^�� ������ �� ������ ������ �� ����\.";
P::trig {Common::parser "��� fly" } "^�� ������������ �� �����\.";
P::trig {Common::parser "��� darkness" } "^������ ����, ���������� ���, �����\.";
P::trig {Common::parser "��� stoneskin" } "^���� ���� ����� ����� ������ � �����������\.";
P::trig {Common::parser "��� cloudly" } "^���� ��������� ��������� ������������\.";
P::trig {Common::parser "��� sun shine" } "^���� ���� ��������� ���������\.";
P::trig {Common::parser "��� enlarge" } "^���� ������� ����� ��������\.";
P::trig {Common::parser "��� blink" } "^�� ��������� ������\.";
P::trig {Common::parser "��� waterbreath" } "^�� ����� ���������� ������ �����\.";
P::trig {Common::parser "��� gods shield" } "^������� ����� ������ ������ ���� ����\.";
P::trig {Common::parser "��� awarness" } "^�� ����� ����� �����������\.";
P::trig {Common::parser "��� air shield" } "^��� ��������� ��� �����\.";
P::trig {Common::parser "��� fast regeneration" } "^����������� ���� �������� ���";
P::trig {Common::parser "��� fire shield" } "^�������� ��� ������ ������ ���� �����\.";
P::trig {Common::parser "��� ice shield" } "^������� ��� ������ ������ ���� �����\.";
P::trig {Common::parser "��� stonehand" } "^���� ���� ��������� � �������� ���������\.";
P::trig {Common::parser "��� prismatic aura" } "^�������������� ���� ������ ������ ���� ������";
P::trig {Common::parser "��� air aura" } "^��������� ���� ������ ��� �������\.";
P::trig {Common::parser "��� fire aura" } "^�������� ���� ������ ��� �������\.";
P::trig {Common::parser "��� ice aura" } "^������� ���� ������ ��� �������\.";
P::trig {Common::parser "��� magic glass" } "^�� ����� ������������� � ���������� ����������.";
P::trig {Common::parser "��� haste" } "^�� ����� ����� �����������.";
P::trig {Common::parser "~;����;������" } "^�� ������� ������...  �����... ���..";
P::trig {Common::parser "��� refresh" } "^�� ������� ������, ����� ��������� ����.";
P::trig
{
        Common::screcho "$Common::lline ���� ��� $Common::line"
} "^������� ���� ������� ��������\. �� � ������� (������ ���� ����|���������� ���� ��������)\.";


P::alias 
{
	$Common::tank = shift;
} $Alias::values{cmd_settank};

P::bindkey
{
	Common::eparser "�� $Common::tank"; 
} $Alias::values{bind_sanctank};

P::bindkey
{
	Common::eparser "�� $Common::tank"; 
} $Alias::values{bind_prizmtank};

P::bindkey
{
	Common::eparser "$Common::heal_command $Common::tank"; 
} $Alias::values{bind_healtank};

1;
