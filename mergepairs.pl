#!/usr/local/bin/perl -w
#This program looks for pairs like say AFGCB5a,AFGCB5b, merges their sequences and writes the new merged sequence into a file. 
#Also it calculates the linkage position (Eg: length of AFGCB5a_sequence + 1)
#As it reads through the input file, it looks for pairs like above. The linker position and length of the merged sequence are appended to the title in the output file.
#----------------------------------------------------------------------------------------------------------------------------------------------------
#To run this program:
#                   perl mergepairs.pl -i inputfile -o outputfile
#----------------------------------------------------------------------------------------------------------------------------------------------------
use strict;
use Getopt::Long;

my ($inputfile,$outputfile);
my $lines = "";
GetOptions('i=s' => \$inputfile, 'o=s' => \$outputfile);
#open input file
#---------------
open(INFILE,"$inputfile")|| die "Cannot open the file";

while (<INFILE>){
      
   $lines.=$_;
}

close(INFILE);

#print "$lines";
#get ids and sequences into two different arrays
#---------------------------------------------
my @ids=($lines=~/>(.*)[^>]*/g);
my @seq=($lines=~/>.*([^>]*)/g);

#get only the ids into  one array by splitting the id line
#--------------------------------------------------------------------------------------------------------
my @idline_split = qw();
my $idline = "";
my @only_ids=qw();

foreach $idline (@ids){

    @idline_split=split(/ /,$idline);
    push(@only_ids,$idline_split[0]);
}

#merge pairs and write into a file.
#Once only the ids are put into an array, here below I am looping through that array by taking 2 ids at a time, i.e. by reading i, i+1 indexed elements.
#Once the i, i+1 indexed elements are obtained, I check if they are the same. If same, then merge them and then go for i+2,i+3. If not same, take i+1,i+2 and then compare.
#Thus by looping through the ids array, the pairs are merged.
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
my $length_IDsArray = @only_ids;
my ($i,$j,$first,$second,$linker_start,$last_var1,$last_var2);
my $count = 0;
open(OUTFILE,">$outputfile");

for(my $i=0;$i<$length_IDsArray;$i+=2){
   $j=$i+1;
   $first=$only_ids[$i];
   chomp($first);
   my @temp1=split(//,$first);
   $seq[$i]=~s/\n//;
   chomp($seq[$i]);
   $linker_start=length($seq[$i]) + 1;
   if($j==$length_IDsArray){
       print OUTFILE (">".$first." ".$linker_start."\n");
       print OUTFILE ($seq[$i]."\n");
       last;
   }
   $second=$only_ids[$j];
   chomp($second);
   my @temp2=split(//,$second);
   $last_var1=$temp1[$#temp1];
   $last_var2=$temp2[$#temp2];
   $seq[$j]=~s/\n//;
   chomp($seq[$j]);
   if($last_var1 eq "a"){
       chop($first);chop($second);
       if($first eq $second){
	   my $combined_sequence = $seq[$i].$seq[$j];
	   my $length_of_combined_sequence = length($combined_sequence);
	   print OUTFILE (">".$first.":".$linker_start.":".$length_of_combined_sequence."\n");
	   print OUTFILE ($combined_sequence."\n");
	   $count++;
       }
   } else {
       
       $i=$i-1;
       
   }
   
   $linker_start=0;
}
close(OUTFILE);

print "$count\n";
