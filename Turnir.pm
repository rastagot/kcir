#!/usr/bin/perl

package Turnir;

use Common;
use Alias;
use MUD;

use strict;


my $howstr = "(|легонько|слегка|сильно|очень сильно|чрезвычайно сильно|ЖЕСТОКО|БОЛЬНО|ОЧЕНЬ БОЛЬНО|ЧРЕЗВЫЧАЙНО БОЛЬНО|НЕВЫНОСИМО БОЛЬНО|УЖАСНО|СМЕРТЕЛЬНО)";
my $caststr = "(прикрыл.?.?.? глаза и прошептал.?.?.?|взглянул.?.?.? на (.*) и произнес.?.?.?|произнес.?.?.?|пробормотал.?.?.?|взглянул.?.?.? на (.*) и бросил.?.?.?|произнес.?.?.?)";
my $weapattack_1 = "(ударил|ободрал|хлестнул|рубанул|укусил|огрел|сокрушил|резанул|оцарапал|подстрелил|пырнул|уколол|ткнул|лягнул|боднул|клюнул)";
my $weapattack_2 = "(ударить|ободрать|хлестнуть|рубануть|укусить|огреть|сокрушить|резануть|оцарапать|подстрелить|пырнуть|уколоть|ткнуть|лягнуть|боднуть|клюнуть)";


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
		P::echo 'Турнир отключен';
		$tell_comand = '';
		MUD::disable_trigger 'TURNIR';
	}
	else
	{
		$tell_comand = $value;
		MUD::enable_trigger 'TURNIR';
		P::echo "Турнир включен. префикс: $tell_comand";
	}
} '_турнир';





P::trig
{
#	return unless scalar keys %damagers;
	my $str =  '';
	for (@actors_seq)
	{
		$str = $str . "$_:";
		$str = $str . "$actors{$_}" unless ($actors{$_} eq '');
		$str = $str . "[бьет $damagers{$_}]" unless ($damagers{$_} eq '');
		$results{$_} =~ s/^,//;
		$str = $str . "\($results{$_}\)" unless ($results{$_} eq '');
		$str = $str . " ";
		delete $damagers{$_};
	}

DAMAGERSCYCLE:	for (keys %damagers)
	{
		next DAMAGERSCYCLE if $_ eq '';
		$str = $str . "$_:";
		$str = $str . "[бьет $damagers{$_}]" unless ($damagers{$_} eq '');
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
	$actors{$1} = "гор.руки";
	$results{$1} .= ",RIP $2";
} "^(.*) слишком горячо обнял.?.? (.*) - .* просто сгорел",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "гор.руки на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) сумел.?.? избежать слишком теплого прикосновения (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "гор.руки на $1";
} "^(.*) заорал.?.? от боли, когда (.*) горячо обнял",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "гор.руки";
	$results{$2} .= ",RIP $1";
} "^(.*) узнал.?.? насколько горячие у (.*) руки. Это было последним, что ",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "гор.руки на $1";
	$results{$2} .= ",фэйл! ";
} "^(.*) смог.?.? избежать обжигающего прикосновения (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "гор.руки на $2";
} "^(.*) подпалил.?.? (.*) своими горящими руками.",'f1000000-:TURNIR';


# Call Lightning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "шар.молн";
	$results{$1} .= ",RIP $2";
} "^После молнии, вызванной (.*), от (.*) остались одни угли.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "шар.молн на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) отпрыгнул.?.? назад от посланной в н.* (.*) молнии.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "шар.молн на $1";
} "^(.*) закричал.?.? от боли, когда в н.* попала молния, пущеная (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "шар.молн";
	$results{$1} .= ",RIP $2";
} "^Молния (.*) отправила (.*) в мир иной.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "шар.молн на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) увернул.?.? от молнии (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "шар.молн на $1";
} "^В (.*) попала молния (.*)\\.",'f1000000-:TURNIR';


# Chill Touch
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.прик";
	$results{$1} .= ",RIP $2";
} "^(.*) коснул.?.?.? (.*), превратив .* в сосульку.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.прик на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) неудачно попытал.?.?.? заморозить (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.прик на $2";
} "^(.*) прикоснул.?.?.? к (.*), котор.* теперь не тянет на \"горячего парня\".",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$2 слаб";
} "^Боевый пыл (.*) несколько остыл.",'f1000000-:TURNIR';


