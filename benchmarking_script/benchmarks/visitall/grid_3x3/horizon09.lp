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
contains(variable(0), value("at-robot(loc-x0-y0)", true)).
contains(variable(0), value("at-robot(loc-x0-y1)", true)).
contains(variable(0), value("at-robot(loc-x0-y2)", true)).
contains(variable(0), value("at-robot(loc-x1-y0)", true)).
contains(variable(0), value("at-robot(loc-x1-y1)", true)).
contains(variable(0), value("at-robot(loc-x1-y2)", true)).
contains(variable(0), value("at-robot(loc-x2-y0)", true)).
contains(variable(0), value("at-robot(loc-x2-y1)", true)).
contains(variable(0), value("at-robot(loc-x2-y2)", true)).

variable(variable(1)).
contains(variable(1), value("visited(loc-x2-y2)", true)).
contains(variable(1), value("visited(loc-x2-y2)", false)).

variable(variable(2)).
contains(variable(2), value("visited(loc-x2-y1)", true)).
contains(variable(2), value("visited(loc-x2-y1)", false)).

variable(variable(3)).
contains(variable(3), value("visited(loc-x2-y0)", true)).
contains(variable(3), value("visited(loc-x2-y0)", false)).

variable(variable(4)).
contains(variable(4), value("visited(loc-x1-y2)", true)).
contains(variable(4), value("visited(loc-x1-y2)", false)).

variable(variable(5)).
contains(variable(5), value("visited(loc-x1-y0)", true)).
contains(variable(5), value("visited(loc-x1-y0)", false)).

variable(variable(6)).
contains(variable(6), value("visited(loc-x0-y2)", true)).
contains(variable(6), value("visited(loc-x0-y2)", false)).

variable(variable(7)).
contains(variable(7), value("visited(loc-x0-y1)", true)).
contains(variable(7), value("visited(loc-x0-y1)", false)).

variable(variable(8)).
contains(variable(8), value("visited(loc-x0-y0)", true)).
contains(variable(8), value("visited(loc-x0-y0)", false)).

