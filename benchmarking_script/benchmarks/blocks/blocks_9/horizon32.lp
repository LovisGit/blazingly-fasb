#const horizon=32.

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
contains(variable(0), value("holding(h)", true)).
contains(variable(0), value("on(h, a)", true)).
contains(variable(0), value("on(h, b)", true)).
contains(variable(0), value("on(h, c)", true)).
contains(variable(0), value("on(h, d)", true)).
contains(variable(0), value("on(h, e)", true)).
contains(variable(0), value("on(h, f)", true)).
contains(variable(0), value("on(h, g)", true)).
contains(variable(0), value("on(h, i)", true)).
contains(variable(0), value("ontable(h)", true)).

variable(variable(1)).
contains(variable(1), value("clear(h)", true)).
contains(variable(1), value("clear(h)", false)).

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
contains(variable(6), value("clear(e)", true)).
contains(variable(6), value("clear(e)", false)).

variable(variable(7)).
contains(variable(7), value("clear(f)", true)).
contains(variable(7), value("clear(f)", false)).

variable(variable(8)).
contains(variable(8), value("clear(g)", true)).
contains(variable(8), value("clear(g)", false)).

variable(variable(9)).
contains(variable(9), value("clear(i)", true)).
contains(variable(9), value("clear(i)", false)).

variable(variable(10)).
contains(variable(10), value("handempty", true)).
contains(variable(10), value("handempty", false)).

variable(variable(11)).
contains(variable(11), value("holding(a)", true)).
contains(variable(11), value("on(a, b)", true)).
contains(variable(11), value("on(a, c)", true)).
contains(variable(11), value("on(a, d)", true)).
contains(variable(11), value("on(a, e)", true)).
contains(variable(11), value("on(a, f)", true)).
contains(variable(11), value("on(a, g)", true)).
contains(variable(11), value("on(a, h)", true)).
contains(variable(11), value("on(a, i)", true)).
contains(variable(11), value("ontable(a)", true)).

variable(variable(12)).
contains(variable(12), value("holding(b)", true)).
contains(variable(12), value("on(b, a)", true)).
contains(variable(12), value("on(b, c)", true)).
contains(variable(12), value("on(b, d)", true)).
contains(variable(12), value("on(b, e)", true)).
contains(variable(12), value("on(b, f)", true)).
contains(variable(12), value("on(b, g)", true)).
contains(variable(12), value("on(b, h)", true)).
contains(variable(12), value("on(b, i)", true)).
contains(variable(12), value("ontable(b)", true)).

variable(variable(13)).
contains(variable(13), value("holding(c)", true)).
contains(variable(13), value("on(c, a)", true)).
contains(variable(13), value("on(c, b)", true)).
contains(variable(13), value("on(c, d)", true)).
contains(variable(13), value("on(c, e)", true)).
contains(variable(13), value("on(c, f)", true)).
contains(variable(13), value("on(c, g)", true)).
contains(variable(13), value("on(c, h)", true)).
contains(variable(13), value("on(c, i)", true)).
contains(variable(13), value("ontable(c)", true)).

variable(variable(14)).
contains(variable(14), value("holding(d)", true)).
contains(variable(14), value("on(d, a)", true)).
contains(variable(14), value("on(d, b)", true)).
contains(variable(14), value("on(d, c)", true)).
contains(variable(14), value("on(d, e)", true)).
contains(variable(14), value("on(d, f)", true)).
contains(variable(14), value("on(d, g)", true)).
contains(variable(14), value("on(d, h)", true)).
contains(variable(14), value("on(d, i)", true)).
contains(variable(14), value("ontable(d)", true)).

variable(variable(15)).
contains(variable(15), value("holding(e)", true)).
contains(variable(15), value("on(e, a)", true)).
contains(variable(15), value("on(e, b)", true)).
contains(variable(15), value("on(e, c)", true)).
contains(variable(15), value("on(e, d)", true)).
contains(variable(15), value("on(e, f)", true)).
contains(variable(15), value("on(e, g)", true)).
contains(variable(15), value("on(e, h)", true)).
contains(variable(15), value("on(e, i)", true)).
contains(variable(15), value("ontable(e)", true)).

variable(variable(16)).
contains(variable(16), value("holding(f)", true)).
contains(variable(16), value("on(f, a)", true)).
contains(variable(16), value("on(f, b)", true)).
contains(variable(16), value("on(f, c)", true)).
contains(variable(16), value("on(f, d)", true)).
contains(variable(16), value("on(f, e)", true)).
contains(variable(16), value("on(f, g)", true)).
contains(variable(16), value("on(f, h)", true)).
contains(variable(16), value("on(f, i)", true)).
contains(variable(16), value("ontable(f)", true)).

variable(variable(17)).
contains(variable(17), value("holding(g)", true)).
contains(variable(17), value("on(g, a)", true)).
contains(variable(17), value("on(g, b)", true)).
contains(variable(17), value("on(g, c)", true)).
contains(variable(17), value("on(g, d)", true)).
contains(variable(17), value("on(g, e)", true)).
contains(variable(17), value("on(g, f)", true)).
contains(variable(17), value("on(g, h)", true)).
contains(variable(17), value("on(g, i)", true)).
contains(variable(17), value("ontable(g)", true)).

variable(variable(18)).
contains(variable(18), value("holding(i)", true)).
contains(variable(18), value("on(i, a)", true)).
contains(variable(18), value("on(i, b)", true)).
contains(variable(18), value("on(i, c)", true)).
contains(variable(18), value("on(i, d)", true)).
contains(variable(18), value("on(i, e)", true)).
contains(variable(18), value("on(i, f)", true)).
contains(variable(18), value("on(i, g)", true)).
contains(variable(18), value("on(i, h)", true)).
contains(variable(18), value("ontable(i)", true)).

% actions
action(action(("pick-up", "a"))).
precondition(action(("pick-up", "a")), variable(2), value("clear(a)", true)).
precondition(action(("pick-up", "a")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "a")), variable(11), value("ontable(a)", true)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "a")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("pick-up", "a")), 1).

action(action(("pick-up", "b"))).
precondition(action(("pick-up", "b")), variable(3), value("clear(b)", true)).
precondition(action(("pick-up", "b")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "b")), variable(12), value("ontable(b)", true)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "b")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("pick-up", "b")), 1).

action(action(("pick-up", "c"))).
precondition(action(("pick-up", "c")), variable(4), value("clear(c)", true)).
precondition(action(("pick-up", "c")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "c")), variable(13), value("ontable(c)", true)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "c")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("pick-up", "c")), 1).

action(action(("pick-up", "d"))).
precondition(action(("pick-up", "d")), variable(5), value("clear(d)", true)).
precondition(action(("pick-up", "d")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "d")), variable(14), value("ontable(d)", true)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "d")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("pick-up", "d")), 1).

action(action(("pick-up", "e"))).
precondition(action(("pick-up", "e")), variable(6), value("clear(e)", true)).
precondition(action(("pick-up", "e")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "e")), variable(15), value("ontable(e)", true)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "e")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("pick-up", "e")), 1).

