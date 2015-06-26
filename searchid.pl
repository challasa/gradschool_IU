#!/usr/local/bin/perl -w

#This program looks for a particular id in a given inputfile and returns the sequences belonging to that id
# to use the program:
#           perl searchid.pl -i inputfile -s search_term
#-----------------------------------------------------------------
use strict;
use Getopt::Long;

my ($inputfile,$searchstring,$lines);
GetOptions('i=s' => \$inputfile, 'searchid=s' => \$searchstring);

my @outputseq = &fetch_sequence($inputfile,$searchstring);

foreach(@outputseq){
    print $_;
}

sub fetch_sequence {
    my ($searchfile,$searchid)= @_ ;
    my @returnarray=qw();

    open(INFILE,"$inputfile") || die "cannot open the input file";

    while (<INFILE>){

	$lines.=$_;
    }

    close(INFILE);

    my @ids=($lines=~/>(.*)[^>]*/g);
    my @seq=($lines=~/>.*([^>]*)/g);

    my $numofids = @ids;

    for(my $i=0;$i<$numofids;$i++){

	if($ids[$i]=~/$searchstring/){
	    push(@returnarray,">$ids[$i]");
	    push(@returnarray,"$seq[$i]");
	}
    }

    return @returnarray;
}



