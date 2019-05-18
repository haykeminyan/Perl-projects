package Anagram;

binmode(STDIN,':utf8');
binmode(STDOUT, ':utf8');
use 5.016;
use warnings;
use strict;
use warnings;
use utf8;
use List::Util;
sub anagram {
	my $words_list = shift;
	my %result;
	my $uniqueSort;
	my %curCount;
    #приведём к нижнему регистру слова из разыменованного
	#ссылки на массив
	$_ = lc for @$words_list;
	my @unique = do { my %seen; grep { !$seen{$_}++ } @$words_list };
  
    for my $i (@unique) 
	{
      $uniqueSort = join "", sort (split //, $i);
      unless($curCount{$uniqueSort})
	   {
        $curCount{$uniqueSort} = $i;
        $result{$i} = [$i];
       } 
	   else 
	   {
        push @{$result{$curCount{$uniqueSort}}}, $i;
       }
    }

    for (keys %result) 
	{
      if (@{$result{$_}} == 1) 
	  {
        delete $result{$_};
      }
    }

    return \%result;
}
1;