# Color Spray
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "брызги";
	$results{$1} .= ",RIP $2";
} "^(.*) превратил.?.?.? (.*) в мириаду разноцветных огоньков.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "брызги на $2";
	$results{$1} .= ",фэйл!";
} "^Разноцветные брызги (.*) пролетели рядом с (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "брызги на $2";
} "^(.*) обрызгал.?.?.? (.*), котор.* просто зарыдал.?.?.? от вида сей красоты.",'f1000000-:TURNIR';

# Dispel Evil


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "изгн.зло";
	$results{$1} .= ",RIP $2";
} "^(.*) pазвеял.?.?.? по ветру (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "изгн.зло на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) улыбнул.?.?.?, глядя на безуспешные попытки (.*) изгнать",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "изгн.зло на $2";
} "^(.*) изгнал.?.?.? из (.*) часть темного духа. Но здоровья .* это не прибавило.",'f1000000-:TURNIR';
# Energy Drain

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "истощ.эн";
	$results{$1} .= ",RIP $2";
} "^(.*) забрал.?.?.? остатки жизни у (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "истощ.эн на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) попытал.?.?.? отнять жизни у (.*), но у н.* ничего не вышло.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "истощ.эн на $2";
} "^(.*) отнял.?.?.? часть жизни у (.*)\\.",'f1000000-:TURNIR';


# Fireball
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "фаербол";
	$results{$1} .= ",RIP $2";
} "^Жар огненного шара (.*) оставил от (.*) лишь обугленный труп.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "фаербол на $2";
	$results{$1} .= ",фэйл!";
} "^Огненный шар (.*) не причинил (.*) никакого вреда.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "фаербол на $2";
} "^(.*) удовлетворенно потер.?.?.? руки - .* огненный шар опалил (.*)!",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "фаербол на $2";
} "^(.*) выпустил.?.?.? огненный шар, который сильно подогрел воздух вокруг (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "фаербол";
	$results{$1} .= ",RIP $2";
} "^После огненного шара (.*) от (.*) не осталось и пепла.",'f1000000-:TURNIR';




# Harm

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "вред";
	$results{$2} .= ",RIP $1";
} "^(.*) не пережил.?.?.? вреда, причиненного .* (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "вред на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) неудачно попытал.?.?.? навредить (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "вред на $2";
} "^Слова, брошенные (.*), заставили (.*) содрогнуться от боли.",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "вред";
	$results{$2} .= ",RIP $1";
} "^(.*) не вынес.?.?.? вреда, нанесенного .?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "вред на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) не смог.?.?.? причинить (.*) вред.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лег.вред на $2";
} "^(.*) легко повредил.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "сер.вред на $2";
} "^(.*) серьезно повредил.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "крит.вред на $2";
} "^(.*) тяжело повредил.?.?.? (.*)\\.",'f1000000-:TURNIR';


# Lightning Bolt

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "молния";
	$results{$1} .= ",RIP $2";
} "^Шаровой заряд (.*) ударил в (.*) и разметал .* останки по комнате.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "молния на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) пытал.?.?.? попасть в (.*) шаровой молнией, но промазал",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "молния на $2";
} "^Посланная (.*) шаровая молния ударила в лицо (.*)\\.",'f1000000-:TURNIR';

# Magic Missile

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "маг.стрел";
	$results{$1} .= ",RIP $2";
} "^Магическая стрела, посланная (.*), погрузила (.*) в вечный сон.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "маг.стрел на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) промахнул.?.?.?, пытаясь поразить (.*) магической стрелой.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "маг.стрел на $2";
} "^(.*) выпустил.?.?.? в (.*) магическую стрелу, которая достигла цели.",'f1000000-:TURNIR';

# Poison


P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",умер :(";
} "^(.*) забил.?.?.? в судорогах, страдая, вытянул.?.?.? и затих",'f1000000-:TURNIR';

# Shocking Grasp

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "хватка";
	$results{$2} .= ",RIP $1";
} "^(.*) упал.?.?.? замеpтво, не в силах пережить шокирующей хватки (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "хватка на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) увеpнул.?.?.?, и (.*) не сумел.?.?.? схватить",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "хватка на $1";
} "^(.*) застонал.?.?.?, когда (.*) сломал.?.?.? .* несколько костей.",'f1000000-:TURNIR';

# Dispel Good


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "расс.свет";
	$results{$1} .= ",RIP $2";
} "^(.*) затоптал.?.?.? последние искры света в душе (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "расс.свет на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) улыбнул.?.?.?, наблюдая безуспешные попытки (.*) развеять",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "расс.свет на $1";
} "^(.*) зашатал.?.?.? и потемнел.?.?.? от слов (.*)\\.",'f1000000-:TURNIR';

