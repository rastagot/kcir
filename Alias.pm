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
        '������' => \%healer_spells,
        '������' => \%bmage_spells,
        '���������' => \%mage_spells,
        '������������' => \%necro_spells,
        '�����' => \%trader_spells,
        '������' => \%paladin_spells,
        '��������' => \%charmer_spells,
	'�����' => \%druid,
);
my %attacks = 
(
        '������' => \%healer_attacks,
        '������' => \%bmage_attacks,
        '���������' => \%mage_attacks,
        '������������' => \%necro_attacks,
        '�����' => \%trader_attacks,
        '������' => \%paladin_attacks,
        '��������' => \%charmer_attacks,
	'���������' => \%tank_attacks,
	'��������' => \%fighter_attacks,
	'����' => \%thief_attacks,
	'�������' => \%nayom_attacks,
	'�������' => \%hunter_attacks,
	'������' => \%blacksmith_attacks,
	'�����' => \%druid_attacks,
);
my %defence = 
(
	'������' => '�����',
	'���������' => '�����',
	'����' => '�����',
	'�������' => '�����',
	'�������' => '�����',
	'������' => '�����',
);
my %defence_delay = 
(
        '������' => 1,
        '���������' => 1,
        '����' => 1,
        '�������' => 1, 
        '�������' => 1,
        '������' => 2,

);
my %aliases = 
(
	'��������� �����' => 'cmd_settank',
	"�������� ���� � ��������� �����" => 'cmd_toup',
	'������� ��� ��������' => 'cmd_setautohealcommand',
	'���������� ������� ��������' => 'cmd_autoheal',
	'����� ��� ����' => 'cmd_loot',
	'����������� ���������' => 'locker',
	'����������� ��������� ��� ���' => 'rune_locker',
	'������� �� ���������' => 'autoloot',
	'����������� ���' => 'food',
	'��� ����� ��������' => 'food_count',
	'������� ��� ������������� ���' => 'food_command',
	'����������� ����' => 'drink',
	'����������� � mud.ru 110' => 'cmd_connect',
	'������ � �������� ������������ ���� ��������' => 'conn_host',
	'���� � �������� ������������ ���� ��������' => 'conn_port',
	'����������� ����� ������ � ���� �� ������' => 'cmd_proxy_connect',
	'����������� � locahost' => 'cmd_connect_local',
	'���� �� localhost' => 'local_port',
	'����� �� ����������� � ������� � ��������' => 'conn_timeout',
	'��������� / ���������� ���������' => 'cmd_autoresc_switch',
	'��������� / ���������� ������ ���� �����' => 'cmd_dodge_switch',
	'���������� ��������� � ������' => 'cmd_druid_setrunelocker',
	'�������� ��� ���� � ���������' => 'cmd_druid_allrunetolocker',
	'��������� ������ � ������ ���' => 'cmd_druid_check_runes',
	'���������� ������� ���������� ��� ���' => 'cmd_druid_runestatistics',
	'�������� / ��������� ����� ������� �������� ������ ������������' => 'cmd_autogetweapons',
	'����� ���� ������' => 'cmd_getweapons',
	'����� �� ����� ���� (0/1)' => 'log',
	'������������ / ��� ��� ������ ���������� �������' => 'arda_commands',
	'����' => 'cmd_breakfast',
	'����' => 'cmd_drink',
	'��������� ��������� � ���������' => 'cmd_fillall',
	'���� ������' => 'cmd_drinkblackpotions',
	'���������� ��������� ��� ����' => 'cmd_setcharismalocker',
	'���������� ������� ��������' => 'cmd_charisma',
	'����� ����' => 'cmd_wearcharisma',
	'����� ����' => 'cmd_takeoffcharisma',
	'�������� pid �������� mmc' => 'showpid',
	'������� ������� ������� ������' => 'cmd_mws_force',
	'������� ������� ���� �������' => 'cmd_mws_forceall',
	'������� ������� ���� ������� � ���������� � 1 ���' => 'cmd_mws_waitforceall',
	'���������� ������� �� ������ ������' => 'cmd_mws_redirect',
	'���������� ��������' => 'charmisez',
	'����� ��� ������� ��������� ����' => 'orderfollowers',
	'��������� ���� ������' => 'fassist',
	'��������� ���� ��������� �' => 'fself',
	'��������� ���� ������' => 'frescue',
	'��������� ���� ������' => 'fstand',
	'��������� ���� ���' => 'fvis',
	'��������� ���� ��� ���.����' => 'fgetc',
	'��������� ���� ��� ���' => 'fdonate',
	'��������� ���� ������� ����' => 'feat',
	'������ ���� �� ������� ������' => 'resc_mode',
	'������ ���� ��� �� ������ � ���� ����' => 'resc_last',
	'�������� � ��������' => 'add_autoresc',
	'�������� �� ����������' => 'add_butresc',
	'�������� �� ���� � ������������ �����' => 'add_specresc',
	'�������� ���� � ������ ������' => 'cmd_clearresc',
	'�������� � ������ �������' => 'add_recallresc',
	'��������� ���� ��� � ������' => 'recallall',
	'������� ��� ������� �����������' => 'recallem',
	'�������� ������ ������ � �����' => 'showrescmodes',
	'����� � �����' => 'enterpent',
	'�������� �������' => 'penttrigger',
	'�������� ����� �� ����' => 'cmd_totick',
	'������� ����� �� ����' => 'cmd_saytotick',
	'���������������� ���������� �����' => 'exp_stat_init',
	'��������, �������������� �����������' => 'backstab',
	'���������� ���������' => 'cmd_setlocker',
	'����� �� ����' => 'bget',
	'�������� � ���� ����� ����' => 'madd',
	'���������� ������� � mmc' => 'cmd_prefix',
	'���������� ��� ������ ������������ ��������� �����' => 'cmd_director',
	'�������� / ��������� �������' => 'cmd_autoloot',
	'�������� / ��������� ���������� �� �������' => 'cmd_autoreport',
	'�������� / ��������� ��������������������' => 'cmd_autodoors',
	'�������� / ��������� ��������� ������ ���������� ������' => 'english_commands',
	'�������� ������������� ���������� ������ ��������� ������' => 'simulation',
	'������� ��� ���������� �������� mmc' => 'cmd_killall',
	'�������� ����� ��������� � mmc' => 'cmd_colors',
	'���������� �������� �������� �������' => 'cmd_noflee',
	'�������, ���� ��� ����� ��������' => 'cmd_flee',
	'���������� �����, ����� ����� ����� ����� �����' => 'cmd_setattack',
	'���������� ����' => 'cmd_settargets',
	'���������� ����� ������� ����' => 'cmd_setcurtarget',
	'������� � ������ ������ ��� ��� ����������' => 'cmd_tobook',
	'������� � ������ ������ ��� ��� ���������' => 'cmd_frombook',
	'������� � ������ ������ ��� ��������� �� ���' => 'cmd_frommem',
);

