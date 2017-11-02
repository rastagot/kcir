#!/usr/bin/perl

package Alias;

use Common;

use strict;


our %healer_spells = ();
our %bmage_spells = ();
our %mage_spells =();
our %necro_spells = ();
our %trader_spells = ();
our %paladin_spells = ();
our %charmer_spells = ();
our %druid = ();

my %healer_attacks;
my %bmage_attacks;
my %mage_attacks;
my %necro_attacks;
my %trader_attacks;
my %paladin_attacks;
my %charmer_attacks;
my %tank_attacks;
my %fighter_attacks;
my %thief_attacks;
my %nayom_attacks;
my %hunter_attacks;
my %blacksmith_attacks;
my %druid_attacks;

my @rcfiles = (

	'aliases.rc',
	'assasine.rc',
	'binds.rc',
	'charmer.rc',
	'cleric.rc',
	'defender.rc',
	'druid.rc',
	'guard.rc',
	'high.rc',
	'mage.rc',
	'merchant.rc',
	'necromancer.rc',
	'paladin.rc',
	'ranger.rc',
	'smith.rc',
	'thief.rc',
	'warrior.rc',
);
our %spells =
(
        'лекарь' => \%healer_spells,
        'колдун' => \%bmage_spells,
        'волшебник' => \%mage_spells,
        'чернокнижник' => \%necro_spells,
        'купец' => \%trader_spells,
        'витязь' => \%paladin_spells,
        'кудесник' => \%charmer_spells,
	'волхв' => \%druid,
);
my %attacks = 
(
        'лекарь' => \%healer_attacks,
        'колдун' => \%bmage_attacks,
        'волшебник' => \%mage_attacks,
        'чернокнижник' => \%necro_attacks,
        'купец' => \%trader_attacks,
        'витязь' => \%paladin_attacks,
        'кудесник' => \%charmer_attacks,
	'дружинник' => \%tank_attacks,
	'богатырь' => \%fighter_attacks,
	'тать' => \%thief_attacks,
	'наемник' => \%nayom_attacks,
	'охотник' => \%hunter_attacks,
	'кузнец' => \%blacksmith_attacks,
	'волхв' => \%druid_attacks,
);
my %defence = 
(
	'витязь' => 'парир',
	'дружинник' => 'парир',
	'тать' => 'уклон',
	'наемник' => 'уклон',
	'охотник' => 'уклон',
	'кузнец' => 'оглуш',
);
my %defence_delay = 
(
        'витязь' => 1,
        'дружинник' => 1,
        'тать' => 1,
        'наемник' => 1, 
        'охотник' => 1,
        'кузнец' => 2,

);
my %aliases = 
(
	'назначить танка' => 'cmd_settank',
	"привести тело в состояние стоит" => 'cmd_toup',
	'команда для автохила' => 'cmd_setautohealcommand',
	'установить степень автохила' => 'cmd_autoheal',
	'алиас для лута' => 'cmd_loot',
	'стандартный контейнер' => 'locker',
	'стандартный контейнер для рун' => 'rune_locker',
	'автолут по умолчанию' => 'autoloot',
	'стандартная еда' => 'food',
	'еды чтобы наесться' => 'food_count',
	'команда для использования еды' => 'food_command',
	'стандартная вода' => 'drink',
	'подключение к mud.ru 110' => 'cmd_connect',
	'сервер к которому подключаемся этой командой' => 'conn_host',
	'порт к которому подключаемся этой командой' => 'conn_port',
	'подключение через прокси к тому же самому' => 'cmd_proxy_connect',
	'подключение к locahost' => 'cmd_connect_local',
	'порт на localhost' => 'local_port',
	'время на подключение к серверу в секундах' => 'conn_timeout',
	'включение / отключение автореска' => 'cmd_autoresc_switch',
	'включение / отключение умений типа веера' => 'cmd_dodge_switch',
	'установить контейнер с рунами' => 'cmd_druid_setrunelocker',
	'положить все руны в контейнер' => 'cmd_druid_allrunetolocker',
	'проверить таймер и заряды рун' => 'cmd_druid_check_runes',
	'посмотреть текущую статистику для рун' => 'cmd_druid_runestatistics',
	'включить / выключить режим подбора выбитого оружия согруппников' => 'cmd_autogetweapons',
	'взять свои оружия' => 'cmd_getweapons',
	'вести не вести логи (0/1)' => 'log',
	'использовать / или нет псевдо английские команды' => 'arda_commands',
	'есть' => 'cmd_breakfast',
	'пить' => 'cmd_drink',
	'наполнить контейнер с жидкостью' => 'cmd_fillall',
	'пить черные' => 'cmd_drinkblackpotions',
	'установить контейнер для хари' => 'cmd_setcharismalocker',
	'установить харевые предметы' => 'cmd_charisma',
	'одеть харю' => 'cmd_wearcharisma',
	'снять харю' => 'cmd_takeoffcharisma',
	'показать pid процесса mmc' => 'showpid',
	'послать команду другому окошку' => 'cmd_mws_force',
	'послать команду всем окошкам' => 'cmd_mws_forceall',
	'послать команду всем окошкам с перерывами в 1 сек' => 'cmd_mws_waitforceall',
	'перекинуть команду на другое окошко' => 'cmd_mws_redirect',
	'установить чармисов' => 'charmisez',
	'алиас для команды приказать всем' => 'orderfollowers',
	'приказать всем помочь' => 'fassist',
	'приказать всем следовать я' => 'fself',
	'приказать всем спасти' => 'frescue',
	'приказать всем встать' => 'fstand',
	'приказать всем поя' => 'fvis',
	'приказать всем взя все.труп' => 'fgetc',
	'приказать всем бро все' => 'fdonate',
	'приказать всем сожрать труп' => 'feat',
	'спасти всех из данного класса' => 'resc_mode',
	'спасти всех кто на кнопке и кого бьют' => 'resc_last',
	'добавить в автореск' => 'add_autoresc',
	'добавить на кнопкореск' => 'add_butresc',
	'добавить на реск в определенный класс' => 'add_specresc',
	'очистить реск и реколл списки' => 'cmd_clearresc',
	'добавить в список реколла' => 'add_recallresc',
	'среколить всех кто в списке' => 'recallall',
	'команда для реколла согрупников' => 'recallem',
	'показать списки рекола и реска' => 'showrescmodes',
	'войти в пенту' => 'enterpent',
	'пентовый триггер' => 'penttrigger',
	'показать время до тика' => 'cmd_totick',
	'сказать время то тика' => 'cmd_saytotick',
	'инициализировать статистику экспы' => 'exp_stat_init',
	'заколоть, предварительно спрятавшись' => 'backstab',
	'установить контейнер' => 'cmd_setlocker',
	'поиск по базе' => 'bget',
	'добавить в базу новые логи' => 'madd',
	'установить префикс в mmc' => 'cmd_prefix',
	'установить имя игрока управляещего движением этого' => 'cmd_director',
	'включить / выключить автолут' => 'cmd_autoloot',
	'включить / выключить автодоклад об умениях' => 'cmd_autoreport',
	'включить / выключить автооткрываниедверей' => 'cmd_autodoors',
	'включить / выключить поддержку псевдо английских команд' => 'english_commands',
	'включить переодическое выполнение всяких случайных команд' => 'simulation',
	'прибить все внутренние процессы mmc' => 'cmd_killall',
	'показать цвета доступные в mmc' => 'cmd_colors',
	'установить предметы мешающие сбежать' => 'cmd_noflee',
	'сбежать, сняв эти самые предметы' => 'cmd_flee',
	'установить атаку, номер сразу после этого слова' => 'cmd_setattack',
	'установить цели' => 'cmd_settargets',
	'установить номер текущей цели' => 'cmd_setcurtarget',
	'префикс к алиасу спелла для его заучивания' => 'cmd_tobook',
	'префикс к алиасу спелла для его забывания' => 'cmd_frombook',
	'префикс к алиасу спелла для забывания из рез' => 'cmd_frommem',
);

