% n-queens, N=8. Place N queens on N×N board so none attack.
#const n=8.
row(1..n).
1 { q(R,1..n) } 1 :- row(R).
:- q(R1,C), q(R2,C), R1 < R2.
:- q(R1,C1), q(R2,C2), R1 < R2, R1-R2 == C1-C2.
:- q(R1,C1), q(R2,C2), R1 < R2, R1-R2 == C2-C1.
