#/usr/bin/perl

package Dodge;
use Common;
use Alias;

use strict;

our $dodgeon = 0;
our $active = 0;
our $shutdown = 0;

sub dodge
{
        Common::eparser $Common::dodge unless $Common::inst;
}

sub actswitch {return $active = 0 if $active; $active = 1};

sub dodge_timer
{
        if (!$shutdown && $dodgeon)
        {
                dodge;
                my $delay = 1900 * $Common::dodge_delay;
                my $count = 1;
                P::timeout \&dodge_timer, $delay , $count;
        }
        else {actswitch;$shutdown = 0}
}

P::alias {return $dodgeon = 0 if $dodgeon; $dodgeon = 1} $Alias::values{cmd_dodge_switch};

P::alias
{
	$Common::dodge = "@_" 
} '_защита';

P::alias
{
	$Common::dodge_delay = shift;
} '_защита_каждые';

1;
