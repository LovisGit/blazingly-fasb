#const horizon=9.

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shows all 'occurs' atoms.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#show occurs/2.
%---------------------------------------
% domain
%---------------------------------------

% utils
boolean(true).
boolean(false).

% types
type(type("place")).
inherits(type("place"), type("object")).
type(type("object")).

has(X, type(T2)) :- has(X, type(T1)), inherits(type(T1), type(T2)).

% variables
variable(variable(("connected", X1, X2))) :- has(X1, type("place")), has(X2, type("place")).
variable(variable(("at-robot", X1))) :- has(X1, type("place")).
variable(variable(("visited", X1))) :- has(X1, type("place")).

contains(X, value(X, B)) :- variable(X), boolean(B).

% actions
action(action(("move", X1, X2))) :- has(X1, type("place")), has(X2, type("place")).
precondition(action(("move", X1, X2)), variable(("at-robot", X1)), value(variable(("at-robot", X1)), true)) :- action(action(("move", X1, X2))).
precondition(action(("move", X1, X2)), variable(("connected", X1, X2)), value(variable(("connected", X1, X2)), true)) :- action(action(("move", X1, X2))).
postcondition(action(("move", X1, X2)), effect(unconditional), variable(("at-robot", X2)), value(variable(("at-robot", X2)), true)) :- action(action(("move", X1, X2))).
postcondition(action(("move", X1, X2)), effect(unconditional), variable(("at-robot", X1)), value(variable(("at-robot", X1)), false)) :- action(action(("move", X1, X2))).
postcondition(action(("move", X1, X2)), effect(unconditional), variable(("visited", X2)), value(variable(("visited", X2)), true)) :- action(action(("move", X1, X2))).

%---------------------------------------
% problem
%---------------------------------------

% objects
constant(constant("loc-x0-y0")).
has(constant("loc-x0-y0"), type("place")).

constant(constant("loc-x0-y1")).
has(constant("loc-x0-y1"), type("place")).

constant(constant("loc-x0-y2")).
has(constant("loc-x0-y2"), type("place")).

constant(constant("loc-x1-y0")).
has(constant("loc-x1-y0"), type("place")).

constant(constant("loc-x1-y1")).
has(constant("loc-x1-y1"), type("place")).

constant(constant("loc-x1-y2")).
has(constant("loc-x1-y2"), type("place")).

constant(constant("loc-x2-y0")).
has(constant("loc-x2-y0"), type("place")).

constant(constant("loc-x2-y1")).
has(constant("loc-x2-y1"), type("place")).

constant(constant("loc-x2-y2")).
has(constant("loc-x2-y2"), type("place")).

