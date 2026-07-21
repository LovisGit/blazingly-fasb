#const horizon=14.

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
% variables
variable(variable(0)).
contains(variable(0), value("fuel-level(plane2, fl0)", true)).
contains(variable(0), value("fuel-level(plane2, fl1)", true)).
contains(variable(0), value("fuel-level(plane2, fl2)", true)).
contains(variable(0), value("fuel-level(plane2, fl3)", true)).
contains(variable(0), value("fuel-level(plane2, fl4)", true)).
contains(variable(0), value("fuel-level(plane2, fl5)", true)).
contains(variable(0), value("fuel-level(plane2, fl6)", true)).

variable(variable(1)).
contains(variable(1), value("at(plane2, city0)", true)).
contains(variable(1), value("at(plane2, city1)", true)).
contains(variable(1), value("at(plane2, city2)", true)).

variable(variable(2)).
contains(variable(2), value("at(plane1, city0)", true)).
contains(variable(2), value("at(plane1, city1)", true)).
contains(variable(2), value("at(plane1, city2)", true)).

variable(variable(3)).
contains(variable(3), value("fuel-level(plane1, fl0)", true)).
contains(variable(3), value("fuel-level(plane1, fl1)", true)).
contains(variable(3), value("fuel-level(plane1, fl2)", true)).
contains(variable(3), value("fuel-level(plane1, fl3)", true)).
contains(variable(3), value("fuel-level(plane1, fl4)", true)).
contains(variable(3), value("fuel-level(plane1, fl5)", true)).
contains(variable(3), value("fuel-level(plane1, fl6)", true)).

variable(variable(4)).
contains(variable(4), value("at(person4, city0)", true)).
contains(variable(4), value("at(person4, city1)", true)).
contains(variable(4), value("at(person4, city2)", true)).
contains(variable(4), value("in(person4, plane1)", true)).
contains(variable(4), value("in(person4, plane2)", true)).

variable(variable(5)).
contains(variable(5), value("at(person3, city0)", true)).
contains(variable(5), value("at(person3, city1)", true)).
contains(variable(5), value("at(person3, city2)", true)).
contains(variable(5), value("in(person3, plane1)", true)).
contains(variable(5), value("in(person3, plane2)", true)).

variable(variable(6)).
contains(variable(6), value("at(person2, city0)", true)).
contains(variable(6), value("at(person2, city1)", true)).
contains(variable(6), value("at(person2, city2)", true)).
contains(variable(6), value("in(person2, plane1)", true)).
contains(variable(6), value("in(person2, plane2)", true)).

variable(variable(7)).
contains(variable(7), value("at(person1, city0)", true)).
contains(variable(7), value("at(person1, city1)", true)).
contains(variable(7), value("at(person1, city2)", true)).
contains(variable(7), value("in(person1, plane1)", true)).
contains(variable(7), value("in(person1, plane2)", true)).

