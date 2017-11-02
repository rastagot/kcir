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
( "����" => 1,
  "��������.������" => 2,
  "�������.������" => 3,
  "������" => 4,
  "������.�.������" => 5 ,
  "����.������" => 6,
  "����������" => 7,
  "�����������.������" => 8,
  "�����.�.��������" => 9,
);
our %rwt = reverse %wt;

our %ot = 
( 
  "UNDEFINED" => "ops",
  "����" => "1",
  "������" => "2",
  "�������" => "3",
  "�����" => "4",
  "������" => "5",
  "������� ������" => "6",   
  "������" => "7",
  "�������������" => "8",
  "�����" => "9",
  "�������" => "90",
  "������" => "11",
  "������" => "12",
  "TRASH" => "93",
  "�����" => "14",
  "���������" => "15",
  "������" => "16",
  "�������" => "17",
  "����" => "18",
  "���" => "19",
  "������" => "20",
  "����" => "21",
  "�����" => "22",
  "��������" => "23",
  "����������.�����" => "24",
  "����������.����������" => "25",
  "����������.���������� :)" => "26",
);
our %rot = reverse %ot;
our %was =
(
"�����.��.�����" => 0 ,
"�����.��.���" => 1 ,
"�����.��.��������" => 2,
"�����.��.������" => 3,
"�����.��.����" => 4,
"�����" => 5,
"�����.��.�����" => 6,
"�����.��.����" => 7,
"������������.���.���" => 8,
"�����.��.�����" => 9,
"�����.��.����" => 90,
"�����.��.��������" => 11,
"�����.�.������.����" => 12,
"�����.�.�����.����" => 93,
"�����.�.��� ����" => 14,
);
our %rwas = reverse %was;

our %mater = 
( 
  "NO" => 1,
  "�����" => 2,
  "������" => 3,
  "������" => 4,
  "�����" => 5,
  "�������.�����" => 6,
  "����.������" => 7,
  "��������" => 8,
  "������" => 9,
  "�������.������" => 90,
  "��������" => 11,
  "������" => 12,
  "������" => 13,
  "�����" => 14,
  "�����" => 15,
  "����" => 16,
  "��������" => 17,
  "�������" => 18,
  "����.������" => 19,
);
our %rmater = reverse %mater;

our %no_flags = 
( 
  "!���������" => 1,
  "!��������" => 2,
  "!NEUTRAL" => 3,
  "!����" => 4,
  "!������" => 5,
  "!����" => 6,
  "!��������" => 7,
  "!��������" => 8,
  "!����������" => 9,
  "!������" => 90,
  "!��������" => 11,
  "!�������" => 12,
  "!�����" => 93,
  "!������" => 14,
  "!������" => 15,
  "!�������" => 16,
  "������ ��� �����" => 17,
  "!��������" => 18,
  "!������" => 19,
  "!�������" => 20,
  "!������" => 21,
  "!������" => 22,
  "!��������" => 23,
  "������" => 24,
  "!�������" => 25,
  "!�������" => 26,
  "!�������" => 27,
);
our %rno_flags =  reverse %no_flags;

our %e_flags =
( 
  "��������" => 1,
  "�����" => 2,
  "!�����" => 3,
  "!������������" => 4,
  "!�������" => 5,
  "�������" => 6,
  "����������" => 7,
  "!�������" => 8,
 # "������������" => 9,
  "!�������" => 90,
  "����������" => 11,
  "����������.���.����" => 12,
  "!�����������" => 93,
  "!����������" => 14,
  "������.�������" => 15,
  "��������" => 16,
  "�������" => 17,
  "��������" => 18,
  "���������.����" => 19,
  "��������.�����" => 20,
  "�.����������" => 21,
  "��������.�����" => 22,
  "��������.������" => 23,
  "��������.�����" => 24,
  "��������.������" => 25,
  "�������" => 26,
  "������" => 27,
  "�����.�������" => 28,
  "�����" => 29,
  "����������.��.�����" => 30,
  "!���������" => 31,
  "�������.��.��������" => 32,
  "��������.�.�����" => 33,
  "������" => 34,
);
our %re_flags = reverse %e_flags;

