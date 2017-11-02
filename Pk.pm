#!/usr/bin/perl

package Pk;
use strict;

open PK, "<$Conf::pk_file";

our %pk_reason = ();
our %pk = ();

for (<PK>) {
	chomp;
	my ($c,$r,$p) = split /:/; 
	$pk{$c} = $p;
	$pk_reason{$c} = $r;
}

close PK;

sub save_list
{
	open PK, ">$Conf::pk_file";
	print PK "$_:$pk_reason{$_}:$pk{$_}\n" for keys %pk;
	close PK;
}
P::alias
{
	my @arg = @_;
	
	if ($arg[0] eq '���' or !length $arg[0])
	{
		P::echo "$_ : $pk{$_} : $pk_reason{$_}" for sort keys %pk;
	}
	elsif ($arg[0] eq '�')
	{
		return P::echo "��� ����� �� ������" unless length $arg[1];	
		my $priority = $arg[2]  || 5;
		my $reason = $arg[3]  || "������ ���";
		return P::echo "��������� ������ ���� �� 1 �� 10" if (($priority < 1) || ($priority > 10));	
		$pk_reason{$arg[1]} = $reason;
		$pk{$arg[1]} = $priority;
		save_list;
		P::echo "�� �������� ������ � ������.";
	}
	elsif ($arg[0] eq '�')
	{
		return P::echo "��� ����� �� ������" unless (length $arg[1] or exists $pk{$arg[1]});     
                delete $pk{$arg[1]};
                delete $pk_reason{$arg[1]};
		save_list;
                P::echo "�� ������� ������ �� �������."; 
	}
	else
	{
		if (exists $pk{$arg[0]})
		{
			P::echo "$arg[0] : $pk{$arg[0]} : $pk_reason{$arg[0]}";
		}
		else {P::echo "���� ������"}
	}
} '��';


1;