action(action(("pick-up", "f"))).
precondition(action(("pick-up", "f")), variable(7), value("clear(f)", true)).
precondition(action(("pick-up", "f")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "f")), variable(16), value("ontable(f)", true)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "f")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("pick-up", "f")), 1).

action(action(("pick-up", "g"))).
precondition(action(("pick-up", "g")), variable(8), value("clear(g)", true)).
precondition(action(("pick-up", "g")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "g")), variable(17), value("ontable(g)", true)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "g")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("pick-up", "g")), 1).

action(action(("pick-up", "h"))).
precondition(action(("pick-up", "h")), variable(1), value("clear(h)", true)).
precondition(action(("pick-up", "h")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "h")), variable(0), value("ontable(h)", true)).
postcondition(action(("pick-up", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("pick-up", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "h")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("pick-up", "h")), 1).

action(action(("pick-up", "i"))).
precondition(action(("pick-up", "i")), variable(9), value("clear(i)", true)).
precondition(action(("pick-up", "i")), variable(10), value("handempty", true)).
precondition(action(("pick-up", "i")), variable(18), value("ontable(i)", true)).
postcondition(action(("pick-up", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("pick-up", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("pick-up", "i")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("pick-up", "i")), 1).

action(action(("put-down", "a"))).
precondition(action(("put-down", "a")), variable(11), value("holding(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "a")), effect(unconditional), variable(11), value("ontable(a)", true)).
costs(action(("put-down", "a")), 1).

action(action(("put-down", "b"))).
precondition(action(("put-down", "b")), variable(12), value("holding(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "b")), effect(unconditional), variable(12), value("ontable(b)", true)).
costs(action(("put-down", "b")), 1).

action(action(("put-down", "c"))).
precondition(action(("put-down", "c")), variable(13), value("holding(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "c")), effect(unconditional), variable(13), value("ontable(c)", true)).
costs(action(("put-down", "c")), 1).

action(action(("put-down", "d"))).
precondition(action(("put-down", "d")), variable(14), value("holding(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "d")), effect(unconditional), variable(14), value("ontable(d)", true)).
costs(action(("put-down", "d")), 1).

action(action(("put-down", "e"))).
precondition(action(("put-down", "e")), variable(15), value("holding(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "e")), effect(unconditional), variable(15), value("ontable(e)", true)).
costs(action(("put-down", "e")), 1).

action(action(("put-down", "f"))).
precondition(action(("put-down", "f")), variable(16), value("holding(f)", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "f")), effect(unconditional), variable(16), value("ontable(f)", true)).
costs(action(("put-down", "f")), 1).

action(action(("put-down", "g"))).
precondition(action(("put-down", "g")), variable(17), value("holding(g)", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "g")), effect(unconditional), variable(17), value("ontable(g)", true)).
costs(action(("put-down", "g")), 1).

action(action(("put-down", "h"))).
precondition(action(("put-down", "h")), variable(0), value("holding(h)", true)).
postcondition(action(("put-down", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("put-down", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "h")), effect(unconditional), variable(0), value("ontable(h)", true)).
costs(action(("put-down", "h")), 1).

action(action(("put-down", "i"))).
precondition(action(("put-down", "i")), variable(18), value("holding(i)", true)).
postcondition(action(("put-down", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("put-down", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("put-down", "i")), effect(unconditional), variable(18), value("ontable(i)", true)).
costs(action(("put-down", "i")), 1).

action(action(("stack", "a", "b"))).
precondition(action(("stack", "a", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "a", "b")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "b")), effect(unconditional), variable(11), value("on(a, b)", true)).
costs(action(("stack", "a", "b")), 1).

action(action(("stack", "a", "c"))).
precondition(action(("stack", "a", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "a", "c")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "c")), effect(unconditional), variable(11), value("on(a, c)", true)).
costs(action(("stack", "a", "c")), 1).

action(action(("stack", "a", "d"))).
precondition(action(("stack", "a", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "a", "d")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "d")), effect(unconditional), variable(11), value("on(a, d)", true)).
costs(action(("stack", "a", "d")), 1).

action(action(("stack", "a", "e"))).
precondition(action(("stack", "a", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "a", "e")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "e")), effect(unconditional), variable(11), value("on(a, e)", true)).
costs(action(("stack", "a", "e")), 1).

action(action(("stack", "a", "f"))).
precondition(action(("stack", "a", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "a", "f")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "f")), effect(unconditional), variable(11), value("on(a, f)", true)).
costs(action(("stack", "a", "f")), 1).

action(action(("stack", "a", "g"))).
precondition(action(("stack", "a", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "a", "g")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "g")), effect(unconditional), variable(11), value("on(a, g)", true)).
costs(action(("stack", "a", "g")), 1).

action(action(("stack", "a", "h"))).
precondition(action(("stack", "a", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "a", "h")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "h")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "a", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "h")), effect(unconditional), variable(11), value("on(a, h)", true)).
costs(action(("stack", "a", "h")), 1).

action(action(("stack", "a", "i"))).
precondition(action(("stack", "a", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "a", "i")), variable(11), value("holding(a)", true)).
postcondition(action(("stack", "a", "i")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("stack", "a", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "a", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "a", "i")), effect(unconditional), variable(11), value("on(a, i)", true)).
costs(action(("stack", "a", "i")), 1).

action(action(("stack", "b", "a"))).
precondition(action(("stack", "b", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "b", "a")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "a")), effect(unconditional), variable(12), value("on(b, a)", true)).
costs(action(("stack", "b", "a")), 1).

action(action(("stack", "b", "c"))).
precondition(action(("stack", "b", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "b", "c")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "c")), effect(unconditional), variable(12), value("on(b, c)", true)).
costs(action(("stack", "b", "c")), 1).

action(action(("stack", "b", "d"))).
precondition(action(("stack", "b", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "b", "d")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "d")), effect(unconditional), variable(12), value("on(b, d)", true)).
costs(action(("stack", "b", "d")), 1).

action(action(("stack", "b", "e"))).
precondition(action(("stack", "b", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "b", "e")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "e")), effect(unconditional), variable(12), value("on(b, e)", true)).
costs(action(("stack", "b", "e")), 1).

action(action(("stack", "b", "f"))).
precondition(action(("stack", "b", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "b", "f")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "f")), effect(unconditional), variable(12), value("on(b, f)", true)).
costs(action(("stack", "b", "f")), 1).

action(action(("stack", "b", "g"))).
precondition(action(("stack", "b", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "b", "g")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "g")), effect(unconditional), variable(12), value("on(b, g)", true)).
costs(action(("stack", "b", "g")), 1).

action(action(("stack", "b", "h"))).
precondition(action(("stack", "b", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "b", "h")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "h")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "b", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "h")), effect(unconditional), variable(12), value("on(b, h)", true)).
costs(action(("stack", "b", "h")), 1).