our %o_aff =
( 
  "�������" => 1,
  "�����������" => 2,
  "���.������������" => 3,
  "���.�����������" => 4,
  "���.�����" => 5,
  "���.�����" => 6,
  "������������" => 7,
  "���������" => 8,
  "���������" => 9,
  "������������" => 90,
  "��" => 11,
  "������.��.����" => 12,
  "������.��.�����" => 93,
  "���" => 14,
  "��.���������" => 15,
  "��������" => 16,
  "�������������" => 17,
  "����������" => 18,
  "����������" => 19,
  "�����" => 20,
  "��������" => 21,
  "���������������" => 22,
  "�������" => 23,
  "��.�������" => 24,
  "����" => 25,
  "���������" => 26,
  "����" => 27,
  "���.���" => 28,
  "��������������" => 29,
  "���������" => 30,
  "�������.�����" => 32,
  "������������" => 33,
  "����������" => 34,
  "������.�����" => 35,
  "���������.���" => 36,
  "��������.���" => 37,
  "�������.���" => 38,
  "�������.�����" => 39,
  "��������.����" => 40,
  "��������������.����" => 41,
  "���������.����" => 42,
  "��������.����" => 43,
  "�������.����" => 44,
  "�������" => 45,
  "������" => 46,
);
our %ro_aff = reverse %o_aff;

our %a_types =
( 
  "������" => 1,
  "����" => 2,
  "��������" => 3,
  "���������" => 4,
  "��������" => 5,
  "������������" => 6,
  "�������" => 7,
  "���������" => 8,
  "�������" => 9,
  "�������" => 90,
  "���" => 11,
  "����" => 12,
  "�����������" => 93,
  "����.�����" => 14,
  "����.�������" => 15,
  "������" => 16,
  "����" => 17,
  "������" => 18,
  "���������" => 19,
  "�����������" => 20,
  "������.��.������������.����������" => 21,
  "������.��.�����.������" => 22,
  "������.��.����������.��������" => 23,
  "������.��.����������.�������" => 24,
  "������.��.����������.�����������" => 25,
  "�����.�����" => 26,
  "�����.�������" => 27,
  "����.1" => 28,
  "����.2" => 29,
  "����.3" => 30,
  "����.4" => 31,
  "����.5" => 32,
  "����.6" => 33,
  "����.7" => 34,
  "����.8" => 35,
  "����.9" => 36,
  "������" => 37,
  "�����" => 38,
  "��" => 39,
  "������.��.������.������" => 40,
  "�����.����������" => 41,
  "�����" => 42,
  "����������" => 43,
  "�������" => 44,
  "����������" => 45,
);

