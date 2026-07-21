#const horizon=26.

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

1 {occurs(Action, T) : action(Action)} 1 :- time(T), T > 0.

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shows all 'occurs' atoms.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show occurs/2.% variables
variable(variable(0)).
contains(variable(0), value("holding(e)", true)).
contains(variable(0), value("on(e, a)", true)).
contains(variable(0), value("on(e, b)", true)).
contains(variable(0), value("on(e, c)", true)).
contains(variable(0), value("on(e, d)", true)).
contains(variable(0), value("on(e, f)", true)).
contains(variable(0), value("on(e, g)", true)).
contains(variable(0), value("ontable(e)", true)).

variable(variable(1)).
contains(variable(1), value("clear(e)", true)).
contains(variable(1), value("clear(e)", false)).

variable(variable(2)).
contains(variable(2), value("clear(a)", true)).
contains(variable(2), value("clear(a)", false)).

variable(variable(3)).
contains(variable(3), value("clear(b)", true)).
contains(variable(3), value("clear(b)", false)).

variable(variable(4)).
contains(variable(4), value("clear(c)", true)).
contains(variable(4), value("clear(c)", false)).

variable(variable(5)).
contains(variable(5), value("clear(d)", true)).
contains(variable(5), value("clear(d)", false)).

variable(variable(6)).
contains(variable(6), value("clear(f)", true)).
contains(variable(6), value("clear(f)", false)).

variable(variable(7)).
contains(variable(7), value("clear(g)", true)).
contains(variable(7), value("clear(g)", false)).

variable(variable(8)).
contains(variable(8), value("handempty", true)).
contains(variable(8), value("handempty", false)).

variable(variable(9)).
contains(variable(9), value("holding(a)", true)).
contains(variable(9), value("on(a, b)", true)).
contains(variable(9), value("on(a, c)", true)).
contains(variable(9), value("on(a, d)", true)).
contains(variable(9), value("on(a, e)", true)).
contains(variable(9), value("on(a, f)", true)).
contains(variable(9), value("on(a, g)", true)).
contains(variable(9), value("ontable(a)", true)).

variable(variable(10)).
contains(variable(10), value("holding(b)", true)).
contains(variable(10), value("on(b, a)", true)).
contains(variable(10), value("on(b, c)", true)).
contains(variable(10), value("on(b, d)", true)).
contains(variable(10), value("on(b, e)", true)).
contains(variable(10), value("on(b, f)", true)).
contains(variable(10), value("on(b, g)", true)).
contains(variable(10), value("ontable(b)", true)).

variable(variable(11)).
contains(variable(11), value("holding(c)", true)).
contains(variable(11), value("on(c, a)", true)).
contains(variable(11), value("on(c, b)", true)).
contains(variable(11), value("on(c, d)", true)).
contains(variable(11), value("on(c, e)", true)).
contains(variable(11), value("on(c, f)", true)).
contains(variable(11), value("on(c, g)", true)).
contains(variable(11), value("ontable(c)", true)).

variable(variable(12)).
contains(variable(12), value("holding(d)", true)).
contains(variable(12), value("on(d, a)", true)).
contains(variable(12), value("on(d, b)", true)).
contains(variable(12), value("on(d, c)", true)).
contains(variable(12), value("on(d, e)", true)).
contains(variable(12), value("on(d, f)", true)).
contains(variable(12), value("on(d, g)", true)).
contains(variable(12), value("ontable(d)", true)).

variable(variable(13)).
contains(variable(13), value("holding(f)", true)).
contains(variable(13), value("on(f, a)", true)).
contains(variable(13), value("on(f, b)", true)).
contains(variable(13), value("on(f, c)", true)).
contains(variable(13), value("on(f, d)", true)).
contains(variable(13), value("on(f, e)", true)).
contains(variable(13), value("on(f, g)", true)).
contains(variable(13), value("ontable(f)", true)).

variable(variable(14)).
contains(variable(14), value("holding(g)", true)).
contains(variable(14), value("on(g, a)", true)).
contains(variable(14), value("on(g, b)", true)).
contains(variable(14), value("on(g, c)", true)).
contains(variable(14), value("on(g, d)", true)).
contains(variable(14), value("on(g, e)", true)).
contains(variable(14), value("on(g, f)", true)).
contains(variable(14), value("ontable(g)", true)).