action(action(("stack", "b", "i"))).
precondition(action(("stack", "b", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "b", "i")), variable(12), value("holding(b)", true)).
postcondition(action(("stack", "b", "i")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("stack", "b", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "b", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "b", "i")), effect(unconditional), variable(12), value("on(b, i)", true)).
costs(action(("stack", "b", "i")), 1).

action(action(("stack", "c", "a"))).
precondition(action(("stack", "c", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "c", "a")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "a")), effect(unconditional), variable(13), value("on(c, a)", true)).
costs(action(("stack", "c", "a")), 1).

action(action(("stack", "c", "b"))).
precondition(action(("stack", "c", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "c", "b")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "b")), effect(unconditional), variable(13), value("on(c, b)", true)).
costs(action(("stack", "c", "b")), 1).

action(action(("stack", "c", "d"))).
precondition(action(("stack", "c", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "c", "d")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "d")), effect(unconditional), variable(13), value("on(c, d)", true)).
costs(action(("stack", "c", "d")), 1).

action(action(("stack", "c", "e"))).
precondition(action(("stack", "c", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "c", "e")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "e")), effect(unconditional), variable(13), value("on(c, e)", true)).
costs(action(("stack", "c", "e")), 1).

action(action(("stack", "c", "f"))).
precondition(action(("stack", "c", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "c", "f")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "f")), effect(unconditional), variable(13), value("on(c, f)", true)).
costs(action(("stack", "c", "f")), 1).

action(action(("stack", "c", "g"))).
precondition(action(("stack", "c", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "c", "g")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "g")), effect(unconditional), variable(13), value("on(c, g)", true)).
costs(action(("stack", "c", "g")), 1).

action(action(("stack", "c", "h"))).
precondition(action(("stack", "c", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "c", "h")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "h")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "c", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "h")), effect(unconditional), variable(13), value("on(c, h)", true)).
costs(action(("stack", "c", "h")), 1).

action(action(("stack", "c", "i"))).
precondition(action(("stack", "c", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "c", "i")), variable(13), value("holding(c)", true)).
postcondition(action(("stack", "c", "i")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("stack", "c", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "c", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "c", "i")), effect(unconditional), variable(13), value("on(c, i)", true)).
costs(action(("stack", "c", "i")), 1).

action(action(("stack", "d", "a"))).
precondition(action(("stack", "d", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "d", "a")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "a")), effect(unconditional), variable(14), value("on(d, a)", true)).
costs(action(("stack", "d", "a")), 1).

action(action(("stack", "d", "b"))).
precondition(action(("stack", "d", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "d", "b")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "b")), effect(unconditional), variable(14), value("on(d, b)", true)).
costs(action(("stack", "d", "b")), 1).

action(action(("stack", "d", "c"))).
precondition(action(("stack", "d", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "d", "c")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "c")), effect(unconditional), variable(14), value("on(d, c)", true)).
costs(action(("stack", "d", "c")), 1).

action(action(("stack", "d", "e"))).
precondition(action(("stack", "d", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "d", "e")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "e")), effect(unconditional), variable(14), value("on(d, e)", true)).
costs(action(("stack", "d", "e")), 1).

action(action(("stack", "d", "f"))).
precondition(action(("stack", "d", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "d", "f")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "f")), effect(unconditional), variable(14), value("on(d, f)", true)).
costs(action(("stack", "d", "f")), 1).

action(action(("stack", "d", "g"))).
precondition(action(("stack", "d", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "d", "g")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "g")), effect(unconditional), variable(14), value("on(d, g)", true)).
costs(action(("stack", "d", "g")), 1).

action(action(("stack", "d", "h"))).
precondition(action(("stack", "d", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "d", "h")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "h")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "d", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "h")), effect(unconditional), variable(14), value("on(d, h)", true)).
costs(action(("stack", "d", "h")), 1).

action(action(("stack", "d", "i"))).
precondition(action(("stack", "d", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "d", "i")), variable(14), value("holding(d)", true)).
postcondition(action(("stack", "d", "i")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("stack", "d", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "d", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "d", "i")), effect(unconditional), variable(14), value("on(d, i)", true)).
costs(action(("stack", "d", "i")), 1).

action(action(("stack", "e", "a"))).
precondition(action(("stack", "e", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "e", "a")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "a")), effect(unconditional), variable(15), value("on(e, a)", true)).
costs(action(("stack", "e", "a")), 1).

action(action(("stack", "e", "b"))).
precondition(action(("stack", "e", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "e", "b")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "b")), effect(unconditional), variable(15), value("on(e, b)", true)).
costs(action(("stack", "e", "b")), 1).

action(action(("stack", "e", "c"))).
precondition(action(("stack", "e", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "e", "c")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "c")), effect(unconditional), variable(15), value("on(e, c)", true)).
costs(action(("stack", "e", "c")), 1).

action(action(("stack", "e", "d"))).
precondition(action(("stack", "e", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "e", "d")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "d")), effect(unconditional), variable(15), value("on(e, d)", true)).
costs(action(("stack", "e", "d")), 1).

action(action(("stack", "e", "f"))).
precondition(action(("stack", "e", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "e", "f")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "f")), effect(unconditional), variable(15), value("on(e, f)", true)).
costs(action(("stack", "e", "f")), 1).

action(action(("stack", "e", "g"))).
precondition(action(("stack", "e", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "e", "g")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "g")), effect(unconditional), variable(15), value("on(e, g)", true)).
costs(action(("stack", "e", "g")), 1).

action(action(("stack", "e", "h"))).
precondition(action(("stack", "e", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "e", "h")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "h")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "e", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "h")), effect(unconditional), variable(15), value("on(e, h)", true)).
costs(action(("stack", "e", "h")), 1).

action(action(("stack", "e", "i"))).
precondition(action(("stack", "e", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "e", "i")), variable(15), value("holding(e)", true)).
postcondition(action(("stack", "e", "i")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("stack", "e", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "e", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "e", "i")), effect(unconditional), variable(15), value("on(e, i)", true)).
costs(action(("stack", "e", "i")), 1).

action(action(("stack", "f", "a"))).
precondition(action(("stack", "f", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "f", "a")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "a")), effect(unconditional), variable(16), value("on(f, a)", true)).
costs(action(("stack", "f", "a")), 1).

action(action(("stack", "f", "b"))).
precondition(action(("stack", "f", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "f", "b")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "b")), effect(unconditional), variable(16), value("on(f, b)", true)).
costs(action(("stack", "f", "b")), 1).

action(action(("stack", "f", "c"))).
precondition(action(("stack", "f", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "f", "c")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "c")), effect(unconditional), variable(16), value("on(f, c)", true)).
costs(action(("stack", "f", "c")), 1).

action(action(("stack", "f", "d"))).
precondition(action(("stack", "f", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "f", "d")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "d")), effect(unconditional), variable(16), value("on(f, d)", true)).
costs(action(("stack", "f", "d")), 1).