my %bindkeys = 
(
	'санк танка' => 'bind_sanctank',
	'хил танка' => 'bind_healtank',
	'призма танка' => 'bind_prizmtanka',
	'команда группа' => 'bind_group',
	'установить режим парирования' => 'bind_parry',
	'установить режим веера' => 'bind_weer',
	'установить режим уклона' => 'bind_dodge',
	'установить режим оглушки' => 'bind_stun',
	'собрать сведения об окошках' => 'bind_window',
	'положить все руны в сумку' => 'bind_druid_runestolocker',
	'спелл в дружественную цель (снять_оцепенение например)' => 'bind_grouptarget',
	'среколить всех' => 'bind_recallall',
	'спасти тех что на кнопке и кого бьют' => 'bind_resclast',
	'спасти себя' => 'bind_rescmode1',
	'среколицца, причем из всех окошек тоже попытаюцца тебя среколить' => 'bind_recall',
	'все реколят всех' => 'bind_recallallall',
	'вперед по спидволку' => 'bind_speedw_fwd',
	'назад по спидволку' => 'bind_speedw_bck',
	'танк север' => 'bind_tanknorth',
	'танк юг' => 'bind_tanksouth',
	'танк запад' => 'bind_tankwest',
	'танк восток' => 'bind_tankeast',
	'идти на север' => 'bind_gonorth',
	'идти на юг' => 'bind_gosouth',
	'идти на запад' => 'bind_gowest',
	'идти на восток' => 'bind_goeast',
	'оглянуться' => 'bind_scan',
	'очистить очередь команд' => 'bind_tilde',
	'помочь / отступить' => 'bind_assist',
	'атака 0 по текущей цели' => 'bind_attack0',
	'атака 1 по текущей цели' => 'bind_attack1',
	'атака 2 по текущей цели' => 'bind_attack2',
	'атака 3 по текущей цели' => 'bind_attack3',
	'атака 4 по текущей цели' => 'bind_attack4',
	'атака 5 по текущей цели' => 'bind_attack5',
	'атака 6 по текущей цели' => 'bind_attack6',
	'атака 7 по текущей цели' => 'bind_attack7',
	'атака 8 по текущей цели' => 'bind_attack8',
	'следущая цель' => 'bind_nextar',
	'предыдущая цель' => 'bind_prevtar',
	'следующий набор целей' => 'bind_nextsettar',
	'предыдущий набор целей' => 'bind_prevsettar',
 	'взять все' => 'bind_getall',
 	'взять все все.труп' => 'bind_getallcorpse',
 	'бро все.труп' => 'bind_dropallcorpse',
);