% initial state
initialState(variable(("at-robot", constant("loc-x1-y1"))), value(variable(("at-robot", constant("loc-x1-y1"))), true)).
initialState(variable(("visited", constant("loc-x1-y1"))), value(variable(("visited", constant("loc-x1-y1"))), true)).
initialState(variable(("connected", constant("loc-x0-y0"), constant("loc-x1-y0"))), value(variable(("connected", constant("loc-x0-y0"), constant("loc-x1-y0"))), true)).
initialState(variable(("connected", constant("loc-x0-y0"), constant("loc-x0-y1"))), value(variable(("connected", constant("loc-x0-y0"), constant("loc-x0-y1"))), true)).
initialState(variable(("connected", constant("loc-x0-y1"), constant("loc-x1-y1"))), value(variable(("connected", constant("loc-x0-y1"), constant("loc-x1-y1"))), true)).
initialState(variable(("connected", constant("loc-x0-y1"), constant("loc-x0-y0"))), value(variable(("connected", constant("loc-x0-y1"), constant("loc-x0-y0"))), true)).
initialState(variable(("connected", constant("loc-x0-y1"), constant("loc-x0-y2"))), value(variable(("connected", constant("loc-x0-y1"), constant("loc-x0-y2"))), true)).
initialState(variable(("connected", constant("loc-x0-y2"), constant("loc-x1-y2"))), value(variable(("connected", constant("loc-x0-y2"), constant("loc-x1-y2"))), true)).
initialState(variable(("connected", constant("loc-x0-y2"), constant("loc-x0-y1"))), value(variable(("connected", constant("loc-x0-y2"), constant("loc-x0-y1"))), true)).
initialState(variable(("connected", constant("loc-x1-y0"), constant("loc-x0-y0"))), value(variable(("connected", constant("loc-x1-y0"), constant("loc-x0-y0"))), true)).
initialState(variable(("connected", constant("loc-x1-y0"), constant("loc-x2-y0"))), value(variable(("connected", constant("loc-x1-y0"), constant("loc-x2-y0"))), true)).
initialState(variable(("connected", constant("loc-x1-y0"), constant("loc-x1-y1"))), value(variable(("connected", constant("loc-x1-y0"), constant("loc-x1-y1"))), true)).
initialState(variable(("connected", constant("loc-x1-y1"), constant("loc-x0-y1"))), value(variable(("connected", constant("loc-x1-y1"), constant("loc-x0-y1"))), true)).
initialState(variable(("connected", constant("loc-x1-y1"), constant("loc-x2-y1"))), value(variable(("connected", constant("loc-x1-y1"), constant("loc-x2-y1"))), true)).
initialState(variable(("connected", constant("loc-x1-y1"), constant("loc-x1-y0"))), value(variable(("connected", constant("loc-x1-y1"), constant("loc-x1-y0"))), true)).
initialState(variable(("connected", constant("loc-x1-y1"), constant("loc-x1-y2"))), value(variable(("connected", constant("loc-x1-y1"), constant("loc-x1-y2"))), true)).
initialState(variable(("connected", constant("loc-x1-y2"), constant("loc-x0-y2"))), value(variable(("connected", constant("loc-x1-y2"), constant("loc-x0-y2"))), true)).
initialState(variable(("connected", constant("loc-x1-y2"), constant("loc-x2-y2"))), value(variable(("connected", constant("loc-x1-y2"), constant("loc-x2-y2"))), true)).
initialState(variable(("connected", constant("loc-x1-y2"), constant("loc-x1-y1"))), value(variable(("connected", constant("loc-x1-y2"), constant("loc-x1-y1"))), true)).
initialState(variable(("connected", constant("loc-x2-y0"), constant("loc-x1-y0"))), value(variable(("connected", constant("loc-x2-y0"), constant("loc-x1-y0"))), true)).
initialState(variable(("connected", constant("loc-x2-y0"), constant("loc-x2-y1"))), value(variable(("connected", constant("loc-x2-y0"), constant("loc-x2-y1"))), true)).
initialState(variable(("connected", constant("loc-x2-y1"), constant("loc-x1-y1"))), value(variable(("connected", constant("loc-x2-y1"), constant("loc-x1-y1"))), true)).
initialState(variable(("connected", constant("loc-x2-y1"), constant("loc-x2-y0"))), value(variable(("connected", constant("loc-x2-y1"), constant("loc-x2-y0"))), true)).
initialState(variable(("connected", constant("loc-x2-y1"), constant("loc-x2-y2"))), value(variable(("connected", constant("loc-x2-y1"), constant("loc-x2-y2"))), true)).
initialState(variable(("connected", constant("loc-x2-y2"), constant("loc-x1-y2"))), value(variable(("connected", constant("loc-x2-y2"), constant("loc-x1-y2"))), true)).
initialState(variable(("connected", constant("loc-x2-y2"), constant("loc-x2-y1"))), value(variable(("connected", constant("loc-x2-y2"), constant("loc-x2-y1"))), true)).

initialState(X, value(X, false)) :- variable(X), not initialState(X, value(X, true)).

% goal
goal(variable(("visited", constant("loc-x0-y0"))), value(variable(("visited", constant("loc-x0-y0"))), true)).
goal(variable(("visited", constant("loc-x0-y1"))), value(variable(("visited", constant("loc-x0-y1"))), true)).
goal(variable(("visited", constant("loc-x0-y2"))), value(variable(("visited", constant("loc-x0-y2"))), true)).
goal(variable(("visited", constant("loc-x1-y0"))), value(variable(("visited", constant("loc-x1-y0"))), true)).
goal(variable(("visited", constant("loc-x1-y1"))), value(variable(("visited", constant("loc-x1-y1"))), true)).
goal(variable(("visited", constant("loc-x1-y2"))), value(variable(("visited", constant("loc-x1-y2"))), true)).
goal(variable(("visited", constant("loc-x2-y0"))), value(variable(("visited", constant("loc-x2-y0"))), true)).
goal(variable(("visited", constant("loc-x2-y1"))), value(variable(("visited", constant("loc-x2-y1"))), true)).
goal(variable(("visited", constant("loc-x2-y2"))), value(variable(("visited", constant("loc-x2-y2"))), true)).
