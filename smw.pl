#!usr/bin/perl 

use Getopt::Std;

%options=();
getopts("mfgeo",\%options);

$options{'m'}=$ARGV[0];
$options{'f'}=$ARGV[2];
$options{'g'}=$ARGV[4];
$options{'e'}=$ARGV[6];
$options{'o'}=$ARGV[8];
$gap=$options{g};
$ext=$options{e};
$Mat=$options{m};

# Read The two sequences from two fasta format file:
open(MYFILE,$options{f});
while (<MYFILE>){
    $v.=$_;
}
close MYFILE;

#extract the names and the sequences
@id=($v=~/>(.*)[^>]*/g);
@seq =($v=~/>.*([^>]*)/g);


# get rid of the newlines, spaces and numbers
foreach $s1($seq[0]){
    $s1=~s/[\s\d]//g;
    @seq1=split(//,$s1);
}


foreach $s2($seq[1]) {
    $s2=~s/[\s\d]//g;
    @seq2=split(//,$s2);
}
open(OUTFILE,">$options{o}");

#PAM250 and BLOSUM62
@Hor=qw(A R N D C Q E G H I L K M F P S T W Y V B J Z);
@Ver=qw(A R N D C Q E G H I L K M F P S T W Y V B J Z);

@PAM1=qw(2 -2 0 0 -2 0 0 1 -1 -1 -2 -1 -1 -3 1 1 1 -6 -3 0 0 -1 0);
@PAM2=qw(-2 6 0 -1 -4 1 -1 -3 2 -2 -3 3 0 -4 0 0 -1 2 -4 -2 -1 -3 0);
@PAM3=qw(0 0 2 2 -4 1 1 0 2 -2 -3 1 -2 -3 0 1 0 -4 -2 -2 2 -3 1);
@PAM4=qw(0 -1 2 4 -5 2 3 1 1 -2 -4 0 -3 -6 -1 0 0 -7 -4 -2 3 -3 3);
@PAM5=qw(-2 -4 -4 -5 12 -5 -5 -3 -3 -2 -6 -5 -5 -4 -3 0 -2 -8 0 -2 -4 -5 -5);
@PAM6=qw(0 1 1 2 -5 4 2 -1 3 -2 -2 1 -1 -5 0 -1 -1 -5 -4 -2 1 -2 3);
@PAM7=qw(0 -1 1 3 -5 2 4 0 1 -2 -3 0 -2 -5 -1 0 0 -7 -4 -2 3 -3 3);
@PAM8=qw(1 -3 0 1 -3 -1 0 5 -2 -3 -4 -2 -3 -5 0 1 0 -7 -5 -1 0 -4 0);
@PAM9=qw(-1 2 2 1 -3 3 1 -2 6 -2 -2 0 -2 -2 0 -1 -1 -3 0 -2 1 -2 2);
@PAM10=qw(-1 -2 -2 -2 -2 -2 -2 -3 -2 5 2 -2 2 1 -2 -1 0 -5 -1 4 -2 3 -2);
@PAM11=qw(-2 -3 -3 -4 -6 -2 -3 -4 -2 2 6 -3 4 2 -3 -3 -2 -2 -1 2 -3 5 -3);
@PAM12=qw(-1 3 1 0 -5 1 0 -2 0 -2 -3 5 0 -5 -1 0 0 -3 -4 -2 1 -3 0);
@PAM13=qw(-1 0 -2 -3 -5 -1 -2 -3 -2 2 4 0 6 0 -2 -2 -1 -4 -2 2 -2 3 -2);
@PAM14=qw(-3 -4 -3 -6 -4 -5 -5 -5 -2 1 2 -5 0 9 -5 -3 -3 0 7 -1 -4 2 -5);
@PAM15=qw(1 0 0 -1 -3 0 -1 0 0 -2 -3 -1 -2 -5 6 1 0 -6 -5 -1 -1 -2 0);
@PAM16=qw(1 0 1 0 0 -1 0 1 -1 -1 -3 0 -2 -3 1 2 1 -2 -3 -1 0 -2 0);
@PAM17=qw(1 -1 0 0 -2 -1 0 0 -1 0 -2 0 -1 -3 0 1 3 -5 -3 0 0 -1 -1);
@PAM18=qw(-6 2 -4 -7 -8 -5 -7 -7 -3 -5 -2 -3 -4 0 -6 -2 -5 17 0 -6 -5 -3 -6);
@PAM19=qw(-3 -4 -2 -4 0 -4 -4 -5 0 -1 -1 -4 -2 7 -5 -3 -3 0 10 -2 -3 -1 -4);
@PAM20=qw(0 -2 -2 -2 -2 -2 -2 -1 -2 4 2 -2 2 -1 -1 -1 0 -6 -2 4 -2 2 -2);
@PAM21=qw(0 -1 2 3 -4 1 3 0 1 -2 -3 1 -2 -4 -1 0 0 -5 -3 -2 3 -3 2);
@PAM22=qw(-1 -3 -3 -3 -5 -2 -3 -4 -2 3 5 -3 3 2 -2 -2 -1 -3 -1 2 -3 5 -2);
@PAM23=qw(0 0 1 3 -5 3 3 0 2 -2 -3 0 -2 -5 0 0 -1 -6 -4 -2 2 -2 3);

@PAM250=(\@PAM1,\@PAM2,\@PAM3,\@PAM4,\@PAM5,\@PAM6,\@PAM7,\@PAM8,\@PAM9,\@PAM10,\@PAM11,\@PAM12,\@PAM13,\@PAM14,\@PAM15,\@PAM16,\@PAM17,\@PAM18,\@PAM19,\@PAM20,\@PAM21,\@PAM22,\@PAM23);

#BLOSUM62

@BLO1=qw(4 -1 -2 -2 0 -1 -1 0 -2 -1 -1 -1 -1 -2 -1 1 0 -3 -2 0 -2 -1 -1);
@BLO2=qw(-1 5 0 -2 -3 1 0 -2 0 -3 -2 2 -1 -3 -2 -1 -1 -3 -2 -3 -1 -2  0);
@BLO3=qw(-2 0 6 1 -3 0 0 0 1 -3 -3 0 -2 -3 -2 1 0 -4 -2 -3 4 -3 0);
@BLO4=qw(-2 -2 1 6 -3 0 2 -1 -1 -3 -4 -1 -3 -3 -1 0 -1 -4 -3 -3 4 -3 1);
@BLO5=qw(0 -3 -3 -3 9 -3 -4 -3 -3 -1 -1 -3 -1 -2 -3 -1 -1 -2 -2 -1 -3 -1 -3);
@BLO6=qw(-1 1 0 0 -3 5 2 -2 0 -3 -2 1 0 -3 -1 0 -1 -2 -1 -2  0 -2 4);
@BLO7=qw(-1 0 0 2 -4 2 5 -2 0 -3 -3 1 -2 -3 -1 0 -1 -3 -2 -2 1 -3 4);
@BLO8=qw(0 -2 0 -1 -3 -2 -2 6 -2 -4 -4 -2 -3 -3 -2 0 -2 -2 -3 -3 -1 -4 -2);
@BLO9=qw(-2 0 1 -1 -3 0 0 -2 8 -3 -3 -1 -2 -1 -2 -1 -2 -2 2 -3 0 -3 0);
@BLO10=qw(-1 -3 -3 -3 -1 -3 -3 -4 -3 4 2 -3 1 0 -3 -2 -1 -3 -1 3 -3 3 -3);
@BLO11=qw(-1 -2 -3 -4 -1 -2 -3 -4 -3 2 4 -2 2 0 -3 -2 -1 -2 -1 1 -4 3 -3);
@BLO12=qw(-1 2 0 -1 -3 1 1 -2 -1 -3 -2 5 -1 -3 -1 0 -1 -3 -2 -2 0 -3 1);
@BLO13=qw(-1 -1 -2 -3 -1 0 -2 -3 -2 1 2 -1 5 0 -2 -1 -1 -1 -1 1 -3 2 -1);
@BLO14=qw(-2 -3 -3 -3 -2 -3 -3 -3 -1 0 0 -3 0 6 -4 -2 -2 1 3 -1 -3 0 -3);
@BLO15=qw(-1 -2 -2 -1 -3 -1 -1 -2 -2 -3 -3 -1 -2 -4 7 -1 -1 -4 -3 -2 -2 -3 -1);
@BLO16=qw(1 -1 1 0 -1 0 0 0 -1 -2 -2 0 -1 -2 -1 4 1 -3 -2 -2 0 -2 0);
@BLO17=qw(0 -1 0 -1 -1 -1 -1 -2 -2 -1 -1 -1 -1 -2 -1 1 5 -2 -2 0 -1 -1 -1);
@BLO18=qw(-3 -3 -4 -4 -2 -2 -3 -2 -2 -3 -2 -3 -1 1 -4 -3 -2 11 2 -3 -4 -2 -2);
@BLO19=qw(-2 -2 -2 -3 -2 -1 -2 -3 2 -1 -1 -2 -1 3 -3 -2 -2 2 7 -1 -3 -1 -2);
@BLO20=qw(0 -3 -3 -3 -1 -2 -2 -3 -3 3 1 -2 1 -1 -2 -2 0 -3 -1 4 -3 2 -2);
@BLO21=qw(-2 -1 4 4 -3 0 1 -1 0 -3 -4 0 -3 -3 -2 0 -1 -4 -3 -3 4 -3 0);
@BLO22=qw(-1 -2 -3 -3 -1 -2 -3 -4 -3 3 3 -3 2 0 -3 -2 -1 -2 -1 2 -3 3 -3);
@BLO23=qw(-1 0 0 1 -3 4 4 -2 0 -3 -3 1 -1 -3 -1 0 -1 -2 -2 -2 0 -3 4);
 
@BLO62=(\@BLO1,\@BLO2,\@BLO3,\@BLO4,\@BLO5,\@BLO6,\@BLO7,\@BLO8,\@BLO9,\@BLO10,\@BLO11,\@BLO12,\@BLO13,\@BLO14,\@BLO15,\@BLO16,\@BLO17,\@BLO18,\@BLO19,\@BLO20,\@BLO21,\@BLO22,\@BLO23);


%P250=();

for($i=0;$i<=$#Hor;$i++){
    for($j=0;$j<=$#Ver;$j++){
	$k=$Hor[$i];
	$l=$Ver[$j];
	$cc=$k.$l;
	$P250{$cc}=$PAM250[$i][$j];
    }
}
 
%B62=();

for($i=0;$i<=$#Hor;$i++) {
    for($j=0;$j<=$#Ver;$j++){
	$k=$Hor[$i];
	$l=$Ver[$j];
	$cc=$k.$l;
	$B62{$cc}=$BLO62[$i][$j];
    }
}
 
#SmithWaterman Algorithm
$l1=$#seq1+1;
$l2=$#seq2+1;

#intialization

for ($i=0;$i<=$len0;$i++){
    $SM[$i][0]=0;
    $M[$i][0]=0;
    $lx[$i][0]=0;
    $ly[$i][0]=0;
    $trb[$i][0]=0;
}
for ($j=0;$j<=$len1;$j++){
    $SM[0][$j]=0;
    $M[0][$j]=0;
    $lx[0][$j]=0;
    $ly[0][$j]=0;
    $trb[0][$j]=0;
}
	
for ($i=1;$i<=$l1;$i++){
    for($j=1;$j<=$l2;$j++){
	$x=$seq1[$i-1];
	$y=$seq2[$j-1];
	$kk=$x.$y;
	if($Mat eq "PAM250"){
	    $S=$P250{$kk};
	 }
	if($Mat eq "BLOSUM62"){
	    $S=$B62{$kk};
	}
	$leftupM=$M[$i-1][$j-1]+$S;
	$leftuplx=$lx[$i-1][$j-1]+$S;
	$leftly=$ly[$i-1][$j-1]+$S;
	@d=($leftupM,$leftuplx,$leftuply);
	@d1 =sort {$a<=>$b} (@d);
	$M[$i][$j]=$d1[-1];
	
	$leftM=$M[$i][$j-1]-$gap;
	$leftly=$ly[$i][$j-1]-$ext;
	@left=($leftM,$leftly);
	@left1=sort{$a<=>$b} (@left);
	$ly[$i][$j]=$left1[-1];         


	$upM=$M[$i-1][$j]-$gap;
	$uplx=$lx[$i-1][$j]-$ext;
	@up=($upM,$uplx);
	@up1=sort{$a<=>$b}(@up);
	$lx[$i][$j]=$up1[-1];

	@max=($M[$i][$j],$lx[$i][$j],$ly[$i][$j]);
	@max1=sort{$a<=>$b}(@max);
	$SM[$i][$j]=$max1[-1];

	if($SM[$i][$j]==$M[$i][$j]){
	    $trb[$i][$j]=1;
	}elsif ($SM[$i][$j]==$ly[$i][$j]) {
	    $trb[$i][$j]=2;
	}elsif ($SM[$i][$j]==$lx[$i][$j]) {
	    $trb[$i][$j]=3;
	} else {
	    $trb[$i][$j]=0;
	}
	if ($SM[$i][$j]> $max_score){
	    $max_score=$SM[$i][$j];
	    $max_i=$i;
	    $max_j=$j;
	}
    }
}

@b1=qw();
@b2=qw();
@ptr=qw();


#traceback steps
while($trb[$max_i][$max_j] != 0) {
    
    if($trb[$max_i][$max_j]==1) {
	unshift(@b1,$seq1[$max_i-1]);
	unshift(@b2,$seq2[$max_j-1]);
	$max_i--;
	$max_j--;
    } elsif ($trb[$max_i][$max_j]==2) {
	unshift(@b1,"-");
	unshift(@b2,$seq2[$max_j-1]);
	$max_j--;
    } elsif ($trb[$max_i][$max_j]==3) {
	unshift(@b1,$seq1[$max_i-1]);
	unshift(@b2,"-");
	$max_i--;
    }
  
}


$score=0;

for($f=0;$f<$#b1+1;$f++){
    if($b1[$f] eq $b2[$f]) {
	$t=$b1[$f];
	$n=$b2[$f];
	$kk=$t.$n;
	if($Mat eq "PAM250") {
	    $score+=$P250{$kk};
	} else {
	    $score+=$B62{$kk};
	}
	$ptr[$f]="|";
    
    } elsif ($b1[$f]eq "-" || $b2[$k]eq "-") {
	$score-=$gap;
	$ptr[$f]=" ";
    } elsif ($b1[$f] ne $b2[$f] && $b1[$f] ne "-" && $b2[$f] ne "-") {
	$t=$b1[$f];
	$n=$b2[$f];
	$kk=$t.$n;
	if($Mat eq "PAM250") {
	    $score+=$P250{$kk};
	} else {
	    $score+=$B62{$kk};
	}
	$ptr[$f]="*";

    }
}


$s1=join(//,@seq1);
$s2=join(//,@seq2);
$aln1=join(//,@b1);
$aln2=join(//,@b2);
$als=join(//,@ptr);
print OUTFILE "<html>
               <title>
		Sequence Alignment
		</title>
		<body>
		<h1>
		Local Sequence Alignment
		Using Smith-Waterman Algorithm</h1>
		<p1>
		 Sequence 1: $s1<br/>
                 Sequence 2: $s2<br/>
		 Score=$score<br/>
		 Sequence 1: $aln1<br/></p1>
		 <p2> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$als</br></p2>
	         <p3>Sequence 2: $aln2</p3>
		 </body></html>";
close OUTFILE ;	

print "\n Sequence 1 :- $s1";
print "\n Sequence 2 :- $s2";
print "\n score=$score";
print "\nSequence1: \t$aln1";
print "\n\t\t$als";
print "\nSequence2: \t$aln2";
#close OUTFILE;