action(action(("stack", "f", "e"))).
precondition(action(("stack", "f", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "f", "e")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "e")), effect(unconditional), variable(16), value("on(f, e)", true)).
costs(action(("stack", "f", "e")), 1).

action(action(("stack", "f", "g"))).
precondition(action(("stack", "f", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "f", "g")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "g")), effect(unconditional), variable(16), value("on(f, g)", true)).
costs(action(("stack", "f", "g")), 1).

action(action(("stack", "f", "h"))).
precondition(action(("stack", "f", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "f", "h")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "h")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "f", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "h")), effect(unconditional), variable(16), value("on(f, h)", true)).
costs(action(("stack", "f", "h")), 1).

action(action(("stack", "f", "i"))).
precondition(action(("stack", "f", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "f", "i")), variable(16), value("holding(f)", true)).
postcondition(action(("stack", "f", "i")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("stack", "f", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "f", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "f", "i")), effect(unconditional), variable(16), value("on(f, i)", true)).
costs(action(("stack", "f", "i")), 1).

action(action(("stack", "g", "a"))).
precondition(action(("stack", "g", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "g", "a")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "a")), effect(unconditional), variable(17), value("on(g, a)", true)).
costs(action(("stack", "g", "a")), 1).

action(action(("stack", "g", "b"))).
precondition(action(("stack", "g", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "g", "b")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "b")), effect(unconditional), variable(17), value("on(g, b)", true)).
costs(action(("stack", "g", "b")), 1).

action(action(("stack", "g", "c"))).
precondition(action(("stack", "g", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "g", "c")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "c")), effect(unconditional), variable(17), value("on(g, c)", true)).
costs(action(("stack", "g", "c")), 1).

action(action(("stack", "g", "d"))).
precondition(action(("stack", "g", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "g", "d")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "d")), effect(unconditional), variable(17), value("on(g, d)", true)).
costs(action(("stack", "g", "d")), 1).

action(action(("stack", "g", "e"))).
precondition(action(("stack", "g", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "g", "e")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "e")), effect(unconditional), variable(17), value("on(g, e)", true)).
costs(action(("stack", "g", "e")), 1).

action(action(("stack", "g", "f"))).
precondition(action(("stack", "g", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "g", "f")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "f")), effect(unconditional), variable(17), value("on(g, f)", true)).
costs(action(("stack", "g", "f")), 1).

action(action(("stack", "g", "h"))).
precondition(action(("stack", "g", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "g", "h")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "h")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "g", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "h")), effect(unconditional), variable(17), value("on(g, h)", true)).
costs(action(("stack", "g", "h")), 1).

action(action(("stack", "g", "i"))).
precondition(action(("stack", "g", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "g", "i")), variable(17), value("holding(g)", true)).
postcondition(action(("stack", "g", "i")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("stack", "g", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "g", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "g", "i")), effect(unconditional), variable(17), value("on(g, i)", true)).
costs(action(("stack", "g", "i")), 1).

action(action(("stack", "h", "a"))).
precondition(action(("stack", "h", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "h", "a")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "h", "a")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "a")), effect(unconditional), variable(0), value("on(h, a)", true)).
costs(action(("stack", "h", "a")), 1).

action(action(("stack", "h", "b"))).
precondition(action(("stack", "h", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "h", "b")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "h", "b")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "b")), effect(unconditional), variable(0), value("on(h, b)", true)).
costs(action(("stack", "h", "b")), 1).

action(action(("stack", "h", "c"))).
precondition(action(("stack", "h", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "h", "c")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "h", "c")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "c")), effect(unconditional), variable(0), value("on(h, c)", true)).
costs(action(("stack", "h", "c")), 1).

action(action(("stack", "h", "d"))).
precondition(action(("stack", "h", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "h", "d")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "h", "d")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "d")), effect(unconditional), variable(0), value("on(h, d)", true)).
costs(action(("stack", "h", "d")), 1).

action(action(("stack", "h", "e"))).
precondition(action(("stack", "h", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "h", "e")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "h", "e")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "e")), effect(unconditional), variable(0), value("on(h, e)", true)).
costs(action(("stack", "h", "e")), 1).

action(action(("stack", "h", "f"))).
precondition(action(("stack", "h", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "h", "f")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "h", "f")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "f")), effect(unconditional), variable(0), value("on(h, f)", true)).
costs(action(("stack", "h", "f")), 1).

action(action(("stack", "h", "g"))).
precondition(action(("stack", "h", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "h", "g")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "h", "g")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "g")), effect(unconditional), variable(0), value("on(h, g)", true)).
costs(action(("stack", "h", "g")), 1).

action(action(("stack", "h", "i"))).
precondition(action(("stack", "h", "i")), variable(9), value("clear(i)", true)).
precondition(action(("stack", "h", "i")), variable(0), value("holding(h)", true)).
postcondition(action(("stack", "h", "i")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("stack", "h", "i")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("stack", "h", "i")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "h", "i")), effect(unconditional), variable(0), value("on(h, i)", true)).
costs(action(("stack", "h", "i")), 1).

action(action(("stack", "i", "a"))).
precondition(action(("stack", "i", "a")), variable(2), value("clear(a)", true)).
precondition(action(("stack", "i", "a")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "a")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("stack", "i", "a")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "a")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "a")), effect(unconditional), variable(18), value("on(i, a)", true)).
costs(action(("stack", "i", "a")), 1).

action(action(("stack", "i", "b"))).
precondition(action(("stack", "i", "b")), variable(3), value("clear(b)", true)).
precondition(action(("stack", "i", "b")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "b")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("stack", "i", "b")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "b")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "b")), effect(unconditional), variable(18), value("on(i, b)", true)).
costs(action(("stack", "i", "b")), 1).

action(action(("stack", "i", "c"))).
precondition(action(("stack", "i", "c")), variable(4), value("clear(c)", true)).
precondition(action(("stack", "i", "c")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "c")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("stack", "i", "c")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "c")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "c")), effect(unconditional), variable(18), value("on(i, c)", true)).
costs(action(("stack", "i", "c")), 1).

action(action(("stack", "i", "d"))).
precondition(action(("stack", "i", "d")), variable(5), value("clear(d)", true)).
precondition(action(("stack", "i", "d")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "d")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("stack", "i", "d")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "d")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "d")), effect(unconditional), variable(18), value("on(i, d)", true)).
costs(action(("stack", "i", "d")), 1).

action(action(("stack", "i", "e"))).
precondition(action(("stack", "i", "e")), variable(6), value("clear(e)", true)).
precondition(action(("stack", "i", "e")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "e")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("stack", "i", "e")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "e")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "e")), effect(unconditional), variable(18), value("on(i, e)", true)).
costs(action(("stack", "i", "e")), 1).

action(action(("stack", "i", "f"))).
precondition(action(("stack", "i", "f")), variable(7), value("clear(f)", true)).
precondition(action(("stack", "i", "f")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "f")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("stack", "i", "f")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "f")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "f")), effect(unconditional), variable(18), value("on(i, f)", true)).
costs(action(("stack", "i", "f")), 1).

