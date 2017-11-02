#!/usr/bin/perl

package Inventory;

use Common;
use Alias;
use Baze;

use strict;

our @noflee;

P::alias
{
	if (@_)
	{
        	($Alias::values{food_command},$Alias::values{food_count},$Alias::values{food}) = split /\s+/, "@_";
	}

        if (!$Common::inbattle)
        {
                Common::sparser "взя $Alias::values{food_count} $Alias::values{food} $Alias::values{locker}";
                Common::sparser "$Alias::values{food_command} $Alias::values{food}" for (1 .. $Alias::values{food_count});
		Common::sparser "пол все.$Alias::values{food} $Alias::values{locker}"
        }
} $Alias::values{cmd_breakfast};

P::alias
{
        if (@_)
        {
                $Alias::values{drink} = "@_";
        } 

        if (!$Common::inbattle)
        {
                Common::sparser "взя $Alias::values{drink} $Alias::values{locker}";
                Common::sparser "пит $Alias::values{drink}" for (1..2);
                Common::sparser "пол $Alias::values{drink} $Alias::values{locker}";
        }
} $Alias::values{cmd_drink};

P::alias
{
	my ($from,$cnt) = split /\s+/, "@_";
	$from = "колодец" unless length $from;
	$cnt = 1 unless length $cnt;
	for (1..$cnt)
	{
		my $pref = "$_."; 
		$pref = '' if $_ == 1;
        	Common::sparser "взя $pref$Alias::values{drink} $Alias::values{locker}";
	        Common::sparser "лить $Alias::values{drink} земля;напол $Alias::values{drink} $from";
	        Common::sparser "пол $Alias::values{drink} $Alias::values{locker}";
	}
} $Alias::values{cmd_fillall};

our $mode = 0;

sub rem_light 
{
	Common::eparser "сня $Common::light" if length $Common::light;
}

sub wear_light 
{
	Common::eparser "дер $Common::light" if length $Common::light;
}

sub restore_left
{	
	if ($mode eq 'twohand') {Common::eparser "воор $Common::dwp" if length $Common::dwp}
	elsif ($mode eq 'dual') {Common::eparser "дер $Common::lwp" if length $Common::lwp}
	elsif ($mode eq 'shield') {Common::eparser "оде $Common::shield" if length $Common::shield ;wear_light}
};

sub restore_right
{
	if ($mode eq 'twohand') {Common::eparser "воор $Common::dwp" if length $Common::dwp}
	else {Common::eparser "воор $Common::rwp" if length $Common::rwp}
}

sub free_left
{
	if ($mode eq 'twohand') {Common::eparser "сня $Common::dwp" if length $Common::dwp}
	elsif ($mode eq 'dual') {Common::eparser "сня $Common::lwp" if length $Common::lwp}
	elsif ($mode eq 'shield') {Common::eparser "сня $Common::shield" if length $Common::shield ;rem_light}
};

my $blp = 0;

P::trig
{
        $Common::ateq = 1;
	@noflee = ();
	$blp = 0;
} 'На Вас надето';


P::trig
{
        return unless $Common::ateq;
	
	my $p = $1;
        my $a = $2;

        $a =~ s/^\[.*\] //;
        $a =~ s/\s+<.*>.*//;
	$a =~ s/ \((погас|\d+ час.?.?)\)//;
	
	if ($a eq '[ Ничего ]')
	{
		if ( ($p eq 'в левой руке' and $mode eq 'dual') || 
	    	     ($p eq 'в руках' and $mode eq 'twohand') ||
	             ($p eq 'щит' and $mode eq 'shield') ||
                     ($p eq 'для освящения' and $mode eq 'shield') ) {restore_left};

		if ($p eq 'в правой руке' and $mode ne 'twohand') {restore_right}
	}
	else
	{
        	my $desc = Baze::alias $a;
		my $str = (Baze::spec_get($a))[11];
		if ( (Baze::spec_get($a))[11] =~ /24/ )
		{
			push @noflee, $desc;
		}
	        if ($p eq "в левой руке") 
		   {
			   $Common::lwp = $desc; 
			   $mode = 'dual'
		   } elsif
        	   ($p eq "в правой руке") {$Common::rwp = $desc} elsif
	           ($p eq "в руках") {$Common::dwp = $desc; $mode = 'twohand';} elsif
		   ($p eq "щит") {$Common::shield = $desc; $mode = 'shield'} elsif
		   ($p eq "для освещения") {$Common::light = $desc}
	}
} '^<(.+?)>\s+(.*)';


