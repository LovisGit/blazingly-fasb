#const horizon=10.

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
contains(variable(0), value("at(truck1, depot0)", true)).
contains(variable(0), value("at(truck1, distributor0)", true)).
contains(variable(0), value("at(truck1, distributor1)", true)).

variable(variable(1)).
contains(variable(1), value("at(truck0, depot0)", true)).
contains(variable(1), value("at(truck0, distributor0)", true)).
contains(variable(1), value("at(truck0, distributor1)", true)).

variable(variable(2)).
contains(variable(2), value("clear(pallet0)", true)).
contains(variable(2), value("clear(pallet0)", false)).

variable(variable(3)).
contains(variable(3), value("clear(pallet1)", true)).
contains(variable(3), value("clear(pallet1)", false)).

variable(variable(4)).
contains(variable(4), value("clear(pallet2)", true)).
contains(variable(4), value("clear(pallet2)", false)).

variable(variable(5)).
contains(variable(5), value("available(hoist0)", true)).
contains(variable(5), value("available(hoist0)", false)).

variable(variable(6)).
contains(variable(6), value("available(hoist1)", true)).
contains(variable(6), value("available(hoist1)", false)).

variable(variable(7)).
contains(variable(7), value("available(hoist2)", true)).
contains(variable(7), value("available(hoist2)", false)).

variable(variable(8)).
contains(variable(8), value("at(crate0, depot0)", true)).
contains(variable(8), value("at(crate0, distributor0)", true)).
contains(variable(8), value("at(crate0, distributor1)", true)).
contains(variable(8), value(none)).

variable(variable(9)).
contains(variable(9), value("at(crate1, depot0)", true)).
contains(variable(9), value("at(crate1, distributor0)", true)).
contains(variable(9), value("at(crate1, distributor1)", true)).
contains(variable(9), value(none)).

variable(variable(10)).
contains(variable(10), value("clear(crate0)", true)).
contains(variable(10), value("clear(crate0)", false)).

variable(variable(11)).
contains(variable(11), value("clear(crate1)", true)).
contains(variable(11), value("clear(crate1)", false)).

variable(variable(12)).
contains(variable(12), value("in(crate0, truck0)", true)).
contains(variable(12), value("in(crate0, truck1)", true)).
contains(variable(12), value("lifting(hoist0, crate0)", true)).
contains(variable(12), value("lifting(hoist1, crate0)", true)).
contains(variable(12), value("lifting(hoist2, crate0)", true)).
contains(variable(12), value("on(crate0, crate1)", true)).
contains(variable(12), value("on(crate0, pallet0)", true)).
contains(variable(12), value("on(crate0, pallet1)", true)).
contains(variable(12), value("on(crate0, pallet2)", true)).

variable(variable(13)).
contains(variable(13), value("in(crate1, truck0)", true)).
contains(variable(13), value("in(crate1, truck1)", true)).
contains(variable(13), value("lifting(hoist0, crate1)", true)).
contains(variable(13), value("lifting(hoist1, crate1)", true)).
contains(variable(13), value("lifting(hoist2, crate1)", true)).
contains(variable(13), value("on(crate1, crate0)", true)).
contains(variable(13), value("on(crate1, pallet0)", true)).
contains(variable(13), value("on(crate1, pallet1)", true)).
contains(variable(13), value("on(crate1, pallet2)", true)).

% actions
action(action(("drive", "truck0", "depot0", "distributor0"))).
precondition(action(("drive", "truck0", "depot0", "distributor0")), variable(1), value("at(truck0, depot0)", true)).
postcondition(action(("drive", "truck0", "depot0", "distributor0")), effect(unconditional), variable(1), value("at(truck0, distributor0)", true)).
costs(action(("drive", "truck0", "depot0", "distributor0")), 1).

action(action(("drive", "truck0", "depot0", "distributor1"))).
precondition(action(("drive", "truck0", "depot0", "distributor1")), variable(1), value("at(truck0, depot0)", true)).
postcondition(action(("drive", "truck0", "depot0", "distributor1")), effect(unconditional), variable(1), value("at(truck0, distributor1)", true)).
costs(action(("drive", "truck0", "depot0", "distributor1")), 1).