#  Chain Lightning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "молния";
	$results{$1} .= ",RIP $2";
} "^После молнии, вызванной (.*), от (.*) остались одни угли.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "молния на $1";
	$results{$2} .= ",фэйл!";
} "^(.*) отпрыгнул.?.?.? назад от посланной в н.?.?.? (.*) молнии.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "молния на $1";
} "^(.*) закричал.?.?.? от боли, когда в н.?.?.? попала молния, пущенная (.*)\\.",'f1000000-:TURNIR';

# Implosion
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "гнев";
	$results{$1} .= ",RIP $2";
} "^Излучаемый (.*) гнев оставил от (.*) лишь кучку пепла.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "гнев на $2";
	$results{$1} .= ",фэйл!";
} "^Волна гнева (.*) прошла мимо (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "гнев на $2";
} "^(.*) разгневанно взглянул.?.?.? на .*. (.*) окружила волна пламени.",'f1000000-:TURNIR';

# Acid blast

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "кисла";
	$results{$1} .= ",RIP $2";
} "^(.*) обдал.?.?.? кислотой (.*), обратив .* в однородную массу.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "кисла на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) не попал.?.?.? своей кислотой в (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "кисла на $2";
} "^(.*) плеснул.?.?.? кислотой в (.*), обдав .?.?.? с головы до пят.",'f1000000-:TURNIR';

# Sacrifice

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "дрын";
	$results{$1} .= ",RIP $2";
} "^(.*) выпил.?.?.? остатки жизненных соков у (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "дрын на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) попытал.?.?.? выпить жизненные соки у (.*), но у н.?.?.? ничего не вышло.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "дрын на $2";
} "^(.*) отхлебнул.?.?.? часть жизненных соков у (.*)\\.",'f1000000-:TURNIR';

# Stunning

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "кам.прокл";
	$results{$1} .= ",RIP $2";
} "^(.*) оглушил.?.?.? (.*)\\. Пусть земля будет .?.?.? пухом.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "кам.прокл на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) не попал.?.?.? в (.*) своим заклинанием.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "кам.прокл на $1";
} "^(.*) стало плохо после того, как (.*) оглушил",'f1000000-:TURNIR';


# Cone of cold
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.вет";
	$results{$1} .= ",RIP $2";
} "^(.*) заморозил.?.?.? (.*) и раздробил.?.?.? .?.?.? на крохотные осколки.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.вет на $2";
	$results{$1} .= ",фэйл!";
} "^(.*) не попал своим заклинанием в (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "лед.вет на $2";
} "^(.*) призвал.?.?.? ледяной ветер, который обморозил (.*)\\.",'f1000000-:TURNIR';



#MASSFRAG


# Earthquake
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "тряс";
} "^(.*) опустил.?.?.? руки, и земля задрожала !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",RIP $2";
} "^(.*) удалось убедить Землю принять (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 повалило";
} "^(.*) повалило на землю.",'f1000000-:TURNIR';




# Armageddon

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "суд";
} "^(.*) сплел.?.?.? руки в замысловатом жесте, и все потускнело !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",RIP $2";
} "^(.*) отправил.?.?.? (.*) на судилище к Богам.",'f1000000-:TURNIR';

# mass blind

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "масс.слепь";
} "^Вдруг над головой (.*) возникла яркая вспышка.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "пыл.буря";
} "^Вас поглотила пылевая буря, вызванная (.*)\\.",'f1000000-:TURNIR';


P::trig
{	
	$results{$curr_actor} .= ",$1 слеп";
} "^(.*) ослеп",'f1000000-:TURNIR';


# Mass Deafness

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "масс.глух";
} "^Как только (.*) склонил.?.?.? голову, раздался оглушающий хлопок.",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 оглох";
} "^(.*) оглох.?.?.? !",'f1000000-:TURNIR';


P::trig
{	
	$results{$curr_actor} .= ",$1 ослаб";
} "^(.*) стал.?.?.? немного слабее.",'f1000000-:TURNIR';

P::trig
{	
	P::echo ">" . $curr_actor;
	$results{$curr_actor} .= ",$1 в холде";
} "^(.*) замер.?.?.? на месте !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 в молче";
} "^(.*) прикусил.?.?.? язык !",'f1000000-:TURNIR';




# Fire blast

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "огн.поток";
} "^На ладонях (.*) вспыхнуло яркое пламя !",'f1000000-:TURNIR';

# ice storm

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "шторм";
} "^(.*) воздел.?.?.? руки к небу, и тысячи мелких льдинок хлынули вниз !",'f1000000-:TURNIR';

P::trig
{	
	$results{$curr_actor} .= ",$1 оглушило";
} "^(.*) оглушило.",'f1000000-:TURNIR';