% actions
action(action(("move", "loc-x0-y0", "loc-x0-y1"))).
precondition(action(("move", "loc-x0-y0", "loc-x0-y1")), variable(0), value("at-robot(loc-x0-y0)", true)).
postcondition(action(("move", "loc-x0-y0", "loc-x0-y1")), effect(unconditional), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x0-y0", "loc-x0-y1")), effect(unconditional), variable(7), value("visited(loc-x0-y1)", true)).
costs(action(("move", "loc-x0-y0", "loc-x0-y1")), 1).

action(action(("move", "loc-x0-y0", "loc-x1-y0"))).
precondition(action(("move", "loc-x0-y0", "loc-x1-y0")), variable(0), value("at-robot(loc-x0-y0)", true)).
postcondition(action(("move", "loc-x0-y0", "loc-x1-y0")), effect(unconditional), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x0-y0", "loc-x1-y0")), effect(unconditional), variable(5), value("visited(loc-x1-y0)", true)).
costs(action(("move", "loc-x0-y0", "loc-x1-y0")), 1).

action(action(("move", "loc-x0-y1", "loc-x0-y0"))).
precondition(action(("move", "loc-x0-y1", "loc-x0-y0")), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x0-y1", "loc-x0-y0")), effect(unconditional), variable(0), value("at-robot(loc-x0-y0)", true)).
postcondition(action(("move", "loc-x0-y1", "loc-x0-y0")), effect(unconditional), variable(8), value("visited(loc-x0-y0)", true)).
costs(action(("move", "loc-x0-y1", "loc-x0-y0")), 1).

action(action(("move", "loc-x0-y1", "loc-x0-y2"))).
precondition(action(("move", "loc-x0-y1", "loc-x0-y2")), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x0-y1", "loc-x0-y2")), effect(unconditional), variable(0), value("at-robot(loc-x0-y2)", true)).
postcondition(action(("move", "loc-x0-y1", "loc-x0-y2")), effect(unconditional), variable(6), value("visited(loc-x0-y2)", true)).
costs(action(("move", "loc-x0-y1", "loc-x0-y2")), 1).

action(action(("move", "loc-x0-y1", "loc-x1-y1"))).
precondition(action(("move", "loc-x0-y1", "loc-x1-y1")), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x0-y1", "loc-x1-y1")), effect(unconditional), variable(0), value("at-robot(loc-x1-y1)", true)).
costs(action(("move", "loc-x0-y1", "loc-x1-y1")), 1).

action(action(("move", "loc-x0-y2", "loc-x0-y1"))).
precondition(action(("move", "loc-x0-y2", "loc-x0-y1")), variable(0), value("at-robot(loc-x0-y2)", true)).
postcondition(action(("move", "loc-x0-y2", "loc-x0-y1")), effect(unconditional), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x0-y2", "loc-x0-y1")), effect(unconditional), variable(7), value("visited(loc-x0-y1)", true)).
costs(action(("move", "loc-x0-y2", "loc-x0-y1")), 1).

action(action(("move", "loc-x0-y2", "loc-x1-y2"))).
precondition(action(("move", "loc-x0-y2", "loc-x1-y2")), variable(0), value("at-robot(loc-x0-y2)", true)).
postcondition(action(("move", "loc-x0-y2", "loc-x1-y2")), effect(unconditional), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x0-y2", "loc-x1-y2")), effect(unconditional), variable(4), value("visited(loc-x1-y2)", true)).
costs(action(("move", "loc-x0-y2", "loc-x1-y2")), 1).

action(action(("move", "loc-x1-y0", "loc-x0-y0"))).
precondition(action(("move", "loc-x1-y0", "loc-x0-y0")), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x1-y0", "loc-x0-y0")), effect(unconditional), variable(0), value("at-robot(loc-x0-y0)", true)).
postcondition(action(("move", "loc-x1-y0", "loc-x0-y0")), effect(unconditional), variable(8), value("visited(loc-x0-y0)", true)).
costs(action(("move", "loc-x1-y0", "loc-x0-y0")), 1).

action(action(("move", "loc-x1-y0", "loc-x1-y1"))).
precondition(action(("move", "loc-x1-y0", "loc-x1-y1")), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x1-y0", "loc-x1-y1")), effect(unconditional), variable(0), value("at-robot(loc-x1-y1)", true)).
costs(action(("move", "loc-x1-y0", "loc-x1-y1")), 1).

action(action(("move", "loc-x1-y0", "loc-x2-y0"))).
precondition(action(("move", "loc-x1-y0", "loc-x2-y0")), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x1-y0", "loc-x2-y0")), effect(unconditional), variable(0), value("at-robot(loc-x2-y0)", true)).
postcondition(action(("move", "loc-x1-y0", "loc-x2-y0")), effect(unconditional), variable(3), value("visited(loc-x2-y0)", true)).
costs(action(("move", "loc-x1-y0", "loc-x2-y0")), 1).

action(action(("move", "loc-x1-y1", "loc-x0-y1"))).
precondition(action(("move", "loc-x1-y1", "loc-x0-y1")), variable(0), value("at-robot(loc-x1-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x0-y1")), effect(unconditional), variable(0), value("at-robot(loc-x0-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x0-y1")), effect(unconditional), variable(7), value("visited(loc-x0-y1)", true)).
costs(action(("move", "loc-x1-y1", "loc-x0-y1")), 1).

action(action(("move", "loc-x1-y1", "loc-x1-y0"))).
precondition(action(("move", "loc-x1-y1", "loc-x1-y0")), variable(0), value("at-robot(loc-x1-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x1-y0")), effect(unconditional), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x1-y0")), effect(unconditional), variable(5), value("visited(loc-x1-y0)", true)).
costs(action(("move", "loc-x1-y1", "loc-x1-y0")), 1).

action(action(("move", "loc-x1-y1", "loc-x1-y2"))).
precondition(action(("move", "loc-x1-y1", "loc-x1-y2")), variable(0), value("at-robot(loc-x1-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x1-y2")), effect(unconditional), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x1-y2")), effect(unconditional), variable(4), value("visited(loc-x1-y2)", true)).
costs(action(("move", "loc-x1-y1", "loc-x1-y2")), 1).

action(action(("move", "loc-x1-y1", "loc-x2-y1"))).
precondition(action(("move", "loc-x1-y1", "loc-x2-y1")), variable(0), value("at-robot(loc-x1-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x2-y1")), effect(unconditional), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x1-y1", "loc-x2-y1")), effect(unconditional), variable(2), value("visited(loc-x2-y1)", true)).
costs(action(("move", "loc-x1-y1", "loc-x2-y1")), 1).

action(action(("move", "loc-x1-y2", "loc-x0-y2"))).
precondition(action(("move", "loc-x1-y2", "loc-x0-y2")), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x1-y2", "loc-x0-y2")), effect(unconditional), variable(0), value("at-robot(loc-x0-y2)", true)).
postcondition(action(("move", "loc-x1-y2", "loc-x0-y2")), effect(unconditional), variable(6), value("visited(loc-x0-y2)", true)).
costs(action(("move", "loc-x1-y2", "loc-x0-y2")), 1).

action(action(("move", "loc-x1-y2", "loc-x1-y1"))).
precondition(action(("move", "loc-x1-y2", "loc-x1-y1")), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x1-y2", "loc-x1-y1")), effect(unconditional), variable(0), value("at-robot(loc-x1-y1)", true)).
costs(action(("move", "loc-x1-y2", "loc-x1-y1")), 1).

action(action(("move", "loc-x1-y2", "loc-x2-y2"))).
precondition(action(("move", "loc-x1-y2", "loc-x2-y2")), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x1-y2", "loc-x2-y2")), effect(unconditional), variable(0), value("at-robot(loc-x2-y2)", true)).
postcondition(action(("move", "loc-x1-y2", "loc-x2-y2")), effect(unconditional), variable(1), value("visited(loc-x2-y2)", true)).
costs(action(("move", "loc-x1-y2", "loc-x2-y2")), 1).

action(action(("move", "loc-x2-y0", "loc-x1-y0"))).
precondition(action(("move", "loc-x2-y0", "loc-x1-y0")), variable(0), value("at-robot(loc-x2-y0)", true)).
postcondition(action(("move", "loc-x2-y0", "loc-x1-y0")), effect(unconditional), variable(0), value("at-robot(loc-x1-y0)", true)).
postcondition(action(("move", "loc-x2-y0", "loc-x1-y0")), effect(unconditional), variable(5), value("visited(loc-x1-y0)", true)).
costs(action(("move", "loc-x2-y0", "loc-x1-y0")), 1).

action(action(("move", "loc-x2-y0", "loc-x2-y1"))).
precondition(action(("move", "loc-x2-y0", "loc-x2-y1")), variable(0), value("at-robot(loc-x2-y0)", true)).
postcondition(action(("move", "loc-x2-y0", "loc-x2-y1")), effect(unconditional), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x2-y0", "loc-x2-y1")), effect(unconditional), variable(2), value("visited(loc-x2-y1)", true)).
costs(action(("move", "loc-x2-y0", "loc-x2-y1")), 1).

action(action(("move", "loc-x2-y1", "loc-x1-y1"))).
precondition(action(("move", "loc-x2-y1", "loc-x1-y1")), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x2-y1", "loc-x1-y1")), effect(unconditional), variable(0), value("at-robot(loc-x1-y1)", true)).
costs(action(("move", "loc-x2-y1", "loc-x1-y1")), 1).

action(action(("move", "loc-x2-y1", "loc-x2-y0"))).
precondition(action(("move", "loc-x2-y1", "loc-x2-y0")), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x2-y1", "loc-x2-y0")), effect(unconditional), variable(0), value("at-robot(loc-x2-y0)", true)).
postcondition(action(("move", "loc-x2-y1", "loc-x2-y0")), effect(unconditional), variable(3), value("visited(loc-x2-y0)", true)).
costs(action(("move", "loc-x2-y1", "loc-x2-y0")), 1).

action(action(("move", "loc-x2-y1", "loc-x2-y2"))).
precondition(action(("move", "loc-x2-y1", "loc-x2-y2")), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x2-y1", "loc-x2-y2")), effect(unconditional), variable(0), value("at-robot(loc-x2-y2)", true)).
postcondition(action(("move", "loc-x2-y1", "loc-x2-y2")), effect(unconditional), variable(1), value("visited(loc-x2-y2)", true)).
costs(action(("move", "loc-x2-y1", "loc-x2-y2")), 1).

action(action(("move", "loc-x2-y2", "loc-x1-y2"))).
precondition(action(("move", "loc-x2-y2", "loc-x1-y2")), variable(0), value("at-robot(loc-x2-y2)", true)).
postcondition(action(("move", "loc-x2-y2", "loc-x1-y2")), effect(unconditional), variable(0), value("at-robot(loc-x1-y2)", true)).
postcondition(action(("move", "loc-x2-y2", "loc-x1-y2")), effect(unconditional), variable(4), value("visited(loc-x1-y2)", true)).
costs(action(("move", "loc-x2-y2", "loc-x1-y2")), 1).

action(action(("move", "loc-x2-y2", "loc-x2-y1"))).
precondition(action(("move", "loc-x2-y2", "loc-x2-y1")), variable(0), value("at-robot(loc-x2-y2)", true)).
postcondition(action(("move", "loc-x2-y2", "loc-x2-y1")), effect(unconditional), variable(0), value("at-robot(loc-x2-y1)", true)).
postcondition(action(("move", "loc-x2-y2", "loc-x2-y1")), effect(unconditional), variable(2), value("visited(loc-x2-y1)", true)).
costs(action(("move", "loc-x2-y2", "loc-x2-y1")), 1).

% initial state
initialState(variable(0), value("at-robot(loc-x1-y1)", true)).
initialState(variable(1), value("visited(loc-x2-y2)", false)).
initialState(variable(2), value("visited(loc-x2-y1)", false)).
initialState(variable(3), value("visited(loc-x2-y0)", false)).
initialState(variable(4), value("visited(loc-x1-y2)", false)).
initialState(variable(5), value("visited(loc-x1-y0)", false)).
initialState(variable(6), value("visited(loc-x0-y2)", false)).
initialState(variable(7), value("visited(loc-x0-y1)", false)).
initialState(variable(8), value("visited(loc-x0-y0)", false)).

% goal
goal(variable(1), value("visited(loc-x2-y2)", true)).
goal(variable(2), value("visited(loc-x2-y1)", true)).
goal(variable(3), value("visited(loc-x2-y0)", true)).
goal(variable(4), value("visited(loc-x1-y2)", true)).
goal(variable(5), value("visited(loc-x1-y0)", true)).
goal(variable(6), value("visited(loc-x0-y2)", true)).
goal(variable(7), value("visited(loc-x0-y1)", true)).
goal(variable(8), value("visited(loc-x0-y0)", true)).
