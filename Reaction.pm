#!/usr/bin/perl

package Reaction;

use Common;
use Alias;

use strict;


my %dirs =
(
        "восток" => "east", "запад" => "west",
        "север" => "north", "юг" => "south",
        "вниз" => "down", "вверх" => "up",
        "низ" => "down", "верх" => "up",
);

my %friend_spell =
(
        'hold' => 'снять оцепенение',
        'blind' => 'вылечить слепоту',
        'poison' => 'удалить яд',
        'silence' => 'снять молчание',
);

my %spell_volhv =
(
	'hold' => 'движения;благости',
	'blind' => 'твердыни;воды;заполнения',
	'poison' => 'отражения;заполнения',
	'silence' => 'заполнения;благости',
);

my %death_traps = (
	"Бездна" => 0,
	"Болотные топи" => 0,
	"Большая яма" => 0,
	"Бревно" => 1,
	"Гать болотная" => 0,
	"Гиблая топь" => 0,
	"Гиблое место" => 0,
	"Глубокая яма" => 0,
	"Глубокий обрыв" => 0,
	"Глубокий овраг" => 0,
	"Хлипкое место" => 0,
	"Капкан" => 0,
	"Кислотный туман" => 0,
	"Ледяной ветер" => 0,
	"Ловушка" => 0,
	"Ловушка с кольями" => 0,
	"Ловушка в пещере" => 0,
	"Ловчая яма" => 0,
	"Маленькая пещерка" => 0,
	"Медвежий капкан" => 0,
	"На обломках" => 0,
	"Над огненными водами" => 0,
	"Небольшая пещера с нависшим потолком" => 0,
	"Недостроенный мостик" => 0,
	"Обрыв" => 0,
	"Обвал" => 0,
	"Огнедышащий вулкан" => 0,
	"Огненная река" => 0,
	"Огненный смерч" => 0,
	"Огромный котлован с бурлющей лавой" => 0,
	"Опасное место" => 0,
	"Охотничий силок" => 0,
	"Окно воды" => 0,
	"Омут" => 0,
	"Омут" => 0,
	"Омут" => 0,
	"Острые коряги" => 0,
	"Острые скалы" => 0,
	"Овраг у дороги" => 0,
	"Падая с вершины..." => 0,
	"Пенек-топляк" => 0,
	"Пещера, заполненная лавой" => 0,
	"Погибель" => 0,
	"Покои Свята" => 0,
	"Полусгоревший склеп" => 0,
	"Потрескавшийся выступ" => 0,
	"Пропасть" => 0,
	"Провал" => 0,
	"Пустая бражневая яма" => 0,
	"Пылающая Скала." => 0,
	"Яма" => 1,
	"Яма с костями" => 0,
	"Яма в пещере" => 0,
	"Расселина-ловушка" => 0,
	"Разряды молний" => 0,
	"Речной затон" => 0,
	"Ров наполненный водой" => 0,
	"Сегодня не Ваш день!" => 0,
	"Смерть в овраге" => 0,
	"Среди клубов пара" => 0,
	"Старая яма со сломанными кольями" => 0,
	"Сточная яма" => 0,
	"Свалившись с моста" => 0,
	"Темная яма" => 0,
	"Темный омут" => 0,
	"Тоненький ледок" => 0,
	"Топкие места" => 1,
	"Топкое место" => 0,
	"Топь" => 0,
	"Тропинка, обложенная прутьями" => 0,
	"Трясина" => 0,
	"У навала камней" => 0,
	"Упав в пропасть" => 0,
	"Жилые комнаты дедули" => 0,
	"В бурлящей воде" => 0, 
	"В обрушившийся рудник" => 0,
	"В темнице" => 1,
	"В топи" => 1, 
	"Ветхая кочка" => 0,
	"Волчья яма" => 0,
	"Заброшенная широкая дорога по лесу" => 1,
	"Западня" => 0,
	"Затресье" => 0,
	"Завал" => 0, 
	"Черный омут" => 0,
	"Яма с кольями" => 0,
	"слишком темно." => 1,
);

