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
                Common::sparser "��� $Alias::values{food_count} $Alias::values{food} $Alias::values{locker}";
                Common::sparser "$Alias::values{food_command} $Alias::values{food}" for (1 .. $Alias::values{food_count});
		Common::sparser "��� ���.$Alias::values{food} $Alias::values{locker}"
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
                Common::sparser "��� $Alias::values{drink} $Alias::values{locker}";
                Common::sparser "��� $Alias::values{drink}" for (1..2);
                Common::sparser "��� $Alias::values{drink} $Alias::values{locker}";
        }
} $Alias::values{cmd_drink};

P::alias
{
	my ($from,$cnt) = split /\s+/, "@_";
	$from = "�������" unless length $from;
	$cnt = 1 unless length $cnt;
	for (1..$cnt)
	{
		my $pref = "$_."; 
		$pref = '' if $_ == 1;
        	Common::sparser "��� $pref$Alias::values{drink} $Alias::values{locker}";
	        Common::sparser "���� $Alias::values{drink} �����;����� $Alias::values{drink} $from";
	        Common::sparser "��� $Alias::values{drink} $Alias::values{locker}";
	}
} $Alias::values{cmd_fillall};

our $mode = 0;

sub rem_light 
{
	Common::eparser "��� $Common::light" if length $Common::light;
}

sub wear_light 
{
	Common::eparser "��� $Common::light" if length $Common::light;
}

sub restore_left
{	
	if ($mode eq 'twohand') {Common::eparser "���� $Common::dwp" if length $Common::dwp}
	elsif ($mode eq 'dual') {Common::eparser "��� $Common::lwp" if length $Common::lwp}
	elsif ($mode eq 'shield') {Common::eparser "��� $Common::shield" if length $Common::shield ;wear_light}
};

sub restore_right
{
	if ($mode eq 'twohand') {Common::eparser "���� $Common::dwp" if length $Common::dwp}
	else {Common::eparser "���� $Common::rwp" if length $Common::rwp}
}

sub free_left
{
	if ($mode eq 'twohand') {Common::eparser "��� $Common::dwp" if length $Common::dwp}
	elsif ($mode eq 'dual') {Common::eparser "��� $Common::lwp" if length $Common::lwp}
	elsif ($mode eq 'shield') {Common::eparser "��� $Common::shield" if length $Common::shield ;rem_light}
};

my $blp = 0;

P::trig
{
        $Common::ateq = 1;
	@noflee = ();
	$blp = 0;
} '�� ��� ������';


P::trig
{
        return unless $Common::ateq;
	
	my $p = $1;
        my $a = $2;

        $a =~ s/^\[.*\] //;
        $a =~ s/\s+<.*>.*//;
	$a =~ s/ \((�����|\d+ ���.?.?)\)//;
	
	if ($a eq '[ ������ ]')
	{
		if ( ($p eq '� ����� ����' and $mode eq 'dual') || 
	    	     ($p eq '� �����' and $mode eq 'twohand') ||
	             ($p eq '���' and $mode eq 'shield') ||
                     ($p eq '��� ���������' and $mode eq 'shield') ) {restore_left};

		if ($p eq '� ������ ����' and $mode ne 'twohand') {restore_right}
	}
	else
	{
        	my $desc = Baze::alias $a;
		my $str = (Baze::spec_get($a))[11];
		if ( (Baze::spec_get($a))[11] =~ /24/ )
		{
			push @noflee, $desc;
		}
	        if ($p eq "� ����� ����") 
		   {
			   $Common::lwp = $desc; 
			   $mode = 'dual'
		   } elsif
        	   ($p eq "� ������ ����") {$Common::rwp = $desc} elsif
	           ($p eq "� �����") {$Common::dwp = $desc; $mode = 'twohand';} elsif
		   ($p eq "���") {$Common::shield = $desc; $mode = 'shield'} elsif
		   ($p eq "��� ���������") {$Common::light = $desc}
	}
} '^<(.+?)>\s+(.*)';