my %substs =
(
        '����' => '�����.����������',
        '�����' => '��������',
        '�����' => '��������',
        '����' => '�������',
        '����' => '���������',
        '���' => '�����',
        '�����' => '������',
        '������' => '�����������',
        '!����' => '��.���������',
        '�����' => '��������',
        '������' => '���������',
        '�����' => '�����������',
        '����' => '�������������',
        '����' => '����������',
        '�����' => '�������.�����',
        '�������' => '��������.����',
        '����' => '�����',
        '�������' => '�������',
        '����' => '���������',
        '����' => '���������',
        '���' => '���',
        '����.?.?' => '����',
        '����.?.?' => '�����',
        '����.?.?.?' => '�����',
        '���' => '�����������',
        '����' => '����.�����',
        '������.?' => '���������',
        '������.?' => '�����������',
        '����' => '����.�������',
        '�����.?.?.?.?' => '�����.�������',
        '�����.?.?.?.?' => '�����.�����',
        '�����' => '������.��.[���]',
        '�����.?' => '����',
        '����' => '����������.����������',
        '����' => '��������',
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
		if ($src =~ /^\s*(.*?) (��������|��������) �� (.*)$/)	
		{
		
			$how = ($2 eq "��������") ? "-" : "+";
			@a_aff = (@a_aff , $a_types{$1}, $how.$3);
		}
		else {last}
	}
	if ($src =~ /^������� "(.*)", ��� : (.*)$/)
	{
		$type = $ot{$2};	
		$name = $1; 
	}
	elsif ($src =~ /^�������� : (.*)/)
	{
		$synon = $1;
	}
	elsif ($src =~ /^����������� � ������ "(.*)"\.$/)
	{
		$class = $wt{$1};
	}
	elsif ($src =~ /���: (.*), ����: (.*), �����: (.*)\((.*)\)/)
	{
		($weight,$cost,$rentaw,$rentai) = ($1,$2,$3,$4)
	}
	elsif ($src =~ /^����� (.*)\./)
	{
		@wearas = (@wearas, $was{$1});
	}
	elsif ($src =~ /^�������� : (.*)/)
	{
		$material = $mater{$1}
	}
	elsif ($src =~ /^�������� : (.*?)\s*$/)
	{
		@notto = (@notto, $no_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^���������� : (.*?)\s*$/)
	{
		@nottto = (@nottto, $no_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^����� �����������: (.*?)\s*$/)
	{
		@eflags = (@eflags, $e_flags{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^��������� .*? '(.*?)D(.*?)' ������� (.*)$/)
	{
		$spec = "$1,$2"
	}
	elsif ($src =~ /^����������� �� ��� �������: (.*?)\s*$/)
	{
		@oaff = (@oaff, $o_aff{$_}) for (split /,/, $1);
	}
	elsif ($src =~ /^������ \(AC\) : (.*)/)
	{
		$spec = $1
	}
	elsif ($src =~ /^�����\s+: (.*)/)
	{
		$spec .= ",$1"
	}
	elsif ($src =~ /^�������� ����������: (.*)/)
	{
		$spec = $1	
	}
	elsif ($src =~ /^�������� ����������: (.*)/)
	{
		$spec = $1
	}
	elsif ($src =~ /^������� (.*?) \(�������� (.*?)\)\./)
	{
		$spec .= ",$1,$2"
	}
	elsif ($src =~ /^�������� ����������\s*: "(.*)"/)
	{
		$spec = $1;
	}
	elsif ($src =~ /������� �������� \(��� ���\) : (.*)/)
	{
		$spec .= ",$1";
	}
	elsif ($src =~ /^�������������� �������� :/)
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
	$aaffstr .= ($_ > 0 ? "�������� �� " : "�������� �� ") . (abs $_) . ", " unless $tmp;
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
	        push @ident, qq(������� "$name", ��� : $type);
	        push @ident, qq(����������� � ������ "$class") if length $class;
	        push @ident, qq(����� $wearstr) if length $wearstr;
	        push @ident, qq(���: $weight, ����: $cost, �����: $rentaw($rentai));
 	        push @ident, qq(�������� : $cl$material);
	        push @ident, qq(�������� : $cl$nottostr); 
	        push @ident, qq(���������� : $cl$notttostr);
	        push @ident, qq(����� �����������: $cl$eflagsstr);
	        if ( $type eq "������" || $type eq "�������" )
	        {push @ident, qq(�������� ����������: $spec) if length $spec}
	        if ($type eq "�������" || $type eq "�����")
	        {
		        my ($spells,$total,$current) = split /,/ , $spec;
		        push @ident, qq(�������� ����������: $spells) if length $spells;
		        push @ident, qq(������� $total (�������� $current).) if length $total.$current;
	        }
	        elsif ($type eq "���������� �����")
	        {
		        my ($spell,$level) = split /,/, $spec;
		        push @ident, qq(�������� ����������       : "$spell") if length $spell;
		        push @ident, qq(������� �������� (��� ���) : $level) if length $level;
	        }
	        elsif ($type eq "������" || $type eq "������� ������")
	        {
		        my ($nt,$nd) = split /,/ , $spec;
		        push @ident, (qq(��������� ����������� '${nt}D$nd' ������� ) . $nt*($nd+1)/2 . ".");
	        }
	        elsif ($type eq "�����")
	        {
		        my ($ac,$abs) = split /,/ , $spec; 
		        push @ident, qq(������ (AC) : $ac);
			push @ident, qq(�����       : $abs);
	        }
	        push @ident, qq(����������� �� ��� �������: $cl$oaffstr) if length $oaffstr; 
	        $aaffstr =~ s/\n//g;
	        push @ident, qq(�������������� �������� : $cl$aaffstr) if length $aaffstr;
		push @ident, qq(��������, ���������� � �������� ��������) unless $true;
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

                $part =~ s/����//g;
                $part =~ s/$_(| .*)$/$substs{$_}$1/g for (keys %substs);
                my $old_part = $part;

                for (keys %wt) {$flag = $_ if /^$part/i}
                $part = "�����:$flag ���:������" if $flag; $flag = 0;

                for (keys %ot) {$flag = $_ if /^$part/i}
                $part = "���:$flag" if $flag; $flag = 0;

                for (keys %was) {$flag = $_ if /^(�����.��|�����.�|������������.���|)\.?$part/i}
                $part = "����:$flag" if $flag; $flag = 0;

                for (keys %mater) {$flag = $_ if /^$part/i}
                $part = "��������:$flag" if $flag; $flag = 0;

                for (keys %e_flags) {$flag = $_ if /^$part/i}
                $part = "����:$flag" if $flag; $flag = 0;

                for (keys %o_aff) {$flag = $_ if /^$part/i}
                $part = "������:$flag" if $flag; $flag = 0;

                for (keys %a_types) {$flag = $_ if /^$part/i}
                $part = "������:$flag" if $flag; $flag = 0;

                $part = "awake:AWAKE" if $part =~ /^�����|�����|�����$/;
                $part = "���:$1" if $part =~ /^���([<>=]\d+)/;

                $part = "���:$part" if $old_part eq $part;
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
                        if ($parsed_request{$feature} eq '�����') {next ITEM unless $class eq $feature}
                        elsif ($parsed_request{$feature} eq '���') {next ITEM unless $type eq $feature}
                        elsif ($parsed_request{$feature} eq '��������') {next ITEM unless $material eq $feature}
                        elsif ($parsed_request{$feature} eq '���')
                        {
                                $feature =~ s/^(.)//;
                                next ITEM if ( ($1 eq '=') && ($feature != $weight) );
                                next ITEM if ( ($1 eq '>') && ($feature >= $weight) );
                                next ITEM if ( ($1 eq '<') && ($feature <= $weight) );
                        }
                        elsif ($parsed_request{$feature} eq 'awake')
                        {
                                next ITEM if $material =~ /(NO|�����|������|������|�����|�������.�����|����.������)/;
                                next ITEM if $eflagsstr =~ /�����|�������|�����|���������/;
                                next ITEM if $oaffstr =~ /���������|����|���������|���|��������������/;
                        }
                        elsif ($parsed_request{$feature} eq '����')
                        {
                                next ITEM unless $wearstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq '������')
                        {
                                next ITEM unless $oaffstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq '����')
                        {
                                next ITEM unless $eflagsstr =~ /$feature/;
                        }
                        elsif ($parsed_request{$feature} eq '������')
                        {
                                next ITEM unless length $aaffstr;
                                my @bonuses = split /\n/, $aaffstr;
                                my $flag = 0;
                                for (@bonuses) {$flag = 1 if /$feature �������� ��/}
                                next ITEM unless $flag;
                        }
                        elsif ($parsed_request{$feature} eq '���')
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