my $oneofdir = '[Вв][Оо][Сс][Тт][Оо][Кк]|[Зз][Аа][Пп][Аа][Дд]|[Юю][Гг]|[Сс][Ее][Вв][Ее][Рр]|[Вв][Нн][Ии][Зз]|[Вв][Вв][Ее][Рр][Хх]';

my $friend_target = '';
my $attack_type = '';

P::trig
{
        my $tt = 120 - time + $Common::time; 
	$tt -= 60 while $tt > 60;
	$tt += 60 while $tt < 0;
        $; = CL::parse_colors ("               *%*%*%*%*%*%*%*%*     $1 В \3BХОЛДЕ\3H [$tt]    *%*%*%*%*%*%*%*%* [alias 1]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "hold";
} '^([^:\']*) замер(.*?) на месте','f6000';


P::trig
{
        my $tt = 120 - time + $Common::time;
        $tt -= 60 while $tt > 60;
        $tt += 60 while $tt < 0;
	$; = CL::parse_colors ("$1 \3Mоглушило \3H[\3L$tt\3H]");
} '^([^:\']*) оглушило','f6000';

P::trig
{
        $; = CL::parse_colors ("---------> $1 СПИТ [alias 5]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "sleep";
} '^([^:\']*) прилег(.*?) подремать';


P::trig
{
	$; = CL::parse_colors ("---------> $1 В ЯДЕ [alias 4]");		
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "poison";
} '^([^:\']*) позеленел.? от действия яда','f6000';


P::trig
{
        my $tt = 120 - time + $Common::time; 
	$tt -= 60 while $tt > 60;
	$tt += 60 while $tt < 0;
        $; = CL::parse_colors ("               -=-=-=-=-=-=-=-=-     $1 В \3JМОЛЧЕ\3H [$tt]     -=-=-=-=-=-=-=-=- [alias 2]");
        $friend_target = "." . Common::str2mob $1;
        $attack_type = "silence";
} '^([^:\']*) прикусил(.*?) язык !','f6000';


P::trig
{
        $; = CL::parse_colors ("---------> $1 В СЛЕПОТЕ [alias 3]");
	$friend_target = "." . Common::str2mob $1;
	$attack_type = "blind";
} '^([^:\']+) ослеп(.*?) !', 'f6000';

P::trig
{
        $; = CL::parse_colors("\3L[>>>]  ") . $;
} 'Вы (получили|использовали) право (еще раз)? отомстить (.*)';



P::trig
{
        my $sub;
        my ($thing,$r) = ($1,$2);
        my $colr = Common::get_color($;,1);
	if ($Alias::values{arda_commands})
	{
        $sub = 'west' if $thing =~ /Запад/;
        $sub = 'east' if $thing =~ /Восток/;
        $sub = 'north' if $thing =~ /Север/;
        $sub = 'south' if $thing =~ /Юг/;
	$sub = 'up' if $thing =~ /Вверх/;
	$sub = 'down' if $thing =~ /Вниз/;
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
	                $; .= CL::parse_colors " \3I<----------------------- \3DДТ$sign";
		}
	        else
	        {
	                $Common::dt_directions{Common::rlower "$1"} = 0;
	        }
	}
} '^(Север|Восток|Юг|Запад|Вниз|Вверх)([\:\- \'].*)', 'f300';

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
	        $last = "$2 с \3C$sub\3H";

	}
	
	my $ok = 0;
	for (keys %Group::group)
        {
           $ok = 1 if ($Group::group{$_} eq $name);
        }
	$ok = 1 if $name =~ /^(Охотник|Слуга|Караульный|Варяг|Хранитель|Стражник)/;
	$ok = 1 unless $name =~ /^([^ ]+)$/;
	my $clr = $ok ? "\3H":"\3N";
	$; = CL::parse_colors($clr."$name \3H$last.");

	
} '^(.*) (приш.?.?|прилетел.?|приплыл.?|вплыл.?|приехал.?|прибежал.?)( с ?)([^ ]*)([ау])\.','f800';


