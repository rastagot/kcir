#!/usr/bin/perl

#   'Mercy!' cried Gandalf.  'If the giving of information is to be the cure
# of your inquisitiveness, I shall spend all the rest of my days answering
# you.  What more do you want to know?'
#   'The names of all the stars, and of all living things, and the whole
# history of Middle-earth and Over-heaven and of the Sundering Seas,'
# laughed Pippin.

package Baze;
use strict;

my $base = './thingbase';
my %BASE = ();

sub baseopen($)
{
	open BF, "<$base";
	while (<BF>)
	{
		chomp;
		/^(.*):(.*)$/;
		$BASE{$1} = "$2";
	}
	close BF;
}

sub baseclose($)
{
	open BF, ">$base";
	print BF "$_:$BASE{$_}\n" for (keys %BASE);
	close BF;
}

sub get_item_alias
{
        my $alias = "@_";
        my @item = split /\s+/ , $alias;
        for (@item)
        {
                $_ = '' if /^..?$/;
                $_ = $1 if /^(..)..?$/;
                $_ = $1 if /^(.*)...$/;
        }
        $alias = join ".", @item;
        $alias =~ s/\s+//; $alias =~ s/\.\./\./g;
        return $alias;
}

baseopen($base);

my %OLDBASE = %BASE;
our %wt = 
( "луки" => 1,
  "короткие.лезвия" => 2,
  "длинные.лезвия" => 3,
  "секиры" => 4,
  "палицы.и.дубины" => 5 ,
  "иное.оружие" => 6,
  "двуручники" => 7,
  "проникающее.оружие" => 8,
  "копья.и.рогатины" => 9,
);
our %rwt = reverse %wt;

our %ot = 
( 
  "UNDEFINED" => "ops",
  "СВЕТ" => "1",
  "СВИТОК" => "2",
  "ПАЛОЧКА" => "3",
  "ПОСОХ" => "4",
  "ОРУЖИЕ" => "5",
  "ОГНЕВОЕ ОРУЖИЕ" => "6",   
  "РАКЕТА" => "7",
  "ДРАГОЦЕННОСТЬ" => "8",
  "БРОНЯ" => "9",
  "НАПИТОК" => "90",
  "ОДЕЖДА" => "11",
  "ДРУГОЕ" => "12",
  "TRASH" => "93",
  "МУСОР" => "14",
  "КОНТЕЙНЕР" => "15",
  "БУМАГА" => "16",
  "ЕМКОСТЬ" => "17",
  "КЛЮЧ" => "18",
  "ЕДА" => "19",
  "ДЕНЬГИ" => "20",
  "ПЕРО" => "21",
  "ЛОДКА" => "22",
  "ИСТОЧНИК" => "23",
  "МАГИЧЕСКАЯ.КНИГА" => "24",
  "МАГИЧЕСКИЙ.ИНГРЕДИЕНТ" => "25",
  "МАГИЧЕСКИЙ.ИНГРЕДИЕНТ :)" => "26",
);
our %rot = reverse %ot;
our %was =
(
"одеть.на.палец" => 0 ,
"одеть.на.шею" => 1 ,
"одеть.на.туловище" => 2,
"одеть.на.голову" => 3,
"одеть.на.ноги" => 4,
"обуть" => 5,
"одеть.на.кисти" => 6,
"одеть.на.руки" => 7,
"использовать.как.щит" => 8,
"одеть.на.плечи" => 9,
"одеть.на.пояс" => 90,
"одеть.на.запястья" => 11,
"взять.в.правую.руку" => 12,
"взять.в.левую.руку" => 93,
"взять.в.обе руки" => 14,
);
our %rwas = reverse %was;

our %mater = 
( 
  "NO" => 1,
  "БУЛАТ" => 2,
  "БРОНЗА" => 3,
  "ЖЕЛЕЗО" => 4,
  "СТАЛЬ" => 5,
  "КОВАНАЯ.СТАЛЬ" => 6,
  "ДРАГ.МЕТАЛЛ" => 7,
  "КРИСТАЛЛ" => 8,
  "ДЕРЕВО" => 9,
  "ПРОЧНОЕ.ДЕРЕВО" => 90,
  "КЕРАМИКА" => 11,
  "СТЕКЛО" => 12,
  "КАМЕНЬ" => 13,
  "КОСТЬ" => 14,
  "ТКАНЬ" => 15,
  "КОЖА" => 16,
  "ОРГАНИКА" => 17,
  "БЕРЕСТА" => 18,
  "ДРАГ.КАМЕНЬ" => 19,
);
our %rmater = reverse %mater;