action(action(("stack", "i", "g"))).
precondition(action(("stack", "i", "g")), variable(8), value("clear(g)", true)).
precondition(action(("stack", "i", "g")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "g")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("stack", "i", "g")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "g")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "g")), effect(unconditional), variable(18), value("on(i, g)", true)).
costs(action(("stack", "i", "g")), 1).

action(action(("stack", "i", "h"))).
precondition(action(("stack", "i", "h")), variable(1), value("clear(h)", true)).
precondition(action(("stack", "i", "h")), variable(18), value("holding(i)", true)).
postcondition(action(("stack", "i", "h")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("stack", "i", "h")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("stack", "i", "h")), effect(unconditional), variable(10), value("handempty", true)).
postcondition(action(("stack", "i", "h")), effect(unconditional), variable(18), value("on(i, h)", true)).
costs(action(("stack", "i", "h")), 1).

action(action(("unstack", "a", "b"))).
precondition(action(("unstack", "a", "b")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "b")), variable(11), value("on(a, b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "b")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "b")), 1).

action(action(("unstack", "a", "c"))).
precondition(action(("unstack", "a", "c")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "c")), variable(11), value("on(a, c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "c")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "c")), 1).

action(action(("unstack", "a", "d"))).
precondition(action(("unstack", "a", "d")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "d")), variable(11), value("on(a, d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "d")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "d")), 1).

action(action(("unstack", "a", "e"))).
precondition(action(("unstack", "a", "e")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "e")), variable(11), value("on(a, e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "e")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "e")), 1).

action(action(("unstack", "a", "f"))).
precondition(action(("unstack", "a", "f")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "f")), variable(11), value("on(a, f)", true)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "f")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "f")), 1).

action(action(("unstack", "a", "g"))).
precondition(action(("unstack", "a", "g")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "g")), variable(11), value("on(a, g)", true)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "g")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "g")), 1).

action(action(("unstack", "a", "h"))).
precondition(action(("unstack", "a", "h")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "h")), variable(11), value("on(a, h)", true)).
postcondition(action(("unstack", "a", "h")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "a", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "h")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "h")), 1).

action(action(("unstack", "a", "i"))).
precondition(action(("unstack", "a", "i")), variable(2), value("clear(a)", true)).
precondition(action(("unstack", "a", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "a", "i")), variable(11), value("on(a, i)", true)).
postcondition(action(("unstack", "a", "i")), effect(unconditional), variable(2), value("clear(a)", false)).
postcondition(action(("unstack", "a", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "a", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "a", "i")), effect(unconditional), variable(11), value("holding(a)", true)).
costs(action(("unstack", "a", "i")), 1).

action(action(("unstack", "b", "a"))).
precondition(action(("unstack", "b", "a")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "a")), variable(12), value("on(b, a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "a")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "a")), 1).

action(action(("unstack", "b", "c"))).
precondition(action(("unstack", "b", "c")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "c")), variable(12), value("on(b, c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "c")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "c")), 1).

action(action(("unstack", "b", "d"))).
precondition(action(("unstack", "b", "d")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "d")), variable(12), value("on(b, d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "d")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "d")), 1).

action(action(("unstack", "b", "e"))).
precondition(action(("unstack", "b", "e")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "e")), variable(12), value("on(b, e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "e")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "e")), 1).

action(action(("unstack", "b", "f"))).
precondition(action(("unstack", "b", "f")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "f")), variable(12), value("on(b, f)", true)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "f")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "f")), 1).

action(action(("unstack", "b", "g"))).
precondition(action(("unstack", "b", "g")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "g")), variable(12), value("on(b, g)", true)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "g")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "g")), 1).

action(action(("unstack", "b", "h"))).
precondition(action(("unstack", "b", "h")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "h")), variable(12), value("on(b, h)", true)).
postcondition(action(("unstack", "b", "h")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "b", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "h")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "h")), 1).

action(action(("unstack", "b", "i"))).
precondition(action(("unstack", "b", "i")), variable(3), value("clear(b)", true)).
precondition(action(("unstack", "b", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "b", "i")), variable(12), value("on(b, i)", true)).
postcondition(action(("unstack", "b", "i")), effect(unconditional), variable(3), value("clear(b)", false)).
postcondition(action(("unstack", "b", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "b", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "b", "i")), effect(unconditional), variable(12), value("holding(b)", true)).
costs(action(("unstack", "b", "i")), 1).

action(action(("unstack", "c", "a"))).
precondition(action(("unstack", "c", "a")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "a")), variable(13), value("on(c, a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "a")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "a")), 1).

action(action(("unstack", "c", "b"))).
precondition(action(("unstack", "c", "b")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "b")), variable(13), value("on(c, b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "b")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "b")), 1).

action(action(("unstack", "c", "d"))).
precondition(action(("unstack", "c", "d")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "d")), variable(13), value("on(c, d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "d")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "d")), 1).

action(action(("unstack", "c", "e"))).
precondition(action(("unstack", "c", "e")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "e")), variable(13), value("on(c, e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "e")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "e")), 1).

action(action(("unstack", "c", "f"))).
precondition(action(("unstack", "c", "f")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "f")), variable(13), value("on(c, f)", true)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "f")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "f")), 1).

action(action(("unstack", "c", "g"))).
precondition(action(("unstack", "c", "g")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "g")), variable(13), value("on(c, g)", true)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "g")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "g")), 1).

action(action(("unstack", "c", "h"))).
precondition(action(("unstack", "c", "h")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "h")), variable(13), value("on(c, h)", true)).
postcondition(action(("unstack", "c", "h")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "c", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "h")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "h")), 1).

action(action(("unstack", "c", "i"))).
precondition(action(("unstack", "c", "i")), variable(4), value("clear(c)", true)).
precondition(action(("unstack", "c", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "c", "i")), variable(13), value("on(c, i)", true)).
postcondition(action(("unstack", "c", "i")), effect(unconditional), variable(4), value("clear(c)", false)).
postcondition(action(("unstack", "c", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "c", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "c", "i")), effect(unconditional), variable(13), value("holding(c)", true)).
costs(action(("unstack", "c", "i")), 1).

action(action(("unstack", "d", "a"))).
precondition(action(("unstack", "d", "a")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "a")), variable(14), value("on(d, a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "a")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "a")), 1).

action(action(("unstack", "d", "b"))).
precondition(action(("unstack", "d", "b")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "b")), variable(14), value("on(d, b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "b")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "b")), 1).

action(action(("unstack", "d", "c"))).
precondition(action(("unstack", "d", "c")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "c")), variable(14), value("on(d, c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "c")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "c")), 1).

action(action(("unstack", "d", "e"))).
precondition(action(("unstack", "d", "e")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "e")), variable(14), value("on(d, e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "e")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "e")), 1).

action(action(("unstack", "d", "f"))).
precondition(action(("unstack", "d", "f")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "f")), variable(14), value("on(d, f)", true)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "f")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "f")), 1).