P::trig
{
	my $last = "$2 $3";
	my $name = $1;
     	if ($Alias::values{arda_commands})
	{
		my ($w,$d) = ($2,$3);
		$d = $1 if $d =~ /^на (.*)/;
      		my $sub = $dirs{$d};
		$sub = $d unless length $sub;
		$last = "$w на \3C$sub\3H"
		
	}

	my $ok = 0;
	for (keys %Group::group)
        {
           $ok = 1 if ($Group::group{$_} eq $name);
        }
	$ok = 1 if $name =~ /^(Охотник|Слуга|Караульный|Варяг|Хранитель|Стражник)^/;
	$ok = 1 unless $name =~ /^([^ ]+)$/;
	my $clr = $ok ? "\3H":"\3H";
	$; = CL::parse_colors($clr."$name \3H$last.");

} '^(.*) (уш.?.?|улетел.?|уплыл.?|убежал.?|сбежал.?|уехал.?) (на [^ ]+|вверх|вниз)\.','f800';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- забашили!");
        Common::eparser "~;встать"
} 'завалил.*? Вас на землю. Поднимайтесь!';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- потрипали!");
        Common::eparser "~;встать"
} 'ловко подсек.*? Вас, усадив на попу.';

P::trig
{
        $; .= CL::parse_colors("\3J         <---------- оглушили нафиг!!");
        Common::eparser "~;встать"
} '^Оглушающий удар .*? сбил Вас с ног';

P::trig
{
        $; .= CL::parse_colors("\3J          <---------- забашили!");
        Common::eparser "~;встать"
} '^Вы полетели на землю от мощного удара';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- йопт");
	Common::eparser "~;встать";
} '^Вы попытались сбить (.*?), но упали сами\. Учитесь\.';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- йопт");
	Common::eparser "~;встать";
} '^Вы попытались подсечь (.*?), но упали сами\.\.\.';
P::trig
{
	$; .= CL::parse_colors("\3P          <---------- йопт");
	Common::eparser "~;встать";
} '^([^:]+) уклонился от Вашего удара, и Вы сами распластались';



P::trig
{
        $; .= CL::parse_colors("\3J          <---------- чтото выбили!");
        my $disarmed = Baze::alias $2;
        Common::parser "взять $disarmed;дер $disarmed" if $disarmed eq $Common::lwp;
        Common::parser "взять $disarmed;воор $disarmed" if $disarmed eq $Common::rwp;
} '^([^\']*)ловко выбил.? (.*?) из Ваших рук';

P::alias
{
        Common::parser "взя $Common::rwp;воор $Common::rwp";
        Common::parser "взя $Common::lwp;дер $Common::lwp" if length $Common::lwp;
} $Alias::values{cmd_getweapons};


P::trig
{
        $; .= CL::parse_colors("\3P          <----------  глупость $2 решает!");
} '^([^:]+) уклонил...? от попытки (.*?) завалить е..?\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 лежит!");
} '^([^:]+) хотел.? завалить Вас, но, не рассчитав сил, упал';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- завалили!");
	Common::eparser "~;встать";
} '^Вы полетели на землю от мощного удара';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 завалили!");
} '^([^:]+) завалил.? (.*?) на землю мощным ударом';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 лежит!");
} '^([^:]+) попытал...? сбить Вас с ног, но, в итоге, приземлил';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 лежит!");
} '^([^:]+) попытал...? завалить (.*?), но';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $2 уронили :)");
} '^([^:]+) избежал попытки (.*?) завалить его';


