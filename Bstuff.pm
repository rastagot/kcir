#!/usr/bin/perl

package Bstuff;

use Common;
use Alias;
use Baze;

my @search_data = ();

P::alias
{
	my $thing = "@_";
	if ($thing =~ /^$/)
	{
		P::echo "\3GКоличество предметов в базе : \3H" . Baze::amount;
	}
	elsif ($thing =~ /^!(.*)/)
	{
	        @search_data = Baze::request "$1";
        	P::echo "Поиск по шаблону [\3G" . (shift @search_data) . "\3H]";
	        my $i = 1;
		if (@search_data)
		{
	        	for (@search_data) {P::echo "\3G$i) $_"; $i++}	
		}
		else
		{
			P::echo "\3GПусто" 
		}
	
	}
	else
	{
		$thing = $search_data[$thing-1] if ($thing =~ /^\d+$/ and length $search_data[$thing-1]);
		my @data = Baze::get $thing, 1;
		if (@data)
		{
			P::echo $_ for @data;
		}
		else 
		{
			P::echo "\3GПусто"
		}
	}
	P::echo '';

} $Alias::values{bget};

P::trig 
{
	P::enable 'IDENT';
} '^Вы зачитали свиток познания, который рассыпался в прах\.$', 'f9000';

P::trig
{
        my $data = $1;
        return if $data =~ /^Вы /;
        $item = $1 if $data =~ /^Предмет "(.*)"/;
        if ($data eq '')
	{
		$at_ident = 0;
		if (Baze::put ($item,@ident_data))
		{
			P::echo '' for (1..2);
			P::echo "\3GПредмет добавлен в базу."
		}
		@ident_data = ();
		P::disable 'IDENT';
	}
	else 
	{
               	push @ident_data, $data
	}
} '^(.*)$' , 'f8000:IDENT';

1;