sub to_mode
{
	my $new = "@_";
	if ($mode eq 'dual') 
	{
		if ($new eq 'shield') {Common::eparser "сня $Common::lwp;оде $Common::shield";wear_light}
		elsif ($new eq 'twohand') {Common::eparser "сня $Common::lwp;сня $Common::rwp;воор $Common::dwp"}
	}
	elsif ($mode eq 'shield')
	{
		if ($new eq 'dual') {rem_light;Common::eparser "сня $Common::shield;дер $Common::lwp"}
		elsif ($new eq 'twohand') {rem_light;Common::eparser "сня $Common::shield;сня $Common::rwp;воор $Common::dwp"}
	}
	elsif ($mode eq 'twohand')
	{
		if ($new eq 'shield') {Common::eparser "сня $Common::dwp;оде $Common::shield;воор $Common::rwp";wear_light}
		if ($new eq 'dual') {Common::eparser "сня $Common::dwp;дер $Common::lwp;воор $Common::rwp"}
	} 
}

P::alias {to_mode "dual"; $mode = "dual"} 'дуал';

P::alias {to_mode "shield"; $mode = "shield"} 'башмод';

P::alias {to_mode "twohand"; $mode = "twohand"} 'двур';


P::alias
{
	my $from = "@_";	
	$from = $Alias::values{locker} unless length $from;
	$blp = 10;
        Common::eparser "взя черн.зелье $from;испи черн.зелье" for (1..10);
	restore_left;
} $Alias::values{cmd_drinkblackpotions};


P::alias
{
        $Common::charisma_locker = "@_";
} $Alias::values{cmd_setcharismalocker};

my $stuff_to = 'посох';

P::alias
{
	$stuff_to = "@_" if length "@_";
	P::echo "\3IПосох:\3H $stuff_to";
} 'посох';

P::alias
{
	free_left;
	Common::eparser "дер $stuff_to;прим $stuff_to @_;снять $stuff_to";
	restore_left;
} 'пп';

P::trig
{
	if ($1 eq "черное" and $blp) {return};
	$blp-- if $blp;
	restore_left;
} '^Вы осушили ([^ ]+)';

my $check_recall = 0;

P::trig
{
	restore_left;
	if ($1 =~ /^свиток возврата/)
	{
		$check_recall = 1;
		P::enable 'CRECALL';		
		Common::sparser "аук пост свиток.возврата 1000 несуществующееимя";
	}
} '^Вы зачитали (.*)';

P::trig {P::disable 'CRECALL'} '^Вы не видите этого игрока\.' , 'g:CRECALL';
P::trig 
{
	P::echo "\3LПроверка на реколл обломалась. Проверь сам.";
	P::echo '';
	P::disable 'CRECALL';
} '^(Стены заглушили Ваши слова\.|Нет свободных брокеров)' , 'g:CRECALL';

P::trig
{
	P::echo "\3J---------------- Ахтунг! Нет рекола! Купи чтоли\. ----------------";
	P::echo '';
	P::disable 'CRECALL';
} '^У Вас этого нет\.' , 'g:CRECALL';

P::disable 'CRECALL';



my %charisma = ();

P::alias
{
        unless (@_)
	{
		P::echo "Команды:";
		P::echo "$charisma{$_} $_" for (keys %charisma);
		return;
	}

        %charisma = ();

        for (@_)
        {
        	if (/^(.*?)\.(.*)$/)
                {
			my $method = $2;
			my $obj = $1;
			$method =~ s/\./ /g;
			$charisma{$obj} = "$method";

                }
		else
		{
			$charisma{$_} = "одеть";
		}
        }
} $Alias::values{cmd_charisma};

P::bindkey {Common::sparser "взя все все.труп"} $Alias::values{bind_getallcorpse};
P::bindkey {Common::sparser "взя все"} $Alias::values{bind_getall};
P::bindkey {Common::sparser "бро все.труп"} $Alias::values{bind_dropallcorpse};

P::alias 
{
	for (keys %charisma)
	{
		Common::eparser "взя $_ $Common::charisma_locker";
		if ($charisma{$_} =~ /^(.*?) (.*)$/)
		{
			Common::eparser "$1 $_ $2"; 
		}
		else { Common::eparser "$charisma{$_} $_" }
	}
} $Alias::values{cmd_wearcharisma};

P::alias 
{
	Common::eparser "сня $_;пол $_ $Common::charisma_locker" 
	for (keys %charisma)
} $Alias::values{cmd_takeoffcharisma};

P::alias
{
	Common::sparser "взя все.труп;взя все все.труп;бро все.труп;взя все все.труп";
} $Alias::values{cmd_loot};

P::alias
{
	$Alias::values{locker} = "@_";
	P::echo "\3DСундук : @_";
} $Alias::values{cmd_setlocker};