P::trig
{
	$; .= CL::parse_colors("\3J          <---------- завалили!");
	Common::eparser "~;встать";
} '^([^:]+) завалил.? Вас на землю. Поднимайтесь!';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $1 завалили!");
} '^Одним ударом .*? повалил.? (.*?) на землю\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- чего то в меня метнули!");
} '^Вы успели увернуться от броска';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 не смог метнуть!");
} '^([^:]+) сумел.? уклониться от броска (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- чтото влетело в $2!");
} '^Меткий бросок (.*?) заставил (.*?) застонать от боли';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно метает!");
} '^([^:]+) швырнул.? в Вас свое оружие, но промахнул';


P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно метает!");
} '^Бросок (.*?) вызвал лишь легкую улыбку на губах (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 застабали нафиг!");
} '^([^:]+) нанизал (.*?) на свое оружие. (.*?) теперь словно поросенок на вертеле';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- стабают!");
} '^([^:]+) попытал...? нанести Вам удар в спину, но его заметили';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно стабает!");
} '^([^:]+) попытал...? нанести (.*?) удар в спину, но';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- застабали!");
} '^Внезапно (.*?) уколол.? Вас в спину';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 застабали!");
} '^([^:]+) воткнул.? свое оружие в спину (.*?)\. Ща';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 застабали нафиг!");
} '^Мастерским ударом в спину, (.*?) отправил.? (.*?) к праотцам';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- увернулись от $1!");
} '^Вам удалось увернуться от коварного удара (.*?)\.';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно стабает!");
} '^([^:]+) не попал.? своим оружием в спину (.*?)\.';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- застабали!");
} '^([^:]+) нанес.?.? Вам удар своим оружием, и этот факт Вас не радует\.';

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 застабали!");
} '^([^:]+) нанес.?.? удар своим оружием в спину (.*?)';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно подсекает!");
} '^([^:]+) попытал...? подсечь Вас, но упал';

P::trig
{
	$; .= CL::parse_colors("\3P          <---------- $1 ватно подсекает!");
} '^([^:]+) попытался подсечь (.*?) но упал';

P::trig
{
	$; .= CL::parse_colors("\3J          <---------- подсекли!");
	Common::eparser "~;встать";
} '^([^:]+) ловко подсек.?.? Вас, усадив на попу';
P::trig
{
	$; .= CL::parse_colors("\3L          <---------- $2 подсекли!");
} '^([^:]+) ловко подсек.?.? (.*?), уронив';

P::trig
{
	Common::sparser "встать";
} '^Вам лучше встать на ноги';

P::trig {} '^[^:\']+ловко выбил.? (топор|нож) из рук', 2000;

P::trig
{
	$; .= CL::parse_colors("\3L          <---------- дизармят!");
        return unless $Alias::values{wepassist};
        my $colr = Common::get_color($;,1);
        if ($colr eq 'H')
        {
                my $desc = Baze::alias $1;
                Common::eparser "взя $desc;дать $desc .$2";
        }
        else
        {
                Common::eparser "фиг";
                P::echo "\3PРежим выключен, попытка взлома";
                $Alias::values{wepassist} = 0;
        }
} '^[^:\']+ловко выбил.? (.*?) из рук (...).*\.' , 'f1000';

P::alias
{
        $Alias::values{wepassist} = !$Alias::values{wepassist};
        my $tt = $Alias::values{wepassist}?'включен':'выключен';
        P::echo "\3PРежим подбора выбитой из рук ваты $tt";
} $Alias::values{cmd_autogetweapons};


P::bindkey
{
	if ($Alias::prof eq 'волхв')
	{
		Alias::take_rune $_ for split /;/,$spell_volhv{$attack_type};
	}
        Common::parser "$Alias::values{cast_command} !$friend_spell{$attack_type}! $friend_target";
} $Alias::values{bind_grouptarget};

my $at_get = 0;

