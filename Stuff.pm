#!/usr/bin/perl
#¬с€ка€ бессистемна€ б€ка

package Stuff;
use Common;
use Alias;
use Inventory;

use strict;

my $flee_dir = '';
my @random_commands = (
        'см','см','см','огл','эки','инв','кто боги','врем€','очк','очк',
        'вых','вых','вых','вых','эки','эк','инв','гр','гр','гр','гр','гр','гр','очк','очк','очк',
	'вых','гр','см','др дсс','др нд','др сп','др гд','др рсп','др дзп','др тв','др рп','гр','гр','гр',
	'вых','огл','аф',
);

my %rdirs =
(
        "восток" => "запад", "запад" => "восток",
        "север" => "юг", "юг" => "север",
        "вниз" => "вверх", "вверх" => "вниз",
);



our $tank_preffix =  'гг “јЌ  -> ';

P::alias
{
	my $value = shift;
	if (! length $value)
	{
		$tank_preffix =  'гг “јЌ  -> ';
	}
	else
	{
		$tank_preffix =  $value;
	}
} '_префикс_танку';




my $scan_command = 'огл';
my $notopen = 1;
my $director = '';
my $simple_sneak_mode = 0;
my $auto_sneak_mode = 0;
P::alias
{
        Common::eparser "order followers войти пент;войти пент" ;
        $Common::triggerpent = 0;
} $Alias::values{enterpent};

P::alias
{
        $Common::triggerpent = !$Common::triggerpent;
} $Alias::values{penttrigger};

P::trig 
{
        $Common::triggerpent = 0 || Common::parser "вп" if $Common::triggerpent;
        Common::screcho " !pentagramm " unless $Common::triggerpent;
} '^Ћазурна€ пентаграмма возникла в воздухе';

P::trig
{
        $Common::time =  time;
} '^ћинул час';

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
		'1' => 'а',
		'2' => 'ы',
		'3' => 'ы',
		'4' => 'ы',
	);
	my $fin = ($tt > 10 and $tt < 20)?'':$endc{$tt % 10};
        return Common::eparser "гов $tt секунд$fin до тика";
} $Alias::values{cmd_saytotick};

P::trig {$Common::ice = 1;P::enable 'SHIELDS'} '^Ћед€ной щит' , 'g5';
P::trig {$Common::air = 1;P::enable 'SHIELDS'} '^¬оздушный щит' , 'g5';

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
        P::echo "\3K  ќпыт  (XP)       :   $battlxp/$mobexp";
} '^¬аш опыт - (.*) очк' , 'f9000';

P::trig
{
        $mobexp += $1;
	$flee_dir = '';
} '^¬аш опыт повысилс€ на (\d+)' , 'f5000';

P::trig
{
        $mobexp++;
} '^¬аш опыт повысилс€ всего-лишь на маленькую единичку';

P::alias
{
        $initiated = 0;
        Common::eparser "очк";
} $Alias::values{exp_stat_init};

P::bindkey {Common::eparser $tank_preffix . "север"} $Alias::values{bind_tanknorth};
P::bindkey {Common::eparser $tank_preffix . "запад"} $Alias::values{bind_tankwest};
P::bindkey {Common::eparser $tank_preffix . "восток"} $Alias::values{bind_tankeast};
P::bindkey {Common::eparser $tank_preffix . "юг"} $Alias::values{bind_tanksouth}; 
P::bindkey {Common::eparser $tank_preffix . "вверх"} "C-".$Alias::values{bind_tanknorth};
P::bindkey {Common::eparser $tank_preffix . "вниз"} "C-".$Alias::values{bind_tanksouth}; 

P::bindkey {Common::eparser "north"} $Alias::values{bind_gonorth};
P::bindkey {Common::eparser "west"} $Alias::values{bind_gowest};
P::bindkey {Common::eparser "east"} $Alias::values{bind_goeast};
P::bindkey {Common::eparser "south"} $Alias::values{bind_gosouth};

P::trig {$:=''} '^Ћистать :';

P::alias 
{
	Common::eparser "огл";
	$notopen = 0;
} $Alias::values{cmd_autodoors};