action(action(("drive", "truck0", "distributor0", "depot0"))).
precondition(action(("drive", "truck0", "distributor0", "depot0")), variable(1), value("at(truck0, distributor0)", true)).
postcondition(action(("drive", "truck0", "distributor0", "depot0")), effect(unconditional), variable(1), value("at(truck0, depot0)", true)).
costs(action(("drive", "truck0", "distributor0", "depot0")), 1).

action(action(("drive", "truck0", "distributor0", "distributor1"))).
precondition(action(("drive", "truck0", "distributor0", "distributor1")), variable(1), value("at(truck0, distributor0)", true)).
postcondition(action(("drive", "truck0", "distributor0", "distributor1")), effect(unconditional), variable(1), value("at(truck0, distributor1)", true)).
costs(action(("drive", "truck0", "distributor0", "distributor1")), 1).

action(action(("drive", "truck0", "distributor1", "depot0"))).
precondition(action(("drive", "truck0", "distributor1", "depot0")), variable(1), value("at(truck0, distributor1)", true)).
postcondition(action(("drive", "truck0", "distributor1", "depot0")), effect(unconditional), variable(1), value("at(truck0, depot0)", true)).
costs(action(("drive", "truck0", "distributor1", "depot0")), 1).

action(action(("drive", "truck0", "distributor1", "distributor0"))).
precondition(action(("drive", "truck0", "distributor1", "distributor0")), variable(1), value("at(truck0, distributor1)", true)).
postcondition(action(("drive", "truck0", "distributor1", "distributor0")), effect(unconditional), variable(1), value("at(truck0, distributor0)", true)).
costs(action(("drive", "truck0", "distributor1", "distributor0")), 1).

action(action(("drive", "truck1", "depot0", "distributor0"))).
precondition(action(("drive", "truck1", "depot0", "distributor0")), variable(0), value("at(truck1, depot0)", true)).
postcondition(action(("drive", "truck1", "depot0", "distributor0")), effect(unconditional), variable(0), value("at(truck1, distributor0)", true)).
costs(action(("drive", "truck1", "depot0", "distributor0")), 1).

action(action(("drive", "truck1", "depot0", "distributor1"))).
precondition(action(("drive", "truck1", "depot0", "distributor1")), variable(0), value("at(truck1, depot0)", true)).
postcondition(action(("drive", "truck1", "depot0", "distributor1")), effect(unconditional), variable(0), value("at(truck1, distributor1)", true)).
costs(action(("drive", "truck1", "depot0", "distributor1")), 1).

action(action(("drive", "truck1", "distributor0", "depot0"))).
precondition(action(("drive", "truck1", "distributor0", "depot0")), variable(0), value("at(truck1, distributor0)", true)).
postcondition(action(("drive", "truck1", "distributor0", "depot0")), effect(unconditional), variable(0), value("at(truck1, depot0)", true)).
costs(action(("drive", "truck1", "distributor0", "depot0")), 1).

action(action(("drive", "truck1", "distributor0", "distributor1"))).
precondition(action(("drive", "truck1", "distributor0", "distributor1")), variable(0), value("at(truck1, distributor0)", true)).
postcondition(action(("drive", "truck1", "distributor0", "distributor1")), effect(unconditional), variable(0), value("at(truck1, distributor1)", true)).
costs(action(("drive", "truck1", "distributor0", "distributor1")), 1).

action(action(("drive", "truck1", "distributor1", "depot0"))).
precondition(action(("drive", "truck1", "distributor1", "depot0")), variable(0), value("at(truck1, distributor1)", true)).
postcondition(action(("drive", "truck1", "distributor1", "depot0")), effect(unconditional), variable(0), value("at(truck1, depot0)", true)).
costs(action(("drive", "truck1", "distributor1", "depot0")), 1).

action(action(("drive", "truck1", "distributor1", "distributor0"))).
precondition(action(("drive", "truck1", "distributor1", "distributor0")), variable(0), value("at(truck1, distributor1)", true)).
postcondition(action(("drive", "truck1", "distributor1", "distributor0")), effect(unconditional), variable(0), value("at(truck1, distributor0)", true)).
costs(action(("drive", "truck1", "distributor1", "distributor0")), 1).

