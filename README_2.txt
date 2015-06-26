patternsearch.py
-----------------
This program takes in two files. One is an input file and another the patterns file. The words in the patterns file are searched within the lines of the input file.

To run the program make sure the numpy module is available.
On Windows platform, it should be in Python\Lib\site-packages folder.
Here is where you can get the numpy module.
http://sourceforge.net/projects/numpy/files/

To run the program on Unix or Windows platform type
python patternsearch.py inputfile patternsfile

--------------------------------------
Implementation:
Mode1 output asked for is obtained by simply comparing the search pattern with every line in the input file. If they are exactly equal that line is thrown as the output. 'Equal to' operator is used.

To obtain the Mode2 output 're' module in python is used. So every search pattern is searched within lines in the input file. if the search pattern is found anywhere in the line, that line is thrown as the output.

To obtain the Mode3 output 'Levenshein Distance' method was used. This is based on dynamic programming concept. Even Needleman Wunsch Algorithm could have been used but since here it is simply calculating the distance, simple levenshein distance is used. Those lines which have words with edit distance <=1 to the search pattern word, are thrown as output.

Looking at very well written Lenshein distance algorithm here http://www.merriampark.com/ld.htm, I wrote a function to get the edit distance given two search strings.
