#!/usr/bin/perl 

package Autoheal;
use Common;
use Alias;
use strict;

our $autoheal_on = 0;

P::alias
{
	my $value = shift;
	if (! length $value)
	{
		P::echo '������� ������� ������������ ��� - ���� �������� (�����)';
		P::echo '���������� ������� ����������� ���������� �� ������� ���';
		P::echo '���� ������';
		P::echo '3 - �����. 2 - ���.�����. 1 - ��.���.���.';
		P::echo '0 - ��������� ��� ����';
	}
	else
	{
		$autoheal_on = $value;	
	}
} $Alias::values{cmd_autoheal};

P::alias
{
	$Common::heal_command = "@_";
} $Alias::values{cmd_setautohealcommand};



sub check($$$)
{
	my ($obj,$health,$colr) = @_;
	$health =~ s/^\s*([^ ]+)\s*$/$1/;
	if ( ($health eq '�����' && $colr eq 'L' && $autoheal_on >= 3) || 
	     ($health eq '���.�����' && $colr eq 'J' && $autoheal_on >= 2) ||
	     ($health eq '��.���.���' && $colr eq 'B' && $autoheal_on >= 1) ||
	     ($health eq '��� ������' && $colr eq 'B')
	   )
	{	
		Common::sparser $Alias::values{cmd_toup};
		Common::sparser "$Common::heal_command .$obj";
	}

};


1;