my %bindkeys = 
(
	'���� �����' => 'bind_sanctank',
	'��� �����' => 'bind_healtank',
	'������ �����' => 'bind_prizmtanka',
	'������� ������' => 'bind_group',
	'���������� ����� �����������' => 'bind_parry',
	'���������� ����� �����' => 'bind_weer',
	'���������� ����� ������' => 'bind_dodge',
	'���������� ����� �������' => 'bind_stun',
	'������� �������� �� �������' => 'bind_window',
	'�������� ��� ���� � �����' => 'bind_druid_runestolocker',
	'����� � ������������� ���� (�����_���������� ��������)' => 'bind_grouptarget',
	'��������� ����' => 'bind_recallall',
	'������ ��� ��� �� ������ � ���� ����' => 'bind_resclast',
	'������ ����' => 'bind_rescmode1',
	'����������, ������ �� ���� ������ ���� ���������� ���� ���������' => 'bind_recall',
	'��� ������� ����' => 'bind_recallallall',
	'������ �� ���������' => 'bind_speedw_fwd',
	'����� �� ���������' => 'bind_speedw_bck',
	'���� �����' => 'bind_tanknorth',
	'���� ��' => 'bind_tanksouth',
	'���� �����' => 'bind_tankwest',
	'���� ������' => 'bind_tankeast',
	'���� �� �����' => 'bind_gonorth',
	'���� �� ��' => 'bind_gosouth',
	'���� �� �����' => 'bind_gowest',
	'���� �� ������' => 'bind_goeast',
	'����������' => 'bind_scan',
	'�������� ������� ������' => 'bind_tilde',
	'������ / ���������' => 'bind_assist',
	'����� 0 �� ������� ����' => 'bind_attack0',
	'����� 1 �� ������� ����' => 'bind_attack1',
	'����� 2 �� ������� ����' => 'bind_attack2',
	'����� 3 �� ������� ����' => 'bind_attack3',
	'����� 4 �� ������� ����' => 'bind_attack4',
	'����� 5 �� ������� ����' => 'bind_attack5',
	'����� 6 �� ������� ����' => 'bind_attack6',
	'����� 7 �� ������� ����' => 'bind_attack7',
	'����� 8 �� ������� ����' => 'bind_attack8',
	'�������� ����' => 'bind_nextar',
	'���������� ����' => 'bind_prevtar',
	'��������� ����� �����' => 'bind_nextsettar',
	'���������� ����� �����' => 'bind_prevsettar',
 	'����� ���' => 'bind_getall',
 	'����� ��� ���.����' => 'bind_getallcorpse',
 	'��� ���.����' => 'bind_dropallcorpse',
);

