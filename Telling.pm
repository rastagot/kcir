#!/usr/bin/perl
package Telling;

use Common;

my $wind = 0;

P::bindkey
{
	$wind = $wind?0:1;
	CL::gotowin($wind);
	
} 'ins';

P::trig
{
	my ($w,$t,$o) = ($1,$2,$3);
	return if $w =~ /������|�������|�����/;
	return if ($w eq '��' && $t =~ /^������/ && $o =~ /������|�������/);
	return if ($; =~ /����/);
	P::wecho 1, "\3I" . $Common::clock . " \3H" . CL::unparse_colors($;);
#	P::wecho 1, "";
} '^([^ ]+?) (�������|���������|������|�������|�������|���|�������|��������|�������|���������|������)(.+?)\'', f10000;



1;