action(action(("unstack", "d", "g"))).
precondition(action(("unstack", "d", "g")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "g")), variable(14), value("on(d, g)", true)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "g")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "g")), 1).

action(action(("unstack", "d", "h"))).
precondition(action(("unstack", "d", "h")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "h")), variable(14), value("on(d, h)", true)).
postcondition(action(("unstack", "d", "h")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "d", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "h")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "h")), 1).

action(action(("unstack", "d", "i"))).
precondition(action(("unstack", "d", "i")), variable(5), value("clear(d)", true)).
precondition(action(("unstack", "d", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "d", "i")), variable(14), value("on(d, i)", true)).
postcondition(action(("unstack", "d", "i")), effect(unconditional), variable(5), value("clear(d)", false)).
postcondition(action(("unstack", "d", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "d", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "d", "i")), effect(unconditional), variable(14), value("holding(d)", true)).
costs(action(("unstack", "d", "i")), 1).

action(action(("unstack", "e", "a"))).
precondition(action(("unstack", "e", "a")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "a")), variable(15), value("on(e, a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "a")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "a")), 1).

action(action(("unstack", "e", "b"))).
precondition(action(("unstack", "e", "b")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "b")), variable(15), value("on(e, b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "b")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "b")), 1).

action(action(("unstack", "e", "c"))).
precondition(action(("unstack", "e", "c")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "c")), variable(15), value("on(e, c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "c")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "c")), 1).

action(action(("unstack", "e", "d"))).
precondition(action(("unstack", "e", "d")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "d")), variable(15), value("on(e, d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "d")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "d")), 1).

action(action(("unstack", "e", "f"))).
precondition(action(("unstack", "e", "f")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "f")), variable(15), value("on(e, f)", true)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "f")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "f")), 1).

action(action(("unstack", "e", "g"))).
precondition(action(("unstack", "e", "g")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "g")), variable(15), value("on(e, g)", true)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "g")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "g")), 1).

action(action(("unstack", "e", "h"))).
precondition(action(("unstack", "e", "h")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "h")), variable(15), value("on(e, h)", true)).
postcondition(action(("unstack", "e", "h")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "e", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "h")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "h")), 1).

action(action(("unstack", "e", "i"))).
precondition(action(("unstack", "e", "i")), variable(6), value("clear(e)", true)).
precondition(action(("unstack", "e", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "e", "i")), variable(15), value("on(e, i)", true)).
postcondition(action(("unstack", "e", "i")), effect(unconditional), variable(6), value("clear(e)", false)).
postcondition(action(("unstack", "e", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "e", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "e", "i")), effect(unconditional), variable(15), value("holding(e)", true)).
costs(action(("unstack", "e", "i")), 1).

action(action(("unstack", "f", "a"))).
precondition(action(("unstack", "f", "a")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "a")), variable(16), value("on(f, a)", true)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "a")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "a")), 1).

action(action(("unstack", "f", "b"))).
precondition(action(("unstack", "f", "b")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "b")), variable(16), value("on(f, b)", true)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "b")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "b")), 1).

action(action(("unstack", "f", "c"))).
precondition(action(("unstack", "f", "c")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "c")), variable(16), value("on(f, c)", true)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "c")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "c")), 1).

action(action(("unstack", "f", "d"))).
precondition(action(("unstack", "f", "d")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "d")), variable(16), value("on(f, d)", true)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "d")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "d")), 1).

action(action(("unstack", "f", "e"))).
precondition(action(("unstack", "f", "e")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "e")), variable(16), value("on(f, e)", true)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "e")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "e")), 1).

action(action(("unstack", "f", "g"))).
precondition(action(("unstack", "f", "g")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "g")), variable(16), value("on(f, g)", true)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "g")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "g")), 1).

action(action(("unstack", "f", "h"))).
precondition(action(("unstack", "f", "h")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "h")), variable(16), value("on(f, h)", true)).
postcondition(action(("unstack", "f", "h")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "f", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "h")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "h")), 1).

action(action(("unstack", "f", "i"))).
precondition(action(("unstack", "f", "i")), variable(7), value("clear(f)", true)).
precondition(action(("unstack", "f", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "f", "i")), variable(16), value("on(f, i)", true)).
postcondition(action(("unstack", "f", "i")), effect(unconditional), variable(7), value("clear(f)", false)).
postcondition(action(("unstack", "f", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "f", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "f", "i")), effect(unconditional), variable(16), value("holding(f)", true)).
costs(action(("unstack", "f", "i")), 1).

action(action(("unstack", "g", "a"))).
precondition(action(("unstack", "g", "a")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "a")), variable(17), value("on(g, a)", true)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "a")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "a")), 1).

action(action(("unstack", "g", "b"))).
precondition(action(("unstack", "g", "b")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "b")), variable(17), value("on(g, b)", true)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "b")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "b")), 1).

action(action(("unstack", "g", "c"))).
precondition(action(("unstack", "g", "c")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "c")), variable(17), value("on(g, c)", true)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "c")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "c")), 1).

action(action(("unstack", "g", "d"))).
precondition(action(("unstack", "g", "d")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "d")), variable(17), value("on(g, d)", true)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "d")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "d")), 1).

action(action(("unstack", "g", "e"))).
precondition(action(("unstack", "g", "e")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "e")), variable(17), value("on(g, e)", true)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "e")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "e")), 1).

action(action(("unstack", "g", "f"))).
precondition(action(("unstack", "g", "f")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "f")), variable(17), value("on(g, f)", true)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "f")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "f")), 1).

action(action(("unstack", "g", "h"))).
precondition(action(("unstack", "g", "h")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "h")), variable(17), value("on(g, h)", true)).
postcondition(action(("unstack", "g", "h")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "g", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "h")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "h")), 1).

action(action(("unstack", "g", "i"))).
precondition(action(("unstack", "g", "i")), variable(8), value("clear(g)", true)).
precondition(action(("unstack", "g", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "g", "i")), variable(17), value("on(g, i)", true)).
postcondition(action(("unstack", "g", "i")), effect(unconditional), variable(8), value("clear(g)", false)).
postcondition(action(("unstack", "g", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "g", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "g", "i")), effect(unconditional), variable(17), value("holding(g)", true)).
costs(action(("unstack", "g", "i")), 1).

action(action(("unstack", "h", "a"))).
precondition(action(("unstack", "h", "a")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "a")), variable(0), value("on(h, a)", true)).
postcondition(action(("unstack", "h", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "h", "a")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "a")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "a")), 1).

action(action(("unstack", "h", "b"))).
precondition(action(("unstack", "h", "b")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "b")), variable(0), value("on(h, b)", true)).
postcondition(action(("unstack", "h", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "h", "b")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "b")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "b")), 1).

action(action(("unstack", "h", "c"))).
precondition(action(("unstack", "h", "c")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "c")), variable(0), value("on(h, c)", true)).
postcondition(action(("unstack", "h", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "h", "c")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "c")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "c")), 1).