action(action(("drop", "hoist0", "crate0", "crate1", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(9), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(11), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(12), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(8), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(12), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist0", "crate0", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), variable(12), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(8), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(12), value("on(crate0, pallet0)", true)).
costs(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(8), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(10), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(13), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(9), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(13), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist0", "crate1", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), variable(13), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(9), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(13), value("on(crate1, pallet0)", true)).
costs(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), 1).

action(action(("drop", "hoist1", "crate0", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(9), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(11), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(12), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(8), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(12), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), variable(12), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(8), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(12), value("on(crate0, pallet1)", true)).
costs(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(8), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(10), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(13), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(9), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(13), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), variable(13), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(9), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(13), value("on(crate1, pallet1)", true)).
costs(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist2", "crate0", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(9), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(11), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(12), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(8), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(12), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), variable(12), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(8), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(12), value("on(crate0, pallet2)", true)).
costs(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(8), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(10), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(13), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(9), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(13), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), variable(13), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(9), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(13), value("on(crate1, pallet2)", true)).
costs(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist0", "crate0", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(8), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(12), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(8), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(12), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(8), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(12), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(8), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(12), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(9), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(13), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(9), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(13), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(9), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(13), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(9), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(13), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), 1).

action(action(("lift", "hoist1", "crate0", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(8), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(12), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(8), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(12), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(8), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(12), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(8), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(12), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(9), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(13), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(9), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(13), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(9), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(13), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(9), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(13), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist2", "crate0", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(8), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(12), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(8), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(12), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(8), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(12), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(8), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(10), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(12), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(9), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(13), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(10), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(9), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(13), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(9), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(13), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(9), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(11), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(13), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(11), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), 1).

action(action(("load", "hoist0", "crate0", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), variable(12), value("lifting(hoist0, crate0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(12), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist0", "crate0", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate0", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), variable(12), value("lifting(hoist0, crate0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(12), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist0", "crate0", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate1", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), variable(13), value("lifting(hoist0, crate1)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(13), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist0", "crate1", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate1", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), variable(13), value("lifting(hoist0, crate1)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(13), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist0", "crate1", "truck1", "depot0")), 1).

action(action(("load", "hoist1", "crate0", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), variable(12), value("lifting(hoist1, crate0)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(12), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist1", "crate0", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate0", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), variable(12), value("lifting(hoist1, crate0)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(12), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist1", "crate0", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate1", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), variable(13), value("lifting(hoist1, crate1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(13), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist1", "crate1", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate1", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), variable(13), value("lifting(hoist1, crate1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(13), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist1", "crate1", "truck1", "distributor0")), 1).

action(action(("load", "hoist2", "crate0", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), variable(12), value("lifting(hoist2, crate0)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(12), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist2", "crate0", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate0", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), variable(12), value("lifting(hoist2, crate0)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(12), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist2", "crate0", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate1", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), variable(13), value("lifting(hoist2, crate1)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(13), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist2", "crate1", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate1", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), variable(13), value("lifting(hoist2, crate1)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(13), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist2", "crate1", "truck1", "distributor1")), 1).

action(action(("unload", "hoist0", "crate0", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(12), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("unload", "hoist0", "crate0", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate0", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(12), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(12), value("lifting(hoist0, crate0)", true)).
costs(action(("unload", "hoist0", "crate0", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate1", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(13), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("unload", "hoist0", "crate1", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate1", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(5), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(13), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(5), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(13), value("lifting(hoist0, crate1)", true)).
costs(action(("unload", "hoist0", "crate1", "truck1", "depot0")), 1).

action(action(("unload", "hoist1", "crate0", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(12), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate0", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(12), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(12), value("lifting(hoist1, crate0)", true)).
costs(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate1", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(13), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate1", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(6), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(13), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(6), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(13), value("lifting(hoist1, crate1)", true)).
costs(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), 1).

action(action(("unload", "hoist2", "crate0", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(12), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate0", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(12), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(12), value("lifting(hoist2, crate0)", true)).
costs(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate1", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(13), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate1", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(7), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(13), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(7), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(13), value("lifting(hoist2, crate1)", true)).
costs(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(8), value("at(crate0, depot0)", true)).
contains(mutexGroup(0), variable(8), value("at(crate0, distributor0)", true)).
contains(mutexGroup(0), variable(8), value("at(crate0, distributor1)", true)).
contains(mutexGroup(0), variable(12), value("in(crate0, truck0)", true)).
contains(mutexGroup(0), variable(12), value("in(crate0, truck1)", true)).
contains(mutexGroup(0), variable(12), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(0), variable(12), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(0), variable(12), value("lifting(hoist2, crate0)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(9), value("at(crate1, depot0)", true)).
contains(mutexGroup(1), variable(9), value("at(crate1, distributor0)", true)).
contains(mutexGroup(1), variable(9), value("at(crate1, distributor1)", true)).
contains(mutexGroup(1), variable(13), value("in(crate1, truck0)", true)).
contains(mutexGroup(1), variable(13), value("in(crate1, truck1)", true)).
contains(mutexGroup(1), variable(13), value("lifting(hoist0, crate1)", true)).
contains(mutexGroup(1), variable(13), value("lifting(hoist1, crate1)", true)).
contains(mutexGroup(1), variable(13), value("lifting(hoist2, crate1)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(5), value("available(hoist0)", true)).
contains(mutexGroup(2), variable(12), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(2), variable(13), value("lifting(hoist0, crate1)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(6), value("available(hoist1)", true)).
contains(mutexGroup(3), variable(12), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(3), variable(13), value("lifting(hoist1, crate1)", true)).

mutexGroup(mutexGroup(4)).
contains(mutexGroup(4), variable(7), value("available(hoist2)", true)).
contains(mutexGroup(4), variable(12), value("lifting(hoist2, crate0)", true)).
contains(mutexGroup(4), variable(13), value("lifting(hoist2, crate1)", true)).

mutexGroup(mutexGroup(5)).
contains(mutexGroup(5), variable(10), value("clear(crate0)", true)).
contains(mutexGroup(5), variable(12), value("in(crate0, truck0)", true)).
contains(mutexGroup(5), variable(12), value("in(crate0, truck1)", true)).
contains(mutexGroup(5), variable(12), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(5), variable(12), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(5), variable(12), value("lifting(hoist2, crate0)", true)).
contains(mutexGroup(5), variable(13), value("on(crate1, crate0)", true)).

mutexGroup(mutexGroup(6)).
contains(mutexGroup(6), variable(11), value("clear(crate1)", true)).
contains(mutexGroup(6), variable(12), value("on(crate0, crate1)", true)).
contains(mutexGroup(6), variable(13), value("in(crate1, truck0)", true)).
contains(mutexGroup(6), variable(13), value("in(crate1, truck1)", true)).
contains(mutexGroup(6), variable(13), value("lifting(hoist0, crate1)", true)).
contains(mutexGroup(6), variable(13), value("lifting(hoist1, crate1)", true)).
contains(mutexGroup(6), variable(13), value("lifting(hoist2, crate1)", true)).

mutexGroup(mutexGroup(7)).
contains(mutexGroup(7), variable(2), value("clear(pallet0)", true)).
contains(mutexGroup(7), variable(12), value("on(crate0, pallet0)", true)).
contains(mutexGroup(7), variable(13), value("on(crate1, pallet0)", true)).

mutexGroup(mutexGroup(8)).
contains(mutexGroup(8), variable(3), value("clear(pallet1)", true)).
contains(mutexGroup(8), variable(12), value("on(crate0, pallet1)", true)).
contains(mutexGroup(8), variable(13), value("on(crate1, pallet1)", true)).

mutexGroup(mutexGroup(9)).
contains(mutexGroup(9), variable(4), value("clear(pallet2)", true)).
contains(mutexGroup(9), variable(12), value("on(crate0, pallet2)", true)).
contains(mutexGroup(9), variable(13), value("on(crate1, pallet2)", true)).

% initial state
initialState(variable(0), value("at(truck1, depot0)", true)).
initialState(variable(1), value("at(truck0, distributor1)", true)).
initialState(variable(2), value("clear(pallet0)", false)).
initialState(variable(3), value("clear(pallet1)", false)).
initialState(variable(4), value("clear(pallet2)", true)).
initialState(variable(5), value("available(hoist0)", true)).
initialState(variable(6), value("available(hoist1)", true)).
initialState(variable(7), value("available(hoist2)", true)).
initialState(variable(8), value("at(crate0, distributor0)", true)).
initialState(variable(9), value("at(crate1, depot0)", true)).
initialState(variable(10), value("clear(crate0)", true)).
initialState(variable(11), value("clear(crate1)", true)).
initialState(variable(12), value("on(crate0, pallet1)", true)).
initialState(variable(13), value("on(crate1, pallet0)", true)).

% goal
goal(variable(12), value("on(crate0, pallet2)", true)).
goal(variable(13), value("on(crate1, pallet1)", true)).
