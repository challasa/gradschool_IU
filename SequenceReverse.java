/*
 *This program reverses the sequence in a given Fasta format file
 *and writes the reversed sequences into the given output file.
 *It takes in the input file and output file as arguments
 * To run the program:
 *    in Unix from commandline: java SequenceReverse inputfile outputfile
 */
//package org.fasta.reverse;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;


public class SequenceReverse {
    
    public static void main(String[] args) {
	//check if all the arguments required are provided
	if(args.length>1){
	    try {
		/*Read the contents from the input file provided*/
		BufferedReader infile = new BufferedReader(new FileReader(args[0]));
		/*create the outputfile and create a writer handle to write the reversed sequences into the output file*/
		File outputfile = new File(args[1]);
                Writer outputwriter = new BufferedWriter(new FileWriter(outputfile));
		String line;
		String title = "";
		String sequence = "";
		String reverse_of_sequence;
		while ((line = infile.readLine())!=null){
		    /*
		     *check if the line starts with ">", if so its title, else its sequence
		     *if its not title line append the sequence line to previous sequence line
		     *do this until a new line with ">" is found. If found just reverse whatever has been read and
		     *write that into a file
		     */
		    if (line.startsWith(">")){
			if(sequence.length()> 1){
			    outputwriter.write(title + "_REVERSE\n");
			    reverse_of_sequence = reverseSequence(sequence);
			    outputwriter.write(reverse_of_sequence + "\n");
			    sequence = "";
			    //reverse_of_sequence = "";
			}
			title = line.replaceAll("\\n","");
		    
		    } else {
			line.replaceAll("\\n","");
			sequence+= line;
		    }
		}
		//finish writing the last title and sequence that is read as well
		outputwriter.write(title + "_REVERSE\n");
		reverse_of_sequence = reverseSequence(sequence);
		outputwriter.write(reverse_of_sequence + "\n");
		infile.close();
		outputwriter.close();
	    
	    } catch (FileNotFoundException e) {
		e.printStackTrace();
	    } catch (IOException e) {
		e.printStackTrace();
	    }

	} else if(args.length==1){
	    System.out.println("Please provide Outputfile");
	} else {
	    System.out.println("Please provide Input and Output files");
	}
    }

    /*function that takes in the sequence,reverses the sequence and outputs the reverse string*/
    public static String reverseSequence(String inputString){
	String[] temp_array = inputString.split("");
	String reverse_string = "";
	for (int index = temp_array.length - 1; index > 0; index--){
		reverse_string+=temp_array[index];
	}
	return reverse_string;
    }
     
}
