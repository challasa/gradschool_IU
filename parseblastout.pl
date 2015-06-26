#!/usr/local/bin/perl -w
#This program parses the blast output in tabular format.
# In the case of olfactory receptor analysis 
#   perl parseblastout.pl -q junco_assembly.fna -b chicken_junco_olfr_tblastxoutput -o junco_olfr_chicken.fasta
#-----------------------------------------------------------------------------------------------------------------
use strict;
use Getopt::Long;

my($blastoutputfile,$line,$query_file,$output_file);
my @sequences = qw();
my $seq="";
my %id_sequence=();
GetOptions('q=s' => \$query_file,'b=s' => \$blastoutputfile,'o=s' => \$output_file);
#get ids and sequences into hash
#----------------------------------
open(QUERYFILE,"$query_file") || die "cannot open the file";
my $temp;
while (<QUERYFILE>){
    $line=$_;
    if ($line=~/^>/){
        if ($seq){
            push(@sequences,$seq);
            $id_sequence{$temp}=$seq;
            $seq="";
        }
        chomp($line);
        my @split_idline = split(" ",$line);
        $temp = substr($split_idline[0],1);
    } else {
        chomp($line);
        $seq.=$line;
    }
}

$id_sequence{$temp}=$seq;
close(QUERYFILE);

#print $id_sequence{"g00093t00001"};

#open blastoutput file and look for hits
#---------------------------------------
open(BLASTOUTPUTFILE,"$blastoutputfile") || die "cannot open the blast output file";

open(OUTFILE,">$output_file");
#create a file to write all the unique ids of chicken or zebrafinch from blastoutput
open(SUBJECTIDS,">subjectids.txt");
my $blastout_line;
my $query_id;
my $temp_var2 = "";
my $temp_var1 = "";
my $query_start = 0;
my $subject_id;
my @subjectids;
my @temp_array1;
my $alignment_length = 0;
my $cnt = 0;
my ($query_end,$query_sequence,$extracted_query_sequence);
my @split_blastout_line = qw();
while (<BLASTOUTPUTFILE>){
    #$blastout_line=$_;
    @split_blastout_line = split(/\t/,$_);
    $query_id = $split_blastout_line[0];
    $subject_id = $split_blastout_line[1];
    @temp_array1 = split(/\|/,$subject_id);
    push (@subjectids,$temp_array1[0]);
    if ($query_id ne $temp_var2){
	$temp_var2 = $split_blastout_line[0];
	$cnt = $cnt+1;
	$query_sequence = $id_sequence{$temp_var2};

	print OUTFILE (">".$temp_var2." ".$split_blastout_line[6]." ".$split_blastout_line[7]."\n");
        print OUTFILE ($query_sequence."\n");
    }
=head
    if(($split_blastout_line[0] ne $query_id) && ($split_blastout_line[6]!=$query_start) && ($split_blastout_line[3]!=$alignment_length)){
	$query_id = $split_blastout_line[0];
	$query_start = $split_blastout_line[6];
	$query_end = $split_blastout_line[7];
	$alignment_length = $split_blastout_line[3];
	$query_sequence = $id_sequence{$query_id};
	#$extracted_query_sequence = substr($query_sequence,$query_start-1,$alignment_length);
    
	print OUTFILE (">".$query_id." ".$query_start." ".$query_end."\n");
	print OUTFILE ($query_sequence."\n");
    } else {
	$query_id = $split_blastout_line[0];
	$query_start = $split_blastout_line[6];
	$alignment_length = $split_blastout_line[3];
    }
=cut        
}
#print (@subjectids);

# this part of the script writes the unique ids of the subject or database (here chicken or zebrafinch) into subjectids.txt file
my %temp_hash = ();
my @array2 = ();
foreach my $subjectid (@subjectids){
    unless ($temp_hash{$subjectid}){
	push (@array2,$subjectid);
	$temp_hash{$subjectid}=1;
	print SUBJECTIDS ($subjectid."\n");
    }
}


#print "junco unique ids count is $cnt\n";
close(BLASTOUTPUTFILE);
close(OUTFILE);
    

    
