#const horizon=22.

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
type(type("object")).

% variables
variable(variable(("on", X1, X2))) :- has(X1, type("object")), has(X2, type("object")).
variable(variable(("ontable", X1))) :- has(X1, type("object")).
variable(variable(("clear", X1))) :- has(X1, type("object")).
variable(variable("handempty")).
variable(variable(("holding", X1))) :- has(X1, type("object")).

contains(X, value(X, B)) :- variable(X), boolean(B).

% actions
action(action(("pick-up", X1))) :- has(X1, type("object")).
precondition(action(("pick-up", X1)), variable(("clear", X1)), value(variable(("clear", X1)), true)) :- action(action(("pick-up", X1))).
precondition(action(("pick-up", X1)), variable(("ontable", X1)), value(variable(("ontable", X1)), true)) :- action(action(("pick-up", X1))).
precondition(action(("pick-up", X1)), variable("handempty"), value(variable("handempty"), true)) :- action(action(("pick-up", X1))).
postcondition(action(("pick-up", X1)), effect(unconditional), variable(("ontable", X1)), value(variable(("ontable", X1)), false)) :- action(action(("pick-up", X1))).
postcondition(action(("pick-up", X1)), effect(unconditional), variable(("clear", X1)), value(variable(("clear", X1)), false)) :- action(action(("pick-up", X1))).
postcondition(action(("pick-up", X1)), effect(unconditional), variable("handempty"), value(variable("handempty"), false)) :- action(action(("pick-up", X1))).
postcondition(action(("pick-up", X1)), effect(unconditional), variable(("holding", X1)), value(variable(("holding", X1)), true)) :- action(action(("pick-up", X1))).

action(action(("put-down", X1))) :- has(X1, type("object")).
precondition(action(("put-down", X1)), variable(("holding", X1)), value(variable(("holding", X1)), true)) :- action(action(("put-down", X1))).
postcondition(action(("put-down", X1)), effect(unconditional), variable(("holding", X1)), value(variable(("holding", X1)), false)) :- action(action(("put-down", X1))).
postcondition(action(("put-down", X1)), effect(unconditional), variable(("clear", X1)), value(variable(("clear", X1)), true)) :- action(action(("put-down", X1))).
postcondition(action(("put-down", X1)), effect(unconditional), variable("handempty"), value(variable("handempty"), true)) :- action(action(("put-down", X1))).
postcondition(action(("put-down", X1)), effect(unconditional), variable(("ontable", X1)), value(variable(("ontable", X1)), true)) :- action(action(("put-down", X1))).

action(action(("stack", X1, X2))) :- has(X1, type("object")), has(X2, type("object")).
precondition(action(("stack", X1, X2)), variable(("holding", X1)), value(variable(("holding", X1)), true)) :- action(action(("stack", X1, X2))).
precondition(action(("stack", X1, X2)), variable(("clear", X2)), value(variable(("clear", X2)), true)) :- action(action(("stack", X1, X2))).
postcondition(action(("stack", X1, X2)), effect(unconditional), variable(("holding", X1)), value(variable(("holding", X1)), false)) :- action(action(("stack", X1, X2))).
postcondition(action(("stack", X1, X2)), effect(unconditional), variable(("clear", X2)), value(variable(("clear", X2)), false)) :- action(action(("stack", X1, X2))).
postcondition(action(("stack", X1, X2)), effect(unconditional), variable(("clear", X1)), value(variable(("clear", X1)), true)) :- action(action(("stack", X1, X2))).
postcondition(action(("stack", X1, X2)), effect(unconditional), variable("handempty"), value(variable("handempty"), true)) :- action(action(("stack", X1, X2))).
postcondition(action(("stack", X1, X2)), effect(unconditional), variable(("on", X1, X2)), value(variable(("on", X1, X2)), true)) :- action(action(("stack", X1, X2))).

action(action(("unstack", X1, X2))) :- has(X1, type("object")), has(X2, type("object")).
precondition(action(("unstack", X1, X2)), variable(("on", X1, X2)), value(variable(("on", X1, X2)), true)) :- action(action(("unstack", X1, X2))).
precondition(action(("unstack", X1, X2)), variable(("clear", X1)), value(variable(("clear", X1)), true)) :- action(action(("unstack", X1, X2))).
precondition(action(("unstack", X1, X2)), variable("handempty"), value(variable("handempty"), true)) :- action(action(("unstack", X1, X2))).
postcondition(action(("unstack", X1, X2)), effect(unconditional), variable(("holding", X1)), value(variable(("holding", X1)), true)) :- action(action(("unstack", X1, X2))).
postcondition(action(("unstack", X1, X2)), effect(unconditional), variable(("clear", X2)), value(variable(("clear", X2)), true)) :- action(action(("unstack", X1, X2))).
postcondition(action(("unstack", X1, X2)), effect(unconditional), variable(("clear", X1)), value(variable(("clear", X1)), false)) :- action(action(("unstack", X1, X2))).
postcondition(action(("unstack", X1, X2)), effect(unconditional), variable("handempty"), value(variable("handempty"), false)) :- action(action(("unstack", X1, X2))).
postcondition(action(("unstack", X1, X2)), effect(unconditional), variable(("on", X1, X2)), value(variable(("on", X1, X2)), false)) :- action(action(("unstack", X1, X2))).

