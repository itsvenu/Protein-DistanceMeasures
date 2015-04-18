#### RminPmin
A simple but powerful way of finding the traces of protein cotranslational folding from the determined strcutures
is computing 'Ratio of minimum distances of near terminal segments to the centroid (Rmin)' and 'Proportion of length
until closest to the centroid'.

Rmin = Cmin/Nmin

       Nmin = min{d(Ri, C):i=1..10}
       
       Cmin = min{d(Ri, C):i=n-10..n}
       
       C - Centroid of protein
       
       n - length of protein
  
Pmin = i/n

        i - residue postion closest to the centroid, starting from N-terminal
        n - Total number of residues

Under CT folding Rmin and Pmin values must be >1 and <0.5 respectively.
