#const horizon=16.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizon, must be defined externally
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time(0..horizon).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Establish initial state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

holds(Variable, Value, 0) :- initialState(Variable, Value).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute derived predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% conjunctive preconditions
satisfied(DerivedPredicate, type(and), T) :- derivedPredicate(DerivedPredicate, type(and)), holds(Variable, Value, T) : precondition(DerivedPredicate, type(and), Variable, Value); time(T).

% disjunctive preconditions
satisfied(DerivedPredicate, type(or), T) :- precondition(DerivedPredicate, type(or), Variable, Value), holds(Variable, Value, T), time(T).

holds(DerivedVariable, Value, T) :- satisfied(DerivedPredicate, Type, T), postcondition(DerivedPredicate, Type, effect(unconditional), DerivedVariable, Value).

holds(derivedVariable(DerivedVariable), value(DerivedVariable, false), T) :- derivedVariable(DerivedVariable), not holds(derivedVariable(DerivedVariable), value(DerivedVariable, true), T), time(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform actions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

0 {occurs(Action, T) : action(Action)} 1 :- time(T), T > 0.

% Check preconditions
:- occurs(Action, T), precondition(Action, Variable, Value), not holds(Variable, Value, T - 1).

% Apply effects
caused(Variable, Value, T) :-
	occurs(Action, T),
	postcondition(Action, Effect, Variable, Value),
	holds(VariablePre, ValuePre, T - 1) : precondition(Effect, VariablePre, ValuePre).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inertia rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

modified(Variable, T) :- caused(Variable, Value, T).

holds(Variable, Value, T) :- caused(Variable, Value, T).
holds(variable(V), Value, T) :- holds(variable(V), Value, T - 1), not modified(variable(V), T), time(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables and mutex groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check that variables have unique values
:- variable(Variable), not 1 {holds(Variable, Value, T) : contains(Variable, Value)} 1, time(T).

% Check mutexes
:- mutexGroup(MutexGroup), not {holds(Variable, Value, T) : contains(MutexGroup, Variable, Value)} 1, time(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verify that goal is met
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- goal(Variable, Value), not holds(Variable, Value, horizon).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shows all 'occurs' atoms.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show occurs/2.% variables
variable(variable(0)).
contains(variable(0), value("holding(a)", true)).
contains(variable(0), value("on(a, b)", true)).
contains(variable(0), value("on(a, c)", true)).
contains(variable(0), value("on(a, d)", true)).
contains(variable(0), value("on(a, e)", true)).
contains(variable(0), value("ontable(a)", true)).

variable(variable(1)).
contains(variable(1), value("clear(a)", true)).
contains(variable(1), value("clear(a)", false)).

variable(variable(2)).
contains(variable(2), value("clear(b)", true)).
contains(variable(2), value("clear(b)", false)).

variable(variable(3)).
contains(variable(3), value("clear(c)", true)).
contains(variable(3), value("clear(c)", false)).

variable(variable(4)).
contains(variable(4), value("clear(d)", true)).
contains(variable(4), value("clear(d)", false)).

variable(variable(5)).
contains(variable(5), value("clear(e)", true)).
contains(variable(5), value("clear(e)", false)).

variable(variable(6)).
contains(variable(6), value("handempty", true)).
contains(variable(6), value("handempty", false)).

variable(variable(7)).
contains(variable(7), value("holding(b)", true)).
contains(variable(7), value("on(b, a)", true)).
contains(variable(7), value("on(b, c)", true)).
contains(variable(7), value("on(b, d)", true)).
contains(variable(7), value("on(b, e)", true)).
contains(variable(7), value("ontable(b)", true)).

variable(variable(8)).
contains(variable(8), value("holding(c)", true)).
contains(variable(8), value("on(c, a)", true)).
contains(variable(8), value("on(c, b)", true)).
contains(variable(8), value("on(c, d)", true)).
contains(variable(8), value("on(c, e)", true)).
contains(variable(8), value("ontable(c)", true)).

variable(variable(9)).
contains(variable(9), value("holding(d)", true)).
contains(variable(9), value("on(d, a)", true)).
contains(variable(9), value("on(d, b)", true)).
contains(variable(9), value("on(d, c)", true)).
contains(variable(9), value("on(d, e)", true)).
contains(variable(9), value("ontable(d)", true)).

variable(variable(10)).
contains(variable(10), value("holding(e)", true)).
contains(variable(10), value("on(e, a)", true)).
contains(variable(10), value("on(e, b)", true)).
contains(variable(10), value("on(e, c)", true)).
contains(variable(10), value("on(e, d)", true)).
contains(variable(10), value("ontable(e)", true)).

% actions
action(action(("pick-up", "a"))).
precondition(action(("pick-up", "a")), variable(1), value("clear(a)", true)).
precondition(action(("pick-up", "a")), variable(6), value("handempty", true)).
precondition(action(("pick-up", "a")), variable(0), value("ontable(a)", true)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(0), value("holding(a)", true)).
costs(action(("pick-up", "a")), 1).

action(action(("pick-up", "b"))).
precondition(action(("pick-up", "b")), variable(2), value("clear(b)", true)).
precondition(action(("pick-up", "b")), variable(6), value("handempty", true)).
precondition(action(("pick-up", "b")), variable(7), value("ontable(b)", true)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(7), value("holding(b)", true)).
costs(action(("pick-up", "b")), 1).

action(action(("pick-up", "c"))).
precondition(action(("pick-up", "c")), variable(3), value("clear(c)", true)).
precondition(action(("pick-up", "c")), variable(6), value("handempty", true)).
precondition(action(("pick-up", "c")), variable(8), value("ontable(c)", true)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(8), value("holding(c)", true)).
costs(action(("pick-up", "c")), 1).

action(action(("pick-up", "d"))).
precondition(action(("pick-up", "d")), variable(4), value("clear(d)", true)).
precondition(action(("pick-up", "d")), variable(6), value("handempty", true)).
precondition(action(("pick-up", "d")), variable(9), value("ontable(d)", true)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(9), value("holding(d)", true)).
costs(action(("pick-up", "d")), 1).

action(action(("pick-up", "e"))).
precondition(action(("pick-up", "e")), variable(5), value("clear(e)", true)).
precondition(action(("pick-up", "e")), variable(6), value("handempty", true)).
precondition(action(("pick-up", "e")), variable(10), value("ontable(e)", true)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(10), value("holding(e)", true)).
costs(action(("pick-up", "e")), 1).

action(action(("put-down", "a"))).
precondition(action(("put-down", "a")), variable(0), value("holding(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(0), value("ontable(a)", true)).
costs(action(("put-down", "a")), 1).

action(action(("put-down", "b"))).
precondition(action(("put-down", "b")), variable(7), value("holding(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(7), value("ontable(b)", true)).
costs(action(("put-down", "b")), 1).

action(action(("put-down", "c"))).
precondition(action(("put-down", "c")), variable(8), value("holding(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(8), value("ontable(c)", true)).
costs(action(("put-down", "c")), 1).

action(action(("put-down", "d"))).
precondition(action(("put-down", "d")), variable(9), value("holding(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(9), value("ontable(d)", true)).
costs(action(("put-down", "d")), 1).

action(action(("put-down", "e"))).
precondition(action(("put-down", "e")), variable(10), value("holding(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(10), value("ontable(e)", true)).
costs(action(("put-down", "e")), 1).

action(action(("stack", "a", "b"))).
precondition(action(("stack", "a", "b")), variable(2), value("clear(b)", true)).
precondition(action(("stack", "a", "b")), variable(0), value("holding(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(0), value("on(a, b)", true)).
costs(action(("stack", "a", "b")), 1).

action(action(("stack", "a", "c"))).
precondition(action(("stack", "a", "c")), variable(3), value("clear(c)", true)).
precondition(action(("stack", "a", "c")), variable(0), value("holding(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(0), value("on(a, c)", true)).
costs(action(("stack", "a", "c")), 1).

action(action(("stack", "a", "d"))).
precondition(action(("stack", "a", "d")), variable(4), value("clear(d)", true)).
precondition(action(("stack", "a", "d")), variable(0), value("holding(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(0), value("on(a, d)", true)).
costs(action(("stack", "a", "d")), 1).

action(action(("stack", "a", "e"))).
precondition(action(("stack", "a", "e")), variable(5), value("clear(e)", true)).
precondition(action(("stack", "a", "e")), variable(0), value("holding(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(0), value("on(a, e)", true)).
costs(action(("stack", "a", "e")), 1).

action(action(("stack", "b", "a"))).
precondition(action(("stack", "b", "a")), variable(1), value("clear(a)", true)).
precondition(action(("stack", "b", "a")), variable(7), value("holding(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(7), value("on(b, a)", true)).
costs(action(("stack", "b", "a")), 1).

action(action(("stack", "b", "c"))).
precondition(action(("stack", "b", "c")), variable(3), value("clear(c)", true)).
precondition(action(("stack", "b", "c")), variable(7), value("holding(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(7), value("on(b, c)", true)).
costs(action(("stack", "b", "c")), 1).

action(action(("stack", "b", "d"))).
precondition(action(("stack", "b", "d")), variable(4), value("clear(d)", true)).
precondition(action(("stack", "b", "d")), variable(7), value("holding(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(7), value("on(b, d)", true)).
costs(action(("stack", "b", "d")), 1).

action(action(("stack", "b", "e"))).
precondition(action(("stack", "b", "e")), variable(5), value("clear(e)", true)).
precondition(action(("stack", "b", "e")), variable(7), value("holding(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(7), value("on(b, e)", true)).
costs(action(("stack", "b", "e")), 1).

action(action(("stack", "c", "a"))).
precondition(action(("stack", "c", "a")), variable(1), value("clear(a)", true)).
precondition(action(("stack", "c", "a")), variable(8), value("holding(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(8), value("on(c, a)", true)).
costs(action(("stack", "c", "a")), 1).

action(action(("stack", "c", "b"))).
precondition(action(("stack", "c", "b")), variable(2), value("clear(b)", true)).
precondition(action(("stack", "c", "b")), variable(8), value("holding(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(8), value("on(c, b)", true)).
costs(action(("stack", "c", "b")), 1).

action(action(("stack", "c", "d"))).
precondition(action(("stack", "c", "d")), variable(4), value("clear(d)", true)).
precondition(action(("stack", "c", "d")), variable(8), value("holding(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(8), value("on(c, d)", true)).
costs(action(("stack", "c", "d")), 1).

action(action(("stack", "c", "e"))).
precondition(action(("stack", "c", "e")), variable(5), value("clear(e)", true)).
precondition(action(("stack", "c", "e")), variable(8), value("holding(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(8), value("on(c, e)", true)).
costs(action(("stack", "c", "e")), 1).

action(action(("stack", "d", "a"))).
precondition(action(("stack", "d", "a")), variable(1), value("clear(a)", true)).
precondition(action(("stack", "d", "a")), variable(9), value("holding(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(9), value("on(d, a)", true)).
costs(action(("stack", "d", "a")), 1).

action(action(("stack", "d", "b"))).
precondition(action(("stack", "d", "b")), variable(2), value("clear(b)", true)).
precondition(action(("stack", "d", "b")), variable(9), value("holding(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(9), value("on(d, b)", true)).
costs(action(("stack", "d", "b")), 1).

action(action(("stack", "d", "c"))).
precondition(action(("stack", "d", "c")), variable(3), value("clear(c)", true)).
precondition(action(("stack", "d", "c")), variable(9), value("holding(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(9), value("on(d, c)", true)).
costs(action(("stack", "d", "c")), 1).

action(action(("stack", "d", "e"))).
precondition(action(("stack", "d", "e")), variable(5), value("clear(e)", true)).
precondition(action(("stack", "d", "e")), variable(9), value("holding(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(9), value("on(d, e)", true)).
costs(action(("stack", "d", "e")), 1).

action(action(("stack", "e", "a"))).
precondition(action(("stack", "e", "a")), variable(1), value("clear(a)", true)).
precondition(action(("stack", "e", "a")), variable(10), value("holding(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(10), value("on(e, a)", true)).
costs(action(("stack", "e", "a")), 1).

action(action(("stack", "e", "b"))).
precondition(action(("stack", "e", "b")), variable(2), value("clear(b)", true)).
precondition(action(("stack", "e", "b")), variable(10), value("holding(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(10), value("on(e, b)", true)).
costs(action(("stack", "e", "b")), 1).

action(action(("stack", "e", "c"))).
precondition(action(("stack", "e", "c")), variable(3), value("clear(c)", true)).
precondition(action(("stack", "e", "c")), variable(10), value("holding(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(10), value("on(e, c)", true)).
costs(action(("stack", "e", "c")), 1).

action(action(("stack", "e", "d"))).
precondition(action(("stack", "e", "d")), variable(4), value("clear(d)", true)).
precondition(action(("stack", "e", "d")), variable(10), value("holding(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(6), value("handempty", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(10), value("on(e, d)", true)).
costs(action(("stack", "e", "d")), 1).

action(action(("unstack", "a", "b"))).
precondition(action(("unstack", "a", "b")), variable(1), value("clear(a)", true)).
precondition(action(("unstack", "a", "b")), variable(6), value("handempty", true)).
precondition(action(("unstack", "a", "b")), variable(0), value("on(a, b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(0), value("holding(a)", true)).
costs(action(("unstack", "a", "b")), 1).

action(action(("unstack", "a", "c"))).
precondition(action(("unstack", "a", "c")), variable(1), value("clear(a)", true)).
precondition(action(("unstack", "a", "c")), variable(6), value("handempty", true)).
precondition(action(("unstack", "a", "c")), variable(0), value("on(a, c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(0), value("holding(a)", true)).
costs(action(("unstack", "a", "c")), 1).

action(action(("unstack", "a", "d"))).
precondition(action(("unstack", "a", "d")), variable(1), value("clear(a)", true)).
precondition(action(("unstack", "a", "d")), variable(6), value("handempty", true)).
precondition(action(("unstack", "a", "d")), variable(0), value("on(a, d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(0), value("holding(a)", true)).
costs(action(("unstack", "a", "d")), 1).

action(action(("unstack", "a", "e"))).
precondition(action(("unstack", "a", "e")), variable(1), value("clear(a)", true)).
precondition(action(("unstack", "a", "e")), variable(6), value("handempty", true)).
precondition(action(("unstack", "a", "e")), variable(0), value("on(a, e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(1), value("clear(a)", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(0), value("holding(a)", true)).
costs(action(("unstack", "a", "e")), 1).

action(action(("unstack", "b", "a"))).
precondition(action(("unstack", "b", "a")), variable(2), value("clear(b)", true)).
precondition(action(("unstack", "b", "a")), variable(6), value("handempty", true)).
precondition(action(("unstack", "b", "a")), variable(7), value("on(b, a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(7), value("holding(b)", true)).
costs(action(("unstack", "b", "a")), 1).

action(action(("unstack", "b", "c"))).
precondition(action(("unstack", "b", "c")), variable(2), value("clear(b)", true)).
precondition(action(("unstack", "b", "c")), variable(6), value("handempty", true)).
precondition(action(("unstack", "b", "c")), variable(7), value("on(b, c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(7), value("holding(b)", true)).
costs(action(("unstack", "b", "c")), 1).

action(action(("unstack", "b", "d"))).
precondition(action(("unstack", "b", "d")), variable(2), value("clear(b)", true)).
precondition(action(("unstack", "b", "d")), variable(6), value("handempty", true)).
precondition(action(("unstack", "b", "d")), variable(7), value("on(b, d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(7), value("holding(b)", true)).
costs(action(("unstack", "b", "d")), 1).

action(action(("unstack", "b", "e"))).
precondition(action(("unstack", "b", "e")), variable(2), value("clear(b)", true)).
precondition(action(("unstack", "b", "e")), variable(6), value("handempty", true)).
precondition(action(("unstack", "b", "e")), variable(7), value("on(b, e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(2), value("clear(b)", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(7), value("holding(b)", true)).
costs(action(("unstack", "b", "e")), 1).

action(action(("unstack", "c", "a"))).
precondition(action(("unstack", "c", "a")), variable(3), value("clear(c)", true)).
precondition(action(("unstack", "c", "a")), variable(6), value("handempty", true)).
precondition(action(("unstack", "c", "a")), variable(8), value("on(c, a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(8), value("holding(c)", true)).
costs(action(("unstack", "c", "a")), 1).

action(action(("unstack", "c", "b"))).
precondition(action(("unstack", "c", "b")), variable(3), value("clear(c)", true)).
precondition(action(("unstack", "c", "b")), variable(6), value("handempty", true)).
precondition(action(("unstack", "c", "b")), variable(8), value("on(c, b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(8), value("holding(c)", true)).
costs(action(("unstack", "c", "b")), 1).

action(action(("unstack", "c", "d"))).
precondition(action(("unstack", "c", "d")), variable(3), value("clear(c)", true)).
precondition(action(("unstack", "c", "d")), variable(6), value("handempty", true)).
precondition(action(("unstack", "c", "d")), variable(8), value("on(c, d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(8), value("holding(c)", true)).
costs(action(("unstack", "c", "d")), 1).

action(action(("unstack", "c", "e"))).
precondition(action(("unstack", "c", "e")), variable(3), value("clear(c)", true)).
precondition(action(("unstack", "c", "e")), variable(6), value("handempty", true)).
precondition(action(("unstack", "c", "e")), variable(8), value("on(c, e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(3), value("clear(c)", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(8), value("holding(c)", true)).
costs(action(("unstack", "c", "e")), 1).

action(action(("unstack", "d", "a"))).
precondition(action(("unstack", "d", "a")), variable(4), value("clear(d)", true)).
precondition(action(("unstack", "d", "a")), variable(6), value("handempty", true)).
precondition(action(("unstack", "d", "a")), variable(9), value("on(d, a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(9), value("holding(d)", true)).
costs(action(("unstack", "d", "a")), 1).

action(action(("unstack", "d", "b"))).
precondition(action(("unstack", "d", "b")), variable(4), value("clear(d)", true)).
precondition(action(("unstack", "d", "b")), variable(6), value("handempty", true)).
precondition(action(("unstack", "d", "b")), variable(9), value("on(d, b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(9), value("holding(d)", true)).
costs(action(("unstack", "d", "b")), 1).

action(action(("unstack", "d", "c"))).
precondition(action(("unstack", "d", "c")), variable(4), value("clear(d)", true)).
precondition(action(("unstack", "d", "c")), variable(6), value("handempty", true)).
precondition(action(("unstack", "d", "c")), variable(9), value("on(d, c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(9), value("holding(d)", true)).
costs(action(("unstack", "d", "c")), 1).

action(action(("unstack", "d", "e"))).
precondition(action(("unstack", "d", "e")), variable(4), value("clear(d)", true)).
precondition(action(("unstack", "d", "e")), variable(6), value("handempty", true)).
precondition(action(("unstack", "d", "e")), variable(9), value("on(d, e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(4), value("clear(d)", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(5), value("clear(e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(9), value("holding(d)", true)).
costs(action(("unstack", "d", "e")), 1).

action(action(("unstack", "e", "a"))).
precondition(action(("unstack", "e", "a")), variable(5), value("clear(e)", true)).
precondition(action(("unstack", "e", "a")), variable(6), value("handempty", true)).
precondition(action(("unstack", "e", "a")), variable(10), value("on(e, a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(1), value("clear(a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(10), value("holding(e)", true)).
costs(action(("unstack", "e", "a")), 1).

action(action(("unstack", "e", "b"))).
precondition(action(("unstack", "e", "b")), variable(5), value("clear(e)", true)).
precondition(action(("unstack", "e", "b")), variable(6), value("handempty", true)).
precondition(action(("unstack", "e", "b")), variable(10), value("on(e, b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(2), value("clear(b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(10), value("holding(e)", true)).
costs(action(("unstack", "e", "b")), 1).

action(action(("unstack", "e", "c"))).
precondition(action(("unstack", "e", "c")), variable(5), value("clear(e)", true)).
precondition(action(("unstack", "e", "c")), variable(6), value("handempty", true)).
precondition(action(("unstack", "e", "c")), variable(10), value("on(e, c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(3), value("clear(c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(10), value("holding(e)", true)).
costs(action(("unstack", "e", "c")), 1).

action(action(("unstack", "e", "d"))).
precondition(action(("unstack", "e", "d")), variable(5), value("clear(e)", true)).
precondition(action(("unstack", "e", "d")), variable(6), value("handempty", true)).
precondition(action(("unstack", "e", "d")), variable(10), value("on(e, d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(4), value("clear(d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(5), value("clear(e)", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(6), value("handempty", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(10), value("holding(e)", true)).
costs(action(("unstack", "e", "d")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(1), value("clear(a)", true)).
contains(mutexGroup(0), variable(0), value("holding(a)", true)).
contains(mutexGroup(0), variable(7), value("on(b, a)", true)).
contains(mutexGroup(0), variable(8), value("on(c, a)", true)).
contains(mutexGroup(0), variable(9), value("on(d, a)", true)).
contains(mutexGroup(0), variable(10), value("on(e, a)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(2), value("clear(b)", true)).
contains(mutexGroup(1), variable(0), value("on(a, b)", true)).
contains(mutexGroup(1), variable(7), value("holding(b)", true)).
contains(mutexGroup(1), variable(8), value("on(c, b)", true)).
contains(mutexGroup(1), variable(9), value("on(d, b)", true)).
contains(mutexGroup(1), variable(10), value("on(e, b)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(3), value("clear(c)", true)).
contains(mutexGroup(2), variable(0), value("on(a, c)", true)).
contains(mutexGroup(2), variable(7), value("on(b, c)", true)).
contains(mutexGroup(2), variable(8), value("holding(c)", true)).
contains(mutexGroup(2), variable(9), value("on(d, c)", true)).
contains(mutexGroup(2), variable(10), value("on(e, c)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(4), value("clear(d)", true)).
contains(mutexGroup(3), variable(0), value("on(a, d)", true)).
contains(mutexGroup(3), variable(7), value("on(b, d)", true)).
contains(mutexGroup(3), variable(8), value("on(c, d)", true)).
contains(mutexGroup(3), variable(9), value("holding(d)", true)).
contains(mutexGroup(3), variable(10), value("on(e, d)", true)).

mutexGroup(mutexGroup(4)).
contains(mutexGroup(4), variable(5), value("clear(e)", true)).
contains(mutexGroup(4), variable(0), value("on(a, e)", true)).
contains(mutexGroup(4), variable(7), value("on(b, e)", true)).
contains(mutexGroup(4), variable(8), value("on(c, e)", true)).
contains(mutexGroup(4), variable(9), value("on(d, e)", true)).
contains(mutexGroup(4), variable(10), value("holding(e)", true)).

mutexGroup(mutexGroup(5)).
contains(mutexGroup(5), variable(6), value("handempty", true)).
contains(mutexGroup(5), variable(0), value("holding(a)", true)).
contains(mutexGroup(5), variable(7), value("holding(b)", true)).
contains(mutexGroup(5), variable(8), value("holding(c)", true)).
contains(mutexGroup(5), variable(9), value("holding(d)", true)).
contains(mutexGroup(5), variable(10), value("holding(e)", true)).

% initial state
initialState(variable(0), value("on(a, b)", true)).
initialState(variable(1), value("clear(a)", false)).
initialState(variable(2), value("clear(b)", false)).
initialState(variable(3), value("clear(c)", false)).
initialState(variable(4), value("clear(d)", true)).
initialState(variable(5), value("clear(e)", false)).
initialState(variable(6), value("handempty", true)).
initialState(variable(7), value("ontable(b)", true)).
initialState(variable(8), value("on(c, a)", true)).
initialState(variable(9), value("on(d, e)", true)).
initialState(variable(10), value("on(e, c)", true)).

% goal
goal(variable(7), value("on(b, e)", true)).
goal(variable(8), value("on(c, b)", true)).
goal(variable(9), value("on(d, c)", true)).
goal(variable(10), value("on(e, a)", true)).