P::trig
{
	return if $notopen;
        my $door = $2; 
	my $where = $1;
        $door =~ s/веро€тно //;
        $door =~ s/ .*//;
        $where =~ s/¬ерх/¬верх/;
        $where =~ s/Ќиз/¬низ/;
        Common::eparser "отпер $door $where; открыть $door $where";
	$notopen = 1;
} '^(.*?):  закрыто \((.*?)\)\.$';

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


my $patt = '“јЌ  ->';

P::trig
{
	return if $2 ne $patt; 
        Common::eparser "$3" if $1 eq $director;
} '^(.+?) сообщил.? группе : \'(.*?) (север|юг|восток|запад|вниз|вверх)','f2000';

P::alias
{
	$patt = "@_" if length "@_";
	P::echo "ok, pattern is ($patt)"
} '_шаблон_управл€ющего';


P::alias
{
        $Alias::values{arda_commands} = !$Alias::values{arda_commands};
        P::echo "\3P–ежим английских команд " . ($Alias::values{arda_commands}?'включен':'выключен');
} $Alias::values{english_commands};

sub rand_command
{
	my $cmd = $random_commands[ int(rand(scalar @random_commands)) ];
	if ($simple_sneak_mode)
	{
		$cmd = 'огл' if $cmd eq 'гр';
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
	P::echo 'лут : 0 - отключен 1 - лут из трупов 2 - лут трупов 3 - лут трупов чармисом с задержкой';
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
                P::echo "!флики : @Inventory::noflee"
        }
} $Alias::values{cmd_noflee};

my $ldir = '';


P::alias
{
	$Common::autoscan = !$Common::autoscan;
	P::echo "\3Kјвтоогл€дывание " . ($Common::autoscan ?"включено":"выключено");
} '_огл€дывание';


P::alias
{
        my $dir = $rdirs{$ldir};
        Common::parser "~";
        Common::parser "сн€ $_" for @Inventory::noflee;
        Common::parser "бежать $dir";
} $Alias::values{cmd_flee};

P::alias {%Common::dt_directions = ();Common::eparser "север"} 'с!';
P::alias {%Common::dt_directions = ();Common::eparser "юг"} 'ю!';
P::alias {%Common::dt_directions = ();Common::eparser "восток"} 'в!';
P::alias {%Common::dt_directions = ();Common::eparser "запад"} 'з!';
P::alias {%Common::dt_directions = ();Common::eparser "вверх"} 'вв!';
P::alias {%Common::dt_directions = ();Common::eparser "вниз"} 'вн!';



P::alias
{
	$flee_dir = $rdirs{$ldir};
	Common::sparser "бежать $flee_dir";
} 'бежв';

P::alias
{
	$flee_dir = $rdirs{$ldir};
	Common::sparser "$flee_dir";
} 'назад';

P::alias
{
	my $todir = "@_";
	Common::sparser "крастьс€ $todir;$rdirs{$todir};бежать $rdirs{$todir}";
} 'тс';

my $in_sneak = 0;

P::alias
{
	$auto_sneak_mode = !$auto_sneak_mode;
	my $tt = $auto_sneak_mode?'включен':'выключен';
	P::echo "\3KPежим автоподкрадывани€ $tt";
} '_подкрадывание';


P::alias
{
	$simple_sneak_mode = !$simple_sneak_mode;
	my $tt = $simple_sneak_mode?'включен':'выключен';
	P::echo "\3KPежим обычного подкрадывани€ $tt";
	Common::sparser "_спр€татьс€" if $simple_sneak_mode;
} 'подкра';

my $lasttime = (localtime)[0];

P::alias
{
	return unless $simple_sneak_mode;
	Common::sparser "подкрастьс€" unless $in_sneak;	
	my $nowtime = (localtime)[0];
	unless ($Common::in_hide)
	{
		if ($nowtime != $lasttime)
		{
			Common::sparser "спр€тат";
			$lasttime = $nowtime;
		}
	}
} '_спр€татьс€';

P::alias
{
	P::echo "\3KPежим обычного подкрадывани€ выключен" if $simple_sneak_mode;
        $simple_sneak_mode = 0;
 	Common::sparser 'по€в';
} 'по€';