%---------------------------------------
% problem
%---------------------------------------

% objects
constant(constant("i")).
has(constant("i"), type("object")).

constant(constant("d")).
has(constant("d"), type("object")).

constant(constant("b")).
has(constant("b"), type("object")).

constant(constant("e")).
has(constant("e"), type("object")).

constant(constant("k")).
has(constant("k"), type("object")).

constant(constant("g")).
has(constant("g"), type("object")).

constant(constant("a")).
has(constant("a"), type("object")).

constant(constant("f")).
has(constant("f"), type("object")).

constant(constant("c")).
has(constant("c"), type("object")).

constant(constant("j")).
has(constant("j"), type("object")).

constant(constant("l")).
has(constant("l"), type("object")).

constant(constant("h")).
has(constant("h"), type("object")).

% initial state
initialState(variable(("clear", constant("h"))), value(variable(("clear", constant("h"))), true)).
initialState(variable(("clear", constant("l"))), value(variable(("clear", constant("l"))), true)).
initialState(variable(("clear", constant("j"))), value(variable(("clear", constant("j"))), true)).
initialState(variable(("ontable", constant("c"))), value(variable(("ontable", constant("c"))), true)).
initialState(variable(("ontable", constant("f"))), value(variable(("ontable", constant("f"))), true)).
initialState(variable(("ontable", constant("j"))), value(variable(("ontable", constant("j"))), true)).
initialState(variable(("on", constant("h"), constant("a"))), value(variable(("on", constant("h"), constant("a"))), true)).
initialState(variable(("on", constant("a"), constant("g"))), value(variable(("on", constant("a"), constant("g"))), true)).
initialState(variable(("on", constant("g"), constant("k"))), value(variable(("on", constant("g"), constant("k"))), true)).
initialState(variable(("on", constant("k"), constant("e"))), value(variable(("on", constant("k"), constant("e"))), true)).
initialState(variable(("on", constant("e"), constant("b"))), value(variable(("on", constant("e"), constant("b"))), true)).
initialState(variable(("on", constant("b"), constant("d"))), value(variable(("on", constant("b"), constant("d"))), true)).
initialState(variable(("on", constant("d"), constant("i"))), value(variable(("on", constant("d"), constant("i"))), true)).
initialState(variable(("on", constant("i"), constant("c"))), value(variable(("on", constant("i"), constant("c"))), true)).
initialState(variable(("on", constant("l"), constant("f"))), value(variable(("on", constant("l"), constant("f"))), true)).
initialState(variable("handempty"), value(variable("handempty"), true)).

initialState(X, value(X, false)) :- variable(X), not initialState(X, value(X, true)).

% goal
goal(variable(("on", constant("i"), constant("c"))), value(variable(("on", constant("i"), constant("c"))), true)).
goal(variable(("on", constant("c"), constant("b"))), value(variable(("on", constant("c"), constant("b"))), true)).
goal(variable(("on", constant("b"), constant("l"))), value(variable(("on", constant("b"), constant("l"))), true)).
goal(variable(("on", constant("l"), constant("d"))), value(variable(("on", constant("l"), constant("d"))), true)).
goal(variable(("on", constant("d"), constant("j"))), value(variable(("on", constant("d"), constant("j"))), true)).
goal(variable(("on", constant("j"), constant("e"))), value(variable(("on", constant("j"), constant("e"))), true)).
goal(variable(("on", constant("e"), constant("k"))), value(variable(("on", constant("e"), constant("k"))), true)).
goal(variable(("on", constant("k"), constant("f"))), value(variable(("on", constant("k"), constant("f"))), true)).
goal(variable(("on", constant("f"), constant("a"))), value(variable(("on", constant("f"), constant("a"))), true)).
goal(variable(("on", constant("a"), constant("h"))), value(variable(("on", constant("a"), constant("h"))), true)).
goal(variable(("on", constant("h"), constant("g"))), value(variable(("on", constant("h"), constant("g"))), true)).