# Mass Fear

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "масс.страх";
} "^(.*) оглядел.?.?.? комнату устрашающим взглядом.",'f1000000-:TURNIR';


# chain Lighting

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "цепь.молн";
} "^(.*) поднял.?.?.? руки к небу и оно осветилось яркими вспышками !",'f1000000-:TURNIR';

# Earthfall
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "камни";
} "^(.*) высоко подбросил.?.?.? комок земли, который, увеличиваясь на глазах, стал падать вниз.",'f1000000-:TURNIR';

# Sonicwave
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "волна";
} "^Негромкий хлопок (.*) породил воздушную волну, сокрушающую все на своем пути.",'f1000000-:TURNIR';


######DAMAGE

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^От удара (.*) (.*) отправил.?.?.? в мир теней.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) сумел.?.?.? уклониться от удара (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$2} = $1;
	$results{$2} .= ",RIP $1";
} "^(.*) скончал.?.?.? мгновенно после сильнейшего удара (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) увернул.?.?.? от удара (.*)\\.",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) разорвал.?.?.? (.*) на мелкие кусочки. Вот это смерть!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? ободрать (.*) - неудачно.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) содрал.?.?.? шкуру с (.*)\\. .* очень больно и .* умирает.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) не смог.?.?.? ободрать (.*) - .* просто промазал",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) хлестнул.?.?.? (.*) - кажется, .* уже хватит.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? хлестнуть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) своим хлестким ударом лишил.?.?.? (.*) жизни.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) увернул.?.?.? от попытки (.*) хлестнуть",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) изрубил.?.?.? .* в фарш. При жизни (.*) выглядел.?.?.? лучше.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? рубануть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) изрубил.?.?.? .*. От (.*) осталось только кровавое месиво.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? рубануть (.*), но этот удар прошел мимо.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) вцепил.?.?.? в шею (.*), загрыз.* до смерти.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? укусить (.*), но поймал.?.?.? зубами лишь воздух.",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) перегрыз.?.?.? глотку (.*), вызвав мгновенную смерть.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? укусить (.*), но лишь громко клацнул.?.?.? зубами.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) огрел.?.?.? .*. Жизнь (.*) дала трещину.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? огреть (.*), но промахнул",'f1000000-:TURNIR';


P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) огрел.?.?.? .*. После такого удара мало кто выживал. (.*) не стал.?.?.? исключением.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? огреть (.*), но .?.?.? удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$2} = $1;
	$results{$2} .= ",RIP $1";
} "^(.*) насмерть сокрушен.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? сокрушить (.*), но .?.?.? удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) смертельно сокрушил.?.?.? .*. Мстить .?.?.? (.*) будет уже в другой жизни.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? сокрушить (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) резанул.?.?.? (.*), выпустив дух из .?.?.? тела",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? резануть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) резанул.?.?.? .*. От этого удара (.*) успустил.?.?.? последний вздох.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? резануть (.*), но .?.?.? удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) оцарапал.?.?.? (.*) своими когтями. От такого умрет кто угодно.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? оцарапать (.*), но .* послал.*подальше.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) смертельно оцарапал.?.?.? .*. (.*) умер.?.?.? от огромной потери крови.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? оцарапать (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^Меткий выстрел (.*) послал (.*) в мир иной.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? подстрелить (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^Стрела (.*) оборвала жизнь (.*)\\. Такова се ля ви!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? подстрелить (.*), но .?.?.? стрела не достигла цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) зверски распорол.?.?.? (.*) на несколько частей, убив",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? пырнуть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) зверски пырнул.?.?.? .*\\. (.*) умирает в страшных муках.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? пырнуть (.*), но .?.?.? удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) пронзил.?.?.? (.*) насквозь и .?.?.? безжизненное тело упало за землю.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? уколоть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) проткнул.?.?.? .* насквозь. В страшных муках (.*) умер",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? проткнуть (.*), но .?.?.? удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) сильно ткнул.?.?.? (.*), вызвав мгновенную смерть.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? ткнуть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) так сильно ткнул.?.?.? (.*), что .* не оставалось ничего, кроме как умереть.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? ткнуть (.*), но .* удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) очень сильно лягнул.?.? .*. Похоже, что (.*) не выдержал.* удара и погиб",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? лягнуть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) очень сильно лягнул.?.?.? .*\\. (.*) не вынес.* такого удара и скончал.* на месте.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.* лягнуть (.*), но .* удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) забодал.*насмерть. Бедн.?.?.? (.*)!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? боднуть (.*), но промахнул",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) насмерть забодал.?.?.? (.*). Смерть .* была ужастна!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? боднуть (.*), но .* удар не достиг цели.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) досмерти заклевал.?.?.? (.*)\\. Вот это расправа!",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? клюнуть (.*), но .* старания не достигли цели.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) попытал.?.?.? клюнуть (.*), но .* старания не достигли цели.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $3;
} "^(.*) попытал.?.?.? $weapattack_2 (.*), но промахнул.?.?.?.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) легонько $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) слегка $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	return if $1 =~ /(легонько|слегка|сильно|очень сильно|чрезвычайно сильно|ЖЕСТОКО|БОЛЬНО|ОЧЕНЬ БОЛЬНО|ЧРЕЗВЫЧАЙНО БОЛЬНО|НЕВЫНОСИМО БОЛЬНО|УЖАСНО|СМЕРТЕЛЬНО)/;
	$damagers{$1} = $3;

} "^(.*) $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';