our %no_flags = 
( 
  "!христиане" => 1,
  "!язычники" => 2,
  "!NEUTRAL" => 3,
  "!маги" => 4,
  "!лекари" => 5,
  "!тати" => 6,
  "!богатыри" => 7,
  "!наемники" => 8,
  "!дружинники" => 9,
  "!витязи" => 90,
  "!охотники" => 11,
  "!кузнецы" => 12,
  "!купцы" => 93,
  "!волхвы" => 14,
  "!убийцы" => 15,
  "!цветные" => 16,
  "только для убийц" => 17,
  "!северяне" => 18,
  "!поляне" => 19,
  "!кривичи" => 20,
  "!вятичи" => 21,
  "!веляне" => 22,
  "!древляне" => 23,
  "ничего" => 24,
  "!мужчины" => 25,
  "!женщины" => 26,
  "!чармисы" => 27,
);
our %rno_flags =  reverse %no_flags;

our %e_flags =
( 
  "светится" => 1,
  "шумит" => 2,
  "!рента" => 3,
  "!пожертвовать" => 4,
  "!невидим" => 5,
  "невидим" => 6,
  "магический" => 7,
  "!бросить" => 8,
 # "благословлен" => 9,
  "!продать" => 90,
  "рассыпется" => 11,
  "рассыпется.вне.зоны" => 12,
  "!обезоружить" => 93,
  "!рассыпется" => 14,
  "таймер.запущен" => 15,
  "отравлен" => 16,
  "заточен" => 17,
  "укреплен" => 18,
  "появиться.днем" => 19,
  "появится.ночью" => 20,
  "в.полнолуние" => 21,
  "появится.зимой" => 22,
  "появится.весной" => 23,
  "появится.летом" => 24,
  "появится.осенью" => 25,
  "плавает" => 26,
  "летает" => 27,
  "можно.метнуть" => 28,
  "горит" => 29,
  "рассыпется.на.репоп" => 30,
  "!разыскать" => 31,
  "слабеет.со.временем" => 32,
  "устойчив.к.магии" => 33,
  "ничего" => 34,
);
our %re_flags = reverse %e_flags;

our %o_aff =
( 
  "слепота" => 1,
  "невидимость" => 2,
  "опр.наклонностей" => 3,
  "опр.невидимости" => 4,
  "опр.магии" => 5,
  "опр.жизни" => 6,
  "водохождение" => 7,
  "освящение" => 8,
  "проклятие" => 9,
  "инфравидение" => 90,
  "яд" => 11,
  "защита.от.тьмы" => 12,
  "защита.от.света" => 93,
  "сон" => 14,
  "не.выследить" => 15,
  "доблесть" => 16,
  "подкрадывание" => 17,
  "спрятаться" => 18,
  "оцепенение" => 19,
  "полет" => 20,
  "молчание" => 21,
  "настороженность" => 22,
  "мигание" => 23,
  "не.сбежать" => 24,
  "свет" => 25,
  "освещение" => 26,
  "тьма" => 27,
  "опр.яда" => 28,
  "медлительность" => 29,
  "ускорение" => 30,
  "дыхание.водой" => 32,
  "кровотечение" => 33,
  "маскировка" => 34,
  "защита.богов" => 35,
  "воздушный.щит" => 36,
  "огненный.щит" => 37,
  "ледяной.щит" => 38,
  "зеркало.магии" => 39,
  "каменная.рука" => 40,
  "призматическая.аура" => 41,
  "воздушная.аура" => 42,
  "огненная.аура" => 43,
  "ледяная.аура" => 44,
  "глухота" => 45,
  "ничего" => 46,
);
our %ro_aff = reverse %o_aff;