P::trig
{

	return if $1 =~ /(Двойник|Хранитель)/;
        for (keys %Group::group)
        {       
           return if ($Group::group{$_} eq $1);
        }
	

	$at_get++;
	if ($Common::autoloot eq 3)
	{
		my $value = $at_get;
		P::timeout sub {Common::eparser "order followers взя все.труп" if $value eq $at_get;} , 1000, 1 if $Common::autoloot eq 3;	
	}

        Common::sparser("взя все") if $Common::autoloot eq 2;
        Common::sparser("взя все все.труп з") if $Common::autoloot eq 1;
	

} '(.*) мерт.*? душа медленно подымается в небеса\.'; 

P::trig
{
	return if $1 =~ /(Двойник|Хранитель)/;
        Common::sparser("взя все") if ($Common::autoloot > 0 and $Common::autoloot < 3);
} '(.*) вспыхнул.? и рассыпал.?.?.? в прах\.'; 

P::trig
{
} '^Труп (.*) пуст.$', 'g1';

P::trig
{
} '^Похоже, здесь ничего нет.$', 'g1';


P::trig
{
        return if $1 eq "Хранитель";
        return if $1 =~ /^(Двойник|Единорог|Дубыня|Горыня|Усыня)/;
	return if $1 eq "Кто-то";

	my $thing = $1;
	$thing =~ s/^(.*).$/$1/;
        Common::eparser ("взять $thing");
} '^([^ :-]+) прекратил[ао]? следовать за ';

P::trig
{
	my $thing = $1;
	$thing =~ s/^(.*?)..$/$1/;
	Common::eparser ("взять $thing");
} '^Вы прекратили следовать за ([^:-\s]*)\.';

P::trig
{
	my $colr = Common::get_color($;,1);
        if ($colr eq 'H') 
        {
        	$; = CL::parse_colors("\3H$1 \3O$2 \3Hиз трупа $3");
	}
} '^([^:]+ взял.?) (.*?) из трупа (.*)$';

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
} '^(.*) (стоит здесь\.|летает здесь\.|спит здесь\.|отдыхает здесь\.|сидит здесь\.|лежит здесь, при смерти\.|лежит здесь, без сознания\.|лежит здесь, в обмороке\.|сражается с)' , 'g1000:SHIT';


P::trig
{
	P::echo $full if length $full; $full = '';
} '^\s*$', 'f9000:SHIT';

my %affcolors = 
(
	'парализован' => 'G',
	'парализована' => 'G',
	'парализовано' => 'G',
	'слеп' => 'P',
	'слепа' => 'P',
	'слепо' => 'P',
	'нем' => 'B',
	'нема' => 'B',
	'немо' => 'B',
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
	if ($3 =~ /щит/) {$sym = '#'};

	for (@aff)
	{
		next unless length;

		my $s;
		if (/огненн/) {$s = "\3J$sym"} elsif
		   (/воздуш/) {$s = "\3P$sym"} elsif 
		   (/ледян/) {$s = "\3O$sym"} elsif
                   (/серебр/) {$s = "\3L!$sym!"} else 
		{
			my @daff = split / \.\.\./;
			for (@daff) 
			{
				if (/светится ярким сиянием/) {$s .= "\3P\:"} elsif 
				   (/переливается всеми цветами/) {$s .= "\3G\:"} elsif 
				   (/окутан сверкающим коконом/) {$s .= "\3Pi"}
			}
		};


		$result .= $s;
	}

	$full .= "$result ";
} '^([\. ]\.\.)(.*?)( аура| ауры| щитом| щитами|)\s*$', 'g1001:SHIT';
P::disable 'SHIT';

P::alias
{
        Common::eparser "снять_оцепенение @_";
} '1';

P::alias
{
        Common::eparser "снять_молчание @_";
} '2';

P::alias
{
        Common::eparser "вылечить_слепоту @_";
} '3';

P::alias
{
        Common::eparser "удалить_яд @_";
} '4';

1;