sub to_mode
{
	my $new = "@_";
	if ($mode eq 'dual') 
	{
		if ($new eq 'shield') {Common::eparser "��� $Common::lwp;��� $Common::shield";wear_light}
		elsif ($new eq 'twohand') {Common::eparser "��� $Common::lwp;��� $Common::rwp;���� $Common::dwp"}
	}
	elsif ($mode eq 'shield')
	{
		if ($new eq 'dual') {rem_light;Common::eparser "��� $Common::shield;��� $Common::lwp"}
		elsif ($new eq 'twohand') {rem_light;Common::eparser "��� $Common::shield;��� $Common::rwp;���� $Common::dwp"}
	}
	elsif ($mode eq 'twohand')
	{
		if ($new eq 'shield') {Common::eparser "��� $Common::dwp;��� $Common::shield;���� $Common::rwp";wear_light}
		if ($new eq 'dual') {Common::eparser "��� $Common::dwp;��� $Common::lwp;���� $Common::rwp"}
	} 
}

P::alias {to_mode "dual"; $mode = "dual"} '����';

P::alias {to_mode "shield"; $mode = "shield"} '������';

P::alias {to_mode "twohand"; $mode = "twohand"} '����';


P::alias
{
	my $from = "@_";	
	$from = $Alias::values{locker} unless length $from;
	$blp = 10;
        Common::eparser "��� ����.����� $from;���� ����.�����" for (1..10);
	restore_left;
} $Alias::values{cmd_drinkblackpotions};


P::alias
{
        $Common::charisma_locker = "@_";
} $Alias::values{cmd_setcharismalocker};

my $stuff_to = '�����';

P::alias
{
	$stuff_to = "@_" if length "@_";
	P::echo "\3I�����:\3H $stuff_to";
} '�����';

P::alias
{
	free_left;
	Common::eparser "��� $stuff_to;���� $stuff_to @_;����� $stuff_to";
	restore_left;
} '��';

P::trig
{
	if ($1 eq "������" and $blp) {return};
	$blp-- if $blp;
	restore_left;
} '^�� ������� ([^ ]+)';

my $check_recall = 0;

P::trig
{
	restore_left;
	if ($1 =~ /^������ ��������/)
	{
		$check_recall = 1;
		P::enable 'CRECALL';		
		Common::sparser "��� ���� ������.�������� 1000 �����������������";
	}
} '^�� �������� (.*)';

P::trig {P::disable 'CRECALL'} '^�� �� ������ ����� ������\.' , 'g:CRECALL';
P::trig 
{
	P::echo "\3L�������� �� ������ ����������. ������� ���.";
	P::echo '';
	P::disable 'CRECALL';
} '^(����� ��������� ���� �����\.|��� ��������� ��������)' , 'g:CRECALL';

P::trig
{
	P::echo "\3J---------------- ������! ��� ������! ���� �����\. ----------------";
	P::echo '';
	P::disable 'CRECALL';
} '^� ��� ����� ���\.' , 'g:CRECALL';

P::disable 'CRECALL';



my %charisma = ();

P::alias
{
        unless (@_)
	{
		P::echo "�������:";
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
			$charisma{$_} = "�����";
		}
        }
} $Alias::values{cmd_charisma};

P::bindkey {Common::sparser "��� ��� ���.����"} $Alias::values{bind_getallcorpse};
P::bindkey {Common::sparser "��� ���"} $Alias::values{bind_getall};
P::bindkey {Common::sparser "��� ���.����"} $Alias::values{bind_dropallcorpse};

P::alias 
{
	for (keys %charisma)
	{
		Common::eparser "��� $_ $Common::charisma_locker";
		if ($charisma{$_} =~ /^(.*?) (.*)$/)
		{
			Common::eparser "$1 $_ $2"; 
		}
		else { Common::eparser "$charisma{$_} $_" }
	}
} $Alias::values{cmd_wearcharisma};

P::alias 
{
	Common::eparser "��� $_;��� $_ $Common::charisma_locker" 
	for (keys %charisma)
} $Alias::values{cmd_takeoffcharisma};

P::alias
{
	Common::sparser "��� ���.����;��� ��� ���.����;��� ���.����;��� ��� ���.����";
} $Alias::values{cmd_loot};

P::alias
{
	$Alias::values{locker} = "@_";
	P::echo "\3D������ : @_";
} $Alias::values{cmd_setlocker};