action(action(("unstack", "h", "d"))).
precondition(action(("unstack", "h", "d")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "d")), variable(0), value("on(h, d)", true)).
postcondition(action(("unstack", "h", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "h", "d")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "d")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "d")), 1).

action(action(("unstack", "h", "e"))).
precondition(action(("unstack", "h", "e")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "e")), variable(0), value("on(h, e)", true)).
postcondition(action(("unstack", "h", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "h", "e")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "e")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "e")), 1).

action(action(("unstack", "h", "f"))).
precondition(action(("unstack", "h", "f")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "f")), variable(0), value("on(h, f)", true)).
postcondition(action(("unstack", "h", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "h", "f")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "f")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "f")), 1).

action(action(("unstack", "h", "g"))).
precondition(action(("unstack", "h", "g")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "g")), variable(0), value("on(h, g)", true)).
postcondition(action(("unstack", "h", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "h", "g")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "g")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "g")), 1).

action(action(("unstack", "h", "i"))).
precondition(action(("unstack", "h", "i")), variable(1), value("clear(h)", true)).
precondition(action(("unstack", "h", "i")), variable(10), value("handempty", true)).
precondition(action(("unstack", "h", "i")), variable(0), value("on(h, i)", true)).
postcondition(action(("unstack", "h", "i")), effect(unconditional), variable(1), value("clear(h)", false)).
postcondition(action(("unstack", "h", "i")), effect(unconditional), variable(9), value("clear(i)", true)).
postcondition(action(("unstack", "h", "i")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "h", "i")), effect(unconditional), variable(0), value("holding(h)", true)).
costs(action(("unstack", "h", "i")), 1).

action(action(("unstack", "i", "a"))).
precondition(action(("unstack", "i", "a")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "a")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "a")), variable(18), value("on(i, a)", true)).
postcondition(action(("unstack", "i", "a")), effect(unconditional), variable(2), value("clear(a)", true)).
postcondition(action(("unstack", "i", "a")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "a")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "a")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "a")), 1).

action(action(("unstack", "i", "b"))).
precondition(action(("unstack", "i", "b")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "b")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "b")), variable(18), value("on(i, b)", true)).
postcondition(action(("unstack", "i", "b")), effect(unconditional), variable(3), value("clear(b)", true)).
postcondition(action(("unstack", "i", "b")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "b")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "b")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "b")), 1).

action(action(("unstack", "i", "c"))).
precondition(action(("unstack", "i", "c")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "c")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "c")), variable(18), value("on(i, c)", true)).
postcondition(action(("unstack", "i", "c")), effect(unconditional), variable(4), value("clear(c)", true)).
postcondition(action(("unstack", "i", "c")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "c")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "c")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "c")), 1).

action(action(("unstack", "i", "d"))).
precondition(action(("unstack", "i", "d")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "d")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "d")), variable(18), value("on(i, d)", true)).
postcondition(action(("unstack", "i", "d")), effect(unconditional), variable(5), value("clear(d)", true)).
postcondition(action(("unstack", "i", "d")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "d")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "d")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "d")), 1).

action(action(("unstack", "i", "e"))).
precondition(action(("unstack", "i", "e")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "e")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "e")), variable(18), value("on(i, e)", true)).
postcondition(action(("unstack", "i", "e")), effect(unconditional), variable(6), value("clear(e)", true)).
postcondition(action(("unstack", "i", "e")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "e")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "e")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "e")), 1).

action(action(("unstack", "i", "f"))).
precondition(action(("unstack", "i", "f")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "f")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "f")), variable(18), value("on(i, f)", true)).
postcondition(action(("unstack", "i", "f")), effect(unconditional), variable(7), value("clear(f)", true)).
postcondition(action(("unstack", "i", "f")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "f")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "f")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "f")), 1).

action(action(("unstack", "i", "g"))).
precondition(action(("unstack", "i", "g")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "g")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "g")), variable(18), value("on(i, g)", true)).
postcondition(action(("unstack", "i", "g")), effect(unconditional), variable(8), value("clear(g)", true)).
postcondition(action(("unstack", "i", "g")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "g")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "g")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "g")), 1).