% actions
action(action(("pick-up", "a"))).
precondition(action(("pick-up", "a")), variable(2), value("clear(a)", true)).
precondition(action(("pick-up", "a")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "a")), variable(9), value("ontable(a)", true)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("pick-up", "a")), 1).

action(action(("pick-up", "b"))).
precondition(action(("pick-up", "b")), variable(3), value("clear(b)", true)).
precondition(action(("pick-up", "b")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "b")), variable(10), value("ontable(b)", true)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("pick-up", "b")), 1).

action(action(("pick-up", "c"))).
precondition(action(("pick-up", "c")), variable(4), value("clear(c)", true)).
precondition(action(("pick-up", "c")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "c")), variable(11), value("ontable(c)", true)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("pick-up", "c")), 1).

action(action(("pick-up", "d"))).
precondition(action(("pick-up", "d")), variable(5), value("clear(d)", true)).
precondition(action(("pick-up", "d")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "d")), variable(12), value("ontable(d)", true)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("pick-up", "d")), 1).

action(action(("pick-up", "e"))).
precondition(action(("pick-up", "e")), variable(1), value("clear(e)", true)).
precondition(action(("pick-up", "e")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "e")), variable(0), value("ontable(e)", true)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("pick-up", "e")), 1).

action(action(("pick-up", "f"))).
precondition(action(("pick-up", "f")), variable(6), value("clear(f)", true)).
precondition(action(("pick-up", "f")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "f")), variable(13), value("ontable(f)", true)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("pick-up", "f")), 1).

action(action(("pick-up", "g"))).
precondition(action(("pick-up", "g")), variable(7), value("clear(g)", true)).
precondition(action(("pick-up", "g")), variable(8), value("handempty", true)).
precondition(action(("pick-up", "g")), variable(14), value("ontable(g)", true)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("pick-up", "g")), 1).

