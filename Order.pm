#!/usr/bin/perl

package Order;

use Common;
use Alias;
use Mws;

use strict;

our @charm = ('followers');

P::alias {
        if (@_)
        {
                @charm = ();
                my $cnt = 1;
                for (@_)
                {
                        my $obj = $_;
                        if (/^\d+$/) { $cnt = $obj }
                        else
                        {
                                push @charm, $obj;
                                push @charm, "$_.$obj" for 2..$cnt;
                                $cnt = 1;
                        }
                }
        }
        else
        {
                P::echo "מÑגÝÙדי : @charm"
        }
} $Alias::values{charmisez};

P::alias
{
	my $str = "@_";
	my $first = shift;
	if (exists $Mws::name2pid{$first})
	{
		Common::parser "f $first @_";
		return;
	}
        for (@charm)
        {
        	Common::parser "order $_ $str"
        }
} $Alias::values{orderfollowers};

P::alias {Common::eparser "$Alias::values{orderfollowers} assist @_"} $Alias::values{fassist};
P::alias {Common::eparser "$Alias::values{orderfollowers} follow self"} $Alias::values{fself};
P::alias {Common::eparser "$Alias::values{orderfollowers} rescue @_"} $Alias::values{frescue};
P::alias {Common::eparser "$Alias::values{orderfollowers} stand"} $Alias::values{fstand};
P::alias {Common::eparser "$Alias::values{orderfollowers} visible"} $Alias::values{fvis};
P::alias {Common::eparser "$Alias::values{orderfollowers} get all.הגוא"} $Alias::values{fgetc};
P::alias {Common::eparser "$Alias::values{orderfollowers} donate all.הגוא"} $Alias::values{fdonate};
P::alias 
{
	Common::eparser "$Alias::values{orderfollowers} donate all.הגוא;$Alias::values{orderfollowers} ד‗זגÑהט הגוא;$Alias::values{orderfollowers} get all.הגוא}"} $Alias::values{feat};

1;
