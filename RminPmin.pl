#!/usr/bin/perl -w

use strict;
use warnings;
use List::Util qw(min);

unless($#ARGV==1){
	print "USAGE: perl rmin.pl file.pdb chainID\n";
	exit;
}

my $id = $ARGV[0];
open(IN, $id);
my $chain = $ARGV[1];
my $s1 = 0;
my $s2 = 0;
my $s3 = 0;

my $cx=0;
my $cy=0;
my $cz=0;

my @pdb;
my @new;
my @new1;

while(<IN>){
	my @col = split;
	next unless $col[0] eq 'ATOM' and $col[4] eq $chain;
	push @pdb, [@col[2,3,5,6,7,8]];
}

for (my $i=0;$i<=$#pdb;$i++){
	my($a, $r, $n, $x, $y, $z) = @{$pdb[$i]};
	
	$s1 = $s1+$x;
	$cx++;
	$s2 = $s2+$y;
	$cy++;
	$s3 = $s3+$z;
	$cz++;
}

#Coordinates of COM

my $X = sprintf "%0.3f", $s1/$cx;
my $Y = sprintf "%0.3f", $s2/$cy;
my $Z = sprintf "%0.3f", $s3/$cz;

#distance of every Residue from COM.

for my $j(0..$#pdb){
	my($a1, $r1, $n1, $x1, $y1, $z1) = @{$pdb[$j]};
	if($a1 eq 'CA'){
	my $dist = sprintf "%0.3f", sqrt(($X-$x1)**2 + ($Y-$y1)**2 + ($Z-$z1)**2);
	push(@new, "$dist\n");
	push(@new1, "$n1\t$dist\n");
	}
}

my $size = @new;
my @disto;

foreach my $line(@new){
	chomp $line;
	push(@disto, $line);
}

my $min_dist = min @disto;			#distance close to COM, starting from N-terminal
my $n_term = min @disto[0..9];			#distance close to COM from N-terminal(1..10)
my $c_term = min @disto[-10..-1];		#distance close to COM from C-terminal(n-10..n), n->length of protein
my $rmin = sprintf "%0.3f", $c_term/$n_term;	# Rmin = Cmin/Nmin

my $posi;
my $pmin;

foreach my $line1(@new1){
	if(substr($line1, 3, 7) == $min_dist){
		$posi = substr($line1, 0,3);		#Residue position closest to COM
		$pmin = sprintf "%0.3f", $posi/$size;	# Pmin = position/n, n-> length of protein
	}
}
print "\nNumber of residues: $size\n\n";
print "Distance of closest residue in first 10 N-terminal residues to COM: $n_term\n\n";
print "Distance of closest residue in first 10 C-terminal residues to COM: $c_term\n\n";
print "Ratio of minimum distances of near-terminal segments to the centroid (Rmin): $rmin\n\n";
print "Length until closest to the centroid(starting from N-terminal): $posi\n\n";
print "Proportion of length until closest to the centroid(Pmin): $pmin\n\n";

#End of program