our %eng_aliases =
(
        "���" => "���","�" => "���",
        "���" => "���", "����" => "",
        "��" => "����;������",
        "��" => "����","���" => "�����",
        "��" => "���","���" => "���",
        "�" => "�","�" => "�",
        "�" => "�","�" => "�",
        "�" => "��","�" => "���",
        "set" => "���",
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
		if (/^###������ ��������� (.*)/)
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
        elsif (/^###���������/)
        {
                $parsing_prof = "system";
        }
        next unless $parsing_prof;

        if ($parsing_prof eq "system")
        {
                if (/^������\s*:\s*(.*?)\s*:\s*(.*)$/)
                {
                        next unless exists $bindkeys{$1};
                        $values{$bindkeys{$1}} = $2;
                }
		elsif (/^�������� ������\s*:\s*(.*?)\s*:\s*(.*)$/)
		{
			my ($command,$alias) = ($1,$2);
			P::echo "bind: $alias => $command";
			P::bindkey { fparser $command } $alias;
		}
		elsif (/^�������� �����\s*:\s*(.*?)\s*:\s*(.*)$/)
		{
			my ($command,$alias) = ($1,$2);
			P::echo "alias: $alias => $command";
			P::alias { fparser $command } $alias;
		}
                elsif (/^���������\s*:\s*(.*?)\s*:\s*(.*)/)
                {
                        $highlightpart{$1} = $2;
                }
                elsif (/^��������� �������\s*:\s*(.*?)\s*:\s*(.*)/)
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
                if ($1 =~ '�����')
                {
                        /^����� (\d+)\s*:\s*(.*)$/;
                        $attacks{$parsing_prof}{$1} = $2;
                        next;
                }
		elsif ($1 =~ '_������')
		{	
			$defence{$parsing_prof} = $2;
		}
		elsif ($1 =~ '_������_������')
		{
			$defence_delay{$parsing_prof} = $2;
		}
                elsif ($parsing_prof ne '�����')
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
        if ($tprof ne '�����')
        {
		$values{cast_command} = '����';
                for (sort keys %{$spells{$tprof}})
                {
                        my $alias = $spells{$tprof}{$_};
                        P::alias
                        {
                                my $to = "@_";
                                $to = $Target::target[$Target::curtar] if $to eq "�";
                                Common::eparser "$values{cast_command} !$alias! $to"
                        } "$_";
                        P::alias {Common::eparser "��� !$alias!"} "$values{cmd_tobook}$_";
                        P::alias {Common::eparser "��� !$alias!"} "$values{cmd_frombook}$_";
                        P::alias {Common::eparser "��� !$alias! �"} "$values{cmd_frommem}$_";
                }
        }
        else {druid_setup}

        $prof = $tprof;

	for (sort keys %{$attacks{$prof}})
	{
        	Common::sparser "��$_ $attacks{$prof}{$_}"
	}
	Common::sparser "_������ $defence{$prof}" if exists $defence{$prof};
	Common::sparser "_������_������ $defence_delay{$prof}" if exists $defence_delay{$prof};

	if ($prof eq '������' or $prof eq '���������' or
            $prof eq '������������' or $prof eq '�����' or
	    $prof eq '��������' or $prof eq '�����' )
	{
 #               Common::eparser "����� " . Common::fupper $Common::ne;
		$Common::resccommand = "order followers rescue";
	}
	else
	{
		$Common::resccommand = "rescue";
	}

} '^�� ([^, ]+).* \(.*, .*?, (.*?) (\d+) .*\).$';

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
        $alias_rune =~ s/^(....?).*/���.$1/;
        $alias_rune =~ s/(���.���|���.���|���.���)./$1/;
        $rune_aliases{$rune} = $alias_rune;
        return $alias_rune;
}

sub simple_take_rune
{
        my $alias_rune = get_rune_alias shift;
        Common::eparser "����� $alias_rune $values{rune_locker}";
}

P::alias
{
        $values{rune_locker} = "@_"
} $values{cmd_druid_setrunelocker};

P::alias
{
        Common::eparser "��� ���.��� $values{rune_locker}";
	%rune_in = ();
        $rune_checking = 0;
} $values{cmd_druid_allrunetolocker};

P::alias
{
        $rune_checking = 1;
	%rune_count = ();
	my @arr = split / /, '��� ��� ��� ��� ��� ���� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ���� ��� ��� ��� ��� ���� ��� ��� ��� ��� ��� ��� ���� ��� ��� ��� ��� ��� ��� ��� ��� ���';
	my ($cont,$cont2) = @_;
	$cont = $values{rune_locker} unless length $cont;
	$cont2 = $cont unless length $cont2;
        Common::sparser "����� ���.$_ $cont;�� ���.$_;����� ���.$_ $cont2" for @arr;
} '_��������';

P::alias
{
	Common::sparser "_��������";
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
                s/^\s*���� ([^ ]+).*$/$1/;

                if (!exists $rune_count{$1})
                {
                        my $rune_alias = get_rune_alias $1;
                        $rune_count{$1} = 1000;
                        Common::eparser "�� $rune_alias" if $prof eq '�����';

                }
                elsif (--$rune_count{$_} == 0)
                {
			delete $rune_count{$_};
                        simple_take_rune $_;
                }
        }
} '�� ������� (.*), �����.. ��������. ����� ������.';


P::trig
{
        $rune_in{$1} = 1;
	$current_rune = $1;
        return if $rune_checking;
        unless (exists $rune_count{$1})
        {
                my $rune_alias = get_rune_alias $1;
                $rune_count{$1} = 1000;
                Common::eparser "�� $rune_alias" if $prof eq '�����';
        }
} '^�� ����� ���� ([^ ]*)(.*)(��|\.)';

P::trig
{
        delete $rune_in{$1};
} '^�� �������� ���� ([^ ]*) (.*)�|^�� ������� ���� ([^ ]*).*\.|^�� ���� ���� ([^ ]*)';

P::trig
{
        $current_rune = $1;
} '^���� ([^ ]+).*���������\.';

P::trig
{
        $rune_count{$current_rune} = $1;
        $rune_in{$current_rune} = 1;
} '^�c������ ����������: (\d+)';

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
	$values{cast_command} = '����';
        for (keys %druid)
        {
                my @runes = split /;/, $druid{$_};
                my $alias = shift @runes;
                $rune_exists{$_} = 1 for (@runes);
                P::alias
                {
                        my $to = "@_";
                        $to = $Target::target[$Target::curtar] if $to eq "�";
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
                $how = "\"$how\"" if $how =~ /[��������������������������������+]/i;
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
