#!/usr/bin/perl
use strict;
use warnings;

sub retest {
  my ($pattern, $text, $expected) = @_;
  my ($m, $s, $p);
  $m=(($text =~ /$pattern/) ? "T" : "F");
  $p=( ($m eq $expected) ? "PASS" : "FAIL");
  #$s="Pattern: $pattern\tText: $text\tMatch: $m\n";
  $s="$p Match: $m Expected: $expected Pattern: \"$pattern\"\tText: \"$text\"\n";
  print $s;
}

print "Phase 1\n";
retest( '^$', 'a', 'F' );
retest( '^$', '' , 'T' );
retest( 'a', '', 'F' );
retest( 'a', 'a', 'T' );
retest( 'ab', 'ab', 'T' );
retest( 'a|b', 'a', 'T' );
retest( 'a|b', 'b' , 'T');
retest( 'a*', '' , 'T' );
retest( 'a*', 'a', 'T' );
retest( 'a*', 'aa', 'T' );
retest( '\|', '|', 'T' );
retest( '\*', '*', 'T' );

print "\n";
print "Phase 2\n";
retest( '[wxy]', 'w' , 'T');
retest( '[wxy]', 'x', 'T' );
retest( '[wxy]', 'y' , 'T');
retest( '[wxy]', 'z', 'F');
retest( '\[wxy\]', '[wxy]', 'T' );
retest( '[^wxy]', 'a', 'T' );
retest( '[^wxy]', 'w', 'F' );
retest( '[^wxy]', 'x', 'F' );
retest( '[^wxy]', 'y', 'F' );
retest( '[]]', ']' , 'T');
retest( '[]]]', ']]', 'T' );
retest( '[][]', '[' , 'T');
retest( '[][]', ']', 'T' );
retest( '[[]]', '[]' , 'T');
retest( ']', ']' , 'T');
retest( 'a+', '' , 'F');
retest( 'a+', 'a', 'T' );
retest( 'a+', 'aa' ,'T');
retest( '\+', '+' ,'T');
retest( '^a{0,0}$', '','T' );
retest( '^a{0,0}$', 'a','F' );
retest( 'a{0,1}', '','T' );
retest( 'a{0,1}', 'a','T' );
retest( '^a{0,1}$', 'b','F' );
retest( 'a{2,4}', '','F' );
retest( 'a{2,4}', 'a','F' );
retest( 'a{2,4}', 'aa','T' );
retest( 'a{2,4}', 'aaa','T' );
retest( 'a{2,4}', 'aaaa','T' );
retest( 'a{2,4}', 'aaaab','T' );
retest( '^[0-2]$', '0', 'T' );
retest( '^[0-2]$', '1', 'T' );
retest( '^[0-2]$', '2', 'T' );
retest( '^[0-2]$', '3', 'F' );
retest( '^.$', '`', 'T' );
retest( '^\s$', ' ', 'T' );
retest( '^\s$', 'q', 'F' );