our %eng_aliases =
(
        "ыду" => "спа","к" => "отд",
        "ысф" => "огл", "ыфму" => "",
        "ые" => "прос;встать",
        "уй" => "экип","дщщ" => "смотр",
        "шт" => "инв","аду" => "беж",
        "ц" => "з","у" => "в",
        "ы" => "ю","т" => "с",
        "в" => "вн","г" => "вве",
        "set" => "уст",
);

our %rvalues = ();

our %values = ();

our %highlightpart = ();
our %highlightstring = ();
my $aliasrc;

sub fparser($)
{
	my $param = shift;
	$param =~ s/\$(\w+)/$Alias::values{$1}/g;
	Common::eparser $param;
}

for $aliasrc (@rcfiles)
{
	my $parsing_prof = '';
	open RC, "<$Conf::config_rc_folder$aliasrc";
	while (<RC>)
	{
	        chomp;
		s/^(.*?)\s*$/$1/;
		next if m#^//#;
		if (/^###алиасы профессии (.*)/)
	        {
                if (!exists $spells{$1} && !exists $attacks{$1})
                {
                        next;
                }
                else
                {
                        $parsing_prof = $1;
                }

        }
        elsif (/^###служебные/)
        {
                $parsing_prof = "system";
        }
        next unless $parsing_prof;

        if ($parsing_prof eq "system")
        {
                if (/^кнопка\s*:\s*(.*?)\s*:\s*(.*)$/)
                {
                        next unless exists $bindkeys{$1};
                        $values{$bindkeys{$1}} = $2;
                }
		elsif (/^добавить кнопку\s*:\s*(.*?)\s*:\s*(.*)$/)
		{
			my ($command,$alias) = ($1,$2);
			P::echo "bind: $alias => $command";
			P::bindkey { fparser $command } $alias;
		}
		elsif (/^добавить алиас\s*:\s*(.*?)\s*:\s*(.*)$/)
		{
			my ($command,$alias) = ($1,$2);
			P::echo "alias: $alias => $command";
			P::alias { fparser $command } $alias;
		}
                elsif (/^подсветка\s*:\s*(.*?)\s*:\s*(.*)/)
                {
                        $highlightpart{$1} = $2;
                }
                elsif (/^подсветка строчки\s*:\s*(.*?)\s*:\s*(.*)/)
                {
                        $highlightstring{$1} = $2;
                }
                elsif (/^(.*?)\s*:\s*(.*)$/)
                {
                        next unless exists $aliases{$1};
                        $values{$aliases{$1}} = $2;
                }
                next;
        }
        if (/^(.*?)\s*:\s*(.*)$/)
        {
                if ($1 =~ 'атака')
                {
                        /^атака (\d+)\s*:\s*(.*)$/;
                        $attacks{$parsing_prof}{$1} = $2;
                        next;
                }
		elsif ($1 =~ '_защита')
		{	
			$defence{$parsing_prof} = $2;
		}
		elsif ($1 =~ '_защита_период')
		{
			$defence_delay{$parsing_prof} = $2;
		}
                elsif ($parsing_prof ne 'волхв')
                {
                        $spells{$parsing_prof}{$2} = $1;
                }
                else {$druid{$2} = $1}
        }
}
close RC;
%rvalues = reverse %values;
}

$Common::charisma_locker = $values{locker};
$Common::autoloot = $values{autoloot};
our $prof = '';
sub druid_setup;
P::trig
{
        my $tprof = $2;
        my $level = $3;
        my $my_ident = $Common::ne;

        return if $tprof eq $prof;
	
	if (length $prof)
	{
		for (keys %{$spells{$prof}})
		{
			Common::sparser "${Conf::char}unalias $_";
			Common::sparser "${Conf::char}unalias $values{cmd_tobook}$_";
			Common::sparser "${Conf::char}unalias $values{cmd_frombook}$_";
			Common::sparser "${Conf::char}unalias $values{cmd_frommem}$_";
		}
	}

	Common::sparser "$values{cmd_clearresc}";
        if ($tprof ne 'волхв')
        {
		$values{cast_command} = 'колд';
                for (sort keys %{$spells{$tprof}})
                {
                        my $alias = $spells{$tprof}{$_};
                        P::alias
                        {
                                my $to = "@_";
                                $to = $Target::target[$Target::curtar] if $to eq "ц";
                                Common::eparser "$values{cast_command} !$alias! $to"
                        } "$_";
                        P::alias {Common::eparser "зау !$alias!"} "$values{cmd_tobook}$_";
                        P::alias {Common::eparser "заб !$alias!"} "$values{cmd_frombook}$_";
                        P::alias {Common::eparser "заб !$alias! р"} "$values{cmd_frommem}$_";
                }
        }
        else {druid_setup}

        $prof = $tprof;

	for (sort keys %{$attacks{$prof}})
	{
        	Common::sparser "ат$_ $attacks{$prof}{$_}"
	}
	Common::sparser "_защита $defence{$prof}" if exists $defence{$prof};
	Common::sparser "_защита_каждые $defence_delay{$prof}" if exists $defence_delay{$prof};

	if ($prof eq 'колдун' or $prof eq 'волшебник' or
            $prof eq 'чернокнижник' or $prof eq 'купец' or
	    $prof eq 'кудесник' or $prof eq 'волхв' )
	{
 #               Common::eparser "ареск " . Common::fupper $Common::ne;
		$Common::resccommand = "order followers rescue";
	}
	else
	{
		$Common::resccommand = "rescue";
	}

} '^Вы ([^, ]+).* \(.*, .*?, (.*?) (\d+) .*\).$';

my %rune_in = (); 
my %rune_count = (); 
my %rune_aliases = (); 
my $current_rune = '';
my $rune_checking = 0;
my %rune_exists = ();
my $rune;

sub get_rune_alias
{
        my $rune = shift;
        return $rune_aliases{$rune} if exists $rune_aliases{$rune};
        my $alias_rune = $rune;
        $alias_rune =~ s/^(....?).*/рун.$1/;
        $alias_rune =~ s/(рун.бог|рун.душ|рун.тьм)./$1/;
        $rune_aliases{$rune} = $alias_rune;
        return $alias_rune;
}

sub simple_take_rune
{
        my $alias_rune = get_rune_alias shift;
        Common::eparser "взять $alias_rune $values{rune_locker}";
}

P::alias
{
        $values{rune_locker} = "@_"
} $values{cmd_druid_setrunelocker};

P::alias
{
        Common::eparser "пол все.рун $values{rune_locker}";
	%rune_in = ();
        $rune_checking = 0;
} $values{cmd_druid_allrunetolocker};

P::alias
{
        $rune_checking = 1;
	%rune_count = ();
	my @arr = split / /, 'воз вод огн зем зап созн яро хля гро отр тве душ дви неб бла лжи вра разр хао пок тра пор сози тел ист тьм све под ука разо еди жив низ пог опу ско вла вос бог';
	my ($cont,$cont2) = @_;
	$cont = $values{rune_locker} unless length $cont;
	$cont2 = $cont unless length $cont2;
        Common::sparser "взять рун.$_ $cont;см рун.$_;полож рун.$_ $cont2" for @arr;
} '_комплект';

P::alias
{
	Common::sparser "_комплект";
} $values{cmd_druid_check_runes} ;

P::bindkey {Common::sparser $values{cmd_druid_allrunetolocker}} $values{bind_druid_runestolocker};

sub take_rune 
{
        my $rune = shift;

        if (!exists $rune_in{$rune})
        {
                simple_take_rune $rune;
        }
}


P::trig
{
        for (split /,/, $1)
        {
                s/^\s*руну ([^ ]+).*$/$1/;

                if (!exists $rune_count{$1})
                {
                        my $rune_alias = get_rune_alias $1;
                        $rune_count{$1} = 1000;
                        Common::eparser "см $rune_alias" if $prof eq 'волхв';

                }
                elsif (--$rune_count{$_} == 0)
                {
			delete $rune_count{$_};
                        simple_take_rune $_;
                }
        }
} 'Вы сложили (.*), котор.. вспыхнул. ярким светом.';


P::trig
{
        $rune_in{$1} = 1;
	$current_rune = $1;
        return if $rune_checking;
        unless (exists $rune_count{$1})
        {
                my $rune_alias = get_rune_alias $1;
                $rune_count{$1} = 1000;
                Common::eparser "см $rune_alias" if $prof eq 'волхв';
        }
} '^Вы взяли руну ([^ ]*)(.*)(из|\.)';

P::trig
{
        delete $rune_in{$1};
} '^Вы положили руну ([^ ]*) (.*)в|^Вы бросили руну ([^ ]*).*\.|^Вы дали руну ([^ ]*)';

P::trig
{
        $current_rune = $1;
} '^Руна ([^ ]+).*состоянии\.';

P::trig
{
        $rune_count{$current_rune} = $1;
        $rune_in{$current_rune} = 1;
} '^Оcталось применений: (\d+)';

P::alias
{
        for (sort {$rune_count{$b} <=> $rune_count{$a}} keys %rune_count)
        {
                my $format = 15 - length $_;
                P::echo "\3P$_". (sprintf "%${format}s")  . "\3H:" . ($rune_count{$_}<50?"\3B " : "\3H ") . $rune_count{$_};
        }
	P::echo "";
} $values{cmd_druid_runestatistics};

sub druid_setup
{
        %rune_in = ();
	$values{cast_command} = 'слож';
        for (keys %druid)
        {
                my @runes = split /;/, $druid{$_};
                my $alias = shift @runes;
                $rune_exists{$_} = 1 for (@runes);
                P::alias
                {
                        my $to = "@_";
                        $to = $Target::target[$Target::curtar] if $to eq "ц";
                        take_rune $_ for @runes;
                        Common::sparser "$values{cast_command} !$alias! $to";
                } "$_";
        }
}

P::alias
{
        my $what = shift;
	my $how = "@_";
        my $line; 
	my $twhat = $what;
	my $specline = 0;
        $twhat = "\$$what" unless $what =~ /^[%\\@]/;
        if (!length $how and length $what)
        {
                $specline = eval qq(return defined $twhat?$twhat:"undef");
                $line = "variable [$what] = [$specline]";
        }
        elsif (length $what)
        {
                $how = "\"$how\"" if $how =~ /[йцукенгшщзхъфывапролджэячсмитьбю+]/i;
                $specline = eval qq(return $twhat = $how;);
                if (defined $specline)
                {
                        $line = "variable [$what] = [$specline]";
                }
                else
                {
                        $@ =~ /^(.*) at \(eval .*/;
                        my $desc = $1;
                        $line = "exception:  [\L$desc\E]";
                }
        }
        else {return}
        P::echo "\3I$line";
} $values{cmd_set};

P::alias
{
	Common::eparser $Common::sost if (length $Common::sost);
} $values{cmd_toup};

1;
