#!/usr/bin/perl

package Mapper;

use strict;
use Alias;

my %rooms = ();
my %cur_comp;
my $comp = 0;
my (@minx,@miny,@maxx,@maxy);
my ($maxz,$minz) = (0,0);

my %translate = ( 0 => 'a' , 1 => 'b' , 2 => 'c', 3 => 'd' , 4 => 'e', 5 => 'f');
my $base = 'roombase';

sub add_all($$$$)
{
	my ($n,$x,$y,$z) = @_;
	return if ($rooms{$n}[5] == $comp);


	$rooms{$n}[2] = $x; 
	$rooms{$n}[3] = $y;
	$rooms{$n}[4] = $z;

	$cur_comp{$n} = $rooms{$n};

	$minx[$z] = $x if $x < $minx[$z];
	$miny[$z] = $y if $y < $miny[$z];
	$minz = $z if $z < $minz;
	$maxx[$z] = $x if $x > $maxx[$z];
	$maxy[$z] = $y if $y > $maxy[$z];
	$maxz = $z if $z > $maxz;

	if (defined $rooms{$n}[5])
	{
		$cur_comp{$n}[0] = "$rooms{$n}[5]g";
		return;
	}
	$rooms{$n}[5] = $comp;

	my @exits = split /,/, $rooms{$n}[0];
	for (@exits) 
	{
		/^(\d+)([abcdef])/; 
		my ($nx,$ny,$nz) = ($x,$y,$z);
		if ($2 eq 'a') {$ny++}
		elsif ($2 eq 'b') {$nx++}
		elsif ($2 eq 'c') {$ny--}
		elsif ($2 eq 'd') {$nx--}
		elsif ($2 eq 'e') {$nz++}
		elsif ($2 eq 'f') {$nz--}
		add_all ($1,$nx,$ny,$nz);
	}
}

sub get_zone_name($)
{	
	my $file = $_ . ".zon";
        open FILE, "./zon/" . $file;
	while (<FILE>)
	{
		if (/^.*\~/)
		{
			s/\r\n/\n/;
			s/\~.*//g;
			P::wecho 1, "$_";
			last;
		}
	}
}


