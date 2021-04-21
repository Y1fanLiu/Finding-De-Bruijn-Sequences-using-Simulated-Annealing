# Finding-De-Bruijn-Sequences-using-Simulated-Annealing
Finding De Bruijn Sequences using Simulated Annealing

For details refer to project report pdf file.

For demonstration purposes the stripped down MATLAB code is for De Bruijn Sequences with alphabet size 6 and order 3. 
It takes around 6 min to run on my 13" Macbook pro 2015 base model and gives out an Energy plot hopefully reaching E=0.

The number of distinct de Bruijn sequence solutions equals to ((k!)^(k^(n-1)))/(k^n) where k is the size of the alphabet and n is the order. 
According to this formula then there will be about 3.38E100 distinct solutions when k=6 and n=3 as in the report and if we do a quick calculation of how many combinations there are to construct a starting state as in the report. The number would be (218!)/((218-72)!) removing the cyclic features by dividing this number by 72 we get 5.6E160 combinations, this compared to 3.38E100 solutions I think it is pretty good for being able to reach the solution.