P::trig
{
	return if $1 =~ /(очень|чрезвычайно)/;
	$damagers{$1} = $3;
} "^(.*) сильно $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) очень сильно $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) чрезвычайно сильно $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ЖЕСТОКО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	return if $1 =~ /(ОЧЕНЬ|ЧРЕЗВЫЧАЙНО|НЕВЫНОСИМО)/;
	$damagers{$1} = $3;
} "^(.*) БОЛЬНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ОЧЕНЬ БОЛЬНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) ЧРЕЗВЫЧАЙНО БОЛЬНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) НЕВЫНОСИМО БОЛЬНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) УЖАСНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';
P::trig
{
	$damagers{$1} = $3;
} "^(.*) СМЕРТЕЛЬНО $weapattack_1.?.?.? (.*)\\.",'f1000000-:TURNIR';


####OTHER

# Suffering

P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",умер :(";
} "^(.*) лежал.?.?.?, страдая, на земле, пока не осталось крови в .?.?.? бренном теле.",'f1000000-:TURNIR';
P::trig
{	
	$damagers{$1} = '';
	$results{$1} .= ",умер :(";
} "^(.*) потерял.?.?.? много крови и погиб",'f1000000-:TURNIR';


####NPC ATTACK
P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) оставил.?.?.? от (.*) лишь кучку пепла.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) подгорел.?.?.? в нескольких местах, когда (.*) дыхнул.?.?.? на .?.?.? огнем.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) убил.?.?.? (.*) смертельно дыхнув на н",'f1000000-:TURNIR';

P::trig
{
	$damagers{$1} = $2;
} "^(.*) напустил.?.?.? газ на (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) сделал из (.*) кусок льда.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) медленно покрывается льдом, после морозного дыхания (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) заставил.?.?.? .* забиться в судорогах. (.*) умирает...",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) бьется в судорогах от кислотного дыхания (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	$damagers{$1} = $2;
	$results{$1} .= ",RIP $2";
} "^(.*) убил.?.?.? (.*) ослепляющим дыханием.",'f1000000-:TURNIR';

P::trig
{
	$damagers{$2} = $1;
} "^(.*) ослеплен.?.?.? дыханием (.*)\\.",'f1000000-:TURNIR';


#***************************************************************************
#*                          Offensive Skills                               *
#***************************************************************************

# Throw
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "метает";
	$results{$1} .= ",RIP $2";
} "^Меткий бросок (.*) заставил (.*) покинуть сей бренный мир.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "метает в $1";
	$results{$2} .= "фэйл";
} "^(.*) сумел.?.?.? уклониться от броска (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "метает в $2";
} "^Меткий бросок (.*) заставил (.*) застонать от боли.",'f1000000-:TURNIR';


# Backstab
P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб";
	$results{$1} .= ",RIP $2";
} "^(.*) нанизал.?.?.? .* на свое оружие. (.*) теперь словно поросенок на вертеле.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб в $2";
	$results{$1} .= "фэйл";
} "^(.*) попытал.?.?.? нанести (.*) удар в спину, но .?.?.? заметили.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб в $2";
} "^(.*) воткнул.?.?.? свое оружие в спину (.*)\\. Ща начнется убивство.",'f1000000-:TURNIR';


P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб";
	$results{$1} .= ",RIP $2";
} "^Мастерским ударом в спину, (.*) отправил.?.?.? (.*) к праотцам.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб в $2";
	$results{$1} .= "фэйл";
} "^(.*) не попал.?.?.? своим оружием в спину (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "стаб в $2";
} "^(.*) нанес.?.?.? удар своим оружием в спину (.*)\\.",'f1000000-:TURNIR';