our %a_types =
( 
  "ничего" => 1,
  "сила" => 2,
  "ловкость" => 3,
  "интеллект" => 4,
  "мудрость" => 5,
  "телосложение" => 6,
  "обаяние" => 7,
  "профессия" => 8,
  "уровень" => 9,
  "возраст" => 90,
  "вес" => 11,
  "рост" => 12,
  "запоминание" => 93,
  "макс.жизнь" => 14,
  "макс.энергия" => 15,
  "деньги" => 16,
  "опыт" => 17,
  "защита" => 18,
  "попадание" => 19,
  "повреждение" => 20,
  "защита.от.парализующих.заклинаний" => 21,
  "защита.от.магии.жезлов" => 22,
  "защита.от.магических.аффектов" => 23,
  "защита.от.магических.дыханий" => 24,
  "защита.от.магических.повреждений" => 25,
  "восст.жизни" => 26,
  "восст.энергии" => 27,
  "слот.1" => 28,
  "слот.2" => 29,
  "слот.3" => 30,
  "слот.4" => 31,
  "слот.5" => 32,
  "слот.6" => 33,
  "слот.7" => 34,
  "слот.8" => 35,
  "слот.9" => 36,
  "размер" => 37,
  "броня" => 38,
  "яд" => 39,
  "защита.от.боевых.умений" => 40,
  "успех.колдовства" => 41,
  "удача" => 42,
  "инициатива" => 43,
  "религия" => 44,
  "поглощение" => 45,
);

my %substs =
(
        'каст' => 'успех.колдовства',
        'мудра' => 'мудрость',
        'ловка' => 'ловкость',
        'харя' => 'обаяние',
        'инта' => 'интеллект',
        'офф' => 'левую',
        'прайм' => 'правую',
        'дизарм' => 'обезоружить',
        '!трек' => 'не.выследить',
        'добла' => 'доблесть',
        'прокла' => 'проклятье',
        'инвиз' => 'невидимость',
        'сник' => 'подкрадывание',
        'хайд' => 'спрятаться',
        'дышка' => 'дыхание.водой',
        'камруки' => 'каменная.рука',
        'флай' => 'полет',
        'мигалка' => 'мигание',
        'санк' => 'освящение',
        'свет' => 'освещение',
        'шея' => 'шею',
        'нару.?.?' => 'руки',
        'ступ.?.?' => 'обуть',
        'боти.?.?.?' => 'обуть',
        'мем' => 'запоминание',
        'хиты' => 'макс.жизнь',
        'хитрол.?' => 'попадание',
        'дамрол.?' => 'повреждение',
        'мувы' => 'макс.энергия',
        'рестм.?.?.?.?' => 'восст.энергии',
        'рестх.?.?.?.?' => 'восст.жизни',
        'сейвы' => 'защита.от.[пмб]',
        'понож.?' => 'ноги',
        'ингр' => 'МАГИЧЕСКИЙ.ИНГРЕДИЕНТ',
        'тело' => 'туловище',
);


our %ra_types = reverse %a_types;

my $bdata = '';