P::trig 
{
	Common::sparser "подкрастьс€" if $simple_sneak_mode;
} '^¬аши передвижени€ стали заметны';

P::trig 
{
	$Common::in_hide = 1; 
} '^ ого ¬ы так сильно ненавидите, что хотите заколоть ?';

P::trig
{
	Common::sparser "_спр€татьс€" if $simple_sneak_mode;
} '^ ровушка стынет в жилах', 'f9000';

P::trig
{
	$in_sneak = 0;
} '^¬ы не сумели пробратьс€ незаметно';

P::trig
{
	$in_sneak = 1;
} '^’орошо, ¬ы попытаетесь двигатьс€ бесшумно';

P::trig
{
	$Common::in_hide = 1;
} '^—осто€ние  : !спр€талс€!';

P::trig
{
	$in_sneak = 1;
} '^—осто€ние  : !крадетс€!'; 

P::trig
{
	$Common::in_sneak = 0;
	Common::sparser "_спр€татьс€" if $simple_sneak_mode;
} '^¬ы стали заметны окружающим';

P::trig
{
	$Common::in_hide = 0;
	Common::sparser "_спр€татьс€" if $simple_sneak_mode;
} '^¬ы прекратили пр€татьс€';

P::trig
{
	$Common::in_hide = 0;
	Common::sparser "_спр€татьс€" if $simple_sneak_mode;
} '^¬ы не сумели остатьс€ незаметным';

P::trig
{
	$Common::in_hide = 1;
} '^’орошо, ¬ы попытаетесь спр€татьс€';

P::alias
{
	Common::sparser "спр€" unless $Common::in_hide;
	Common::sparser "кр $_[0]";
} '_крастьс€';

P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ north"}else {Common::sparser "n";}} 'с';
P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ west"}else {Common::sparser "w";}} 'з';
P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ south"}else {Common::sparser "s";}} 'ю';
P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ east"}else {Common::sparser "e";}} 'в';

P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ down"}else {Common::sparser "dow";}} 'вн';
P::alias {if($auto_sneak_mode){Common::sparser "крастьс€ up"}else {Common::sparser "u";}} 'вве';

P::alias {Common::sparser "з"} 'запад';
P::alias {Common::sparser "з"} 'west';
P::alias {Common::sparser "в"} 'east';
P::alias {Common::sparser "в"} 'восток';
P::alias {Common::sparser "ю"} 'south';
P::alias {Common::sparser "ю"} 'юг';
P::alias {Common::sparser "с"} 'north';
P::alias {Common::sparser "с"} 'север';
P::alias {Common::sparser "вве"} 'up';
P::alias {Common::sparser "вве"} 'вверх';
P::alias {Common::sparser "вн"} 'down';
P::alias {Common::sparser "вн"} 'вниз';

P::alias
{
	Common::eparser "подн @_;вст" for (1..10)
} '_под';

P::alias
{
	Common::eparser "#6000:6000 подн @_";
} '_подн';

P::trig
{
	return unless length $flee_dir;
	$ldir = $rdirs{$flee_dir};
	Common::sparser "~;_спр€татьс€" if $simple_sneak_mode;
	Common::sparser $ldir;
	$flee_dir = '';
} '^¬ы быстро убежали с пол€ битвы';

P::bindkey {Common::eparser "~;killall"} $Alias::values{bind_tilde};
P::bindkey {Common::eparser "~;killall"} '`';


P::alias {$scan_command = 'вых';Common::sparser "выходы"} 'вых';


my $scan_key = $Alias::values{bind_scan};
$scan_key = $Conf::windows ? "M-$scan_key" : "C-]";

P::bindkey {$scan_command = 'огл';Common::eparser "огл"} $scan_key;
P::bindkey {Common::eparser $scan_command} $Alias::values{bind_scan};

P::bindkey {return Common::eparser "отступ" if $Common::inbattle; Common::eparser "пом"} $Alias::values{bind_assist};

my $ll = 0;

P::alias
{
	Common::eparser "спр€тат;кто $Common::ne";
} 'спр€';


