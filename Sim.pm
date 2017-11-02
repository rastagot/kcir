#!/usr/bin/perl

package Sim;

use strict;
use Common;

my ($from,$which);

P::alias
{
        ($from,$which) = @_;
} '_считать';

P::alias
{
        Common::eparser "гов $from";
        $from += $which;
} 'считать';

my @all = ();
my $line1 = 'й ц у к е н г ш щ з х ъ';
my $line2 = 'ф ы в а п р о л д';
my $line3 = 'я ч с м и т ь б ю';

P::alias {@all = split / /, $line1} '_ряд_слева_1';
P::alias {@all = split / /, $line2} '_ряд_слева_2';
P::alias {@all = split / /, $line3} '_ряд_слева_3';

P::alias {@all = reverse split / /, $line1} '_ряд_справа_1';
P::alias {@all = reverse split / /, $line2} '_ряд_справа_2';
P::alias {@all = reverse split / /, $line3} '_ряд_справа_3';

P::trig
{
        $_ = $2;
        return unless /^\d/;
        @all = split /[^\d]+/, $_;
}"^(.*?) сказал.? Вам : '(.*)'";

P::alias
{
        Common::eparser "гов " . shift @all;
} 'говорить';


my @ph = 
( 
	'стоп',
	'стоп!',
	'погодите',
	'я не понял',
	'что надо говорить',
	'не увидел',
	'повтори задание',
	'блин'
);
my $phcount;
my $random_int = 1500;

sub ph_command
{
	return unless $phcount--;
	Common::eparser "гов " . $ph[ int(rand(scalar @ph)) ];
	P::timeout \&ph_command, int(rand(2000)) + 1000, 1;
	
	
}
P::alias
{
	$phcount = 8 - rand(3);
	P::timeout \&ph_command, $random_int, 1;
} '_непонятки';

1;


