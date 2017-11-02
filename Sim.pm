#!/usr/bin/perl

package Sim;

use strict;
use Common;

my ($from,$which);

P::alias
{
        ($from,$which) = @_;
} '_�������';

P::alias
{
        Common::eparser "��� $from";
        $from += $which;
} '�������';

my @all = ();
my $line1 = '� � � � � � � � � � � �';
my $line2 = '� � � � � � � � �';
my $line3 = '� � � � � � � � �';

P::alias {@all = split / /, $line1} '_���_�����_1';
P::alias {@all = split / /, $line2} '_���_�����_2';
P::alias {@all = split / /, $line3} '_���_�����_3';

P::alias {@all = reverse split / /, $line1} '_���_������_1';
P::alias {@all = reverse split / /, $line2} '_���_������_2';
P::alias {@all = reverse split / /, $line3} '_���_������_3';

P::trig
{
        $_ = $2;
        return unless /^\d/;
        @all = split /[^\d]+/, $_;
}"^(.*?) ������.? ��� : '(.*)'";

P::alias
{
        Common::eparser "��� " . shift @all;
} '��������';


my @ph = 
( 
	'����',
	'����!',
	'��������',
	'� �� �����',
	'��� ���� ��������',
	'�� ������',
	'������� �������',
	'����'
);
my $phcount;
my $random_int = 1500;

sub ph_command
{
	return unless $phcount--;
	Common::eparser "��� " . $ph[ int(rand(scalar @ph)) ];
	P::timeout \&ph_command, int(rand(2000)) + 1000, 1;
	
	
}
P::alias
{
	$phcount = 8 - rand(3);
	P::timeout \&ph_command, $random_int, 1;
} '_���������';

1;


