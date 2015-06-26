/*
 *  This program reads in a file name and returns the line with maximum number of 
 *  vowels in it. It uses the Provided API.
 */
package org.interview.factual;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class VowelsCheck extends File {

	public static void main (String[] args){
		/*read in the file name from the User*/
		System.out.print("Enter a file name");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
	       String filename = null;
	       try {
	         filename = br.readLine();
	       } catch (IOException e) {
	         System.out.println("error");
	         System.exit(1);
	       }
	       
	    /*find out which line has Most vowels*/
		String line = getLineWithMostVowels(filename);
		System.out.println("The line with Most Vowels is:\n"+line);
		
	}

	private static String getLineWithMostVowels(String fileName) {
		/*opening the file, implemented by the API provided*/
		File abc = open(fileName);
		/*read all the lines into an array, provided by the API*/
		String[] lines = abc.getLines();
		String[] vowels = {"a","e","i","o","u","A","E","I","O","U"};
		/*By using the ArrayList it is easy to calculate the number of vowels in a word by
		 * just checking whether a given alphabet is in the vowel arraylist.
		 */
		ArrayList<String> vowel_arraylist = new ArrayList<String>();
		ArrayList<Integer> vowel_counts = new ArrayList<Integer>();
		//filling the vowel_arraylist with vowels
		for (int v = 0;v < vowels.length; v++){
			vowel_arraylist.add(vowels[v]);
		}
		//initialize count for vowels
		int count=0;
		/*Loop through every line, split it into words, split the words into alphabets,
		 * check if the alphabet is a vowel. If vowel, increment the count. Finally
		 * put the count of every line into vowel_counts arraylist and then find out the maximum
		 * count. Then by getting the index of the maximum count value, get the particular line
		 * from the lines String array.
		 */
		
		for (int line_index = 0; line_index < lines.length; line_index++){
			String line = lines[line_index];
			String[] words_array = line.split("");
			for (int word_index = 0; word_index < words_array.length; word_index++){
				String[] word = words_array[word_index].split("");
				for (int alphabet_index = 0; alphabet_index < word.length; alphabet_index++){
					String alphabet = word[alphabet_index];
					if (vowel_arraylist.contains(alphabet)){
						count++;
					}
				}
			}
			vowel_counts.add(count);
			count = 0;
		}
		/*find max vowel count value*/
		int max_val = 0;
		for (int i = 0; i < vowel_counts.size();i++){
			int temp_val = vowel_counts.get(i); 
			if (temp_val > max_val){
				max_val = temp_val;
			}
		}
		int index_of_maxval = vowel_counts.indexOf(max_val);
		return (lines[index_of_maxval]);
		
	}

}
