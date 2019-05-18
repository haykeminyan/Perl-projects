package List::Util;
use 5.020;
use warnings;
use utf8;
use POSIX;
use Getopt::Long;
#use Scalar::Util qw(looks_like_number);
use List::Util;
# Получаем ключи и параметры
my $f_list;
my $TAB = "\t";
my $flag_s;	
GetOptions (
	'f=s' => \$f_list,	# -f - fields - выбрать колонки
	'd=s' => \$TAB,		# -d - delimeter - использовать другой разделитель 
	's' => \$flag_s,	# -s - separated - только строки с разделителем	
)or print STDERR "cut: you should read README.md" and exit(1);
print STDERR "cut: the delimiter must be a single character" and exit(1) if length($TAB) != 1;	
print STDERR "cut: you must specify a list of fields" and exit(1) unless defined $f_list;
#print STDERR "cut: the delimiter must be a single character" and exit(1) if ($TAB eq "");
print STDERR  "cut: invalid field value '$f_list'" and exit(1) if ($f_list !~ /^(\d+)?-?(\d+)?$/);				
my ($from, $to) = split(/-/, $f_list); #что и по какому параметру
$from //= 1 ;

$to = $from unless $f_list =~ /-/;
print STDERR "cut: invalid decreasing range" and exit(1) if ($to and $from > $to);
print STDERR 'cut: fields are numbered from 1' and exit(1) if $from <= 0;
my $KK = 1000000;
print STDERR "cut: field number '$f_list' is too large" and exit(1) if $from > $KK or ($to and $to > $KK);
while (<STDIN>)
{
	chomp;
	my @str = split(/$TAB/, $_);#/([^$TAB]+)$TAB?/g;
	my @to_out;
	for ($from..($to // scalar @str)) {#если определено ту то ту иначе скаляр стр
		last unless defined $str[$_-1];
	
		#print STDERR 'cut: fields are numbered from 1' and exit(1) if($f_list<=0);
		#print "$TAB" unless ($f_list[0] == $_);
		push @to_out, $str[$_-1];
	}
	
	print join($TAB, @to_out) . "\n";
}
1;