action(action(("put-down", "a"))).
precondition(action(("put-down", "a")), variable(9), value("holding(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(9), value("ontable(a)", true)).
costs(action(("put-down", "a")), 1).

action(action(("put-down", "b"))).
precondition(action(("put-down", "b")), variable(10), value("holding(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(10), value("ontable(b)", true)).
costs(action(("put-down", "b")), 1).

action(action(("put-down", "c"))).
precondition(action(("put-down", "c")), variable(11), value("holding(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(11), value("ontable(c)", true)).
costs(action(("put-down", "c")), 1).

action(action(("put-down", "d"))).
precondition(action(("put-down", "d")), variable(12), value("holding(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(12), value("ontable(d)", true)).
costs(action(("put-down", "d")), 1).

action(action(("put-down", "e"))).
precondition(action(("put-down", "e")), variable(0), value("holding(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(0), value("ontable(e)", true)).
costs(action(("put-down", "e")), 1).

action(action(("put-down", "f"))).
precondition(action(("put-down", "f")), variable(13), value("holding(f)", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(13), value("ontable(f)", true)).
costs(action(("put-down", "f")), 1).

action(action(("put-down", "g"))).
precondition(action(("put-down", "g")), variable(14), value("holding(g)", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(14), value("ontable(g)", true)).
costs(action(("put-down", "g")), 1).

action(action(("stack", "a", "b"))).
precondition(action(("stack", "a", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "a", "b")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(9), value("on(a, b)", true)).
costs(action(("stack", "a", "b")), 1).

action(action(("stack", "a", "c"))).
precondition(action(("stack", "a", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "a", "c")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(9), value("on(a, c)", true)).
costs(action(("stack", "a", "c")), 1).

action(action(("stack", "a", "d"))).
precondition(action(("stack", "a", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "a", "d")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(9), value("on(a, d)", true)).
costs(action(("stack", "a", "d")), 1).

action(action(("stack", "a", "e"))).
precondition(action(("stack", "a", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "a", "e")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(9), value("on(a, e)", true)).
costs(action(("stack", "a", "e")), 1).

action(action(("stack", "a", "f"))).
precondition(action(("stack", "a", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "a", "f")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(9), value("on(a, f)", true)).
costs(action(("stack", "a", "f")), 1).

action(action(("stack", "a", "g"))).
precondition(action(("stack", "a", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "a", "g")), variable(9), value("holding(a)", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(9), value("on(a, g)", true)).
costs(action(("stack", "a", "g")), 1).

action(action(("stack", "b", "a"))).
precondition(action(("stack", "b", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "b", "a")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(10), value("on(b, a)", true)).
costs(action(("stack", "b", "a")), 1).

action(action(("stack", "b", "c"))).
precondition(action(("stack", "b", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "b", "c")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(10), value("on(b, c)", true)).
costs(action(("stack", "b", "c")), 1).

action(action(("stack", "b", "d"))).
precondition(action(("stack", "b", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "b", "d")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(10), value("on(b, d)", true)).
costs(action(("stack", "b", "d")), 1).

action(action(("stack", "b", "e"))).
precondition(action(("stack", "b", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "b", "e")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(10), value("on(b, e)", true)).
costs(action(("stack", "b", "e")), 1).

action(action(("stack", "b", "f"))).
precondition(action(("stack", "b", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "b", "f")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(10), value("on(b, f)", true)).
costs(action(("stack", "b", "f")), 1).

action(action(("stack", "b", "g"))).
precondition(action(("stack", "b", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "b", "g")), variable(10), value("holding(b)", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(10), value("on(b, g)", true)).
costs(action(("stack", "b", "g")), 1).

action(action(("stack", "c", "a"))).
precondition(action(("stack", "c", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "c", "a")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(11), value("on(c, a)", true)).
costs(action(("stack", "c", "a")), 1).

action(action(("stack", "c", "b"))).
precondition(action(("stack", "c", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "c", "b")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(11), value("on(c, b)", true)).
costs(action(("stack", "c", "b")), 1).

action(action(("stack", "c", "d"))).
precondition(action(("stack", "c", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "c", "d")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(11), value("on(c, d)", true)).
costs(action(("stack", "c", "d")), 1).

action(action(("stack", "c", "e"))).
precondition(action(("stack", "c", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "c", "e")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(11), value("on(c, e)", true)).
costs(action(("stack", "c", "e")), 1).

action(action(("stack", "c", "f"))).
precondition(action(("stack", "c", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "c", "f")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(11), value("on(c, f)", true)).
costs(action(("stack", "c", "f")), 1).

action(action(("stack", "c", "g"))).
precondition(action(("stack", "c", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "c", "g")), variable(11), value("holding(c)", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(11), value("on(c, g)", true)).
costs(action(("stack", "c", "g")), 1).

action(action(("stack", "d", "a"))).
precondition(action(("stack", "d", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "d", "a")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(12), value("on(d, a)", true)).
costs(action(("stack", "d", "a")), 1).

action(action(("stack", "d", "b"))).
precondition(action(("stack", "d", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "d", "b")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(12), value("on(d, b)", true)).
costs(action(("stack", "d", "b")), 1).

action(action(("stack", "d", "c"))).
precondition(action(("stack", "d", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "d", "c")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(12), value("on(d, c)", true)).
costs(action(("stack", "d", "c")), 1).

action(action(("stack", "d", "e"))).
precondition(action(("stack", "d", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "d", "e")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(12), value("on(d, e)", true)).
costs(action(("stack", "d", "e")), 1).

action(action(("stack", "d", "f"))).
precondition(action(("stack", "d", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "d", "f")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(12), value("on(d, f)", true)).
costs(action(("stack", "d", "f")), 1).

action(action(("stack", "d", "g"))).
precondition(action(("stack", "d", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "d", "g")), variable(12), value("holding(d)", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(12), value("on(d, g)", true)).
costs(action(("stack", "d", "g")), 1).

action(action(("stack", "e", "a"))).
precondition(action(("stack", "e", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "e", "a")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(0), value("on(e, a)", true)).
costs(action(("stack", "e", "a")), 1).

action(action(("stack", "e", "b"))).
precondition(action(("stack", "e", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "e", "b")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(0), value("on(e, b)", true)).
costs(action(("stack", "e", "b")), 1).

action(action(("stack", "e", "c"))).
precondition(action(("stack", "e", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "e", "c")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(0), value("on(e, c)", true)).
costs(action(("stack", "e", "c")), 1).

action(action(("stack", "e", "d"))).
precondition(action(("stack", "e", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "e", "d")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(0), value("on(e, d)", true)).
costs(action(("stack", "e", "d")), 1).

action(action(("stack", "e", "f"))).
precondition(action(("stack", "e", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "e", "f")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(0), value("on(e, f)", true)).
costs(action(("stack", "e", "f")), 1).

action(action(("stack", "e", "g"))).
precondition(action(("stack", "e", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "e", "g")), variable(0), value("holding(e)", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(0), value("on(e, g)", true)).
costs(action(("stack", "e", "g")), 1).

action(action(("stack", "f", "a"))).
precondition(action(("stack", "f", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "f", "a")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(13), value("on(f, a)", true)).
costs(action(("stack", "f", "a")), 1).

action(action(("stack", "f", "b"))).
precondition(action(("stack", "f", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "f", "b")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(13), value("on(f, b)", true)).
costs(action(("stack", "f", "b")), 1).

action(action(("stack", "f", "c"))).
precondition(action(("stack", "f", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "f", "c")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(13), value("on(f, c)", true)).
costs(action(("stack", "f", "c")), 1).

action(action(("stack", "f", "d"))).
precondition(action(("stack", "f", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "f", "d")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(13), value("on(f, d)", true)).
costs(action(("stack", "f", "d")), 1).

action(action(("stack", "f", "e"))).
precondition(action(("stack", "f", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "f", "e")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(13), value("on(f, e)", true)).
costs(action(("stack", "f", "e")), 1).

action(action(("stack", "f", "g"))).
precondition(action(("stack", "f", "g")), variable(7), value("clear(g)", true)).
precondition(action(("stack", "f", "g")), variable(13), value("holding(f)", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(13), value("on(f, g)", true)).
costs(action(("stack", "f", "g")), 1).

action(action(("stack", "g", "a"))).
precondition(action(("stack", "g", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "g", "a")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(14), value("on(g, a)", true)).
costs(action(("stack", "g", "a")), 1).

action(action(("stack", "g", "b"))).
precondition(action(("stack", "g", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "g", "b")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(14), value("on(g, b)", true)).
costs(action(("stack", "g", "b")), 1).

action(action(("stack", "g", "c"))).
precondition(action(("stack", "g", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "g", "c")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(14), value("on(g, c)", true)).
costs(action(("stack", "g", "c")), 1).

action(action(("stack", "g", "d"))).
precondition(action(("stack", "g", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "g", "d")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(14), value("on(g, d)", true)).
costs(action(("stack", "g", "d")), 1).

action(action(("stack", "g", "e"))).
precondition(action(("stack", "g", "e")), variable(1), value("clear(e)", true)).
precondition(action(("stack", "g", "e")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(14), value("on(g, e)", true)).
costs(action(("stack", "g", "e")), 1).

action(action(("stack", "g", "f"))).
precondition(action(("stack", "g", "f")), variable(6), value("clear(f)", true)).
precondition(action(("stack", "g", "f")), variable(14), value("holding(g)", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(8), value("handempty", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(14), value("on(g, f)", true)).
costs(action(("stack", "g", "f")), 1).

action(action(("unstack", "a", "b"))).
precondition(action(("unstack", "a", "b")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "b")), variable(9), value("on(a, b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "b")), 1).

action(action(("unstack", "a", "c"))).
precondition(action(("unstack", "a", "c")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "c")), variable(9), value("on(a, c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "c")), 1).

action(action(("unstack", "a", "d"))).
precondition(action(("unstack", "a", "d")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "d")), variable(9), value("on(a, d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "d")), 1).

action(action(("unstack", "a", "e"))).
precondition(action(("unstack", "a", "e")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "e")), variable(9), value("on(a, e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "e")), 1).

action(action(("unstack", "a", "f"))).
precondition(action(("unstack", "a", "f")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "f")), variable(9), value("on(a, f)", true)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "f")), 1).

action(action(("unstack", "a", "g"))).
precondition(action(("unstack", "a", "g")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "a", "g")), variable(9), value("on(a, g)", true)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(9), value("holding(a)", true)).
costs(action(("unstack", "a", "g")), 1).

action(action(("unstack", "b", "a"))).
precondition(action(("unstack", "b", "a")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "a")), variable(10), value("on(b, a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "a")), 1).

action(action(("unstack", "b", "c"))).
precondition(action(("unstack", "b", "c")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "c")), variable(10), value("on(b, c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "c")), 1).

action(action(("unstack", "b", "d"))).
precondition(action(("unstack", "b", "d")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "d")), variable(10), value("on(b, d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "d")), 1).

action(action(("unstack", "b", "e"))).
precondition(action(("unstack", "b", "e")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "e")), variable(10), value("on(b, e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "e")), 1).

action(action(("unstack", "b", "f"))).
precondition(action(("unstack", "b", "f")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "f")), variable(10), value("on(b, f)", true)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "f")), 1).

action(action(("unstack", "b", "g"))).
precondition(action(("unstack", "b", "g")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "b", "g")), variable(10), value("on(b, g)", true)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(10), value("holding(b)", true)).
costs(action(("unstack", "b", "g")), 1).

action(action(("unstack", "c", "a"))).
precondition(action(("unstack", "c", "a")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "a")), variable(11), value("on(c, a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "a")), 1).

action(action(("unstack", "c", "b"))).
precondition(action(("unstack", "c", "b")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "b")), variable(11), value("on(c, b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "b")), 1).

action(action(("unstack", "c", "d"))).
precondition(action(("unstack", "c", "d")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "d")), variable(11), value("on(c, d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "d")), 1).

action(action(("unstack", "c", "e"))).
precondition(action(("unstack", "c", "e")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "e")), variable(11), value("on(c, e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "e")), 1).

action(action(("unstack", "c", "f"))).
precondition(action(("unstack", "c", "f")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "f")), variable(11), value("on(c, f)", true)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "f")), 1).

action(action(("unstack", "c", "g"))).
precondition(action(("unstack", "c", "g")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "c", "g")), variable(11), value("on(c, g)", true)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(11), value("holding(c)", true)).
costs(action(("unstack", "c", "g")), 1).

action(action(("unstack", "d", "a"))).
precondition(action(("unstack", "d", "a")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "a")), variable(12), value("on(d, a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "a")), 1).

action(action(("unstack", "d", "b"))).
precondition(action(("unstack", "d", "b")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "b")), variable(12), value("on(d, b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "b")), 1).

action(action(("unstack", "d", "c"))).
precondition(action(("unstack", "d", "c")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "c")), variable(12), value("on(d, c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "c")), 1).

action(action(("unstack", "d", "e"))).
precondition(action(("unstack", "d", "e")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "e")), variable(12), value("on(d, e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "e")), 1).

action(action(("unstack", "d", "f"))).
precondition(action(("unstack", "d", "f")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "f")), variable(12), value("on(d, f)", true)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "f")), 1).

action(action(("unstack", "d", "g"))).
precondition(action(("unstack", "d", "g")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "d", "g")), variable(12), value("on(d, g)", true)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(12), value("holding(d)", true)).
costs(action(("unstack", "d", "g")), 1).

action(action(("unstack", "e", "a"))).
precondition(action(("unstack", "e", "a")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "a")), variable(0), value("on(e, a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "a")), 1).

action(action(("unstack", "e", "b"))).
precondition(action(("unstack", "e", "b")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "b")), variable(0), value("on(e, b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "b")), 1).

action(action(("unstack", "e", "c"))).
precondition(action(("unstack", "e", "c")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "c")), variable(0), value("on(e, c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "c")), 1).

action(action(("unstack", "e", "d"))).
precondition(action(("unstack", "e", "d")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "d")), variable(0), value("on(e, d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "d")), 1).

action(action(("unstack", "e", "f"))).
precondition(action(("unstack", "e", "f")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "f")), variable(0), value("on(e, f)", true)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "f")), 1).

action(action(("unstack", "e", "g"))).
precondition(action(("unstack", "e", "g")), variable(1), value("clear(e)", true)).
precondition(action(("unstack", "e", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "e", "g")), variable(0), value("on(e, g)", true)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(1), value("clear(e)", false)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(0), value("holding(e)", true)).
costs(action(("unstack", "e", "g")), 1).

action(action(("unstack", "f", "a"))).
precondition(action(("unstack", "f", "a")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "a")), variable(13), value("on(f, a)", true)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "a")), 1).

action(action(("unstack", "f", "b"))).
precondition(action(("unstack", "f", "b")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "b")), variable(13), value("on(f, b)", true)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "b")), 1).

action(action(("unstack", "f", "c"))).
precondition(action(("unstack", "f", "c")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "c")), variable(13), value("on(f, c)", true)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "c")), 1).

action(action(("unstack", "f", "d"))).
precondition(action(("unstack", "f", "d")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "d")), variable(13), value("on(f, d)", true)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "d")), 1).

action(action(("unstack", "f", "e"))).
precondition(action(("unstack", "f", "e")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "e")), variable(13), value("on(f, e)", true)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "e")), 1).

action(action(("unstack", "f", "g"))).
precondition(action(("unstack", "f", "g")), variable(6), value("clear(f)", true)).
precondition(action(("unstack", "f", "g")), variable(8), value("handempty", true)).
precondition(action(("unstack", "f", "g")), variable(13), value("on(f, g)", true)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(6), value("clear(f)", false)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(7), value("clear(g)", true)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(13), value("holding(f)", true)).
costs(action(("unstack", "f", "g")), 1).

action(action(("unstack", "g", "a"))).
precondition(action(("unstack", "g", "a")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "a")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "a")), variable(14), value("on(g, a)", true)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "a")), 1).

action(action(("unstack", "g", "b"))).
precondition(action(("unstack", "g", "b")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "b")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "b")), variable(14), value("on(g, b)", true)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "b")), 1).

action(action(("unstack", "g", "c"))).
precondition(action(("unstack", "g", "c")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "c")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "c")), variable(14), value("on(g, c)", true)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "c")), 1).

action(action(("unstack", "g", "d"))).
precondition(action(("unstack", "g", "d")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "d")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "d")), variable(14), value("on(g, d)", true)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "d")), 1).

action(action(("unstack", "g", "e"))).
precondition(action(("unstack", "g", "e")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "e")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "e")), variable(14), value("on(g, e)", true)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(1), value("clear(e)", true)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "e")), 1).

action(action(("unstack", "g", "f"))).
precondition(action(("unstack", "g", "f")), variable(7), value("clear(g)", true)).
precondition(action(("unstack", "g", "f")), variable(8), value("handempty", true)).
precondition(action(("unstack", "g", "f")), variable(14), value("on(g, f)", true)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(6), value("clear(f)", true)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(7), value("clear(g)", false)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(8), value("handempty", false)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(14), value("holding(g)", true)).
costs(action(("unstack", "g", "f")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(2), value("clear(a)", true)).
contains(mutexGroup(0), variable(9), value("holding(a)", true)).
contains(mutexGroup(0), variable(10), value("on(b, a)", true)).
contains(mutexGroup(0), variable(11), value("on(c, a)", true)).
contains(mutexGroup(0), variable(12), value("on(d, a)", true)).
contains(mutexGroup(0), variable(0), value("on(e, a)", true)).
contains(mutexGroup(0), variable(13), value("on(f, a)", true)).
contains(mutexGroup(0), variable(14), value("on(g, a)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(3), value("clear(b)", true)).
contains(mutexGroup(1), variable(9), value("on(a, b)", true)).
contains(mutexGroup(1), variable(10), value("holding(b)", true)).
contains(mutexGroup(1), variable(11), value("on(c, b)", true)).
contains(mutexGroup(1), variable(12), value("on(d, b)", true)).
contains(mutexGroup(1), variable(0), value("on(e, b)", true)).
contains(mutexGroup(1), variable(13), value("on(f, b)", true)).
contains(mutexGroup(1), variable(14), value("on(g, b)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(4), value("clear(c)", true)).
contains(mutexGroup(2), variable(9), value("on(a, c)", true)).
contains(mutexGroup(2), variable(10), value("on(b, c)", true)).
contains(mutexGroup(2), variable(11), value("holding(c)", true)).
contains(mutexGroup(2), variable(12), value("on(d, c)", true)).
contains(mutexGroup(2), variable(0), value("on(e, c)", true)).
contains(mutexGroup(2), variable(13), value("on(f, c)", true)).
contains(mutexGroup(2), variable(14), value("on(g, c)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(5), value("clear(d)", true)).
contains(mutexGroup(3), variable(9), value("on(a, d)", true)).
contains(mutexGroup(3), variable(10), value("on(b, d)", true)).
contains(mutexGroup(3), variable(11), value("on(c, d)", true)).
contains(mutexGroup(3), variable(12), value("holding(d)", true)).
contains(mutexGroup(3), variable(0), value("on(e, d)", true)).
contains(mutexGroup(3), variable(13), value("on(f, d)", true)).
contains(mutexGroup(3), variable(14), value("on(g, d)", true)).

mutexGroup(mutexGroup(4)).
contains(mutexGroup(4), variable(1), value("clear(e)", true)).
contains(mutexGroup(4), variable(9), value("on(a, e)", true)).
contains(mutexGroup(4), variable(10), value("on(b, e)", true)).
contains(mutexGroup(4), variable(11), value("on(c, e)", true)).
contains(mutexGroup(4), variable(12), value("on(d, e)", true)).
contains(mutexGroup(4), variable(0), value("holding(e)", true)).
contains(mutexGroup(4), variable(13), value("on(f, e)", true)).
contains(mutexGroup(4), variable(14), value("on(g, e)", true)).

mutexGroup(mutexGroup(5)).
contains(mutexGroup(5), variable(6), value("clear(f)", true)).
contains(mutexGroup(5), variable(9), value("on(a, f)", true)).
contains(mutexGroup(5), variable(10), value("on(b, f)", true)).
contains(mutexGroup(5), variable(11), value("on(c, f)", true)).
contains(mutexGroup(5), variable(12), value("on(d, f)", true)).
contains(mutexGroup(5), variable(0), value("on(e, f)", true)).
contains(mutexGroup(5), variable(13), value("holding(f)", true)).
contains(mutexGroup(5), variable(14), value("on(g, f)", true)).

mutexGroup(mutexGroup(6)).
contains(mutexGroup(6), variable(7), value("clear(g)", true)).
contains(mutexGroup(6), variable(9), value("on(a, g)", true)).
contains(mutexGroup(6), variable(10), value("on(b, g)", true)).
contains(mutexGroup(6), variable(11), value("on(c, g)", true)).
contains(mutexGroup(6), variable(12), value("on(d, g)", true)).
contains(mutexGroup(6), variable(0), value("on(e, g)", true)).
contains(mutexGroup(6), variable(13), value("on(f, g)", true)).
contains(mutexGroup(6), variable(14), value("holding(g)", true)).

mutexGroup(mutexGroup(7)).
contains(mutexGroup(7), variable(8), value("handempty", true)).
contains(mutexGroup(7), variable(9), value("holding(a)", true)).
contains(mutexGroup(7), variable(10), value("holding(b)", true)).
contains(mutexGroup(7), variable(11), value("holding(c)", true)).
contains(mutexGroup(7), variable(12), value("holding(d)", true)).
contains(mutexGroup(7), variable(0), value("holding(e)", true)).
contains(mutexGroup(7), variable(13), value("holding(f)", true)).
contains(mutexGroup(7), variable(14), value("holding(g)", true)).

% initial state
initialState(variable(0), value("on(e, g)", true)).
initialState(variable(1), value("clear(e)", true)).
initialState(variable(2), value("clear(a)", false)).
initialState(variable(3), value("clear(b)", false)).
initialState(variable(4), value("clear(c)", false)).
initialState(variable(5), value("clear(d)", false)).
initialState(variable(6), value("clear(f)", false)).
initialState(variable(7), value("clear(g)", false)).
initialState(variable(8), value("handempty", true)).
initialState(variable(9), value("on(a, f)", true)).
initialState(variable(10), value("on(b, a)", true)).
initialState(variable(11), value("on(c, d)", true)).
initialState(variable(12), value("ontable(d)", true)).
initialState(variable(13), value("on(f, c)", true)).
initialState(variable(14), value("on(g, b)", true)).

% goal
goal(variable(9), value("on(a, g)", true)).
goal(variable(10), value("on(b, c)", true)).
goal(variable(11), value("on(c, f)", true)).
goal(variable(12), value("on(d, b)", true)).
goal(variable(13), value("on(f, e)", true)).
goal(variable(14), value("on(g, d)", true)).
