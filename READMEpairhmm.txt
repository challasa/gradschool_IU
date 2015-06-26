To run this program:
-------------------
perl pairhmm.pl -i inputfile -o outputfile

Three hidden states in the pairhmm are M(match or mismatch state), X(gap in sequence 1), Y(gap in sequence 2)

Parameters used:
---------------
delta=transition proabability from M state to X or Y. This was taken as 0.05
epsilon=trnsition probability from state X to state X or from state Y to state Y. This was taken as 0.5
tou=transition probability from state M or X or Y or Begin to the end state. This was taken as 0.02
eta=taken as 0.1

Emission probabilities were taken arbitrarily. They were chosen in such a way that emissions of AA or GG or CC TT were taken high in value.
Others are chosen in such a way that that AA+AT+AG+AC add up to 1. Similarly with all the combinations of C,T,G.

The dynamic program was implemented as given in the algorithm in the Durbin's book. 
Viterbi probability was calculated by multiplying all the probabilities of each alignment obtained.
Forward probability which is the probability of all the alignments possible was calculated.
The ratio of the viterbi and forward alignments was calculated to give the posterior distibution or rather the accuracy of the alignment obtained.