# bash
P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "баш";
	$results{$2} .= ",RIP $1";
} "^(.*) завалил.?.?.? на землю от удара (.*), да так и остал.?.?.? лежать.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "баш в $1";
	$results{$2} .= "фэйл";
} "^(.*) уклонил.?.?.? от попытки (.*) завалить",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "баш в $2";
} "^(.*) завалил.?.?.? (.*) на землю мощным ударом.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "баш";
	$results{$2} .= ",RIP $1";
} "^(.*) рухнул.?.?.? на землю и рассыпал.?.?.? после мощного удара (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "баш в $2";
	$results{$1} .= "фэйл";
} "^(.*) попытал.?.?.? завалить (.*), но .?.?.? уклонил",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "баш в $1";
	$results{$2} .= "фэйл";
} "^(.*) избежал.?.?.? попытки (.*) завалить",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "баш в $2";
	$results{$1} .= "фэйл";
} "^(.*) попытал.?.?.? завалить (.*), но не тут-то было.",'f1000000-:TURNIR';



P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "баш в $2";
} "^Одним ударом (.*) повалил.?.?.? (.*) на землю.",'f1000000-:TURNIR';


# kick
P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "пинок";
	$results{$2} .= ",RIP $1";
} "^(.*) погиб.?.?.? от мощного удара ноги (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "пинок в $2";
	$results{$1} .= "фэйл";
} "^(.*) попытал.?.?.? пнуть (.*)\\. Займите же .?.?.? ловкости.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "пинок в $3";
} "^(.*) $howstr пнул.?.?.? (.*)\\. Лицо .* искривилось в гримасе боли.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "пинок";
	$results{$1} .= ",RIP $2";
} "^(.*) убил.?.?.? (.*) своим ядреным пинком",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $2;
	$curr_actor = $2;
	$actors{$2} = "пинок в $1";
	$results{$2} .= "фэйл";
} "^(.*) увернул.?.?.? от мощного пинка (.*)\\.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "пинок в $3";
} "^(.*) $howstr пнул.?.?.? .*\\. Теперь (.*) дико вращает глазами от боли.",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "реск $2";
} "^(.*) героически спас.?.?.? (.*)!",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "подсек $2";
} "^(.*) ловко подсек.?.?.? (.*), уронив",'f1000000-:TURNIR';