sub do_pack(@)
{
my @data = @_;
my @a_aff = ();
my @wearas = ();
my @notto= ();
my @nottto= ();
my $addmode='';
my @oaff= ();
my $type='';
my $class='';  
my $how='';
my @eflags = ();
my $spec = '';
my $add_mode = 0;
my $name = '';
my $weight = 0;
my $cost = 0;
my $rentaw = 0;
my $material = '';
my $rentai = 0;
my $synon = '';
for (@data)
{
	my $src = $_;
	my $data;
	for $data (keys %wt,keys %ot,keys %was,keys %mater,keys %no_flags,keys %e_flags,keys %o_aff,keys %a_types) 
	{
		my $tdata = $data; 
		$tdata =~ s/\./ /g; 
		$tdata =~ s/([?+*()\[^$\.])/\\$1/g;
		$src =~ s/$tdata/$data/g;
	};
	if ($add_mode)
	{
		if ($src =~ /^\s*(.*?) (ухудшает|улучшает) на (.*)$/)	
		{
		
			$how = ($2 eq "ухудшает") ? "-" : "+";
			@a_aff = (@a_aff , $a_types{$1}, $how.$3);
		}
		else {last}
	}
	if ($src =~ /^Предмет "(.*)", тип : (.*)$/)
	{
		$type = $ot{$2};	
		$name = $1; 
	}
	elsif ($src =~ /^Синонимы : (.*)/)
	{
		$synon = $1;
	}
	elsif ($src =~ /^Принадлежит к классу "(.*)"\.$/)
	{
		$class = $wt{$1};
	}
	elsif ($src =~ /Вес: (.*), Цена: (.*), Рента: (.*)\((.*)\)/)
	{
		($weight,$cost,$rentaw,$rentai) = ($1,$2,$3,$4)
	}
	elsif ($src =~ /^Можно (.*)\./)
	{
		@wearas = (@wearas, $was{$1});
	}
	elsif ($src =~ /^Материал : (.*)/)
	{
		$material = $mater{$1}
	}
	elsif ($src =~ /^Неудобен : (.*?)\s*$/)
	{
		@notto = (@notto, $no_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^Недоступен : (.*?)\s*$/)
	{
		@nottto = (@nottto, $no_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^Имеет экстрафлаги: (.*?)\s*$/)
	{
		@eflags = (@eflags, $e_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^Наносимые .*? '(.*?)D(.*?)' среднее (.*)$/)
	{
		$spec = "$1,$2"
	}
	elsif ($src =~ /^Накладывает на Вас аффекты: (.*?)\s*$/)
	{
		@oaff = (@oaff, $o_aff{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^защита \(AC\) : (.*)/)
	{
		$spec = $1
	}
	elsif ($src =~ /^броня\s+: (.*)/)
	{
		$spec .= ",$1"
	}
	elsif ($src =~ /^содержит заклинания: (.*)/)
	{
		$spec = $1	
	}
	elsif ($src =~ /^Вызывает заклинания: (.*)/)
	{
		$spec = $1
	}
	elsif ($src =~ /^Зарядов (.*?) \(осталось (.*?)\)\./)
	{
		$spec .= ",$1,$2"
	}
	elsif ($src =~ /^содержит заклинание\s*: "(.*)"/)
	{
		$spec = $1;
	}
	elsif ($src =~ /уровень изучения \(для Вас\) : (.*)/)
	{
		$spec .= ",$1";
	}
	elsif ($src =~ /^Дополнительные свойства :/)
	{
		$add_mode = 1
	}
}
return '' unless (scalar @notto && scalar @nottto && scalar @eflags);

#my $format = "CCIIIIC/Z*C/Z*C/Z*C/Z*C/Z*C/Z*C/Z*C";

$synon = get_item_alias $name unless length $synon;


my $wearas = join "," , @wearas;
my $notto =  join "," , @notto;
my $nottto = join "," , @nottto;
my $eflags = join "," , @eflags;
my $oaff =   join "," , @oaff;
my $a_aff =  join "," , @a_aff;

$bdata = "$synon#$type#$class#$weight#$cost#$rentaw#$rentai#$wearas#$notto#$nottto#$eflags#$oaff#$a_aff#$spec#$material#1";
return $bdata;

}

sub do_unpack($) 
{
my @wearas = ();
my @notto= ();
my @nottto= ();
my @oaff= ();
my @aaff = ();
my @eflags = ();

my $src = $_[0];
return '' unless length $src;
my ($synon,$type,$class,$weight,$cost,$rentaw,$rentai,$wearas,$notto, $nottto, $eflags, $oaff, $aaff, $spec, $material, $true) = split /#/, $src;

@wearas = split ',', $wearas;
@notto =  split ',', $notto;
@nottto = split ',', $nottto;
@eflags = split ',', $eflags;
@oaff =  split ',', $oaff;
@aaff = split ',', $aaff;

unless (@wearas) { if (@notto and $type =~ /^(9|11)$/ and $cost > 0 and $rentaw > 0) {@wearas = (0)}}
my ($aaffstr,$wearstr,$nottostr,$notttostr,$eflagsstr,$oaffstr);
$aaffstr= '';
$wearstr .= "$rwas{$_}," for (@wearas);
$nottostr .= "$rno_flags{$_}," for (@notto);
$notttostr .= "$rno_flags{$_}," for (@nottto);
$eflagsstr .= "$re_flags{$_}," for (@eflags);
$oaffstr .= "$ro_aff{$_}," for (@oaff);
chop ($wearstr,$nottostr,$notttostr,$eflagsstr,$oaffstr); 
$wearstr .= '.' if length $wearstr;
my $tmp = 1;
for (@aaff)
{
	$aaffstr .= "$ra_types{$_} " if $tmp;
	$aaffstr .= ($_ > 0 ? "улучшает на " : "ухудшает на ") . (abs $_) . ", " unless $tmp;
	$tmp = !$tmp;
}
chop($aaffstr);chop($aaffstr);
return (
$rot{$type},
$rwt{$class},
$rmater{$material},
$rentaw,
$rentai,
$weight,
$cost,
$wearstr,
$nottostr,
$notttostr,
$eflagsstr,
$oaffstr,
$aaffstr,
$spec,
$true,
$synon
)
}

sub spec_get($) {my $str = shift; return split /#/, $BASE{$str} }

sub get(@$)
{
	my @patt = split /\s+/, $_[0];
	my $cl = $_[1]?"\3G":'';
	my @tmp = @patt; my $tmp2 = shift @tmp; $_ = ' '.$_ for (@tmp); @patt = ($tmp2,@tmp);
        my @ident = (); 
	my $name;
  ITEM: for $name (keys %BASE)
        {
		for (@patt) {next ITEM unless $name =~ /$_/}
	        my (    $type, $class, $material, $rentaw, $rentai, $weight, $cost,
	                $wearstr, $nottostr, $notttostr, $eflagsstr,$oaffstr,$aaffstr,$spec,$true,$synon
	        ) = do_unpack $BASE{$name};

	        next unless length $type;
	        push @ident, qq(Предмет "$name", тип : $type);
	        push @ident, qq(Принадлежит к классу "$class") if length $class;
	        push @ident, qq(Можно $wearstr) if length $wearstr;
	        push @ident, qq(Вес: $weight, Цена: $cost, Рента: $rentaw($rentai));
 	        push @ident, qq(Материал : $cl$material);
	        push @ident, qq(Неудобен : $cl$nottostr); 
	        push @ident, qq(Недоступен : $cl$notttostr);
	        push @ident, qq(Имеет экстрафлаги: $cl$eflagsstr);
	        if ( $type eq "СВИТОК" || $type eq "НАПИТОК" )
	        {push @ident, qq(Содержит заклинания: $spec) if length $spec}
	        if ($type eq "ПАЛОЧКА" || $type eq "ПОСОХ")
	        {
		        my ($spells,$total,$current) = split /,/ , $spec;
		        push @ident, qq(Вызывает заклинания: $spells) if length $spells;
		        push @ident, qq(Зарядов $total (осталось $current).) if length $total.$current;
	        }
	        elsif ($type eq "МАГИЧЕСКАЯ КНИГА")
	        {
		        my ($spell,$level) = split /,/, $spec;
		        push @ident, qq(содержит заклинание       : "$spell") if length $spell;
		        push @ident, qq(уровень изучения (для Вас) : $level) if length $level;
	        }
	        elsif ($type eq "ОРУЖИЕ" || $type eq "ОГНЕВОЕ ОРУЖИЕ")
	        {
		        my ($nt,$nd) = split /,/ , $spec;
		        push @ident, (qq(Наносимые повреждения '${nt}D$nd' среднее ) . $nt*($nd+1)/2 . ".");
	        }
	        elsif ($type eq "БРОНЯ")
	        {
		        my ($ac,$abs) = split /,/ , $spec; 
		        push @ident, qq(защита (AC) : $ac);
			push @ident, qq(броня       : $abs);
	        }
	        push @ident, qq(Накладывает на Вас аффекты: $cl$oaffstr) if length $oaffstr; 
	        $aaffstr =~ s/\n//g;
	        push @ident, qq(Дополнительные свойства : $cl$aaffstr) if length $aaffstr;
		push @ident, qq(Внимание, информация о предмете устарела) unless $true;
		push @ident, '';
        }
	return @ident;
}

sub put(@)
{
        my $item = shift @_;
        my $data = do_pack @_;
	my $old_data = $BASE{$item};
	return undef if $old_data eq $data;
	my @tmp = do_unpack $data;
        return $BASE{$item} = $data if shift @tmp;
	undef;
}

sub request(@)
{
        my $string = "@_";
        my @request = ();

        $string =~ s/([?+*()\[^$\.\\])/\\$1/g;

        @request = split / /, $string;
        my %parsed_request = ();
	my $part;
        for $part (@request)
        {
                my $flag = 0;

                $part =~ s/авто//g;
                $part =~ s/$_(| .*)$/$substs{$_}$1/g for (keys %substs);
                my $old_part = $part;

                for (keys %wt) {$flag = $_ if /^$part/i}
                $part = "класс:$flag тип:ОРУЖИЕ" if $flag; $flag = 0;

                for (keys %ot) {$flag = $_ if /^$part/i}
                $part = "тип:$flag" if $flag; $flag = 0;

                for (keys %was) {$flag = $_ if /^(одеть.на|взять.в|использовать.как|)\.?$part/i}
                $part = "куда:$flag" if $flag; $flag = 0;

                for (keys %mater) {$flag = $_ if /^$part/i}
                $part = "материал:$flag" if $flag; $flag = 0;

                for (keys %e_flags) {$flag = $_ if /^$part/i}
                $part = "флаг:$flag" if $flag; $flag = 0;

                for (keys %o_aff) {$flag = $_ if /^$part/i}
                $part = "аффект:$flag" if $flag; $flag = 0;

                for (keys %a_types) {$flag = $_ if /^$part/i}
                $part = "эффект:$flag" if $flag; $flag = 0;

                $part = "awake:AWAKE" if $part =~ /^тихая|тихое|тихие$/;
                $part = "вес:$1" if $part =~ /^вес([<>=]\d+)/;

                $part = "имя:$part" if $old_part eq $part;
        }

        $string = "@request"; @request = split / /, $string;

        for (@request)
        {
                $parsed_request{$2} = $1 if  /^([^:]+):(.*)/;
        }

        my @finded_items = ();
	my $item;
  ITEM: for $item (keys %BASE)
        {
                my (    $type, $class, $material, $rentaw, $rentai, $weight, $cost,
                        $wearstr, $nottostr, $notttostr, $eflagsstr,$oaffstr,$aaffstr,$spec
                ) = do_unpack $BASE{$item};
		my $feature;
                for $feature (keys %parsed_request)
                {
                        if ($parsed_request{$feature} eq 'класс') {next ITEM unless $class eq $feature}
                        elsif ($parsed_request{$feature} eq 'тип') {next ITEM unless $type eq $feature}
                        elsif ($parsed_request{$feature} eq 'материал') {next ITEM unless $material eq $feature}
                        elsif ($parsed_request{$feature} eq 'вес')
                        {
                                $feature =~ s/^(.)//;
                                next ITEM if ( ($1 eq '=') && ($feature != $weight) );
                                next ITEM if ( ($1 eq '>') && ($feature >= $weight) );
                                next ITEM if ( ($1 eq '<') && ($feature <= $weight) );
                        }
                        elsif ($parsed_request{$feature} eq 'awake')
                        {
                                next ITEM if $material =~ /(NO|БУЛАТ|БРОНЗА|ЖЕЛЕЗО|СТАЛЬ|КОВАНАЯ.СТАЛЬ|ДРАГ.МЕТАЛЛ)/;
                                next ITEM if $eflagsstr =~ /шумит|блестит|горит|светиться/;
                                next ITEM if $oaffstr =~ /освящение|свет|освещение|щит|призматическая/;
                        }
                        elsif ($parsed_request{$feature} eq 'куда')
                        {
                                next ITEM unless $wearstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq 'аффект')
                        {
                                next ITEM unless $oaffstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq 'флаг')
                        {
                                next ITEM unless $eflagsstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq 'эффект')
                        {
                                next ITEM unless length $aaffstr;
                                my @bonuses = split /\n/, $aaffstr;
                                my $flag = 0;
                                for (@bonuses) {$flag = 1 if /$feature улучшает на/}
                                next ITEM unless $flag;
                        }
                        elsif ($parsed_request{$feature} eq 'имя')
                        {
                                next ITEM unless $item =~ /$feature/;
                        }
                }
                push @finded_items, $item;
        }
        return ("@request",@finded_items);
}

sub exists
{
	return 1 if exists $BASE{"@_"};
	return undef;
}

sub true($)
{
	return (split /#/, $BASE{"@_"})[-1];
}

sub alias($)
{
	$BASE{"@_"} =~ /^(.*?)#/;
	unless (length $1) {return get_item_alias "@_"}
	return $1;
}

sub reload
{
	for (keys %BASE)
	{	
		unless ($BASE{$_} eq $OLDBASE{$_})
		{
		        baseclose($base);
	        	baseopen($base);	
			return;
		}
	}
}

sub amount
{
	return scalar keys %BASE;
}

1;