P::alias
{
	return if $Common::inst;
	$Common::inst = 1;
	Common::sparser 'вст'
} 'встать';

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
		Common::sparser "запечатать_комнату";
		$activate_lock = 0;
	}

	Common::sparser "$scan_command" if ($Common::autoscan and $Common::speedwalk eq 0);
	$Common::speedwalk-- if $Common::speedwalk > 0;
	$Common::tank_direction = '';
} "^¬ы поплелись (следом за .*? )?(на )?(.*)\.";

P::alias
{
        my $value = shift;
        if (! length $value)
        {
                P::echo ' оманда используецца так - один параметр (число)';
                P::echo 'означающее как нужно печатать';
                P::echo '2 -  аждую 1 -  аждую если ушел танк';
                P::echo '0 - отключить эту фичу';
        }
        $lock_room = $value;
} '_печатать';

P::trig
{
	return unless $lock_room;
	Common::sparser "запечатать_комнату";
} '^ћаги€, запечатывающа€ входы, пропала.';

P::trig
{
	return unless $lock_room;
	Common::sparser "запечатать_комнату";
} '^ћаги€, запечатывающа€ входы, пропала.';



P::trig
{
	if ($Common::tank eq $1)
	{
	
        	$activate_lock = 1 if ($lock_room eq '1');
		$tank_direction = $3;
		$tank_direction =~ s/^в(верх|низ)$/$1/;
	        Common::sparser "look $tank_direction";
	}
} '^([јаЅб¬в√гƒд≈е®Є∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъџы№ьЁэёюя€]+) (ушел|ушла|улетел.?|уплыл.?|уехал.?) н?а? ?(.*)\.','f700';

open TABLES, "<$Conf::tables_rc_proxy_file";

my @randt = <TABLES>;
chomp @randt;
close TABLES;

sub random_table {$randt[rand scalar @randt]}

P::alias { Common::parser "эм достала " . random_table . " с надписью '@_'" } 'табличка';
P::alias { Common::parser "эм достал " . random_table . " с надписью '@_'" } 'атабличка';

P::trig
{
        my $colr = Common::get_color($;,1);
        return if (not ($colr eq 'H'));
        for (keys %Group::group)
        {
           return if ($Group::group{$_} eq $1);
        }

        $; = CL::parse_colors("\3N$1 \3Hвз€л$2 труп $3");

} '^([јаЅб¬в√гƒд≈ег+∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъџы№ьЁэёюя€]+) вз€л(.?) труп ([јаЅб¬в√гƒд≈е∞±∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъџы№ьЁэёюя€]+)$';


P::trig
{
        for (keys %Group::group)
        {
           return if ($Group::group{$_} eq $1);
        }
        return if $1 =~ /^(ќхотник|—луга| араульный|¬ар€г|’ранитель)/;
        $; = CL::parse_colors("\3N$1 \3Hпо€вил$2 из пентаграммы.");

} '^([јаЅб¬в√гƒд≈ег+∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъџы№ьЁэёюя€]+) по€вил(.?.?.?) из пентаграммы\.','f700';

P::bindkey
{
	Common::sparser "запечатать_комнату";
} "Џ";

P::bindkey
{
	Common::sparser "$scan_command";
} "k5";

P::bindkey {$scan_command = 'огл';Common::sparser "огл"} 'C-k5';

P::bindkey
{
	$tank_direction =~ s/^(верх|низ)$/в$1/;
	Common::sparser "$tank_direction" if length $tank_direction;
	$tank_direction = '';
} "k7";

P::alias
{
	Common::sparser "look $tank_direction";
} "смотреть_за_танком";


my $achtung = 0;
P::alias
{
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
	if ($tt < 15 && !$achtung)
	{
		P::echo "\3LЌе буду ставить. слишком мало до тика. »ли набери еще раз";
		P::echo "";
		$achtung = 1;
		return
	}
	Common::sparser "_переход @_";
	$achtung = 0;
} 'переход';



unless ($Conf::windows)
{
	P::alias
	{	
		system 'mmcb&';
	} 'mmcb'
}

1;