action(action(("unstack", "i", "h"))).
precondition(action(("unstack", "i", "h")), variable(9), value("clear(i)", true)).
precondition(action(("unstack", "i", "h")), variable(10), value("handempty", true)).
precondition(action(("unstack", "i", "h")), variable(18), value("on(i, h)", true)).
postcondition(action(("unstack", "i", "h")), effect(unconditional), variable(1), value("clear(h)", true)).
postcondition(action(("unstack", "i", "h")), effect(unconditional), variable(9), value("clear(i)", false)).
postcondition(action(("unstack", "i", "h")), effect(unconditional), variable(10), value("handempty", false)).
postcondition(action(("unstack", "i", "h")), effect(unconditional), variable(18), value("holding(i)", true)).
costs(action(("unstack", "i", "h")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(2), value("clear(a)", true)).
contains(mutexGroup(0), variable(11), value("holding(a)", true)).
contains(mutexGroup(0), variable(12), value("on(b, a)", true)).
contains(mutexGroup(0), variable(13), value("on(c, a)", true)).
contains(mutexGroup(0), variable(14), value("on(d, a)", true)).
contains(mutexGroup(0), variable(15), value("on(e, a)", true)).
contains(mutexGroup(0), variable(16), value("on(f, a)", true)).
contains(mutexGroup(0), variable(17), value("on(g, a)", true)).
contains(mutexGroup(0), variable(0), value("on(h, a)", true)).
contains(mutexGroup(0), variable(18), value("on(i, a)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(3), value("clear(b)", true)).
contains(mutexGroup(1), variable(11), value("on(a, b)", true)).
contains(mutexGroup(1), variable(12), value("holding(b)", true)).
contains(mutexGroup(1), variable(13), value("on(c, b)", true)).
contains(mutexGroup(1), variable(14), value("on(d, b)", true)).
contains(mutexGroup(1), variable(15), value("on(e, b)", true)).
contains(mutexGroup(1), variable(16), value("on(f, b)", true)).
contains(mutexGroup(1), variable(17), value("on(g, b)", true)).
contains(mutexGroup(1), variable(0), value("on(h, b)", true)).
contains(mutexGroup(1), variable(18), value("on(i, b)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(4), value("clear(c)", true)).
contains(mutexGroup(2), variable(11), value("on(a, c)", true)).
contains(mutexGroup(2), variable(12), value("on(b, c)", true)).
contains(mutexGroup(2), variable(13), value("holding(c)", true)).
contains(mutexGroup(2), variable(14), value("on(d, c)", true)).
contains(mutexGroup(2), variable(15), value("on(e, c)", true)).
contains(mutexGroup(2), variable(16), value("on(f, c)", true)).
contains(mutexGroup(2), variable(17), value("on(g, c)", true)).
contains(mutexGroup(2), variable(0), value("on(h, c)", true)).
contains(mutexGroup(2), variable(18), value("on(i, c)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(5), value("clear(d)", true)).
contains(mutexGroup(3), variable(11), value("on(a, d)", true)).
contains(mutexGroup(3), variable(12), value("on(b, d)", true)).
contains(mutexGroup(3), variable(13), value("on(c, d)", true)).
contains(mutexGroup(3), variable(14), value("holding(d)", true)).
contains(mutexGroup(3), variable(15), value("on(e, d)", true)).
contains(mutexGroup(3), variable(16), value("on(f, d)", true)).
contains(mutexGroup(3), variable(17), value("on(g, d)", true)).
contains(mutexGroup(3), variable(0), value("on(h, d)", true)).
contains(mutexGroup(3), variable(18), value("on(i, d)", true)).

mutexGroup(mutexGroup(4)).
contains(mutexGroup(4), variable(6), value("clear(e)", true)).
contains(mutexGroup(4), variable(11), value("on(a, e)", true)).
contains(mutexGroup(4), variable(12), value("on(b, e)", true)).
contains(mutexGroup(4), variable(13), value("on(c, e)", true)).
contains(mutexGroup(4), variable(14), value("on(d, e)", true)).
contains(mutexGroup(4), variable(15), value("holding(e)", true)).
contains(mutexGroup(4), variable(16), value("on(f, e)", true)).
contains(mutexGroup(4), variable(17), value("on(g, e)", true)).
contains(mutexGroup(4), variable(0), value("on(h, e)", true)).
contains(mutexGroup(4), variable(18), value("on(i, e)", true)).

mutexGroup(mutexGroup(5)).
contains(mutexGroup(5), variable(7), value("clear(f)", true)).
contains(mutexGroup(5), variable(11), value("on(a, f)", true)).
contains(mutexGroup(5), variable(12), value("on(b, f)", true)).
contains(mutexGroup(5), variable(13), value("on(c, f)", true)).
contains(mutexGroup(5), variable(14), value("on(d, f)", true)).
contains(mutexGroup(5), variable(15), value("on(e, f)", true)).
contains(mutexGroup(5), variable(16), value("holding(f)", true)).
contains(mutexGroup(5), variable(17), value("on(g, f)", true)).
contains(mutexGroup(5), variable(0), value("on(h, f)", true)).
contains(mutexGroup(5), variable(18), value("on(i, f)", true)).

mutexGroup(mutexGroup(6)).
contains(mutexGroup(6), variable(8), value("clear(g)", true)).
contains(mutexGroup(6), variable(11), value("on(a, g)", true)).
contains(mutexGroup(6), variable(12), value("on(b, g)", true)).
contains(mutexGroup(6), variable(13), value("on(c, g)", true)).
contains(mutexGroup(6), variable(14), value("on(d, g)", true)).
contains(mutexGroup(6), variable(15), value("on(e, g)", true)).
contains(mutexGroup(6), variable(16), value("on(f, g)", true)).
contains(mutexGroup(6), variable(17), value("holding(g)", true)).
contains(mutexGroup(6), variable(0), value("on(h, g)", true)).
contains(mutexGroup(6), variable(18), value("on(i, g)", true)).

mutexGroup(mutexGroup(7)).
contains(mutexGroup(7), variable(1), value("clear(h)", true)).
contains(mutexGroup(7), variable(11), value("on(a, h)", true)).
contains(mutexGroup(7), variable(12), value("on(b, h)", true)).
contains(mutexGroup(7), variable(13), value("on(c, h)", true)).
contains(mutexGroup(7), variable(14), value("on(d, h)", true)).
contains(mutexGroup(7), variable(15), value("on(e, h)", true)).
contains(mutexGroup(7), variable(16), value("on(f, h)", true)).
contains(mutexGroup(7), variable(17), value("on(g, h)", true)).
contains(mutexGroup(7), variable(0), value("holding(h)", true)).
contains(mutexGroup(7), variable(18), value("on(i, h)", true)).

mutexGroup(mutexGroup(8)).
contains(mutexGroup(8), variable(9), value("clear(i)", true)).
contains(mutexGroup(8), variable(11), value("on(a, i)", true)).
contains(mutexGroup(8), variable(12), value("on(b, i)", true)).
contains(mutexGroup(8), variable(13), value("on(c, i)", true)).
contains(mutexGroup(8), variable(14), value("on(d, i)", true)).
contains(mutexGroup(8), variable(15), value("on(e, i)", true)).
contains(mutexGroup(8), variable(16), value("on(f, i)", true)).
contains(mutexGroup(8), variable(17), value("on(g, i)", true)).
contains(mutexGroup(8), variable(0), value("on(h, i)", true)).
contains(mutexGroup(8), variable(18), value("holding(i)", true)).

mutexGroup(mutexGroup(9)).
contains(mutexGroup(9), variable(10), value("handempty", true)).
contains(mutexGroup(9), variable(11), value("holding(a)", true)).
contains(mutexGroup(9), variable(12), value("holding(b)", true)).
contains(mutexGroup(9), variable(13), value("holding(c)", true)).
contains(mutexGroup(9), variable(14), value("holding(d)", true)).
contains(mutexGroup(9), variable(15), value("holding(e)", true)).
contains(mutexGroup(9), variable(16), value("holding(f)", true)).
contains(mutexGroup(9), variable(17), value("holding(g)", true)).
contains(mutexGroup(9), variable(0), value("holding(h)", true)).
contains(mutexGroup(9), variable(18), value("holding(i)", true)).

% initial state
initialState(variable(0), value("on(h, b)", true)).
initialState(variable(1), value("clear(h)", false)).
initialState(variable(2), value("clear(a)", false)).
initialState(variable(3), value("clear(b)", false)).
initialState(variable(4), value("clear(c)", true)).
initialState(variable(5), value("clear(d)", false)).
initialState(variable(6), value("clear(e)", false)).
initialState(variable(7), value("clear(f)", true)).
initialState(variable(8), value("clear(g)", false)).
initialState(variable(9), value("clear(i)", false)).
initialState(variable(10), value("handempty", true)).
initialState(variable(11), value("on(a, i)", true)).
initialState(variable(12), value("ontable(b)", true)).
initialState(variable(13), value("ontable(c)", true)).
initialState(variable(14), value("on(d, h)", true)).
initialState(variable(15), value("on(e, a)", true)).
initialState(variable(16), value("on(f, g)", true)).
initialState(variable(17), value("on(g, e)", true)).
initialState(variable(18), value("on(i, d)", true)).

% goal
goal(variable(11), value("on(a, i)", true)).
goal(variable(12), value("on(b, c)", true)).
goal(variable(13), value("on(c, a)", true)).
goal(variable(14), value("on(d, b)", true)).
goal(variable(15), value("on(e, h)", true)).
goal(variable(16), value("on(f, e)", true)).
goal(variable(17), value("on(g, d)", true)).
goal(variable(18), value("on(i, f)", true)).
