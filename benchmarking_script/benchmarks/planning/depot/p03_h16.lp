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
contains(variable(5), value("at(crate0, depot0)", true)).
contains(variable(5), value("at(crate0, distributor0)", true)).
contains(variable(5), value("at(crate0, distributor1)", true)).
contains(variable(5), value(none)).

variable(variable(6)).
contains(variable(6), value("at(crate1, depot0)", true)).
contains(variable(6), value("at(crate1, distributor0)", true)).
contains(variable(6), value("at(crate1, distributor1)", true)).
contains(variable(6), value(none)).

variable(variable(7)).
contains(variable(7), value("at(crate2, depot0)", true)).
contains(variable(7), value("at(crate2, distributor0)", true)).
contains(variable(7), value("at(crate2, distributor1)", true)).
contains(variable(7), value(none)).

variable(variable(8)).
contains(variable(8), value("at(crate3, depot0)", true)).
contains(variable(8), value("at(crate3, distributor0)", true)).
contains(variable(8), value("at(crate3, distributor1)", true)).
contains(variable(8), value(none)).

variable(variable(9)).
contains(variable(9), value("at(crate4, depot0)", true)).
contains(variable(9), value("at(crate4, distributor0)", true)).
contains(variable(9), value("at(crate4, distributor1)", true)).
contains(variable(9), value(none)).

variable(variable(10)).
contains(variable(10), value("at(crate5, depot0)", true)).
contains(variable(10), value("at(crate5, distributor0)", true)).
contains(variable(10), value("at(crate5, distributor1)", true)).
contains(variable(10), value(none)).

variable(variable(11)).
contains(variable(11), value("clear(crate0)", true)).
contains(variable(11), value("clear(crate0)", false)).

variable(variable(12)).
contains(variable(12), value("clear(crate1)", true)).
contains(variable(12), value("clear(crate1)", false)).

variable(variable(13)).
contains(variable(13), value("clear(crate2)", true)).
contains(variable(13), value("clear(crate2)", false)).

variable(variable(14)).
contains(variable(14), value("clear(crate3)", true)).
contains(variable(14), value("clear(crate3)", false)).

variable(variable(15)).
contains(variable(15), value("clear(crate4)", true)).
contains(variable(15), value("clear(crate4)", false)).

variable(variable(16)).
contains(variable(16), value("clear(crate5)", true)).
contains(variable(16), value("clear(crate5)", false)).

variable(variable(17)).
contains(variable(17), value("available(hoist0)", true)).
contains(variable(17), value("available(hoist0)", false)).

variable(variable(18)).
contains(variable(18), value("available(hoist1)", true)).
contains(variable(18), value("available(hoist1)", false)).

variable(variable(19)).
contains(variable(19), value("available(hoist2)", true)).
contains(variable(19), value("available(hoist2)", false)).

variable(variable(20)).
contains(variable(20), value("in(crate0, truck0)", true)).
contains(variable(20), value("in(crate0, truck1)", true)).
contains(variable(20), value("lifting(hoist0, crate0)", true)).
contains(variable(20), value("lifting(hoist1, crate0)", true)).
contains(variable(20), value("lifting(hoist2, crate0)", true)).
contains(variable(20), value("on(crate0, crate1)", true)).
contains(variable(20), value("on(crate0, crate2)", true)).
contains(variable(20), value("on(crate0, crate3)", true)).
contains(variable(20), value("on(crate0, crate4)", true)).
contains(variable(20), value("on(crate0, crate5)", true)).
contains(variable(20), value("on(crate0, pallet0)", true)).
contains(variable(20), value("on(crate0, pallet1)", true)).
contains(variable(20), value("on(crate0, pallet2)", true)).

variable(variable(21)).
contains(variable(21), value("in(crate1, truck0)", true)).
contains(variable(21), value("in(crate1, truck1)", true)).
contains(variable(21), value("lifting(hoist0, crate1)", true)).
contains(variable(21), value("lifting(hoist1, crate1)", true)).
contains(variable(21), value("lifting(hoist2, crate1)", true)).
contains(variable(21), value("on(crate1, crate0)", true)).
contains(variable(21), value("on(crate1, crate2)", true)).
contains(variable(21), value("on(crate1, crate3)", true)).
contains(variable(21), value("on(crate1, crate4)", true)).
contains(variable(21), value("on(crate1, crate5)", true)).
contains(variable(21), value("on(crate1, pallet0)", true)).
contains(variable(21), value("on(crate1, pallet1)", true)).
contains(variable(21), value("on(crate1, pallet2)", true)).

variable(variable(22)).
contains(variable(22), value("in(crate2, truck0)", true)).
contains(variable(22), value("in(crate2, truck1)", true)).
contains(variable(22), value("lifting(hoist0, crate2)", true)).
contains(variable(22), value("lifting(hoist1, crate2)", true)).
contains(variable(22), value("lifting(hoist2, crate2)", true)).
contains(variable(22), value("on(crate2, crate0)", true)).
contains(variable(22), value("on(crate2, crate1)", true)).
contains(variable(22), value("on(crate2, crate3)", true)).
contains(variable(22), value("on(crate2, crate4)", true)).
contains(variable(22), value("on(crate2, crate5)", true)).
contains(variable(22), value("on(crate2, pallet0)", true)).
contains(variable(22), value("on(crate2, pallet1)", true)).
contains(variable(22), value("on(crate2, pallet2)", true)).

variable(variable(23)).
contains(variable(23), value("in(crate3, truck0)", true)).
contains(variable(23), value("in(crate3, truck1)", true)).
contains(variable(23), value("lifting(hoist0, crate3)", true)).
contains(variable(23), value("lifting(hoist1, crate3)", true)).
contains(variable(23), value("lifting(hoist2, crate3)", true)).
contains(variable(23), value("on(crate3, crate0)", true)).
contains(variable(23), value("on(crate3, crate1)", true)).
contains(variable(23), value("on(crate3, crate2)", true)).
contains(variable(23), value("on(crate3, crate4)", true)).
contains(variable(23), value("on(crate3, crate5)", true)).
contains(variable(23), value("on(crate3, pallet0)", true)).
contains(variable(23), value("on(crate3, pallet1)", true)).
contains(variable(23), value("on(crate3, pallet2)", true)).

variable(variable(24)).
contains(variable(24), value("in(crate4, truck0)", true)).
contains(variable(24), value("in(crate4, truck1)", true)).
contains(variable(24), value("lifting(hoist0, crate4)", true)).
contains(variable(24), value("lifting(hoist1, crate4)", true)).
contains(variable(24), value("lifting(hoist2, crate4)", true)).
contains(variable(24), value("on(crate4, crate0)", true)).
contains(variable(24), value("on(crate4, crate1)", true)).
contains(variable(24), value("on(crate4, crate2)", true)).
contains(variable(24), value("on(crate4, crate3)", true)).
contains(variable(24), value("on(crate4, crate5)", true)).
contains(variable(24), value("on(crate4, pallet0)", true)).
contains(variable(24), value("on(crate4, pallet1)", true)).
contains(variable(24), value("on(crate4, pallet2)", true)).

