#!/usr/bin/perl
#��������� � ������ �������������� ��� ���

package Speedw;

use Common;
use Alias;

use strict;

my %edirs =
(
        "east" => "west" , "west" => "east",
        "north" => "south" , "south" => "north",
        "down" => "up", "up" => "down"
);


my %speedwalks = (
        '���:�����' => '��������������������������������������������������������������',
        '���:����' =>    '��������������',
        '����:������' => '����������',
        '����:������' => '�������������������������������',
        '������:�����' => '�����������������',
        '�����:���' => '��������������������������������������',
        '�����:���������' => '��������������������������',
	'���������:���' => '������������',
        '�����:����' => '���������������������������������������������������������',
        '����:������' => '�������������������������',
        '���:���' => '������������',
        '���:����' => '����������������������������������',
        '���:�������' => '������������������������������',
        '����:�������' => '��������������������',
        '����:��������' => '�������������������������',
        '����:����' => '������������������������������',
        '����:���' => '����������',
        '��������:������'=>'�����������������������������',
        '������:�������' => '�����������������',
        '�����:������' => '��������������������������������������������������������������������������������������',
        '������:3�' => '��������������������������',
        '3�:�����' => '��������������������������',
        '�����:�����' => '�����������������������',
        '�����:�����' => '������������������',
        '�����:����' => '������������������������������',
        '��:�����' => '������������������������',
        '��:���������' => '������������������������������������',
        '���������:������' => '�����������������������������������������������������',
	'������:�����' => '��������������',
	'�����:������' => '������������������������',
        '��������:��������' => '������������������������������������������������������������������������������������������������������������',
	'��������:39' => '���������������������������������������������������������������������������������������������������������',
	'39:�����' => '����������������������������',
        '���������:������' => '������������',
        '������:�����' => '���������������',
        '�����:��������' => '������������������������������',
        '��������:������2' => '���������',
        '������2:����' => '�����������������������������������������������',
        '����:����' => '�����������������������������������',
        '����:������' => '������������������������������������������',
        '������:��������' => '�������������������������������',
        '��������:��' => '�����������������',
	'���:��' => '��������������',
	'���:��������' => '�����������������',
        '��������:�����' => '���������������������������',
	'�����:�������' => '������������������������������������������',
	'������:��' => '������������������������������������������������������������������������������',
	'������:������' => '������������������������������������������������������������������������������',
	'��:������' => '�������������������������������������������������',
	'������:������' => '�����������������������������'
);

my %inverts = ('�' => '�', '�' => '�' , '�' => '�', '�' => '�' , 'u' => 'd', 'd' => 'u');
my %einverts = ('�' => '�', '�' => '�' , '�' => '�', '�' => '�' , 'u' => 'd', 'd' => 'u');
my %translate = ('�' => 'east', '�' => 'west' , '�' => 'north', '�' => 'south' , 'u' => 'up', 'd' => 'down');

my $cur_pos = 0;
my @speed_array = ();
for (keys %speedwalks)
{
        my ($from,$to) = split /:/;
        my ($lineto,$linefrom) = ('','');
        for (split // , $speedwalks{$_})
        {
                $lineto .= "$_;";
                $linefrom = "$inverts{$_};$linefrom"
        }
        chop $lineto; chop $linefrom;

        P::alias {$Common::speedwalk = (-1 + length $lineto) / 2; Common::eparser "$lineto" } "+$from$to";
        P::alias {$Common::speedwalk = (-1 + length $linefrom)/ 2; Common::eparser "$linefrom" } "+$to$from";

        my $vat = $_;
        P::alias
        {
                my $sw = $vat;
                $cur_pos = 0;
                @speed_array = split // , $speedwalks{$sw};
        } "?$from$to";

        P::alias
        {
                my $sw = $vat;
                @speed_array = reverse split // , $speedwalks{$sw};
                $_ = $inverts{$_} for @speed_array;
                $cur_pos = 0;
        } "?$to$from";
}


sub speedwalk_forward
{
        return P::echo "\3Ispeedwalk is empty" if $cur_pos >= scalar @speed_array;
        Common::sparser "$translate{$speed_array[$cur_pos]}"; 
        $cur_pos++;

}
sub speedwalk_backward
{
        return P::echo "\3Ispeedwalk is empty" if $cur_pos < 1;
        --$cur_pos;
        Common::sparser "$edirs{ $translate{ $speed_array[$cur_pos] } }";

}
P::bindkey { speedwalk_forward } $Alias::values{bind_speedw_fwd};
P::bindkey { speedwalk_backward } $Alias::values{bind_speedw_bck};


1;