% 3-coloring of a cycle graph C_n with two fixed chord edges.
#const n=10.
node(1..n).
edge(I, I+1) :- I=1..n-1.
edge(n, 1).
edge(1, 4).
edge(2, 5).
1 { color(V, 1); color(V, 2); color(V, 3) } 1 :- node(V).
:- edge(X,Y), color(X,K), color(Y,K).