variable(variable(25)).
contains(variable(25), value("in(crate5, truck0)", true)).
contains(variable(25), value("in(crate5, truck1)", true)).
contains(variable(25), value("lifting(hoist0, crate5)", true)).
contains(variable(25), value("lifting(hoist1, crate5)", true)).
contains(variable(25), value("lifting(hoist2, crate5)", true)).
contains(variable(25), value("on(crate5, crate0)", true)).
contains(variable(25), value("on(crate5, crate1)", true)).
contains(variable(25), value("on(crate5, crate2)", true)).
contains(variable(25), value("on(crate5, crate3)", true)).
contains(variable(25), value("on(crate5, crate4)", true)).
contains(variable(25), value("on(crate5, pallet0)", true)).
contains(variable(25), value("on(crate5, pallet1)", true)).
contains(variable(25), value("on(crate5, pallet2)", true)).

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
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(20), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist0", "crate0", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "crate2", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(20), value("on(crate0, crate2)", true)).
costs(action(("drop", "hoist0", "crate0", "crate2", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "crate3", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(20), value("on(crate0, crate3)", true)).
costs(action(("drop", "hoist0", "crate0", "crate3", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "crate4", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(20), value("on(crate0, crate4)", true)).
costs(action(("drop", "hoist0", "crate0", "crate4", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "crate5", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(20), value("on(crate0, crate5)", true)).
costs(action(("drop", "hoist0", "crate0", "crate5", "depot0")), 1).

action(action(("drop", "hoist0", "crate0", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(5), value("at(crate0, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(20), value("on(crate0, pallet0)", true)).
costs(action(("drop", "hoist0", "crate0", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(21), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist0", "crate1", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate2", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(21), value("on(crate1, crate2)", true)).
costs(action(("drop", "hoist0", "crate1", "crate2", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate3", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(21), value("on(crate1, crate3)", true)).
costs(action(("drop", "hoist0", "crate1", "crate3", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate4", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(21), value("on(crate1, crate4)", true)).
costs(action(("drop", "hoist0", "crate1", "crate4", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "crate5", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(21), value("on(crate1, crate5)", true)).
costs(action(("drop", "hoist0", "crate1", "crate5", "depot0")), 1).

action(action(("drop", "hoist0", "crate1", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(6), value("at(crate1, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(21), value("on(crate1, pallet0)", true)).
costs(action(("drop", "hoist0", "crate1", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(22), value("on(crate2, crate0)", true)).
costs(action(("drop", "hoist0", "crate2", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "crate1", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(22), value("on(crate2, crate1)", true)).
costs(action(("drop", "hoist0", "crate2", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "crate3", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(22), value("on(crate2, crate3)", true)).
costs(action(("drop", "hoist0", "crate2", "crate3", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "crate4", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(22), value("on(crate2, crate4)", true)).
costs(action(("drop", "hoist0", "crate2", "crate4", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "crate5", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(22), value("on(crate2, crate5)", true)).
costs(action(("drop", "hoist0", "crate2", "crate5", "depot0")), 1).

action(action(("drop", "hoist0", "crate2", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(7), value("at(crate2, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(22), value("on(crate2, pallet0)", true)).
costs(action(("drop", "hoist0", "crate2", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(23), value("on(crate3, crate0)", true)).
costs(action(("drop", "hoist0", "crate3", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "crate1", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(23), value("on(crate3, crate1)", true)).
costs(action(("drop", "hoist0", "crate3", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "crate2", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(23), value("on(crate3, crate2)", true)).
costs(action(("drop", "hoist0", "crate3", "crate2", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "crate4", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(23), value("on(crate3, crate4)", true)).
costs(action(("drop", "hoist0", "crate3", "crate4", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "crate5", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(23), value("on(crate3, crate5)", true)).
costs(action(("drop", "hoist0", "crate3", "crate5", "depot0")), 1).

action(action(("drop", "hoist0", "crate3", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(8), value("at(crate3, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(23), value("on(crate3, pallet0)", true)).
costs(action(("drop", "hoist0", "crate3", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(24), value("on(crate4, crate0)", true)).
costs(action(("drop", "hoist0", "crate4", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "crate1", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(24), value("on(crate4, crate1)", true)).
costs(action(("drop", "hoist0", "crate4", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "crate2", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(24), value("on(crate4, crate2)", true)).
costs(action(("drop", "hoist0", "crate4", "crate2", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "crate3", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(24), value("on(crate4, crate3)", true)).
costs(action(("drop", "hoist0", "crate4", "crate3", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "crate5", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(24), value("on(crate4, crate5)", true)).
costs(action(("drop", "hoist0", "crate4", "crate5", "depot0")), 1).

action(action(("drop", "hoist0", "crate4", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(9), value("at(crate4, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(24), value("on(crate4, pallet0)", true)).
costs(action(("drop", "hoist0", "crate4", "pallet0", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "crate0", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(25), value("on(crate5, crate0)", true)).
costs(action(("drop", "hoist0", "crate5", "crate0", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "crate1", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(25), value("on(crate5, crate1)", true)).
costs(action(("drop", "hoist0", "crate5", "crate1", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "crate2", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(25), value("on(crate5, crate2)", true)).
costs(action(("drop", "hoist0", "crate5", "crate2", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "crate3", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(25), value("on(crate5, crate3)", true)).
costs(action(("drop", "hoist0", "crate5", "crate3", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "crate4", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(25), value("on(crate5, crate4)", true)).
costs(action(("drop", "hoist0", "crate5", "crate4", "depot0")), 1).

action(action(("drop", "hoist0", "crate5", "pallet0", "depot0"))).
precondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), variable(2), value("clear(pallet0)", true)).
precondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(10), value("at(crate5, depot0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", false)).
postcondition(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(25), value("on(crate5, pallet0)", true)).
costs(action(("drop", "hoist0", "crate5", "pallet0", "depot0")), 1).

action(action(("drop", "hoist1", "crate0", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(20), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist1", "crate0", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "crate2", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(20), value("on(crate0, crate2)", true)).
costs(action(("drop", "hoist1", "crate0", "crate2", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "crate3", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(20), value("on(crate0, crate3)", true)).
costs(action(("drop", "hoist1", "crate0", "crate3", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "crate4", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(20), value("on(crate0, crate4)", true)).
costs(action(("drop", "hoist1", "crate0", "crate4", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "crate5", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(20), value("on(crate0, crate5)", true)).
costs(action(("drop", "hoist1", "crate0", "crate5", "distributor0")), 1).

action(action(("drop", "hoist1", "crate0", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(5), value("at(crate0, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(20), value("on(crate0, pallet1)", true)).
costs(action(("drop", "hoist1", "crate0", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(21), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist1", "crate1", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate2", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(21), value("on(crate1, crate2)", true)).
costs(action(("drop", "hoist1", "crate1", "crate2", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate3", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(21), value("on(crate1, crate3)", true)).
costs(action(("drop", "hoist1", "crate1", "crate3", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate4", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(21), value("on(crate1, crate4)", true)).
costs(action(("drop", "hoist1", "crate1", "crate4", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "crate5", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(21), value("on(crate1, crate5)", true)).
costs(action(("drop", "hoist1", "crate1", "crate5", "distributor0")), 1).

action(action(("drop", "hoist1", "crate1", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(6), value("at(crate1, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(21), value("on(crate1, pallet1)", true)).
costs(action(("drop", "hoist1", "crate1", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(22), value("on(crate2, crate0)", true)).
costs(action(("drop", "hoist1", "crate2", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(22), value("on(crate2, crate1)", true)).
costs(action(("drop", "hoist1", "crate2", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "crate3", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(22), value("on(crate2, crate3)", true)).
costs(action(("drop", "hoist1", "crate2", "crate3", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "crate4", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(22), value("on(crate2, crate4)", true)).
costs(action(("drop", "hoist1", "crate2", "crate4", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "crate5", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(22), value("on(crate2, crate5)", true)).
costs(action(("drop", "hoist1", "crate2", "crate5", "distributor0")), 1).

action(action(("drop", "hoist1", "crate2", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(7), value("at(crate2, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(22), value("on(crate2, pallet1)", true)).
costs(action(("drop", "hoist1", "crate2", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(23), value("on(crate3, crate0)", true)).
costs(action(("drop", "hoist1", "crate3", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(23), value("on(crate3, crate1)", true)).
costs(action(("drop", "hoist1", "crate3", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "crate2", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(23), value("on(crate3, crate2)", true)).
costs(action(("drop", "hoist1", "crate3", "crate2", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "crate4", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(23), value("on(crate3, crate4)", true)).
costs(action(("drop", "hoist1", "crate3", "crate4", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "crate5", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(23), value("on(crate3, crate5)", true)).
costs(action(("drop", "hoist1", "crate3", "crate5", "distributor0")), 1).

action(action(("drop", "hoist1", "crate3", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(8), value("at(crate3, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(23), value("on(crate3, pallet1)", true)).
costs(action(("drop", "hoist1", "crate3", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(24), value("on(crate4, crate0)", true)).
costs(action(("drop", "hoist1", "crate4", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(24), value("on(crate4, crate1)", true)).
costs(action(("drop", "hoist1", "crate4", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "crate2", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(24), value("on(crate4, crate2)", true)).
costs(action(("drop", "hoist1", "crate4", "crate2", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "crate3", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(24), value("on(crate4, crate3)", true)).
costs(action(("drop", "hoist1", "crate4", "crate3", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "crate5", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(24), value("on(crate4, crate5)", true)).
costs(action(("drop", "hoist1", "crate4", "crate5", "distributor0")), 1).

action(action(("drop", "hoist1", "crate4", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(9), value("at(crate4, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(24), value("on(crate4, pallet1)", true)).
costs(action(("drop", "hoist1", "crate4", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "crate0", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(25), value("on(crate5, crate0)", true)).
costs(action(("drop", "hoist1", "crate5", "crate0", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "crate1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(25), value("on(crate5, crate1)", true)).
costs(action(("drop", "hoist1", "crate5", "crate1", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "crate2", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(25), value("on(crate5, crate2)", true)).
costs(action(("drop", "hoist1", "crate5", "crate2", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "crate3", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(25), value("on(crate5, crate3)", true)).
costs(action(("drop", "hoist1", "crate5", "crate3", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "crate4", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(25), value("on(crate5, crate4)", true)).
costs(action(("drop", "hoist1", "crate5", "crate4", "distributor0")), 1).

action(action(("drop", "hoist1", "crate5", "pallet1", "distributor0"))).
precondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), variable(3), value("clear(pallet1)", true)).
precondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(10), value("at(crate5, distributor0)", true)).
postcondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", false)).
postcondition(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(25), value("on(crate5, pallet1)", true)).
costs(action(("drop", "hoist1", "crate5", "pallet1", "distributor0")), 1).

action(action(("drop", "hoist2", "crate0", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(20), value("on(crate0, crate1)", true)).
costs(action(("drop", "hoist2", "crate0", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "crate2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(20), value("on(crate0, crate2)", true)).
costs(action(("drop", "hoist2", "crate0", "crate2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "crate3", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(20), value("on(crate0, crate3)", true)).
costs(action(("drop", "hoist2", "crate0", "crate3", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "crate4", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(20), value("on(crate0, crate4)", true)).
costs(action(("drop", "hoist2", "crate0", "crate4", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "crate5", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(20), value("on(crate0, crate5)", true)).
costs(action(("drop", "hoist2", "crate0", "crate5", "distributor1")), 1).

action(action(("drop", "hoist2", "crate0", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(5), value("at(crate0, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(20), value("on(crate0, pallet2)", true)).
costs(action(("drop", "hoist2", "crate0", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(21), value("on(crate1, crate0)", true)).
costs(action(("drop", "hoist2", "crate1", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(21), value("on(crate1, crate2)", true)).
costs(action(("drop", "hoist2", "crate1", "crate2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate3", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(21), value("on(crate1, crate3)", true)).
costs(action(("drop", "hoist2", "crate1", "crate3", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate4", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(21), value("on(crate1, crate4)", true)).
costs(action(("drop", "hoist2", "crate1", "crate4", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "crate5", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(21), value("on(crate1, crate5)", true)).
costs(action(("drop", "hoist2", "crate1", "crate5", "distributor1")), 1).

action(action(("drop", "hoist2", "crate1", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(6), value("at(crate1, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(21), value("on(crate1, pallet2)", true)).
costs(action(("drop", "hoist2", "crate1", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(22), value("on(crate2, crate0)", true)).
costs(action(("drop", "hoist2", "crate2", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(22), value("on(crate2, crate1)", true)).
costs(action(("drop", "hoist2", "crate2", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "crate3", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(22), value("on(crate2, crate3)", true)).
costs(action(("drop", "hoist2", "crate2", "crate3", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "crate4", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(22), value("on(crate2, crate4)", true)).
costs(action(("drop", "hoist2", "crate2", "crate4", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "crate5", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(22), value("on(crate2, crate5)", true)).
costs(action(("drop", "hoist2", "crate2", "crate5", "distributor1")), 1).

action(action(("drop", "hoist2", "crate2", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(7), value("at(crate2, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(22), value("on(crate2, pallet2)", true)).
costs(action(("drop", "hoist2", "crate2", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(23), value("on(crate3, crate0)", true)).
costs(action(("drop", "hoist2", "crate3", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(23), value("on(crate3, crate1)", true)).
costs(action(("drop", "hoist2", "crate3", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "crate2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(23), value("on(crate3, crate2)", true)).
costs(action(("drop", "hoist2", "crate3", "crate2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "crate4", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(23), value("on(crate3, crate4)", true)).
costs(action(("drop", "hoist2", "crate3", "crate4", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "crate5", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(23), value("on(crate3, crate5)", true)).
costs(action(("drop", "hoist2", "crate3", "crate5", "distributor1")), 1).

action(action(("drop", "hoist2", "crate3", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(8), value("at(crate3, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(23), value("on(crate3, pallet2)", true)).
costs(action(("drop", "hoist2", "crate3", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(24), value("on(crate4, crate0)", true)).
costs(action(("drop", "hoist2", "crate4", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(24), value("on(crate4, crate1)", true)).
costs(action(("drop", "hoist2", "crate4", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "crate2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(24), value("on(crate4, crate2)", true)).
costs(action(("drop", "hoist2", "crate4", "crate2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "crate3", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(24), value("on(crate4, crate3)", true)).
costs(action(("drop", "hoist2", "crate4", "crate3", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "crate5", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(24), value("on(crate4, crate5)", true)).
costs(action(("drop", "hoist2", "crate4", "crate5", "distributor1")), 1).

action(action(("drop", "hoist2", "crate4", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(9), value("at(crate4, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(24), value("on(crate4, pallet2)", true)).
costs(action(("drop", "hoist2", "crate4", "pallet2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "crate0", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(25), value("on(crate5, crate0)", true)).
costs(action(("drop", "hoist2", "crate5", "crate0", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "crate1", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(25), value("on(crate5, crate1)", true)).
costs(action(("drop", "hoist2", "crate5", "crate1", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "crate2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(25), value("on(crate5, crate2)", true)).
costs(action(("drop", "hoist2", "crate5", "crate2", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "crate3", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(25), value("on(crate5, crate3)", true)).
costs(action(("drop", "hoist2", "crate5", "crate3", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "crate4", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(25), value("on(crate5, crate4)", true)).
costs(action(("drop", "hoist2", "crate5", "crate4", "distributor1")), 1).

action(action(("drop", "hoist2", "crate5", "pallet2", "distributor1"))).
precondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), variable(4), value("clear(pallet2)", true)).
precondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(10), value("at(crate5, distributor1)", true)).
postcondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", false)).
postcondition(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(25), value("on(crate5, pallet2)", true)).
costs(action(("drop", "hoist2", "crate5", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist0", "crate0", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), variable(20), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate1", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "crate2", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), variable(20), value("on(crate0, crate2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate2", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate2", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "crate3", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), variable(20), value("on(crate0, crate3)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate3", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate3", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "crate4", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), variable(20), value("on(crate0, crate4)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate4", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate4", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "crate5", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), variable(20), value("on(crate0, crate5)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist0", "crate0", "crate5", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "crate5", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), variable(20), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), variable(20), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate0", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(5), value("at(crate0, depot0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), variable(20), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("lift", "hoist0", "crate0", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), variable(21), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate0", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate2", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), variable(21), value("on(crate1, crate2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate2", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate2", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate3", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), variable(21), value("on(crate1, crate3)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate3", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate3", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate4", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), variable(21), value("on(crate1, crate4)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate4", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate4", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "crate5", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), variable(21), value("on(crate1, crate5)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist0", "crate1", "crate5", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "crate5", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), variable(21), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), variable(21), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate1", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(6), value("at(crate1, depot0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), variable(21), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("lift", "hoist0", "crate1", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), variable(22), value("on(crate2, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate0", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), variable(22), value("on(crate2, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate1", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "crate3", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), variable(22), value("on(crate2, crate3)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate3", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "crate3", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "crate4", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), variable(22), value("on(crate2, crate4)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate4", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "crate4", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "crate5", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), variable(22), value("on(crate2, crate5)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist0", "crate2", "crate5", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "crate5", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), variable(22), value("on(crate2, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), variable(22), value("on(crate2, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate2", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), variable(7), value("at(crate2, depot0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), variable(22), value("on(crate2, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("lift", "hoist0", "crate2", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), variable(23), value("on(crate3, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate0", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), variable(23), value("on(crate3, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate1", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "crate2", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), variable(23), value("on(crate3, crate2)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate2", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "crate2", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "crate4", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), variable(23), value("on(crate3, crate4)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate4", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "crate4", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "crate5", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), variable(23), value("on(crate3, crate5)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist0", "crate3", "crate5", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "crate5", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), variable(23), value("on(crate3, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), variable(23), value("on(crate3, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate3", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), variable(8), value("at(crate3, depot0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), variable(23), value("on(crate3, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("lift", "hoist0", "crate3", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), variable(24), value("on(crate4, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate0", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), variable(24), value("on(crate4, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate1", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "crate2", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), variable(24), value("on(crate4, crate2)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate2", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "crate2", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "crate3", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), variable(24), value("on(crate4, crate3)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate3", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "crate3", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "crate5", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), variable(24), value("on(crate4, crate5)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist0", "crate4", "crate5", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "crate5", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), variable(24), value("on(crate4, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), variable(24), value("on(crate4, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate4", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), variable(9), value("at(crate4, depot0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), variable(24), value("on(crate4, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("lift", "hoist0", "crate4", "pallet2", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "crate0", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), variable(25), value("on(crate5, crate0)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate0", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "crate0", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "crate1", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), variable(25), value("on(crate5, crate1)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate1", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "crate1", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "crate2", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), variable(25), value("on(crate5, crate2)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate2", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "crate2", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "crate3", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), variable(25), value("on(crate5, crate3)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate3", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "crate3", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "crate4", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), variable(25), value("on(crate5, crate4)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "crate4", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "crate4", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "pallet0", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), variable(25), value("on(crate5, pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "pallet0", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "pallet1", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), variable(25), value("on(crate5, pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "pallet1", "depot0")), 1).

action(action(("lift", "hoist0", "crate5", "pallet2", "depot0"))).
precondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), variable(10), value("at(crate5, depot0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), variable(25), value("on(crate5, pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("lift", "hoist0", "crate5", "pallet2", "depot0")), 1).

action(action(("lift", "hoist1", "crate0", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), variable(20), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "crate2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), variable(20), value("on(crate0, crate2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "crate3", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), variable(20), value("on(crate0, crate3)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate3", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "crate4", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), variable(20), value("on(crate0, crate4)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate4", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "crate5", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), variable(20), value("on(crate0, crate5)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "crate5", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), variable(20), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), variable(20), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate0", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(5), value("at(crate0, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), variable(20), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("lift", "hoist1", "crate0", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), variable(21), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), variable(21), value("on(crate1, crate2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate3", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), variable(21), value("on(crate1, crate3)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate3", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate4", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), variable(21), value("on(crate1, crate4)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate4", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "crate5", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), variable(21), value("on(crate1, crate5)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "crate5", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), variable(21), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), variable(21), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate1", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(6), value("at(crate1, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), variable(21), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("lift", "hoist1", "crate1", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), variable(22), value("on(crate2, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), variable(22), value("on(crate2, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "crate3", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), variable(22), value("on(crate2, crate3)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "crate3", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "crate4", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), variable(22), value("on(crate2, crate4)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "crate4", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "crate5", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), variable(22), value("on(crate2, crate5)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "crate5", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), variable(22), value("on(crate2, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), variable(22), value("on(crate2, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate2", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), variable(7), value("at(crate2, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), variable(22), value("on(crate2, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("lift", "hoist1", "crate2", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), variable(23), value("on(crate3, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), variable(23), value("on(crate3, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "crate2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), variable(23), value("on(crate3, crate2)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "crate2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "crate4", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), variable(23), value("on(crate3, crate4)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "crate4", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "crate5", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), variable(23), value("on(crate3, crate5)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "crate5", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), variable(23), value("on(crate3, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), variable(23), value("on(crate3, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate3", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), variable(8), value("at(crate3, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), variable(23), value("on(crate3, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("lift", "hoist1", "crate3", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), variable(24), value("on(crate4, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), variable(24), value("on(crate4, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "crate2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), variable(24), value("on(crate4, crate2)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "crate2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "crate3", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), variable(24), value("on(crate4, crate3)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "crate3", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "crate5", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), variable(24), value("on(crate4, crate5)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "crate5", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), variable(24), value("on(crate4, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), variable(24), value("on(crate4, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate4", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), variable(9), value("at(crate4, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), variable(24), value("on(crate4, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("lift", "hoist1", "crate4", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "crate0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), variable(25), value("on(crate5, crate0)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "crate0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "crate1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), variable(25), value("on(crate5, crate1)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "crate1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "crate2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), variable(25), value("on(crate5, crate2)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "crate2", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "crate3", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), variable(25), value("on(crate5, crate3)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "crate3", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "crate4", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), variable(25), value("on(crate5, crate4)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "crate4", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "pallet0", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), variable(25), value("on(crate5, pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "pallet0", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "pallet1", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), variable(25), value("on(crate5, pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "pallet1", "distributor0")), 1).

action(action(("lift", "hoist1", "crate5", "pallet2", "distributor0"))).
precondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), variable(10), value("at(crate5, distributor0)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), variable(25), value("on(crate5, pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("lift", "hoist1", "crate5", "pallet2", "distributor0")), 1).

action(action(("lift", "hoist2", "crate0", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), variable(20), value("on(crate0, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "crate2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), variable(20), value("on(crate0, crate2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "crate3", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), variable(20), value("on(crate0, crate3)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate3", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "crate4", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), variable(20), value("on(crate0, crate4)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate4", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "crate5", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), variable(20), value("on(crate0, crate5)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "crate5", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), variable(20), value("on(crate0, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), variable(20), value("on(crate0, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate0", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(5), value("at(crate0, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(11), value("clear(crate0)", true)).
precondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), variable(20), value("on(crate0, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(5), value(none)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", false)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("lift", "hoist2", "crate0", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), variable(21), value("on(crate1, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), variable(21), value("on(crate1, crate2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate3", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), variable(21), value("on(crate1, crate3)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate3", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate4", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), variable(21), value("on(crate1, crate4)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate4", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "crate5", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), variable(21), value("on(crate1, crate5)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "crate5", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), variable(21), value("on(crate1, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), variable(21), value("on(crate1, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate1", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(6), value("at(crate1, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(12), value("clear(crate1)", true)).
precondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), variable(21), value("on(crate1, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(6), value(none)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", false)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("lift", "hoist2", "crate1", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), variable(22), value("on(crate2, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), variable(22), value("on(crate2, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "crate3", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), variable(22), value("on(crate2, crate3)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "crate3", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "crate4", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), variable(22), value("on(crate2, crate4)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "crate4", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "crate5", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), variable(22), value("on(crate2, crate5)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "crate5", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), variable(22), value("on(crate2, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), variable(22), value("on(crate2, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate2", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), variable(7), value("at(crate2, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), variable(13), value("clear(crate2)", true)).
precondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), variable(22), value("on(crate2, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(7), value(none)).
postcondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", false)).
postcondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("lift", "hoist2", "crate2", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), variable(23), value("on(crate3, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), variable(23), value("on(crate3, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "crate2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), variable(23), value("on(crate3, crate2)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "crate2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "crate4", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), variable(23), value("on(crate3, crate4)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "crate4", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "crate5", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), variable(23), value("on(crate3, crate5)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "crate5", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), variable(23), value("on(crate3, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), variable(23), value("on(crate3, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate3", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), variable(8), value("at(crate3, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), variable(14), value("clear(crate3)", true)).
precondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), variable(23), value("on(crate3, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(8), value(none)).
postcondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", false)).
postcondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("lift", "hoist2", "crate3", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), variable(24), value("on(crate4, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), variable(24), value("on(crate4, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "crate2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), variable(24), value("on(crate4, crate2)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "crate2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "crate3", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), variable(24), value("on(crate4, crate3)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "crate3", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "crate5", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), variable(24), value("on(crate4, crate5)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", true)).
postcondition(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "crate5", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), variable(24), value("on(crate4, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), variable(24), value("on(crate4, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate4", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), variable(9), value("at(crate4, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), variable(15), value("clear(crate4)", true)).
precondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), variable(24), value("on(crate4, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(9), value(none)).
postcondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", false)).
postcondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("lift", "hoist2", "crate4", "pallet2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "crate0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), variable(25), value("on(crate5, crate0)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(11), value("clear(crate0)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "crate0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "crate1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), variable(25), value("on(crate5, crate1)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(12), value("clear(crate1)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "crate1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "crate2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), variable(25), value("on(crate5, crate2)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(13), value("clear(crate2)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "crate2", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "crate3", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), variable(25), value("on(crate5, crate3)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(14), value("clear(crate3)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "crate3", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "crate4", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), variable(25), value("on(crate5, crate4)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(15), value("clear(crate4)", true)).
postcondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "crate4", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "pallet0", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), variable(25), value("on(crate5, pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), effect(unconditional), variable(2), value("clear(pallet0)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "pallet0", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "pallet1", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), variable(25), value("on(crate5, pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), effect(unconditional), variable(3), value("clear(pallet1)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "pallet1", "distributor1")), 1).

action(action(("lift", "hoist2", "crate5", "pallet2", "distributor1"))).
precondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), variable(10), value("at(crate5, distributor1)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), variable(16), value("clear(crate5)", true)).
precondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), variable(25), value("on(crate5, pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(10), value(none)).
postcondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(16), value("clear(crate5)", false)).
postcondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(4), value("clear(pallet2)", true)).
postcondition(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("lift", "hoist2", "crate5", "pallet2", "distributor1")), 1).

action(action(("load", "hoist0", "crate0", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(20), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist0", "crate0", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate0", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), variable(20), value("lifting(hoist0, crate0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(20), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist0", "crate0", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate1", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(21), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist0", "crate1", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate1", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), variable(21), value("lifting(hoist0, crate1)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(21), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist0", "crate1", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate2", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate2", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate2", "truck0", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("load", "hoist0", "crate2", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate2", "truck0", "depot0")), effect(unconditional), variable(22), value("in(crate2, truck0)", true)).
costs(action(("load", "hoist0", "crate2", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate2", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate2", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate2", "truck1", "depot0")), variable(22), value("lifting(hoist0, crate2)", true)).
postcondition(action(("load", "hoist0", "crate2", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate2", "truck1", "depot0")), effect(unconditional), variable(22), value("in(crate2, truck1)", true)).
costs(action(("load", "hoist0", "crate2", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate3", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate3", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate3", "truck0", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("load", "hoist0", "crate3", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate3", "truck0", "depot0")), effect(unconditional), variable(23), value("in(crate3, truck0)", true)).
costs(action(("load", "hoist0", "crate3", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate3", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate3", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate3", "truck1", "depot0")), variable(23), value("lifting(hoist0, crate3)", true)).
postcondition(action(("load", "hoist0", "crate3", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate3", "truck1", "depot0")), effect(unconditional), variable(23), value("in(crate3, truck1)", true)).
costs(action(("load", "hoist0", "crate3", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate4", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate4", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate4", "truck0", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("load", "hoist0", "crate4", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate4", "truck0", "depot0")), effect(unconditional), variable(24), value("in(crate4, truck0)", true)).
costs(action(("load", "hoist0", "crate4", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate4", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate4", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate4", "truck1", "depot0")), variable(24), value("lifting(hoist0, crate4)", true)).
postcondition(action(("load", "hoist0", "crate4", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate4", "truck1", "depot0")), effect(unconditional), variable(24), value("in(crate4, truck1)", true)).
costs(action(("load", "hoist0", "crate4", "truck1", "depot0")), 1).

action(action(("load", "hoist0", "crate5", "truck0", "depot0"))).
precondition(action(("load", "hoist0", "crate5", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("load", "hoist0", "crate5", "truck0", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("load", "hoist0", "crate5", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate5", "truck0", "depot0")), effect(unconditional), variable(25), value("in(crate5, truck0)", true)).
costs(action(("load", "hoist0", "crate5", "truck0", "depot0")), 1).

action(action(("load", "hoist0", "crate5", "truck1", "depot0"))).
precondition(action(("load", "hoist0", "crate5", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("load", "hoist0", "crate5", "truck1", "depot0")), variable(25), value("lifting(hoist0, crate5)", true)).
postcondition(action(("load", "hoist0", "crate5", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", true)).
postcondition(action(("load", "hoist0", "crate5", "truck1", "depot0")), effect(unconditional), variable(25), value("in(crate5, truck1)", true)).
costs(action(("load", "hoist0", "crate5", "truck1", "depot0")), 1).

action(action(("load", "hoist1", "crate0", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(20), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist1", "crate0", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate0", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), variable(20), value("lifting(hoist1, crate0)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(20), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist1", "crate0", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate1", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(21), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist1", "crate1", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate1", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), variable(21), value("lifting(hoist1, crate1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(21), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist1", "crate1", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate2", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate2", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate2", "truck0", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("load", "hoist1", "crate2", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate2", "truck0", "distributor0")), effect(unconditional), variable(22), value("in(crate2, truck0)", true)).
costs(action(("load", "hoist1", "crate2", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate2", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate2", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate2", "truck1", "distributor0")), variable(22), value("lifting(hoist1, crate2)", true)).
postcondition(action(("load", "hoist1", "crate2", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate2", "truck1", "distributor0")), effect(unconditional), variable(22), value("in(crate2, truck1)", true)).
costs(action(("load", "hoist1", "crate2", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate3", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate3", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate3", "truck0", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("load", "hoist1", "crate3", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate3", "truck0", "distributor0")), effect(unconditional), variable(23), value("in(crate3, truck0)", true)).
costs(action(("load", "hoist1", "crate3", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate3", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate3", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate3", "truck1", "distributor0")), variable(23), value("lifting(hoist1, crate3)", true)).
postcondition(action(("load", "hoist1", "crate3", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate3", "truck1", "distributor0")), effect(unconditional), variable(23), value("in(crate3, truck1)", true)).
costs(action(("load", "hoist1", "crate3", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate4", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate4", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate4", "truck0", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("load", "hoist1", "crate4", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate4", "truck0", "distributor0")), effect(unconditional), variable(24), value("in(crate4, truck0)", true)).
costs(action(("load", "hoist1", "crate4", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate4", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate4", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate4", "truck1", "distributor0")), variable(24), value("lifting(hoist1, crate4)", true)).
postcondition(action(("load", "hoist1", "crate4", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate4", "truck1", "distributor0")), effect(unconditional), variable(24), value("in(crate4, truck1)", true)).
costs(action(("load", "hoist1", "crate4", "truck1", "distributor0")), 1).

action(action(("load", "hoist1", "crate5", "truck0", "distributor0"))).
precondition(action(("load", "hoist1", "crate5", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("load", "hoist1", "crate5", "truck0", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("load", "hoist1", "crate5", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate5", "truck0", "distributor0")), effect(unconditional), variable(25), value("in(crate5, truck0)", true)).
costs(action(("load", "hoist1", "crate5", "truck0", "distributor0")), 1).

action(action(("load", "hoist1", "crate5", "truck1", "distributor0"))).
precondition(action(("load", "hoist1", "crate5", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("load", "hoist1", "crate5", "truck1", "distributor0")), variable(25), value("lifting(hoist1, crate5)", true)).
postcondition(action(("load", "hoist1", "crate5", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", true)).
postcondition(action(("load", "hoist1", "crate5", "truck1", "distributor0")), effect(unconditional), variable(25), value("in(crate5, truck1)", true)).
costs(action(("load", "hoist1", "crate5", "truck1", "distributor0")), 1).

action(action(("load", "hoist2", "crate0", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(20), value("in(crate0, truck0)", true)).
costs(action(("load", "hoist2", "crate0", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate0", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), variable(20), value("lifting(hoist2, crate0)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(20), value("in(crate0, truck1)", true)).
costs(action(("load", "hoist2", "crate0", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate1", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(21), value("in(crate1, truck0)", true)).
costs(action(("load", "hoist2", "crate1", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate1", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), variable(21), value("lifting(hoist2, crate1)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(21), value("in(crate1, truck1)", true)).
costs(action(("load", "hoist2", "crate1", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate2", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate2", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate2", "truck0", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("load", "hoist2", "crate2", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate2", "truck0", "distributor1")), effect(unconditional), variable(22), value("in(crate2, truck0)", true)).
costs(action(("load", "hoist2", "crate2", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate2", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate2", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate2", "truck1", "distributor1")), variable(22), value("lifting(hoist2, crate2)", true)).
postcondition(action(("load", "hoist2", "crate2", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate2", "truck1", "distributor1")), effect(unconditional), variable(22), value("in(crate2, truck1)", true)).
costs(action(("load", "hoist2", "crate2", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate3", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate3", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate3", "truck0", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("load", "hoist2", "crate3", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate3", "truck0", "distributor1")), effect(unconditional), variable(23), value("in(crate3, truck0)", true)).
costs(action(("load", "hoist2", "crate3", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate3", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate3", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate3", "truck1", "distributor1")), variable(23), value("lifting(hoist2, crate3)", true)).
postcondition(action(("load", "hoist2", "crate3", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate3", "truck1", "distributor1")), effect(unconditional), variable(23), value("in(crate3, truck1)", true)).
costs(action(("load", "hoist2", "crate3", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate4", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate4", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate4", "truck0", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("load", "hoist2", "crate4", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate4", "truck0", "distributor1")), effect(unconditional), variable(24), value("in(crate4, truck0)", true)).
costs(action(("load", "hoist2", "crate4", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate4", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate4", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate4", "truck1", "distributor1")), variable(24), value("lifting(hoist2, crate4)", true)).
postcondition(action(("load", "hoist2", "crate4", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate4", "truck1", "distributor1")), effect(unconditional), variable(24), value("in(crate4, truck1)", true)).
costs(action(("load", "hoist2", "crate4", "truck1", "distributor1")), 1).

action(action(("load", "hoist2", "crate5", "truck0", "distributor1"))).
precondition(action(("load", "hoist2", "crate5", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("load", "hoist2", "crate5", "truck0", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("load", "hoist2", "crate5", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate5", "truck0", "distributor1")), effect(unconditional), variable(25), value("in(crate5, truck0)", true)).
costs(action(("load", "hoist2", "crate5", "truck0", "distributor1")), 1).

action(action(("load", "hoist2", "crate5", "truck1", "distributor1"))).
precondition(action(("load", "hoist2", "crate5", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("load", "hoist2", "crate5", "truck1", "distributor1")), variable(25), value("lifting(hoist2, crate5)", true)).
postcondition(action(("load", "hoist2", "crate5", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", true)).
postcondition(action(("load", "hoist2", "crate5", "truck1", "distributor1")), effect(unconditional), variable(25), value("in(crate5, truck1)", true)).
costs(action(("load", "hoist2", "crate5", "truck1", "distributor1")), 1).

action(action(("unload", "hoist0", "crate0", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), variable(20), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate0", "truck0", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("unload", "hoist0", "crate0", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate0", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), variable(20), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate0", "truck1", "depot0")), effect(unconditional), variable(20), value("lifting(hoist0, crate0)", true)).
costs(action(("unload", "hoist0", "crate0", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate1", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), variable(21), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate1", "truck0", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("unload", "hoist0", "crate1", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate1", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), variable(21), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate1", "truck1", "depot0")), effect(unconditional), variable(21), value("lifting(hoist0, crate1)", true)).
costs(action(("unload", "hoist0", "crate1", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate2", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate2", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate2", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate2", "truck0", "depot0")), variable(22), value("in(crate2, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate2", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate2", "truck0", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("unload", "hoist0", "crate2", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate2", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate2", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate2", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate2", "truck1", "depot0")), variable(22), value("in(crate2, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate2", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate2", "truck1", "depot0")), effect(unconditional), variable(22), value("lifting(hoist0, crate2)", true)).
costs(action(("unload", "hoist0", "crate2", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate3", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate3", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate3", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate3", "truck0", "depot0")), variable(23), value("in(crate3, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate3", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate3", "truck0", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("unload", "hoist0", "crate3", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate3", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate3", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate3", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate3", "truck1", "depot0")), variable(23), value("in(crate3, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate3", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate3", "truck1", "depot0")), effect(unconditional), variable(23), value("lifting(hoist0, crate3)", true)).
costs(action(("unload", "hoist0", "crate3", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate4", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate4", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate4", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate4", "truck0", "depot0")), variable(24), value("in(crate4, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate4", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate4", "truck0", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("unload", "hoist0", "crate4", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate4", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate4", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate4", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate4", "truck1", "depot0")), variable(24), value("in(crate4, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate4", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate4", "truck1", "depot0")), effect(unconditional), variable(24), value("lifting(hoist0, crate4)", true)).
costs(action(("unload", "hoist0", "crate4", "truck1", "depot0")), 1).

action(action(("unload", "hoist0", "crate5", "truck0", "depot0"))).
precondition(action(("unload", "hoist0", "crate5", "truck0", "depot0")), variable(1), value("at(truck0, depot0)", true)).
precondition(action(("unload", "hoist0", "crate5", "truck0", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate5", "truck0", "depot0")), variable(25), value("in(crate5, truck0)", true)).
postcondition(action(("unload", "hoist0", "crate5", "truck0", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate5", "truck0", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("unload", "hoist0", "crate5", "truck0", "depot0")), 1).

action(action(("unload", "hoist0", "crate5", "truck1", "depot0"))).
precondition(action(("unload", "hoist0", "crate5", "truck1", "depot0")), variable(0), value("at(truck1, depot0)", true)).
precondition(action(("unload", "hoist0", "crate5", "truck1", "depot0")), variable(17), value("available(hoist0)", true)).
precondition(action(("unload", "hoist0", "crate5", "truck1", "depot0")), variable(25), value("in(crate5, truck1)", true)).
postcondition(action(("unload", "hoist0", "crate5", "truck1", "depot0")), effect(unconditional), variable(17), value("available(hoist0)", false)).
postcondition(action(("unload", "hoist0", "crate5", "truck1", "depot0")), effect(unconditional), variable(25), value("lifting(hoist0, crate5)", true)).
costs(action(("unload", "hoist0", "crate5", "truck1", "depot0")), 1).

action(action(("unload", "hoist1", "crate0", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), variable(20), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("unload", "hoist1", "crate0", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate0", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), variable(20), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), effect(unconditional), variable(20), value("lifting(hoist1, crate0)", true)).
costs(action(("unload", "hoist1", "crate0", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate1", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), variable(21), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("unload", "hoist1", "crate1", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate1", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), variable(21), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), effect(unconditional), variable(21), value("lifting(hoist1, crate1)", true)).
costs(action(("unload", "hoist1", "crate1", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate2", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), variable(22), value("in(crate2, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("unload", "hoist1", "crate2", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate2", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), variable(22), value("in(crate2, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), effect(unconditional), variable(22), value("lifting(hoist1, crate2)", true)).
costs(action(("unload", "hoist1", "crate2", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate3", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), variable(23), value("in(crate3, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("unload", "hoist1", "crate3", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate3", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), variable(23), value("in(crate3, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), effect(unconditional), variable(23), value("lifting(hoist1, crate3)", true)).
costs(action(("unload", "hoist1", "crate3", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate4", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), variable(24), value("in(crate4, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("unload", "hoist1", "crate4", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate4", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), variable(24), value("in(crate4, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), effect(unconditional), variable(24), value("lifting(hoist1, crate4)", true)).
costs(action(("unload", "hoist1", "crate4", "truck1", "distributor0")), 1).

action(action(("unload", "hoist1", "crate5", "truck0", "distributor0"))).
precondition(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), variable(1), value("at(truck0, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), variable(25), value("in(crate5, truck0)", true)).
postcondition(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("unload", "hoist1", "crate5", "truck0", "distributor0")), 1).

action(action(("unload", "hoist1", "crate5", "truck1", "distributor0"))).
precondition(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), variable(0), value("at(truck1, distributor0)", true)).
precondition(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), variable(18), value("available(hoist1)", true)).
precondition(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), variable(25), value("in(crate5, truck1)", true)).
postcondition(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), effect(unconditional), variable(18), value("available(hoist1)", false)).
postcondition(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), effect(unconditional), variable(25), value("lifting(hoist1, crate5)", true)).
costs(action(("unload", "hoist1", "crate5", "truck1", "distributor0")), 1).

action(action(("unload", "hoist2", "crate0", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), variable(20), value("in(crate0, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("unload", "hoist2", "crate0", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate0", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), variable(20), value("in(crate0, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), effect(unconditional), variable(20), value("lifting(hoist2, crate0)", true)).
costs(action(("unload", "hoist2", "crate0", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate1", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), variable(21), value("in(crate1, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("unload", "hoist2", "crate1", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate1", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), variable(21), value("in(crate1, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), effect(unconditional), variable(21), value("lifting(hoist2, crate1)", true)).
costs(action(("unload", "hoist2", "crate1", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate2", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), variable(22), value("in(crate2, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("unload", "hoist2", "crate2", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate2", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), variable(22), value("in(crate2, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), effect(unconditional), variable(22), value("lifting(hoist2, crate2)", true)).
costs(action(("unload", "hoist2", "crate2", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate3", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), variable(23), value("in(crate3, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("unload", "hoist2", "crate3", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate3", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), variable(23), value("in(crate3, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), effect(unconditional), variable(23), value("lifting(hoist2, crate3)", true)).
costs(action(("unload", "hoist2", "crate3", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate4", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), variable(24), value("in(crate4, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("unload", "hoist2", "crate4", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate4", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), variable(24), value("in(crate4, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), effect(unconditional), variable(24), value("lifting(hoist2, crate4)", true)).
costs(action(("unload", "hoist2", "crate4", "truck1", "distributor1")), 1).

action(action(("unload", "hoist2", "crate5", "truck0", "distributor1"))).
precondition(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), variable(1), value("at(truck0, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), variable(25), value("in(crate5, truck0)", true)).
postcondition(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("unload", "hoist2", "crate5", "truck0", "distributor1")), 1).

action(action(("unload", "hoist2", "crate5", "truck1", "distributor1"))).
precondition(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), variable(0), value("at(truck1, distributor1)", true)).
precondition(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), variable(19), value("available(hoist2)", true)).
precondition(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), variable(25), value("in(crate5, truck1)", true)).
postcondition(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), effect(unconditional), variable(19), value("available(hoist2)", false)).
postcondition(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), effect(unconditional), variable(25), value("lifting(hoist2, crate5)", true)).
costs(action(("unload", "hoist2", "crate5", "truck1", "distributor1")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(5), value("at(crate0, depot0)", true)).
contains(mutexGroup(0), variable(5), value("at(crate0, distributor0)", true)).
contains(mutexGroup(0), variable(5), value("at(crate0, distributor1)", true)).
contains(mutexGroup(0), variable(20), value("in(crate0, truck0)", true)).
contains(mutexGroup(0), variable(20), value("in(crate0, truck1)", true)).
contains(mutexGroup(0), variable(20), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(0), variable(20), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(0), variable(20), value("lifting(hoist2, crate0)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(6), value("at(crate1, depot0)", true)).
contains(mutexGroup(1), variable(6), value("at(crate1, distributor0)", true)).
contains(mutexGroup(1), variable(6), value("at(crate1, distributor1)", true)).
contains(mutexGroup(1), variable(21), value("in(crate1, truck0)", true)).
contains(mutexGroup(1), variable(21), value("in(crate1, truck1)", true)).
contains(mutexGroup(1), variable(21), value("lifting(hoist0, crate1)", true)).
contains(mutexGroup(1), variable(21), value("lifting(hoist1, crate1)", true)).
contains(mutexGroup(1), variable(21), value("lifting(hoist2, crate1)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(7), value("at(crate2, depot0)", true)).
contains(mutexGroup(2), variable(7), value("at(crate2, distributor0)", true)).
contains(mutexGroup(2), variable(7), value("at(crate2, distributor1)", true)).
contains(mutexGroup(2), variable(22), value("in(crate2, truck0)", true)).
contains(mutexGroup(2), variable(22), value("in(crate2, truck1)", true)).
contains(mutexGroup(2), variable(22), value("lifting(hoist0, crate2)", true)).
contains(mutexGroup(2), variable(22), value("lifting(hoist1, crate2)", true)).
contains(mutexGroup(2), variable(22), value("lifting(hoist2, crate2)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(8), value("at(crate3, depot0)", true)).
contains(mutexGroup(3), variable(8), value("at(crate3, distributor0)", true)).
contains(mutexGroup(3), variable(8), value("at(crate3, distributor1)", true)).
contains(mutexGroup(3), variable(23), value("in(crate3, truck0)", true)).
contains(mutexGroup(3), variable(23), value("in(crate3, truck1)", true)).
contains(mutexGroup(3), variable(23), value("lifting(hoist0, crate3)", true)).
contains(mutexGroup(3), variable(23), value("lifting(hoist1, crate3)", true)).
contains(mutexGroup(3), variable(23), value("lifting(hoist2, crate3)", true)).

mutexGroup(mutexGroup(4)).
contains(mutexGroup(4), variable(9), value("at(crate4, depot0)", true)).
contains(mutexGroup(4), variable(9), value("at(crate4, distributor0)", true)).
contains(mutexGroup(4), variable(9), value("at(crate4, distributor1)", true)).
contains(mutexGroup(4), variable(24), value("in(crate4, truck0)", true)).
contains(mutexGroup(4), variable(24), value("in(crate4, truck1)", true)).
contains(mutexGroup(4), variable(24), value("lifting(hoist0, crate4)", true)).
contains(mutexGroup(4), variable(24), value("lifting(hoist1, crate4)", true)).
contains(mutexGroup(4), variable(24), value("lifting(hoist2, crate4)", true)).

mutexGroup(mutexGroup(5)).
contains(mutexGroup(5), variable(10), value("at(crate5, depot0)", true)).
contains(mutexGroup(5), variable(10), value("at(crate5, distributor0)", true)).
contains(mutexGroup(5), variable(10), value("at(crate5, distributor1)", true)).
contains(mutexGroup(5), variable(25), value("in(crate5, truck0)", true)).
contains(mutexGroup(5), variable(25), value("in(crate5, truck1)", true)).
contains(mutexGroup(5), variable(25), value("lifting(hoist0, crate5)", true)).
contains(mutexGroup(5), variable(25), value("lifting(hoist1, crate5)", true)).
contains(mutexGroup(5), variable(25), value("lifting(hoist2, crate5)", true)).

mutexGroup(mutexGroup(6)).
contains(mutexGroup(6), variable(17), value("available(hoist0)", true)).
contains(mutexGroup(6), variable(20), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(6), variable(21), value("lifting(hoist0, crate1)", true)).
contains(mutexGroup(6), variable(22), value("lifting(hoist0, crate2)", true)).
contains(mutexGroup(6), variable(23), value("lifting(hoist0, crate3)", true)).
contains(mutexGroup(6), variable(24), value("lifting(hoist0, crate4)", true)).
contains(mutexGroup(6), variable(25), value("lifting(hoist0, crate5)", true)).

mutexGroup(mutexGroup(7)).
contains(mutexGroup(7), variable(18), value("available(hoist1)", true)).
contains(mutexGroup(7), variable(20), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(7), variable(21), value("lifting(hoist1, crate1)", true)).
contains(mutexGroup(7), variable(22), value("lifting(hoist1, crate2)", true)).
contains(mutexGroup(7), variable(23), value("lifting(hoist1, crate3)", true)).
contains(mutexGroup(7), variable(24), value("lifting(hoist1, crate4)", true)).
contains(mutexGroup(7), variable(25), value("lifting(hoist1, crate5)", true)).

mutexGroup(mutexGroup(8)).
contains(mutexGroup(8), variable(19), value("available(hoist2)", true)).
contains(mutexGroup(8), variable(20), value("lifting(hoist2, crate0)", true)).
contains(mutexGroup(8), variable(21), value("lifting(hoist2, crate1)", true)).
contains(mutexGroup(8), variable(22), value("lifting(hoist2, crate2)", true)).
contains(mutexGroup(8), variable(23), value("lifting(hoist2, crate3)", true)).
contains(mutexGroup(8), variable(24), value("lifting(hoist2, crate4)", true)).
contains(mutexGroup(8), variable(25), value("lifting(hoist2, crate5)", true)).

mutexGroup(mutexGroup(9)).
contains(mutexGroup(9), variable(11), value("clear(crate0)", true)).
contains(mutexGroup(9), variable(20), value("in(crate0, truck0)", true)).
contains(mutexGroup(9), variable(20), value("in(crate0, truck1)", true)).
contains(mutexGroup(9), variable(20), value("lifting(hoist0, crate0)", true)).
contains(mutexGroup(9), variable(20), value("lifting(hoist1, crate0)", true)).
contains(mutexGroup(9), variable(20), value("lifting(hoist2, crate0)", true)).
contains(mutexGroup(9), variable(21), value("on(crate1, crate0)", true)).
contains(mutexGroup(9), variable(22), value("on(crate2, crate0)", true)).
contains(mutexGroup(9), variable(23), value("on(crate3, crate0)", true)).
contains(mutexGroup(9), variable(24), value("on(crate4, crate0)", true)).
contains(mutexGroup(9), variable(25), value("on(crate5, crate0)", true)).

mutexGroup(mutexGroup(10)).
contains(mutexGroup(10), variable(12), value("clear(crate1)", true)).
contains(mutexGroup(10), variable(20), value("on(crate0, crate1)", true)).
contains(mutexGroup(10), variable(21), value("in(crate1, truck0)", true)).
contains(mutexGroup(10), variable(21), value("in(crate1, truck1)", true)).
contains(mutexGroup(10), variable(21), value("lifting(hoist0, crate1)", true)).
contains(mutexGroup(10), variable(21), value("lifting(hoist1, crate1)", true)).
contains(mutexGroup(10), variable(21), value("lifting(hoist2, crate1)", true)).
contains(mutexGroup(10), variable(22), value("on(crate2, crate1)", true)).
contains(mutexGroup(10), variable(23), value("on(crate3, crate1)", true)).
contains(mutexGroup(10), variable(24), value("on(crate4, crate1)", true)).
contains(mutexGroup(10), variable(25), value("on(crate5, crate1)", true)).

mutexGroup(mutexGroup(11)).
contains(mutexGroup(11), variable(13), value("clear(crate2)", true)).
contains(mutexGroup(11), variable(20), value("on(crate0, crate2)", true)).
contains(mutexGroup(11), variable(21), value("on(crate1, crate2)", true)).
contains(mutexGroup(11), variable(22), value("in(crate2, truck0)", true)).
contains(mutexGroup(11), variable(22), value("in(crate2, truck1)", true)).
contains(mutexGroup(11), variable(22), value("lifting(hoist0, crate2)", true)).
contains(mutexGroup(11), variable(22), value("lifting(hoist1, crate2)", true)).
contains(mutexGroup(11), variable(22), value("lifting(hoist2, crate2)", true)).
contains(mutexGroup(11), variable(23), value("on(crate3, crate2)", true)).
contains(mutexGroup(11), variable(24), value("on(crate4, crate2)", true)).
contains(mutexGroup(11), variable(25), value("on(crate5, crate2)", true)).

mutexGroup(mutexGroup(12)).
contains(mutexGroup(12), variable(14), value("clear(crate3)", true)).
contains(mutexGroup(12), variable(20), value("on(crate0, crate3)", true)).
contains(mutexGroup(12), variable(21), value("on(crate1, crate3)", true)).
contains(mutexGroup(12), variable(22), value("on(crate2, crate3)", true)).
contains(mutexGroup(12), variable(23), value("in(crate3, truck0)", true)).
contains(mutexGroup(12), variable(23), value("in(crate3, truck1)", true)).
contains(mutexGroup(12), variable(23), value("lifting(hoist0, crate3)", true)).
contains(mutexGroup(12), variable(23), value("lifting(hoist1, crate3)", true)).
contains(mutexGroup(12), variable(23), value("lifting(hoist2, crate3)", true)).
contains(mutexGroup(12), variable(24), value("on(crate4, crate3)", true)).
contains(mutexGroup(12), variable(25), value("on(crate5, crate3)", true)).

mutexGroup(mutexGroup(13)).
contains(mutexGroup(13), variable(15), value("clear(crate4)", true)).
contains(mutexGroup(13), variable(20), value("on(crate0, crate4)", true)).
contains(mutexGroup(13), variable(21), value("on(crate1, crate4)", true)).
contains(mutexGroup(13), variable(22), value("on(crate2, crate4)", true)).
contains(mutexGroup(13), variable(23), value("on(crate3, crate4)", true)).
contains(mutexGroup(13), variable(24), value("in(crate4, truck0)", true)).
contains(mutexGroup(13), variable(24), value("in(crate4, truck1)", true)).
contains(mutexGroup(13), variable(24), value("lifting(hoist0, crate4)", true)).
contains(mutexGroup(13), variable(24), value("lifting(hoist1, crate4)", true)).
contains(mutexGroup(13), variable(24), value("lifting(hoist2, crate4)", true)).
contains(mutexGroup(13), variable(25), value("on(crate5, crate4)", true)).

mutexGroup(mutexGroup(14)).
contains(mutexGroup(14), variable(16), value("clear(crate5)", true)).
contains(mutexGroup(14), variable(20), value("on(crate0, crate5)", true)).
contains(mutexGroup(14), variable(21), value("on(crate1, crate5)", true)).
contains(mutexGroup(14), variable(22), value("on(crate2, crate5)", true)).
contains(mutexGroup(14), variable(23), value("on(crate3, crate5)", true)).
contains(mutexGroup(14), variable(24), value("on(crate4, crate5)", true)).
contains(mutexGroup(14), variable(25), value("in(crate5, truck0)", true)).
contains(mutexGroup(14), variable(25), value("in(crate5, truck1)", true)).
contains(mutexGroup(14), variable(25), value("lifting(hoist0, crate5)", true)).
contains(mutexGroup(14), variable(25), value("lifting(hoist1, crate5)", true)).
contains(mutexGroup(14), variable(25), value("lifting(hoist2, crate5)", true)).

mutexGroup(mutexGroup(15)).
contains(mutexGroup(15), variable(2), value("clear(pallet0)", true)).
contains(mutexGroup(15), variable(20), value("on(crate0, pallet0)", true)).
contains(mutexGroup(15), variable(21), value("on(crate1, pallet0)", true)).
contains(mutexGroup(15), variable(22), value("on(crate2, pallet0)", true)).
contains(mutexGroup(15), variable(23), value("on(crate3, pallet0)", true)).
contains(mutexGroup(15), variable(24), value("on(crate4, pallet0)", true)).
contains(mutexGroup(15), variable(25), value("on(crate5, pallet0)", true)).

mutexGroup(mutexGroup(16)).
contains(mutexGroup(16), variable(3), value("clear(pallet1)", true)).
contains(mutexGroup(16), variable(20), value("on(crate0, pallet1)", true)).
contains(mutexGroup(16), variable(21), value("on(crate1, pallet1)", true)).
contains(mutexGroup(16), variable(22), value("on(crate2, pallet1)", true)).
contains(mutexGroup(16), variable(23), value("on(crate3, pallet1)", true)).
contains(mutexGroup(16), variable(24), value("on(crate4, pallet1)", true)).
contains(mutexGroup(16), variable(25), value("on(crate5, pallet1)", true)).

mutexGroup(mutexGroup(17)).
contains(mutexGroup(17), variable(4), value("clear(pallet2)", true)).
contains(mutexGroup(17), variable(20), value("on(crate0, pallet2)", true)).
contains(mutexGroup(17), variable(21), value("on(crate1, pallet2)", true)).
contains(mutexGroup(17), variable(22), value("on(crate2, pallet2)", true)).
contains(mutexGroup(17), variable(23), value("on(crate3, pallet2)", true)).
contains(mutexGroup(17), variable(24), value("on(crate4, pallet2)", true)).
contains(mutexGroup(17), variable(25), value("on(crate5, pallet2)", true)).

% initial state
initialState(variable(0), value("at(truck1, distributor0)", true)).
initialState(variable(1), value("at(truck0, depot0)", true)).
initialState(variable(2), value("clear(pallet0)", false)).
initialState(variable(3), value("clear(pallet1)", false)).
initialState(variable(4), value("clear(pallet2)", false)).
initialState(variable(5), value("at(crate0, distributor0)", true)).
initialState(variable(6), value("at(crate1, depot0)", true)).
initialState(variable(7), value("at(crate2, distributor1)", true)).
initialState(variable(8), value("at(crate3, distributor0)", true)).
initialState(variable(9), value("at(crate4, distributor0)", true)).
initialState(variable(10), value("at(crate5, distributor1)", true)).
initialState(variable(11), value("clear(crate0)", false)).
initialState(variable(12), value("clear(crate1)", true)).
initialState(variable(13), value("clear(crate2)", false)).
initialState(variable(14), value("clear(crate3)", false)).
initialState(variable(15), value("clear(crate4)", true)).
initialState(variable(16), value("clear(crate5)", true)).
initialState(variable(17), value("available(hoist0)", true)).
initialState(variable(18), value("available(hoist1)", true)).
initialState(variable(19), value("available(hoist2)", true)).
initialState(variable(20), value("on(crate0, pallet1)", true)).
initialState(variable(21), value("on(crate1, pallet0)", true)).
initialState(variable(22), value("on(crate2, pallet2)", true)).
initialState(variable(23), value("on(crate3, crate0)", true)).
initialState(variable(24), value("on(crate4, crate3)", true)).
initialState(variable(25), value("on(crate5, crate2)", true)).

% goal
goal(variable(20), value("on(crate0, crate1)", true)).
goal(variable(21), value("on(crate1, pallet2)", true)).
goal(variable(22), value("on(crate2, pallet0)", true)).
goal(variable(23), value("on(crate3, crate2)", true)).
goal(variable(24), value("on(crate4, pallet1)", true)).
goal(variable(25), value("on(crate5, crate0)", true)).