P::alias 
{
        open BASE, ">$base";	
	for my $zone (1..999) {
        my $file = $zone . ".wld";
        open FILE, "./wld/" . $file or next;


	my %rooms = ();
        my $room = -1;
        my $name = '';
        my @desc = ();
        my @exits = ();
        my $flags; 
        my $expect = 0;


        my @info = <FILE>;
        close FILE;
        
        s/\r\n/\n/ for (@info);
        chomp @info;

        while (1)
        {	
                $rooms{$room} = [(join ',' , @exits) ,$flags] if ($room >= 0 and length "@exits"); 
                $_ = shift @info;
                last if $_ eq '$';

                if (/^#(\d+)/)
                {
                        $room = $1 % 100;
                        @exits = @desc = (); 
                        $expect = 1; #название комнаты
                        next;
                }

                if ($expect == 1)
                {
                        $name = $_; chop $name;
                        $expect++; #описание
                }
                elsif ($expect == 2)
                {
                        unless (/~/) {push @desc, $_}
                        else {$expect++} #флаги комнаты
                }
                elsif ($expect == 3)
                {
			$flags = (split / /, $_)[1];
                        $expect++; #выходы
                }
                elsif ($expect == 4)
                {
                        next unless /^D(\d+)/;
			
                        my $tmp = $translate{$1};
 
                        $_ = shift @info;
                        while (! (/^[ \d-]+ ([\d-]+)$/) )
                        {
                                $_ = shift @info;
                        }
                        /^[ \d-]+ ([\d-]+)$/;
                        next unless $1;	

                        push @exits , "$1$tmp";
                }
                next;
        }

	print BASE "#$zone\n" if keys %rooms;
        for (sort keys %rooms) {print BASE "$_|$rooms{$_}[0]|$rooms{$_}[1]\n" }
	print BASE "\$\n" if keys %rooms;

	}
	close BASE;
	P::echo 'done';

} '_маппер_обновить_базу';

sub parse(@)
{

	my @zones = @_;
	open BASE, "<$base";
	%rooms = ();
	my $ok = 0;
	$maxz = $minz = 10;

	my $zone;
	while (<BASE>)
	{
		chomp;
		unless ($ok)
		{
			if (/^\#(\d+)/)
			{
				for (@zones) {$ok = 1 if $_ == $1};
			} 
			$zone = $1;
			next;
		}
		
		if ($_ =~ /\$/) {$ok = 0; next}
		my @data = split /\|/;
		$data[0] = "0$data[0]" if $data[0] < 10;
		$rooms{ "$zone$data[0]" } = [ $data[1] , $data[2]];

	}
	close BASE;

	for (@zones) {P::wecho 1, get_zone_name $_};


	my $start = (sort keys %rooms)[0];
	%cur_comp = ();

	while (1)
	{
		@minx = @miny = @maxx = @maxy = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$comp++;
		add_all($start,0,0,10);

		for (keys %cur_comp)
		{
			$cur_comp{$_}[2] -= $minx[$cur_comp{$_}[4]];
			$cur_comp{$_}[3] -= $miny[$cur_comp{$_}[4]];
		}
	
		for ($minz..$maxz)
		{
			$maxx[$_] -= $minx[$_];
			$maxy[$_] -= $miny[$_];
		}
		P::wecho 1, "\3KShowing @_, next part";
		for my $zc ($minz..$maxz)
		{
			my $content = 0;
			my @matrix = ();
			
			for (keys %cur_comp)
			{
				next if $cur_comp{$_}[4] != $zc;
				
				my $flags = $cur_comp{$_}[1];

				my $clr = "\3H";
				if ($flags =~ /b0/) {$clr = "\3J"} #death trap
				elsif ($flags =~ /e1/) {$clr = "\3J"}
				elsif ($flags =~ /f1/) {$clr = "\3J"}
				elsif ($flags =~ /i0/) {$clr = "\3N"}
				elsif ($flags =~ /e0/) {if ($flags =~ /h0/) {$clr = "\3O"} else {$clr = "\3K"}}
				elsif ($flags =~ /c0/) {$clr = "\3L"}
				elsif ($flags =~ /h0/) {$clr = "\3G"}
				elsif ($flags =~ /c0/) {$clr = "\3K"}
				elsif ($flags =~ /b1/) {$clr = "\3D"}
				
				$matrix[$cur_comp{$_}[2] * 2][$cur_comp{$_}[3] * 2] = $clr."+"."\3H";


				my @exits = split /,/, $rooms{$_}[0];
				my $room = $_;
			        for (@exits)
				{
					my ($nx,$ny) = (0,0);
			                /^(\d+)([abcdef])/;
					my $sym;
			                if ($2 eq 'a') {$ny++;$content = 1}
			                elsif ($2 eq 'b') {$nx++;$content = 1}
			                elsif ($2 eq 'c') {$ny--;$content = 1}
			                elsif ($2 eq 'd') {$nx--;$content = 1}
					elsif ($2 eq 'e') {$sym = $clr."u\3H"}
					elsif ($2 eq 'f') {$sym = $clr."d\3H"}
					else {$sym = $1}
					$sym = '-' if $nx;	
					$sym = '|' if $ny;	
					my $x = $cur_comp{$room}[2]*2 + $nx;
					my $y = $cur_comp{$room}[3]*2 + $ny;
					$matrix[$x][$y] = $sym;
				}
			}
			next unless $content;
			P::wecho 1, "\3KFloor ". ($zc-10). " \3H: -> "; P::wecho 1 , '';
			my $str = '';
			for my $b (0..$maxy[$zc]*2) 
			{
				for my $a (0..$maxx[$zc]*2) 
				{
					if ($matrix[$a][2*$maxy[$zc]-$b]) {$str .= $matrix[$a][2*$maxy[$zc]-$b]} else {$str .= " "};
				}
				P::wecho 1, $str; $str = '';
			}
			P::wecho 1, '';
			P::wecho 1, "-----------------------------------------";
		}

		%cur_comp = ();
		$ok = 1;
		for (keys %rooms) 
		{
			unless (defined $rooms{$_}[5]) {$ok = 0;$start = $_;last}
		};
		next unless $ok;

		last;
	}
}

P::alias
{
	parse @_;
} '_маппер';

1;
