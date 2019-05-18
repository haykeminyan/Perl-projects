use 5.028;
use warnings;
use utf8;
use Getopt::Long;
use Encode qw(decode_utf8);
use Array::Utils qw(:all);
use DDP;
Getopt::Long::Configure("bundling");

my $pattern;
my $param_A;
my $param_B;
my $param_C;
my $flag_F;
my $flag_c;
my $flag_i;
my $flag_n;
my $flag_v;
my $unique;
my @res;

GetOptions(
    'A=s' => \$param_A,
    'B=s' => \$param_B,
    'C=s' => \$param_C,
    'c'   => \$flag_c,
    'i'   => \$flag_i,
    'v'   => \$flag_v,
    'F'   => \$flag_F,
    'n'   => \$flag_n
) or print STDERR "please read README.md" and exit(1);

$pattern = decode_utf8( $ARGV[0] );
print STDERR and exit(1) unless $pattern;

if ( $param_C ne '' ) {
    die
"$param_C: Неверный аргумент длины контекста"
      if ( $param_C < 0 );
}
if ( $param_B ne '' ) {
    die
"$param_B: Неверный аргумент длины контекста"
      if ( $param_B < 0 );
}
if ( $param_A ne '' ) {
    die
"$param_A: Неверный аргумент длины контекста"
      if ( $param_A < 0 );
}

sub func    #inizialization
{
    my @arr;
    while (<STDIN>) {
        chomp $_;
        push @arr, $_;
    }
    return \@arr;    #со ссылками удобнее
}

sub calc {
    my $arr = shift;
    for my $i ( 0 .. ( scalar @$arr - 1 ) ) {
        if ($flag_i) {
            my $p = fc($pattern);
            if ( fc( $arr->[$i] ) =~ /$p/ ) {
                push @res, $i;
            }
        }
        elsif ($flag_F) {
            if ( $arr->[$i] eq $pattern ) {
                push @res, $i;
            }
        }
        elsif ($flag_v) {
            if ( $arr->[$i] !~ /$pattern/ ) {
                push @res, $i;
            }
        }
        else {
            if ( $arr->[$i] =~ /$pattern/ ) {
                push @res, $i;
            }
        }
    }
}

sub func_A(@) {
    my $arr = shift;
    if ($param_A) {
        for my $i (@res) {    #обработанные элементы
            for my $j ( 0 .. $param_A ) {
                my $chet = ( $i + $j );
                $unique->{$chet} = $chet if ( $chet < scalar @$arr );
            }
        }
    }
}

sub func_B(@) {
    my $arr = shift;
    if ($param_B) {
        for my $i (@res) {
            for my $j ( 0 .. $param_B ) {
                my $chet = ( $i - $j );
                $unique->{$chet} = $chet if ( $chet >= 0 );
            }
        }
    }
}

sub func_C () {
    $param_A = $param_C;
    $param_B = $param_C;
}

sub vivod (@) {
    my ($arr) = @_;
    @vivod = keys %$unique if ( keys %$unique );
    @vivod = sort { $a <=> $b } @vivod;
    if ($flag_n) {
        for my $j ( 0 .. ( scalar @vivod - 1 ) ) {
            say( $vivod [$j] + 1 );
        }
        return 0;
    }
    for my $i (@vivod) {
        say join " ", $arr->[$i];
    }
}

my $arr = func();
calc($arr);    #найти паттерн
if ($param_C) {
    func_C();
}

if ( $param_A or $param_B ) {
    func_A($arr);
}

if ($flag_c) {
    print scalar @res . "\n";
}
else {
    vivod($arr);
}
