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
} '^(Но вы же не член \(в лучшем смысле этого слова\) группы!|Вы прекратили следовать за|Вы распустили группу|Вы исключены из группы)';

P::alias
{
	my $f = 2*(int (rand 8));
	my $left = $messages[$f];
	my $right = $messages[$f+1];
	$f = 2*(int (rand 3));
	my $close_left = $close_messages[$f];
	my $close_right = $close_messages[$f+1];
	my $message = $left.' '.$close_left."@_".$close_right.' '.$right;
        return Common::sparser "гг $message" if $group_number > 0;
        Common::screcho "$message";
} 'ггр';

P::bindkey
{
	Common::sparser "гр";
} $Alias::values{bind_group};

P::trig 
{
	$group_spam = 1;
	$group_number = 0;
	%group = ();
} '^Ваша группа состоит из:', 'f5000';

P::trig 
{
	$group_spam = 0;
} '^(Ваши последователи|Последователи членов)';
 
P::trig
{
	return unless $group_spam;

	my ($name,$sps,$health,$ener,$here,$mem,$aff,$who,$pos) = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
	my %mvcl = (' Полон ' => "\3C",'Отдохн.' => "\3C",'Хорошо ' => "\3K",'Л.устал' => "\3L",' Устал ' => "\3J",'О.устал' => "\3B",'Истощен' => "\3B");
	my $ln = (length $1) + (length $2);

	if ($name =~ /^Персонаж/)
	{
		$; = CL::parse_colors ( "Персонаж            | N | Здоровье |Энергия|Рядом|Учить| N | Аффект | Кто | Положение");
	}
	else
	{
		my $colr = Common::get_color($;,$ln+1);
		Autoheal::check($name,$health,$colr) if $here =~ /Да/;

		my $gn = $group_number>9 ? ($group_number) : ($group_number . ' '); 
		my $hlcl = "\3B"; $hlcl = "\3C" if ($here =~ /Да/);
		my $mmcl = "\3B"; $mmcl = "\3C" if ($mem =~ /\d/);
	
		my @af = split // , $aff;

		$; = CL::parse_colors (
	        "\3M$name\3H$sps| \3J$gn\3H|\3".$colr."$health\3H|".$mvcl{$ener}.
                "$ener\3H|".$hlcl."$here\3H|".$mmcl."$mem\3H| \3J$gn\3H| \3J$af[1]\3C$af[2]\3O$af[3]\3L$af[4]\3M$af[5]\3D$af[6]\3H |$who|$pos"
                );
		$group{$group_number++} = $name;
	}
} '^([^ ]+)(.*?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+)';



P::trig {Common::parser "ггр armor" } "^Вы почувствовали себя менее защищенно.";
P::trig {Common::parser "ггр bless" } "^Вы почувствовали себя менее доблестно.";
P::trig {Common::parser "ггр blind" } "^Вы ослепли !";
P::trig {Common::parser "ггр curse" } "^Боги сурово поглядели на Вас";
P::trig {Common::parser "ггр detect invisible" } "^Вы не в состоянии больше видеть невидимых.";
P::trig {Common::parser "ггр energy drain" } "^Вы почувствовали себя слабее !";
P::trig {Common::parser "ггр invis" } "^Вы вновь видимы\.";
P::trig {Common::parser "ггр protect evil" } "^Вы вновь ощущаете страх перед тьмой.";
P::trig {Common::parser "ггр sanctuary"} "^Белая аура вокруг Вашего тела угасла.";
P::trig {Common::parser "ггр strength" } "^Вы чувствуете себя немного слабее";
P::trig {Common::parser "ггр sense life" } "^Вы больше не можете чувствовать жизнь\.";
P::trig {Common::parser "ггр waterwalk" } "^Вы больше не можете ходить по воде\.";
P::trig {Common::parser "ггр fly" } "^Вы приземлились на землю\.";
P::trig {Common::parser "ггр darkness" } "^Облако тьмы, окружающее Вас, спало\.";
P::trig {Common::parser "ггр stoneskin" } "^Ваша кожа вновь стала мягкой и бархатистой\.";
P::trig {Common::parser "ггр cloudly" } "^Ваши очертания приобрели отчетливость\.";
P::trig {Common::parser "ггр sun shine" } "^Ваше тело перестало светиться\.";
P::trig {Common::parser "ггр enlarge" } "^Ваши размеры стали прежними\.";
P::trig {Common::parser "ггр blink" } "^Вы перестали мигать\.";
P::trig {Common::parser "ггр waterbreath" } "^Вы более неспособны дышать водой\.";
P::trig {Common::parser "ггр gods shield" } "^Голубой кокон вокруг Вашего тела угас\.";
P::trig {Common::parser "ггр awarness" } "^Вы стали менее внимательны\.";
P::trig {Common::parser "ггр air shield" } "^Ваш воздушный щит исчез\.";
P::trig {Common::parser "ггр fast regeneration" } "^Живительная сила покинула Вас";
P::trig {Common::parser "ггр fire shield" } "^Огненный щит вокруг Вашего тела исчез\.";
P::trig {Common::parser "ггр ice shield" } "^Ледяной щит вокруг Вашего тела исчез\.";
P::trig {Common::parser "ггр stonehand" } "^Ваши руки вернулись к прежнему состоянию\.";
P::trig {Common::parser "ггр prismatic aura" } "^Призматическая аура вокруг Вашего тела угасла";
P::trig {Common::parser "ггр air aura" } "^Воздушная аура вокруг Вас исчезла\.";
P::trig {Common::parser "ггр fire aura" } "^Огненная аура вокруг Вас исчезла\.";
P::trig {Common::parser "ггр ice aura" } "^Ледяная аура вокруг Вас исчезла\.";
P::trig {Common::parser "ггр magic glass" } "^Вы вновь чувствительны к магическим поражениям.";
P::trig {Common::parser "ггр haste" } "^Вы стали более медлительны.";
P::trig {Common::parser "~;прос;встать" } "^Вы слишком устали...  Спать... Спа..";
P::trig {Common::parser "ггр refresh" } "^Вы слишком устали, чтобы следовать туда.";
P::trig
{
        Common::screcho "$Common::lline есть мем $Common::line"
} "^Наконец Ваши занятия окончены\. Вы с улыбкой (убрали свои резы|захлопнули свой часослов)\.";


P::alias 
{
	$Common::tank = shift;
} $Alias::values{cmd_settank};

P::bindkey
{
	Common::eparser "ос $Common::tank"; 
} $Alias::values{bind_sanctank};

P::bindkey
{
	Common::eparser "па $Common::tank"; 
} $Alias::values{bind_prizmtank};

P::bindkey
{
	Common::eparser "$Common::heal_command $Common::tank"; 
} $Alias::values{bind_healtank};

1;
