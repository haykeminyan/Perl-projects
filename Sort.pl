use 5.010;
use strict;
use warnings;
use Getopt::Long;
use Scalar::Util qw(looks_like_number);
use Data::Dumper;
use DDP;
use POSIX;
my $key;
my $num;
my $reverse;
my $unique;
my $month_sort;
say "Supplied options: -k, -n, -r, -u, -M";
GetOptions('key=s' => \$key, 
'num' => \$num,
'reverse' => \$reverse, 
'unique' => \$unique, 
'month-sort' => \$month_sort)
or die ("Please read options");	
my @args;
chomp(@args=<STDIN>);
die "Nothing to sort " unless @args;
@args = sort @args;

if ($num) 
{
	$a='' unless defined $a;
	$b='' unless defined $b;
	if(looks_like_number($a) && looks_like_number($b))
	{
		@args = sort{ $a <=> $b }@args;
	}
	else
	{
    	@args=sort{$a cmp $b}@args;
	}
} 
elsif($month_sort)
{
	@args=sort{monthssort($a,$b)}@args;
}
if ($reverse) 
{
	@args = reverse @args;
}
if ($unique) 
{
	my %already;
	@args = grep {!$already{$_}++} @args;
}
if($key)
{
	my @args = sort { (split(/\s+/, $b))[$_] <=> (split(/\s+/, $a))[$_] } @args;
}

sub monthssort 
{
	my ($a, $b) = @_;
	# Хешики месяцев (с их весами)
	my %months = qw(JAN 0 FEB 1 MAR 2 APR 3 MAY 4 JUN 5 JUL 6 AUG 7 SEP 8 OCT 9 NOV 10 DEC 11);
	$a = join " ", split " ", $a;
	$b = join " ", split " ", $b;
	my $monA = uc(substr($a,0,3));
	my $monB = uc(substr($b,0,3));
	if (exists $months{$monA} and exists $months{$monB})
	{
		return $months{$monA} <=> $months{$monB};
	}
	elsif (exists $months{$monA})
	{
		return -1;
	}
	elsif (exists $months{$monB})
	{
		return 1;
	}
	return $a cmp $b;
}
	p @args; 