% actions
action(action(("board", "person1", "plane1", "city0"))).
precondition(action(("board", "person1", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("board", "person1", "plane1", "city0")), variable(7), value("at(person1, city0)", true)).
postcondition(action(("board", "person1", "plane1", "city0")), effect(unconditional), variable(7), value("in(person1, plane1)", true)).
costs(action(("board", "person1", "plane1", "city0")), 1).

action(action(("board", "person1", "plane1", "city1"))).
precondition(action(("board", "person1", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("board", "person1", "plane1", "city1")), variable(7), value("at(person1, city1)", true)).
postcondition(action(("board", "person1", "plane1", "city1")), effect(unconditional), variable(7), value("in(person1, plane1)", true)).
costs(action(("board", "person1", "plane1", "city1")), 1).

action(action(("board", "person1", "plane1", "city2"))).
precondition(action(("board", "person1", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("board", "person1", "plane1", "city2")), variable(7), value("at(person1, city2)", true)).
postcondition(action(("board", "person1", "plane1", "city2")), effect(unconditional), variable(7), value("in(person1, plane1)", true)).
costs(action(("board", "person1", "plane1", "city2")), 1).

action(action(("board", "person1", "plane2", "city0"))).
precondition(action(("board", "person1", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("board", "person1", "plane2", "city0")), variable(7), value("at(person1, city0)", true)).
postcondition(action(("board", "person1", "plane2", "city0")), effect(unconditional), variable(7), value("in(person1, plane2)", true)).
costs(action(("board", "person1", "plane2", "city0")), 1).

action(action(("board", "person1", "plane2", "city1"))).
precondition(action(("board", "person1", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("board", "person1", "plane2", "city1")), variable(7), value("at(person1, city1)", true)).
postcondition(action(("board", "person1", "plane2", "city1")), effect(unconditional), variable(7), value("in(person1, plane2)", true)).
costs(action(("board", "person1", "plane2", "city1")), 1).

action(action(("board", "person1", "plane2", "city2"))).
precondition(action(("board", "person1", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("board", "person1", "plane2", "city2")), variable(7), value("at(person1, city2)", true)).
postcondition(action(("board", "person1", "plane2", "city2")), effect(unconditional), variable(7), value("in(person1, plane2)", true)).
costs(action(("board", "person1", "plane2", "city2")), 1).

action(action(("board", "person2", "plane1", "city0"))).
precondition(action(("board", "person2", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("board", "person2", "plane1", "city0")), variable(6), value("at(person2, city0)", true)).
postcondition(action(("board", "person2", "plane1", "city0")), effect(unconditional), variable(6), value("in(person2, plane1)", true)).
costs(action(("board", "person2", "plane1", "city0")), 1).

action(action(("board", "person2", "plane1", "city1"))).
precondition(action(("board", "person2", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("board", "person2", "plane1", "city1")), variable(6), value("at(person2, city1)", true)).
postcondition(action(("board", "person2", "plane1", "city1")), effect(unconditional), variable(6), value("in(person2, plane1)", true)).
costs(action(("board", "person2", "plane1", "city1")), 1).

action(action(("board", "person2", "plane1", "city2"))).
precondition(action(("board", "person2", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("board", "person2", "plane1", "city2")), variable(6), value("at(person2, city2)", true)).
postcondition(action(("board", "person2", "plane1", "city2")), effect(unconditional), variable(6), value("in(person2, plane1)", true)).
costs(action(("board", "person2", "plane1", "city2")), 1).

action(action(("board", "person2", "plane2", "city0"))).
precondition(action(("board", "person2", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("board", "person2", "plane2", "city0")), variable(6), value("at(person2, city0)", true)).
postcondition(action(("board", "person2", "plane2", "city0")), effect(unconditional), variable(6), value("in(person2, plane2)", true)).
costs(action(("board", "person2", "plane2", "city0")), 1).

action(action(("board", "person2", "plane2", "city1"))).
precondition(action(("board", "person2", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("board", "person2", "plane2", "city1")), variable(6), value("at(person2, city1)", true)).
postcondition(action(("board", "person2", "plane2", "city1")), effect(unconditional), variable(6), value("in(person2, plane2)", true)).
costs(action(("board", "person2", "plane2", "city1")), 1).

action(action(("board", "person2", "plane2", "city2"))).
precondition(action(("board", "person2", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("board", "person2", "plane2", "city2")), variable(6), value("at(person2, city2)", true)).
postcondition(action(("board", "person2", "plane2", "city2")), effect(unconditional), variable(6), value("in(person2, plane2)", true)).
costs(action(("board", "person2", "plane2", "city2")), 1).

action(action(("board", "person3", "plane1", "city0"))).
precondition(action(("board", "person3", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("board", "person3", "plane1", "city0")), variable(5), value("at(person3, city0)", true)).
postcondition(action(("board", "person3", "plane1", "city0")), effect(unconditional), variable(5), value("in(person3, plane1)", true)).
costs(action(("board", "person3", "plane1", "city0")), 1).

action(action(("board", "person3", "plane1", "city1"))).
precondition(action(("board", "person3", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("board", "person3", "plane1", "city1")), variable(5), value("at(person3, city1)", true)).
postcondition(action(("board", "person3", "plane1", "city1")), effect(unconditional), variable(5), value("in(person3, plane1)", true)).
costs(action(("board", "person3", "plane1", "city1")), 1).

action(action(("board", "person3", "plane1", "city2"))).
precondition(action(("board", "person3", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("board", "person3", "plane1", "city2")), variable(5), value("at(person3, city2)", true)).
postcondition(action(("board", "person3", "plane1", "city2")), effect(unconditional), variable(5), value("in(person3, plane1)", true)).
costs(action(("board", "person3", "plane1", "city2")), 1).

action(action(("board", "person3", "plane2", "city0"))).
precondition(action(("board", "person3", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("board", "person3", "plane2", "city0")), variable(5), value("at(person3, city0)", true)).
postcondition(action(("board", "person3", "plane2", "city0")), effect(unconditional), variable(5), value("in(person3, plane2)", true)).
costs(action(("board", "person3", "plane2", "city0")), 1).

action(action(("board", "person3", "plane2", "city1"))).
precondition(action(("board", "person3", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("board", "person3", "plane2", "city1")), variable(5), value("at(person3, city1)", true)).
postcondition(action(("board", "person3", "plane2", "city1")), effect(unconditional), variable(5), value("in(person3, plane2)", true)).
costs(action(("board", "person3", "plane2", "city1")), 1).

action(action(("board", "person3", "plane2", "city2"))).
precondition(action(("board", "person3", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("board", "person3", "plane2", "city2")), variable(5), value("at(person3, city2)", true)).
postcondition(action(("board", "person3", "plane2", "city2")), effect(unconditional), variable(5), value("in(person3, plane2)", true)).
costs(action(("board", "person3", "plane2", "city2")), 1).

action(action(("board", "person4", "plane1", "city0"))).
precondition(action(("board", "person4", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("board", "person4", "plane1", "city0")), variable(4), value("at(person4, city0)", true)).
postcondition(action(("board", "person4", "plane1", "city0")), effect(unconditional), variable(4), value("in(person4, plane1)", true)).
costs(action(("board", "person4", "plane1", "city0")), 1).

action(action(("board", "person4", "plane1", "city1"))).
precondition(action(("board", "person4", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("board", "person4", "plane1", "city1")), variable(4), value("at(person4, city1)", true)).
postcondition(action(("board", "person4", "plane1", "city1")), effect(unconditional), variable(4), value("in(person4, plane1)", true)).
costs(action(("board", "person4", "plane1", "city1")), 1).

action(action(("board", "person4", "plane1", "city2"))).
precondition(action(("board", "person4", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("board", "person4", "plane1", "city2")), variable(4), value("at(person4, city2)", true)).
postcondition(action(("board", "person4", "plane1", "city2")), effect(unconditional), variable(4), value("in(person4, plane1)", true)).
costs(action(("board", "person4", "plane1", "city2")), 1).

action(action(("board", "person4", "plane2", "city0"))).
precondition(action(("board", "person4", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("board", "person4", "plane2", "city0")), variable(4), value("at(person4, city0)", true)).
postcondition(action(("board", "person4", "plane2", "city0")), effect(unconditional), variable(4), value("in(person4, plane2)", true)).
costs(action(("board", "person4", "plane2", "city0")), 1).

action(action(("board", "person4", "plane2", "city1"))).
precondition(action(("board", "person4", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("board", "person4", "plane2", "city1")), variable(4), value("at(person4, city1)", true)).
postcondition(action(("board", "person4", "plane2", "city1")), effect(unconditional), variable(4), value("in(person4, plane2)", true)).
costs(action(("board", "person4", "plane2", "city1")), 1).

action(action(("board", "person4", "plane2", "city2"))).
precondition(action(("board", "person4", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("board", "person4", "plane2", "city2")), variable(4), value("at(person4, city2)", true)).
postcondition(action(("board", "person4", "plane2", "city2")), effect(unconditional), variable(4), value("in(person4, plane2)", true)).
costs(action(("board", "person4", "plane2", "city2")), 1).

action(action(("debark", "person1", "plane1", "city0"))).
precondition(action(("debark", "person1", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("debark", "person1", "plane1", "city0")), variable(7), value("in(person1, plane1)", true)).
postcondition(action(("debark", "person1", "plane1", "city0")), effect(unconditional), variable(7), value("at(person1, city0)", true)).
costs(action(("debark", "person1", "plane1", "city0")), 1).

action(action(("debark", "person1", "plane1", "city1"))).
precondition(action(("debark", "person1", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("debark", "person1", "plane1", "city1")), variable(7), value("in(person1, plane1)", true)).
postcondition(action(("debark", "person1", "plane1", "city1")), effect(unconditional), variable(7), value("at(person1, city1)", true)).
costs(action(("debark", "person1", "plane1", "city1")), 1).

action(action(("debark", "person1", "plane1", "city2"))).
precondition(action(("debark", "person1", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("debark", "person1", "plane1", "city2")), variable(7), value("in(person1, plane1)", true)).
postcondition(action(("debark", "person1", "plane1", "city2")), effect(unconditional), variable(7), value("at(person1, city2)", true)).
costs(action(("debark", "person1", "plane1", "city2")), 1).

action(action(("debark", "person1", "plane2", "city0"))).
precondition(action(("debark", "person1", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("debark", "person1", "plane2", "city0")), variable(7), value("in(person1, plane2)", true)).
postcondition(action(("debark", "person1", "plane2", "city0")), effect(unconditional), variable(7), value("at(person1, city0)", true)).
costs(action(("debark", "person1", "plane2", "city0")), 1).

action(action(("debark", "person1", "plane2", "city1"))).
precondition(action(("debark", "person1", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("debark", "person1", "plane2", "city1")), variable(7), value("in(person1, plane2)", true)).
postcondition(action(("debark", "person1", "plane2", "city1")), effect(unconditional), variable(7), value("at(person1, city1)", true)).
costs(action(("debark", "person1", "plane2", "city1")), 1).

action(action(("debark", "person1", "plane2", "city2"))).
precondition(action(("debark", "person1", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("debark", "person1", "plane2", "city2")), variable(7), value("in(person1, plane2)", true)).
postcondition(action(("debark", "person1", "plane2", "city2")), effect(unconditional), variable(7), value("at(person1, city2)", true)).
costs(action(("debark", "person1", "plane2", "city2")), 1).

action(action(("debark", "person2", "plane1", "city0"))).
precondition(action(("debark", "person2", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("debark", "person2", "plane1", "city0")), variable(6), value("in(person2, plane1)", true)).
postcondition(action(("debark", "person2", "plane1", "city0")), effect(unconditional), variable(6), value("at(person2, city0)", true)).
costs(action(("debark", "person2", "plane1", "city0")), 1).

action(action(("debark", "person2", "plane1", "city1"))).
precondition(action(("debark", "person2", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("debark", "person2", "plane1", "city1")), variable(6), value("in(person2, plane1)", true)).
postcondition(action(("debark", "person2", "plane1", "city1")), effect(unconditional), variable(6), value("at(person2, city1)", true)).
costs(action(("debark", "person2", "plane1", "city1")), 1).

action(action(("debark", "person2", "plane1", "city2"))).
precondition(action(("debark", "person2", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("debark", "person2", "plane1", "city2")), variable(6), value("in(person2, plane1)", true)).
postcondition(action(("debark", "person2", "plane1", "city2")), effect(unconditional), variable(6), value("at(person2, city2)", true)).
costs(action(("debark", "person2", "plane1", "city2")), 1).

action(action(("debark", "person2", "plane2", "city0"))).
precondition(action(("debark", "person2", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("debark", "person2", "plane2", "city0")), variable(6), value("in(person2, plane2)", true)).
postcondition(action(("debark", "person2", "plane2", "city0")), effect(unconditional), variable(6), value("at(person2, city0)", true)).
costs(action(("debark", "person2", "plane2", "city0")), 1).

action(action(("debark", "person2", "plane2", "city1"))).
precondition(action(("debark", "person2", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("debark", "person2", "plane2", "city1")), variable(6), value("in(person2, plane2)", true)).
postcondition(action(("debark", "person2", "plane2", "city1")), effect(unconditional), variable(6), value("at(person2, city1)", true)).
costs(action(("debark", "person2", "plane2", "city1")), 1).

action(action(("debark", "person2", "plane2", "city2"))).
precondition(action(("debark", "person2", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("debark", "person2", "plane2", "city2")), variable(6), value("in(person2, plane2)", true)).
postcondition(action(("debark", "person2", "plane2", "city2")), effect(unconditional), variable(6), value("at(person2, city2)", true)).
costs(action(("debark", "person2", "plane2", "city2")), 1).

action(action(("debark", "person3", "plane1", "city0"))).
precondition(action(("debark", "person3", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("debark", "person3", "plane1", "city0")), variable(5), value("in(person3, plane1)", true)).
postcondition(action(("debark", "person3", "plane1", "city0")), effect(unconditional), variable(5), value("at(person3, city0)", true)).
costs(action(("debark", "person3", "plane1", "city0")), 1).

action(action(("debark", "person3", "plane1", "city1"))).
precondition(action(("debark", "person3", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("debark", "person3", "plane1", "city1")), variable(5), value("in(person3, plane1)", true)).
postcondition(action(("debark", "person3", "plane1", "city1")), effect(unconditional), variable(5), value("at(person3, city1)", true)).
costs(action(("debark", "person3", "plane1", "city1")), 1).

action(action(("debark", "person3", "plane1", "city2"))).
precondition(action(("debark", "person3", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("debark", "person3", "plane1", "city2")), variable(5), value("in(person3, plane1)", true)).
postcondition(action(("debark", "person3", "plane1", "city2")), effect(unconditional), variable(5), value("at(person3, city2)", true)).
costs(action(("debark", "person3", "plane1", "city2")), 1).

action(action(("debark", "person3", "plane2", "city0"))).
precondition(action(("debark", "person3", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("debark", "person3", "plane2", "city0")), variable(5), value("in(person3, plane2)", true)).
postcondition(action(("debark", "person3", "plane2", "city0")), effect(unconditional), variable(5), value("at(person3, city0)", true)).
costs(action(("debark", "person3", "plane2", "city0")), 1).

action(action(("debark", "person3", "plane2", "city1"))).
precondition(action(("debark", "person3", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("debark", "person3", "plane2", "city1")), variable(5), value("in(person3, plane2)", true)).
postcondition(action(("debark", "person3", "plane2", "city1")), effect(unconditional), variable(5), value("at(person3, city1)", true)).
costs(action(("debark", "person3", "plane2", "city1")), 1).

action(action(("debark", "person3", "plane2", "city2"))).
precondition(action(("debark", "person3", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("debark", "person3", "plane2", "city2")), variable(5), value("in(person3, plane2)", true)).
postcondition(action(("debark", "person3", "plane2", "city2")), effect(unconditional), variable(5), value("at(person3, city2)", true)).
costs(action(("debark", "person3", "plane2", "city2")), 1).

action(action(("debark", "person4", "plane1", "city0"))).
precondition(action(("debark", "person4", "plane1", "city0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("debark", "person4", "plane1", "city0")), variable(4), value("in(person4, plane1)", true)).
postcondition(action(("debark", "person4", "plane1", "city0")), effect(unconditional), variable(4), value("at(person4, city0)", true)).
costs(action(("debark", "person4", "plane1", "city0")), 1).

action(action(("debark", "person4", "plane1", "city1"))).
precondition(action(("debark", "person4", "plane1", "city1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("debark", "person4", "plane1", "city1")), variable(4), value("in(person4, plane1)", true)).
postcondition(action(("debark", "person4", "plane1", "city1")), effect(unconditional), variable(4), value("at(person4, city1)", true)).
costs(action(("debark", "person4", "plane1", "city1")), 1).

action(action(("debark", "person4", "plane1", "city2"))).
precondition(action(("debark", "person4", "plane1", "city2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("debark", "person4", "plane1", "city2")), variable(4), value("in(person4, plane1)", true)).
postcondition(action(("debark", "person4", "plane1", "city2")), effect(unconditional), variable(4), value("at(person4, city2)", true)).
costs(action(("debark", "person4", "plane1", "city2")), 1).

action(action(("debark", "person4", "plane2", "city0"))).
precondition(action(("debark", "person4", "plane2", "city0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("debark", "person4", "plane2", "city0")), variable(4), value("in(person4, plane2)", true)).
postcondition(action(("debark", "person4", "plane2", "city0")), effect(unconditional), variable(4), value("at(person4, city0)", true)).
costs(action(("debark", "person4", "plane2", "city0")), 1).

action(action(("debark", "person4", "plane2", "city1"))).
precondition(action(("debark", "person4", "plane2", "city1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("debark", "person4", "plane2", "city1")), variable(4), value("in(person4, plane2)", true)).
postcondition(action(("debark", "person4", "plane2", "city1")), effect(unconditional), variable(4), value("at(person4, city1)", true)).
costs(action(("debark", "person4", "plane2", "city1")), 1).

action(action(("debark", "person4", "plane2", "city2"))).
precondition(action(("debark", "person4", "plane2", "city2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("debark", "person4", "plane2", "city2")), variable(4), value("in(person4, plane2)", true)).
postcondition(action(("debark", "person4", "plane2", "city2")), effect(unconditional), variable(4), value("at(person4, city2)", true)).
costs(action(("debark", "person4", "plane2", "city2")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city0", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city0", "city0", "fl6", "fl5")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city0", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city0", "city0", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city0", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city0", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city0", "city1", "fl6", "fl5")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city1", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city0", "city1", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city0", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city0", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city0", "city2", "fl6", "fl5")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("fly", "plane1", "city0", "city2", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city0", "city2", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city0", "city2", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city1", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city1", "city0", "fl6", "fl5")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city0", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city1", "city0", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city1", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city1", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city1", "city1", "fl6", "fl5")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city1", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city1", "city1", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city1", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city1", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city1", "city2", "fl6", "fl5")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("fly", "plane1", "city1", "city2", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("fly", "plane1", "city1", "city2", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city1", "city2", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city2", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city2", "city0", "fl6", "fl5")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city0", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("fly", "plane1", "city2", "city0", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city2", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city2", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city2", "city1", "fl6", "fl5")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city1", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl6", "fl5")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("fly", "plane1", "city2", "city1", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city2", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane1", "city2", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane1", "city2", "city2", "fl6", "fl5")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("fly", "plane1", "city2", "city2", "fl6", "fl5")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("fly", "plane1", "city2", "city2", "fl6", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("fly", "plane1", "city2", "city2", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city0", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city0", "city0", "fl6", "fl5")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city0", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city0", "city0", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city0", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city0", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city0", "city1", "fl6", "fl5")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city1", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city0", "city1", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city0", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city0", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city0", "city2", "fl6", "fl5")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("fly", "plane2", "city0", "city2", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city0", "city2", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city0", "city2", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city1", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city1", "city0", "fl6", "fl5")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city0", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city1", "city0", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city1", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city1", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city1", "city1", "fl6", "fl5")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city1", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city1", "city1", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city1", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city1", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city1", "city2", "fl6", "fl5")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("fly", "plane2", "city1", "city2", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("fly", "plane2", "city1", "city2", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city1", "city2", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city2", "city0", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city2", "city0", "fl6", "fl5")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city0", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("fly", "plane2", "city2", "city0", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city2", "city0", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city2", "city1", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city2", "city1", "fl6", "fl5")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city1", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl6", "fl5")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("fly", "plane2", "city2", "city1", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city2", "city1", "fl6", "fl5")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl1", "fl0"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl1", "fl0")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl2", "fl1"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl2", "fl1")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl3", "fl2"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl3", "fl2")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl4", "fl3"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl4", "fl3")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl5", "fl4"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl5", "fl4")), 1).

action(action(("fly", "plane2", "city2", "city2", "fl6", "fl5"))).
precondition(action(("fly", "plane2", "city2", "city2", "fl6", "fl5")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("fly", "plane2", "city2", "city2", "fl6", "fl5")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("fly", "plane2", "city2", "city2", "fl6", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("fly", "plane2", "city2", "city2", "fl6", "fl5")), 1).

action(action(("refuel", "plane1", "city0", "fl0", "fl1"))).
precondition(action(("refuel", "plane1", "city0", "fl0", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl0", "fl1")), variable(3), value("fuel-level(plane1, fl0)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl0", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("refuel", "plane1", "city0", "fl0", "fl1")), 1).

action(action(("refuel", "plane1", "city0", "fl1", "fl2"))).
precondition(action(("refuel", "plane1", "city0", "fl1", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl1", "fl2")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl1", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("refuel", "plane1", "city0", "fl1", "fl2")), 1).

action(action(("refuel", "plane1", "city0", "fl2", "fl3"))).
precondition(action(("refuel", "plane1", "city0", "fl2", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl2", "fl3")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl2", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("refuel", "plane1", "city0", "fl2", "fl3")), 1).

action(action(("refuel", "plane1", "city0", "fl3", "fl4"))).
precondition(action(("refuel", "plane1", "city0", "fl3", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl3", "fl4")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl3", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("refuel", "plane1", "city0", "fl3", "fl4")), 1).

action(action(("refuel", "plane1", "city0", "fl4", "fl5"))).
precondition(action(("refuel", "plane1", "city0", "fl4", "fl5")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl4", "fl5")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl4", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("refuel", "plane1", "city0", "fl4", "fl5")), 1).

action(action(("refuel", "plane1", "city0", "fl5", "fl6"))).
precondition(action(("refuel", "plane1", "city0", "fl5", "fl6")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("refuel", "plane1", "city0", "fl5", "fl6")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("refuel", "plane1", "city0", "fl5", "fl6")), effect(unconditional), variable(3), value("fuel-level(plane1, fl6)", true)).
costs(action(("refuel", "plane1", "city0", "fl5", "fl6")), 1).

action(action(("refuel", "plane1", "city1", "fl0", "fl1"))).
precondition(action(("refuel", "plane1", "city1", "fl0", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl0", "fl1")), variable(3), value("fuel-level(plane1, fl0)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl0", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("refuel", "plane1", "city1", "fl0", "fl1")), 1).

action(action(("refuel", "plane1", "city1", "fl1", "fl2"))).
precondition(action(("refuel", "plane1", "city1", "fl1", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl1", "fl2")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl1", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("refuel", "plane1", "city1", "fl1", "fl2")), 1).

action(action(("refuel", "plane1", "city1", "fl2", "fl3"))).
precondition(action(("refuel", "plane1", "city1", "fl2", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl2", "fl3")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl2", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("refuel", "plane1", "city1", "fl2", "fl3")), 1).

action(action(("refuel", "plane1", "city1", "fl3", "fl4"))).
precondition(action(("refuel", "plane1", "city1", "fl3", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl3", "fl4")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl3", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("refuel", "plane1", "city1", "fl3", "fl4")), 1).

action(action(("refuel", "plane1", "city1", "fl4", "fl5"))).
precondition(action(("refuel", "plane1", "city1", "fl4", "fl5")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl4", "fl5")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl4", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("refuel", "plane1", "city1", "fl4", "fl5")), 1).

action(action(("refuel", "plane1", "city1", "fl5", "fl6"))).
precondition(action(("refuel", "plane1", "city1", "fl5", "fl6")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("refuel", "plane1", "city1", "fl5", "fl6")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("refuel", "plane1", "city1", "fl5", "fl6")), effect(unconditional), variable(3), value("fuel-level(plane1, fl6)", true)).
costs(action(("refuel", "plane1", "city1", "fl5", "fl6")), 1).

action(action(("refuel", "plane1", "city2", "fl0", "fl1"))).
precondition(action(("refuel", "plane1", "city2", "fl0", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl0", "fl1")), variable(3), value("fuel-level(plane1, fl0)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl0", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("refuel", "plane1", "city2", "fl0", "fl1")), 1).

action(action(("refuel", "plane1", "city2", "fl1", "fl2"))).
precondition(action(("refuel", "plane1", "city2", "fl1", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl1", "fl2")), variable(3), value("fuel-level(plane1, fl1)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl1", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("refuel", "plane1", "city2", "fl1", "fl2")), 1).

action(action(("refuel", "plane1", "city2", "fl2", "fl3"))).
precondition(action(("refuel", "plane1", "city2", "fl2", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl2", "fl3")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl2", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("refuel", "plane1", "city2", "fl2", "fl3")), 1).

action(action(("refuel", "plane1", "city2", "fl3", "fl4"))).
precondition(action(("refuel", "plane1", "city2", "fl3", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl3", "fl4")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl3", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("refuel", "plane1", "city2", "fl3", "fl4")), 1).

action(action(("refuel", "plane1", "city2", "fl4", "fl5"))).
precondition(action(("refuel", "plane1", "city2", "fl4", "fl5")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl4", "fl5")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl4", "fl5")), effect(unconditional), variable(3), value("fuel-level(plane1, fl5)", true)).
costs(action(("refuel", "plane1", "city2", "fl4", "fl5")), 1).

action(action(("refuel", "plane1", "city2", "fl5", "fl6"))).
precondition(action(("refuel", "plane1", "city2", "fl5", "fl6")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("refuel", "plane1", "city2", "fl5", "fl6")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("refuel", "plane1", "city2", "fl5", "fl6")), effect(unconditional), variable(3), value("fuel-level(plane1, fl6)", true)).
costs(action(("refuel", "plane1", "city2", "fl5", "fl6")), 1).

action(action(("refuel", "plane2", "city0", "fl0", "fl1"))).
precondition(action(("refuel", "plane2", "city0", "fl0", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl0", "fl1")), variable(0), value("fuel-level(plane2, fl0)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl0", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("refuel", "plane2", "city0", "fl0", "fl1")), 1).

action(action(("refuel", "plane2", "city0", "fl1", "fl2"))).
precondition(action(("refuel", "plane2", "city0", "fl1", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl1", "fl2")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl1", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("refuel", "plane2", "city0", "fl1", "fl2")), 1).

action(action(("refuel", "plane2", "city0", "fl2", "fl3"))).
precondition(action(("refuel", "plane2", "city0", "fl2", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl2", "fl3")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl2", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("refuel", "plane2", "city0", "fl2", "fl3")), 1).

action(action(("refuel", "plane2", "city0", "fl3", "fl4"))).
precondition(action(("refuel", "plane2", "city0", "fl3", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl3", "fl4")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl3", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("refuel", "plane2", "city0", "fl3", "fl4")), 1).

action(action(("refuel", "plane2", "city0", "fl4", "fl5"))).
precondition(action(("refuel", "plane2", "city0", "fl4", "fl5")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl4", "fl5")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl4", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("refuel", "plane2", "city0", "fl4", "fl5")), 1).

action(action(("refuel", "plane2", "city0", "fl5", "fl6"))).
precondition(action(("refuel", "plane2", "city0", "fl5", "fl6")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("refuel", "plane2", "city0", "fl5", "fl6")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("refuel", "plane2", "city0", "fl5", "fl6")), effect(unconditional), variable(0), value("fuel-level(plane2, fl6)", true)).
costs(action(("refuel", "plane2", "city0", "fl5", "fl6")), 1).

action(action(("refuel", "plane2", "city1", "fl0", "fl1"))).
precondition(action(("refuel", "plane2", "city1", "fl0", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl0", "fl1")), variable(0), value("fuel-level(plane2, fl0)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl0", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("refuel", "plane2", "city1", "fl0", "fl1")), 1).

action(action(("refuel", "plane2", "city1", "fl1", "fl2"))).
precondition(action(("refuel", "plane2", "city1", "fl1", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl1", "fl2")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl1", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("refuel", "plane2", "city1", "fl1", "fl2")), 1).

action(action(("refuel", "plane2", "city1", "fl2", "fl3"))).
precondition(action(("refuel", "plane2", "city1", "fl2", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl2", "fl3")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl2", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("refuel", "plane2", "city1", "fl2", "fl3")), 1).

action(action(("refuel", "plane2", "city1", "fl3", "fl4"))).
precondition(action(("refuel", "plane2", "city1", "fl3", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl3", "fl4")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl3", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("refuel", "plane2", "city1", "fl3", "fl4")), 1).

action(action(("refuel", "plane2", "city1", "fl4", "fl5"))).
precondition(action(("refuel", "plane2", "city1", "fl4", "fl5")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl4", "fl5")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl4", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("refuel", "plane2", "city1", "fl4", "fl5")), 1).

action(action(("refuel", "plane2", "city1", "fl5", "fl6"))).
precondition(action(("refuel", "plane2", "city1", "fl5", "fl6")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("refuel", "plane2", "city1", "fl5", "fl6")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("refuel", "plane2", "city1", "fl5", "fl6")), effect(unconditional), variable(0), value("fuel-level(plane2, fl6)", true)).
costs(action(("refuel", "plane2", "city1", "fl5", "fl6")), 1).

action(action(("refuel", "plane2", "city2", "fl0", "fl1"))).
precondition(action(("refuel", "plane2", "city2", "fl0", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl0", "fl1")), variable(0), value("fuel-level(plane2, fl0)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl0", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("refuel", "plane2", "city2", "fl0", "fl1")), 1).

action(action(("refuel", "plane2", "city2", "fl1", "fl2"))).
precondition(action(("refuel", "plane2", "city2", "fl1", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl1", "fl2")), variable(0), value("fuel-level(plane2, fl1)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl1", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("refuel", "plane2", "city2", "fl1", "fl2")), 1).

action(action(("refuel", "plane2", "city2", "fl2", "fl3"))).
precondition(action(("refuel", "plane2", "city2", "fl2", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl2", "fl3")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl2", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("refuel", "plane2", "city2", "fl2", "fl3")), 1).

action(action(("refuel", "plane2", "city2", "fl3", "fl4"))).
precondition(action(("refuel", "plane2", "city2", "fl3", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl3", "fl4")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl3", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("refuel", "plane2", "city2", "fl3", "fl4")), 1).

action(action(("refuel", "plane2", "city2", "fl4", "fl5"))).
precondition(action(("refuel", "plane2", "city2", "fl4", "fl5")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl4", "fl5")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl4", "fl5")), effect(unconditional), variable(0), value("fuel-level(plane2, fl5)", true)).
costs(action(("refuel", "plane2", "city2", "fl4", "fl5")), 1).

action(action(("refuel", "plane2", "city2", "fl5", "fl6"))).
precondition(action(("refuel", "plane2", "city2", "fl5", "fl6")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("refuel", "plane2", "city2", "fl5", "fl6")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("refuel", "plane2", "city2", "fl5", "fl6")), effect(unconditional), variable(0), value("fuel-level(plane2, fl6)", true)).
costs(action(("refuel", "plane2", "city2", "fl5", "fl6")), 1).

action(action(("zoom", "plane1", "city0", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city0", "city0", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city0", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city0", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city0", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city0", "city0", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city0", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city0", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city0", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city0", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city0", "city0", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city0", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city0", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city0", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city0", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city0", "city0", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city0", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city0", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city0", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city0", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city0", "city0", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city0", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city0", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city0", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city0", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city0", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city0", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city0", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city0", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city0", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city0", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city0", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city0", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city0)", true)).
precondition(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city0", "city2", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city1", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city1", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city1", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city1", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city1", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city1", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city1", "city1", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city1", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city1", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city1", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city1", "city1", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city1", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city1", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city1", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city1", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city1", "city1", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city1", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city1", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city1", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city1", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city1", "city1", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city1", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city1", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city1", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city1", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city1", "city1", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city1", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city1", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city1", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city1", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city1", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city1", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city1", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city1)", true)).
precondition(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city2)", true)).
postcondition(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city1", "city2", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city2", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city2", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city2", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city2", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city0)", true)).
postcondition(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city2", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city2", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city2", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city2", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city2", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(2), value("at(plane1, city1)", true)).
postcondition(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city2", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane1", "city2", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane1", "city2", "city2", "fl2", "fl1", "fl0")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city2", "fl2", "fl1", "fl0")), variable(3), value("fuel-level(plane1, fl2)", true)).
postcondition(action(("zoom", "plane1", "city2", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(3), value("fuel-level(plane1, fl0)", true)).
costs(action(("zoom", "plane1", "city2", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane1", "city2", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane1", "city2", "city2", "fl3", "fl2", "fl1")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city2", "fl3", "fl2", "fl1")), variable(3), value("fuel-level(plane1, fl3)", true)).
postcondition(action(("zoom", "plane1", "city2", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(3), value("fuel-level(plane1, fl1)", true)).
costs(action(("zoom", "plane1", "city2", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane1", "city2", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane1", "city2", "city2", "fl4", "fl3", "fl2")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city2", "fl4", "fl3", "fl2")), variable(3), value("fuel-level(plane1, fl4)", true)).
postcondition(action(("zoom", "plane1", "city2", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(3), value("fuel-level(plane1, fl2)", true)).
costs(action(("zoom", "plane1", "city2", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane1", "city2", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane1", "city2", "city2", "fl5", "fl4", "fl3")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city2", "fl5", "fl4", "fl3")), variable(3), value("fuel-level(plane1, fl5)", true)).
postcondition(action(("zoom", "plane1", "city2", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(3), value("fuel-level(plane1, fl3)", true)).
costs(action(("zoom", "plane1", "city2", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane1", "city2", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane1", "city2", "city2", "fl6", "fl5", "fl4")), variable(2), value("at(plane1, city2)", true)).
precondition(action(("zoom", "plane1", "city2", "city2", "fl6", "fl5", "fl4")), variable(3), value("fuel-level(plane1, fl6)", true)).
postcondition(action(("zoom", "plane1", "city2", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(3), value("fuel-level(plane1, fl4)", true)).
costs(action(("zoom", "plane1", "city2", "city2", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city0", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city0", "city0", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city0", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city0", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city0", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city0", "city0", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city0", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city0", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city0", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city0", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city0", "city0", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city0", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city0", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city0", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city0", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city0", "city0", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city0", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city0", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city0", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city0", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city0", "city0", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city0", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city0", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city0", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city0", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city0", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city0", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city0", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city0", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city0", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city0", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city0", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city0", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city0)", true)).
precondition(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city0", "city2", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city1", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city1", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city1", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city1", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city1", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city1", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city1", "city1", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city1", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city1", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city1", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city1", "city1", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city1", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city1", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city1", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city1", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city1", "city1", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city1", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city1", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city1", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city1", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city1", "city1", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city1", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city1", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city1", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city1", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city1", "city1", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city1", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city1", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city1", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city1", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city1", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city1", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city1", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city1)", true)).
precondition(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city2)", true)).
postcondition(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city1", "city2", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city2", "city0", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city2", "city0", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city2", "city0", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city2", "city0", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city0)", true)).
postcondition(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city2", "city0", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city2", "city1", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city2", "city1", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city2", "city1", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city2", "city1", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(1), value("at(plane2, city1)", true)).
postcondition(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city2", "city1", "fl6", "fl5", "fl4")), 1).

action(action(("zoom", "plane2", "city2", "city2", "fl2", "fl1", "fl0"))).
precondition(action(("zoom", "plane2", "city2", "city2", "fl2", "fl1", "fl0")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city2", "fl2", "fl1", "fl0")), variable(0), value("fuel-level(plane2, fl2)", true)).
postcondition(action(("zoom", "plane2", "city2", "city2", "fl2", "fl1", "fl0")), effect(unconditional), variable(0), value("fuel-level(plane2, fl0)", true)).
costs(action(("zoom", "plane2", "city2", "city2", "fl2", "fl1", "fl0")), 1).

action(action(("zoom", "plane2", "city2", "city2", "fl3", "fl2", "fl1"))).
precondition(action(("zoom", "plane2", "city2", "city2", "fl3", "fl2", "fl1")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city2", "fl3", "fl2", "fl1")), variable(0), value("fuel-level(plane2, fl3)", true)).
postcondition(action(("zoom", "plane2", "city2", "city2", "fl3", "fl2", "fl1")), effect(unconditional), variable(0), value("fuel-level(plane2, fl1)", true)).
costs(action(("zoom", "plane2", "city2", "city2", "fl3", "fl2", "fl1")), 1).

action(action(("zoom", "plane2", "city2", "city2", "fl4", "fl3", "fl2"))).
precondition(action(("zoom", "plane2", "city2", "city2", "fl4", "fl3", "fl2")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city2", "fl4", "fl3", "fl2")), variable(0), value("fuel-level(plane2, fl4)", true)).
postcondition(action(("zoom", "plane2", "city2", "city2", "fl4", "fl3", "fl2")), effect(unconditional), variable(0), value("fuel-level(plane2, fl2)", true)).
costs(action(("zoom", "plane2", "city2", "city2", "fl4", "fl3", "fl2")), 1).

action(action(("zoom", "plane2", "city2", "city2", "fl5", "fl4", "fl3"))).
precondition(action(("zoom", "plane2", "city2", "city2", "fl5", "fl4", "fl3")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city2", "fl5", "fl4", "fl3")), variable(0), value("fuel-level(plane2, fl5)", true)).
postcondition(action(("zoom", "plane2", "city2", "city2", "fl5", "fl4", "fl3")), effect(unconditional), variable(0), value("fuel-level(plane2, fl3)", true)).
costs(action(("zoom", "plane2", "city2", "city2", "fl5", "fl4", "fl3")), 1).

action(action(("zoom", "plane2", "city2", "city2", "fl6", "fl5", "fl4"))).
precondition(action(("zoom", "plane2", "city2", "city2", "fl6", "fl5", "fl4")), variable(1), value("at(plane2, city2)", true)).
precondition(action(("zoom", "plane2", "city2", "city2", "fl6", "fl5", "fl4")), variable(0), value("fuel-level(plane2, fl6)", true)).
postcondition(action(("zoom", "plane2", "city2", "city2", "fl6", "fl5", "fl4")), effect(unconditional), variable(0), value("fuel-level(plane2, fl4)", true)).
costs(action(("zoom", "plane2", "city2", "city2", "fl6", "fl5", "fl4")), 1).

% initial state
initialState(variable(0), value("fuel-level(plane2, fl5)", true)).
initialState(variable(1), value("at(plane2, city2)", true)).
initialState(variable(2), value("at(plane1, city0)", true)).
initialState(variable(3), value("fuel-level(plane1, fl4)", true)).
initialState(variable(4), value("at(person4, city1)", true)).
initialState(variable(5), value("at(person3, city1)", true)).
initialState(variable(6), value("at(person2, city0)", true)).
initialState(variable(7), value("at(person1, city0)", true)).

% goal
goal(variable(1), value("at(plane2, city2)", true)).
goal(variable(4), value("at(person4, city1)", true)).
goal(variable(5), value("at(person3, city0)", true)).
goal(variable(6), value("at(person2, city0)", true)).
goal(variable(7), value("at(person1, city1)", true)).