P::trig
{	
	push @actors_seq, $1;
	$curr_actor = $1;
	$actors{$1} = "подсечка $2";
	$results{$1} .= "фэйл";
} "^(.*) попытал.?.?.? подсечь (.*), но упал",'f1000000-:TURNIR';


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
	$actors{$caster} = "кастует";
 	return;
 };

 if ($spell eq 'рунит')
 {
	$actors{$caster} = "рунит";
 	return;
 };


 if ($spell =~ /(Стрибог, даруй прибежище)|(защита от ветра и покров от непогоды)|(воздушный щит)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "возд.щит";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(Хорс, даруй прибежище)|(душа горячая, как пылающий огонь)|(огненный щит)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "огн.щит";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(Морена, даруй прибежище)|(а снег и лед выдерживали огонь и не таяли)|(ледяной щит)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "лед.щит";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(буде во прибежище)|(Он - помощь наша и защита наша)|(защита)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "защита";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(истягну умь крепостию)|(даст блага просящим у Него)|(доблесть)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "добл";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }


 if ($spell =~ /(пусть будет много меня)|(и плодились, и весьма умножились)|(клонирование)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "клонир";
 	return;
 }
 if ($spell =~ /(стихия подкоряшися)|(власть затворить небо, чтобы не шел дождь)|(контроль погоды)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "контроль.пог";
 	return;
 }
 if ($spell =~ /(будовати снедь)|(это хлеб, который Господь дал вам в пищу)|(создать пищу)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "созд.хле";
 	return;
 }
 if ($spell =~ /(напоиши влагой)|(и потекло много воды)|(создать воду)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "созд.вод";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(зряще узрите)|(и прозрят из тьмы и мрака глаза слепых)|(вылечить слепоту)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "снять.слеп";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(малейше целити раны)|(да затянутся раны твои)|(легкое исцеление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "лег.исц";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(узряще норов)|(и отделит одних от других, как пастырь отделяет овец от козлов)|(определение наклонностей)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "опр.накл";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(взор мечетный)|(ибо нет ничего тайного, что не сделалось бы явным)|(видеть невидимое)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "вид.невид";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(зряще ворожбу)|(покажись, ересь богопротивная)|(определение магии)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "опр.магии";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(зряще трутизну)|(по плодам их узнаете их)|(определение яда)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "опр.яда";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(згола гой еси)|(тебе говорю, встань)|(исцеление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "хил";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(гой еси)|(да зарубцуются гноища твои)|(критическое исцеление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "крит.исц";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(низовати мечетно)|(ибо видимое временно, а невидимое вечно)|(невидимость)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "инвиз";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(супостат нощи)|(свет, который в тебе, да убоится тьма)|(защита от тьмы)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "защ.от.тьм";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(изыде порча)|(да простятся тебе прегрешения твои)|(снять проклятье)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сня.прокл";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(иже во святых, други)|(будьте святы, аки Господь наш свят)|(групповое освящение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.санк";
 	return;
 }
 if ($spell =~ /(иже во святых)|(буде святым, аки Господь наш свят)|(освящение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "санк";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(будет силен)|(и человек разумный укрепляет силу свою)|(сила)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сила";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(кличу-велю)|(и послали за ним и призвали его)|(призвать)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "призыв";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(с глаз долой исчезни)|(ступай с миром)|(слово возврата)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "слово.возвр";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(изыде трутизна)|(именем Божьим, изгнати сгниенье из тела)|(удалить яд)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сня.яд";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(зряще живота)|(ибо нет ничего сокровенного, что не обнаружилось бы)|(определение жизни)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "опр.жиз";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(прибежище други)|(ибо кто Бог, кроме Господа, и кто защита, кроме Бога нашего)|(групповая защита)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.защ";
 	return;
 }
 if ($spell =~ /(други, гой еси)|(вам говорю, встаньте)|(групповое исцеление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "ГХ";
 	return;
 }
 if ($spell =~ /(исчезните с глаз моих)|(вам говорю, ступайте с миром)|(групповой возврат)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.рекол";
 	return;
 }
 if ($spell =~ /(целите раны)|(да уменьшатся раны твои)|(серьезное исцеление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сер.исц";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(други сильны)|(и даст нам Господь силу)|(групповая сила)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.сила";
 	return;
 }
 if ($spell =~ /(летать зегзицею)|(и полетел, и понесся на крыльях ветра)|(полет)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "полет";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(буде тверд аки камень)|(твердость ли камней твердость твоя)|(каменная кожа)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "кам.кож";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(мгла покрыла)|(будут как утренний туман)|(затуманивание)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "туман";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(други, низовати мечетны)|(возвещай всем великую силу Бога. И, сказав сие, они стали невидимы)|(групповая невидимость)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.инвиз";
 	return;
 }
 if ($spell =~ /(возросши к небу)|(и плоть выросла)|(увеличение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "увелич";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(буде быстр аки прежде)|(встань, и ходи)|(снять оцепенение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дисхолд";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(буде полон здоровья)|(крепкое тело лучше несметного богатства)|(увеличить жизнь)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "увж";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(глаголите)|(слова из уст мудрого - благодать)|(снять молчание)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сня.молч";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(крыла им створисте)|(и все летающие по роду их)|(групповой полет)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.полет";
 	return;
 }
 if ($spell =~ /(други, наполнися ратнаго духа)|(блажены те, слышащие слово Божие)|(групповая доблесть)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.добл";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(буде свеж)|(не будет у него ни усталого, ни изнемогающего)|(восстановление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "фреш";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(брюхо полно)|(душа больше пищи, и тело - одежды)|(насыщение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "насыщ";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(не затвори темне березе)|(дух дышит, где хочет)|(дышать водой)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дышка";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(быстры аки ястребов стая)|(и они быстры как серны на горах)|(групповое ускорение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.ускор";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(скор аки ястреб)|(поднимет его ветер и понесет, и он быстро побежит от него)|(ускорение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "ускор";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(Навь, очисти тело)|(хочу, очистись)|(вылечить лихорадку)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сня.лихор";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(око недреманно)|(не дам сна очам моим и веждам моим - дремания)|(внимательность)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "внимательность";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(изыде ворожба)|(выйди, дух нечистый)|(развеять магию)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "разв.магию";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(заживет аки на собаке)|(нет богатства лучше телесного здоровья)|(быстрое восстановление)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "бв";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(Дажьбог, даруй защитника)|(Ангел Мой с вами, и он защитник душ ваших)|(огненный защитник)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "огн.защитник";
 	return;
 }
 if ($spell =~ /(Сварог, даруй защитника)|(и благословен защитник мой)|(защитник)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "защитник";
 	return;
 }
 if ($spell =~ /(буде мал аки мышь)|(плоть на нем пропадает)|(уменьшение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "уменьш";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(гладь воды отразит)|(воздай им по делам их, по злым поступкам их)|(магическое зеркало)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "зеркало";
 	return;
 }
 if ($spell =~ /(сильны велетов руки)|(рука Моя пребудет с ним, и мышца Моя укрепит его)|(каменные руки)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "кам.руки";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(други, буде окружены радугой)|(взгляни на радугу, и прославь Сотворившего ее)|(групповая призматическая аура)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "гр.призм";
 	return;
 }
 if ($spell =~ /(окружен радугой)|(явится радуга в облаке)|(призматическая аура)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "призма";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(зло творяще)|(и ты воздашь им злом)|(силы зла)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сз";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(оглохни)|(и глухота поразит тебя)|(глухота)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "глухота";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(слушай глас мой)|(услышь слово Его)|(снять глухоту)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сня.глух";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(да застит уши твои)|(и будь глухим надолго)|(длительная глухота)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дл.глух";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
 if ($spell =~ /(Живый в помощи Вышняго)|(благословен буде Грядый во имя Господне)|(защита богов)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "ЗБ";
 	return;
 }
 if ($spell =~ /(разум аки мутный омут)|(и безумие его с ним)|(повреждение разума)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "повр.разума на $victim";
 	return;
 }
 if ($spell =~ /(буде чахнуть)|(и силу могучих ослабляет)|(слабость)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "слабость на $victim";
 	return;
 }
 if ($spell =~ /(порча их)|(прокляты вы пред всеми скотами)|(массовое проклятье)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "масс.прокл";
 	return;
 }
 if ($spell =~ /(порча)|(проклят ты пред всеми скотами)|(проклятье)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "прокл на $victim";
 	return;
 }
 if ($spell =~ /(иже дремлет)|(на веки твои тяжесть покладет)|(сон)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "сон на $victim";
 	return;
 }
 if ($spell =~ /(згола аки околел)|(замри надолго)|(длительное оцепенение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дл.холд на $victim";
 	return;
 }
 if ($spell =~ /(их окалеть)|(замрите)|(массовое оцепенение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "МХ";
 	return;
 }
 if ($spell =~ /(аки околел)|(замри)|(оцепенение)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "холд на $victim";
 	return;
 }
 if ($spell =~ /(типун тебе на язык!)|(да замкнутся уста твои)|(молчание)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "молч на $victim";
 	return;
 }
 if ($spell =~ /(згола застить очеса)|(поразит тебя Господь слепотою навечно)|(полная слепота)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дл.слепь на $victim";
 	return;
 }
 if ($spell =~ /(згола не прерчет)|(исходящее из уст твоих, да не осквернит слуха)|(длительное молчание)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "дл.молч на $victim";
 	return;
 }
 if ($spell =~ /(Чтоб твои зенки вылезли!)|(поразит тебя Господь слепотою)|(слепота)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "слепь на $victim";
 	return;
 }
 if ($spell =~ /(трутизна)|(и пошлю на них зубы зверей и яд ползающих по земле)|(яд)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "яд на $victim";
 	return;
 }

 if ($spell =~ /(падоша в тернии)|(убойся того, кто по убиении ввергнет в геенну)|(страх)/)
 {
	push @actors_seq, $caster;
	$actors{$caster} = "страх";
	$actors{$caster} .= " на $victim" unless $victim eq '';
 	return;
 }
	
# $actors{$caster} = "кастует";


}


P::trig
{
 my @params;
 push @params, $1;
 push @params, "рунит";
 analyze_cast @params;
} "^(.*) сложил.?.?.? руны, которые вспыхнули ярким пламенем." , 'f1000000-:TURNIR';

P::trig
{
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) прикрыл.?.?.? глаза и прошептал.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 my @params;
 push @params, $1;
 push @params, $3;
 push @params, $2;
 analyze_cast  @params;
} "^(.*) взглянул.?.?.? на (.*) и произнес.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 return if $1 =~ /взглянул.?.?.? на/;
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) произнес.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';

P::trig
{
 my @params;
 push @params, $1;
 push @params, $2;
 analyze_cast @params;
} "^(.*) пробормотал.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';
P::trig
{
 my @params;
 push @params, $1;
 push @params, $3;
 push @params, $2;
 analyze_cast  @params;
} "^(.*) взглянул.?.?.? на (.*) и бросил.?.?.? : \'(.*)\'" , 'f1000000-:TURNIR';

#P::trig
#{
# analyze_cast $1,'','';
#} "^(.*) издал.?.?.? непонятный звук" , 'f1000000-:TURNIR';



1;



