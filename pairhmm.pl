#!usr/bin/perl 

use strict;
use Getopt::Long;

my($inputfile,$outfile);

GetOptions('i=s' => \$inputfile,'o=s' => \$outfile);

# Read The two sequences from two fasta format file:
open(INFILE,"$inputfile") || die ("cannot open the file");
my $lines;
while (<INFILE>){
    $lines.=$_;
}
close(INFILE);

#extract the names and the sequences
my @ids = ($lines=~/>(.*)[^>]*/g);
my @sequences = ($lines=~/>.*([^>]*)/g);


# remove newlines, spaces and numbers
my ($sequence1,$sequence2);
my (@sequence1_split,@sequence2_split);
foreach $sequence1($sequences[0]){
    $sequence1 =~s/[\s\d]//g;
    @sequence1_split = split(//,$sequence1);
}
	


foreach $sequence2($sequences[1]){
    $sequence2=~s/[\s\d]//g;
    @sequence2_split = split(//,$sequence2);
}
	

#Smith and Waterman Recursion: Find the score of the optimal alignment
my $sequence1_length = $#sequence1_split+1;
my $sequence2_length = $#sequence2_split+1;

my $infinity = -300000;
my $delta = 0.05;
my $epsilon = 0.5;
my $tou = 0.02;
my $eta = 0.1;
my %Pxy = ();
my (@Score,@Mmat,@Xmat,@Ymat,@pointer,@fM,@fX,@fY) = ();


%Pxy=("AA"=>"0.6","AT"=>"0.2","AC"=>"0.1","AG"=>"0.1","CA"=>"0.05","CC"=>"0.6","CG"=>"0.25","CT"=>"0.1","GA"=>"0.25","GT"=>"0.15","GC"=>"0.2","GG"=>"0.5","TA"=>"0.15","TC"=>"0.25","TT"=>"0.5","TG"=>"0.1");

for (my $firstSeq_index = 0;$firstSeq_index <= $sequence1_length;$firstSeq_index++){
    $Score[$firstSeq_index][0] = 0;
    $Mmat[$firstSeq_index][0] = 0;
    $Xmat[$firstSeq_index][0] = $infinity;
    $Ymat[$firstSeq_index][0] = $infinity;
    $pointer[$firstSeq_index][0] = 0;
    $fM[$firstSeq_index][0] = 0;
    $fX[$firstSeq_index][0] = 0;
    $fY[$firstSeq_index][0] = 0;
}

for (my $secondSeq_index = 0;$secondSeq_index <= $sequence2_length;$secondSeq_index++){
    $Score[0][$secondSeq_index] = 0;
    $Mmat[0][$secondSeq_index] = 0;
    $Xmat[0][$secondSeq_index] = $infinity;
    $Ymat[0][$secondSeq_index] = $infinity;
    $pointer[0][$secondSeq_index] = 0;
    $fM[0][$secondSeq_index] = 0;
    $fX[0][$secondSeq_index] = 0;
    $fY[0][$secondSeq_index] = 0;
}

my @temp_array = ();
my @sorted_array = ();
my $d = -log(($delta*(1 - $epsilon - $tou))/((1 - $eta)*(1 - (2 * $delta) - $tou)));
my $e = -log(($epsilon)/(1 - $eta));
my $const = log(1 - (2 * $delta) - $tou) - log(1 - $epsilon - $tou);	
for (my $i = 1;$i <= $sequence1_length;$i++){
    for(my $j = 1;$j <= $sequence2_length;$j++){
	if ($i == 1 && $j == 1){
	    $Mmat[$i][$j] = -2*log($eta);
	    $Xmat[$i][$j] = $infinity;
	    $Ymat[$i][$j] = $infinity;
	    $fM[$i][$j] = 1;
	    $fX[$i][$j] = 0;
	    $fY[$i][$j] = 0;
	    if ($Mmat[$i][$j] > $Xmat[$i][$j] && $Mmat[$i][$j] > $Ymat[$i][$j]){
		$Score[$i][$j] = $Mmat[$i][$j];
		$pointer[$i][$j] = 1; #trace diagonal
	    } elsif ($Xmat[$i][$j] > $Ymat[$i][$j]){
		$Score[$i][$j] = $Xmat[$i][$j];
		$pointer[$i][$j] = 2;  #trace up
	    } else {
		$Score[$i][$j] = $Ymat[$i][$j];
		$pointer[$i][$j] = 3;  #trace left
	    }
	} else {
	    my $first_seq_nucleotide = $sequence1_split[$i - 1];
	    my $second_seq_nucleotide = $sequence2_split[$j - 1];
	    my $pair = $first_seq_nucleotide.$second_seq_nucleotide;
	    my $sc = log(($Pxy{$pair})/(0.25 * 0.25)) + log ((1 - (2 * $delta) - $tou)/((1 - $eta)**2));
	    my $diag1 = $Mmat[$i - 1][$j - 1];
	    my $diag2 = $Xmat[$i - 1][$j - 1];
	    my $diag3 = $Ymat[$i - 1][$j - 1];
            @temp_array = ($diag1,$diag2,$diag3);
            @sorted_array = sort{$a<=>$b}(@temp_array);
            $Mmat[$i][$j] = $sorted_array[-1];
            $fM[$i][$j] = (($Pxy{$pair}) * (((1 - (2 * $delta) - $tou) * $fM[$i - 1][$j - 1]) + ((1 - $epsilon - $tou) * $fX[$i - 1][$j - 1]) + $fY[$i - 1][$j - 1]));
	    @temp_array = ();
	    @sorted_array = ();
	    my $up1 = $Mmat[$i - 1][$j] - $d;
	    my $up2 = $Xmat[$i - 1][$j] -  $e;
            my @temp_array = ($up1,$up2);
            my @sorted_array = sort{$a<=>$b}(@temp_array);
            $Xmat[$i][$j] = $sorted_array[-1];
            $fX[$i][$j] = ((0.25)*(($delta * $fM[$i - 1][$j]) + ($epsilon * $fX[$i - 1][$j])));
	    @temp_array = ();
	    @sorted_array = ();
	    my $left1 = $Mmat[$i][$j - 1] - $d;
            my $left2 = $Ymat[$i][$j - 1] - $e;
            my @temp_array = ($left1,$left2);
            my @sorted_array = sort{$a<=>$b}(@temp_array);
            $Ymat[$i][$j] = $sorted_array[-1];
            $fY[$i][$j] = ((0.25)*(($delta * $fM[$i][$j - 1]) + ($epsilon * $fY[$i][$j - 1])));
	    @temp_array = ();
	    @sorted_array = ();
            my @temp_array = ($Mmat[$i][$j],$Xmat[$i][$j],$Ymat[$i][$j]);
            my @sorted_array = sort{$a<=>$b}(@temp_array);
            $Score[$i][$j] = $sorted_array[-1];
	    @temp_array = ();
	    @sorted_array = ();
	    if ($Score[$i][$j] == $Mmat[$i][$j]) {
		$pointer[$i][$j] = 1;
	    } elsif($Score[$i][$j] == $Xmat[$i][$j]) {
		$pointer[$i][$j] = 2;
	    } elsif ($Score[$i][$j] == $Ymat[$i][$j]) {
		$pointer[$i][$j] = 3;
	    } else {
		$pointer[$i][$j] = 0;
	    }
	}
    }
}

		
	       
 
$Mmat[$sequence1_length][$sequence2_length] = $Mmat[$sequence1_length][$sequence2_length];
$Xmat[$sequence1_length][$sequence2_length] = $Xmat[$sequence1_length][$sequence2_length] + $const;
$Ymat[$sequence1_length][$sequence2_length] = $Ymat[$sequence1_length][$sequence2_length] + $const ; 

my $fE = ($tou * ($fM[$sequence1_length][$sequence2_length] + $fX[$sequence1_length][$sequence2_length] + $fY[$sequence1_length][$sequence2_length]));

@temp_array = ($Mmat[$sequence1_length][$sequence2_length],$Xmat[$sequence1_length][$sequence2_length],$Ymat[$sequence1_length][$sequence2_length]);
@sorted_array = sort{$a<=>$b}(@temp_array);
my $V = $sorted_array[-1];
if ($V == $Mmat[$sequence1_length][$sequence2_length]){
    $Score[$sequence1_length][$sequence2_length] = $Mmat[$sequence1_length][$sequence2_length];
    $pointer[$sequence1_length][$sequence2_length] = 1;
} elsif ($V == $Xmat[$sequence1_length][$sequence2_length]) {
    $Score[$sequence1_length][$sequence2_length] = $Xmat[$sequence1_length][$sequence2_length];
    $pointer[$sequence1_length][$sequence2_length] = 2;
} else {
    $Score[$sequence1_length][$sequence2_length] = $Ymat[$sequence1_length][$sequence2_length];
    $pointer[$sequence1_length][$sequence2_length] = 3;
}      

my @align1 = qw();
my @align2 = qw();
my @hiddenstates = qw();


###traceback steps
my $ViterbiProb=1;
while ($sequence1_length > 0 and $sequence2_length > 0) {
    if($pointer[$sequence1_length][$sequence2_length] == 1) {
	unshift(@align1,$sequence1_split[$sequence1_length - 1]);
	unshift(@align2,$sequence2_split[$sequence2_length - 1]);
	unshift(@hiddenstates,"M");
	$ViterbiProb = $ViterbiProb * $Pxy{$sequence1_split[$sequence1_length - 1].$sequence2_split[$sequence2_length - 1]};
	$sequence1_length--;
	$sequence2_length--;
    } elsif ($pointer[$sequence1_length][$sequence2_length] == 2){
	unshift(@align1,$sequence1_split[$sequence1_length - 1]);
	unshift(@align2,"-");
	unshift(@hiddenstates,"X");
	$ViterbiProb = $ViterbiProb * 0.25;
	$sequence1_length--;
    } elsif ($pointer[$sequence1_length][$sequence2_length] == 3) {
	unshift(@align1,"-");
	unshift(@align2,$sequence2_split[$sequence2_length - 1]);
	unshift(@hiddenstates,"Y");
	$ViterbiProb = $ViterbiProb * 0.25;
	$sequence2_length--;
    }
}
                 

my $finalsequence_1 = join(//,@align1);
my $finalsequence_2 = join(//,@align2);
my $finalstates = join(//,@hiddenstates);
my $posteriordistribution = $ViterbiProb/$fE;

open(OUTFILE,">$outfile");

print OUTFILE "\n Sequence 1 : $finalsequence_1";
print OUTFILE "\n Sequence 2 : $finalsequence_2";
print OUTFILE "\n HiddenStates : $finalstates";
print OUTFILE "\n Viterbi Probability: $ViterbiProb";
print OUTFILE "\n Forward Algo Probability: $fE";
print OUTFILE "\n Posterior Distribution: $posteriordistribution";

close(OUTFILE);
