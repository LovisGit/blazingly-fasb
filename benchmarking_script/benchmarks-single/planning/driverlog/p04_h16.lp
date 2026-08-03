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
#show occurs/2.

% variables
variable(variable(0)).
contains(variable(0), value("empty(truck1)", true)).
contains(variable(0), value("empty(truck1)", false)).

variable(variable(1)).
contains(variable(1), value("empty(truck2)", true)).
contains(variable(1), value("empty(truck2)", false)).

variable(variable(2)).
contains(variable(2), value("at(truck1, s0)", true)).
contains(variable(2), value("at(truck1, s1)", true)).
contains(variable(2), value("at(truck1, s2)", true)).

variable(variable(3)).
contains(variable(3), value("at(truck2, s0)", true)).
contains(variable(3), value("at(truck2, s1)", true)).
contains(variable(3), value("at(truck2, s2)", true)).

variable(variable(4)).
contains(variable(4), value("at(driver1, p0-1)", true)).
contains(variable(4), value("at(driver1, p1-2)", true)).
contains(variable(4), value("at(driver1, s0)", true)).
contains(variable(4), value("at(driver1, s1)", true)).
contains(variable(4), value("at(driver1, s2)", true)).
contains(variable(4), value("driving(driver1, truck1)", true)).
contains(variable(4), value("driving(driver1, truck2)", true)).

variable(variable(5)).
contains(variable(5), value("at(driver2, p0-1)", true)).
contains(variable(5), value("at(driver2, p1-2)", true)).
contains(variable(5), value("at(driver2, s0)", true)).
contains(variable(5), value("at(driver2, s1)", true)).
contains(variable(5), value("at(driver2, s2)", true)).
contains(variable(5), value("driving(driver2, truck1)", true)).
contains(variable(5), value("driving(driver2, truck2)", true)).

variable(variable(6)).
contains(variable(6), value("at(driver3, p0-1)", true)).
contains(variable(6), value("at(driver3, p1-2)", true)).
contains(variable(6), value("at(driver3, s0)", true)).
contains(variable(6), value("at(driver3, s1)", true)).
contains(variable(6), value("at(driver3, s2)", true)).
contains(variable(6), value("driving(driver3, truck1)", true)).
contains(variable(6), value("driving(driver3, truck2)", true)).

variable(variable(7)).
contains(variable(7), value("at(package4, s0)", true)).
contains(variable(7), value("at(package4, s1)", true)).
contains(variable(7), value("at(package4, s2)", true)).
contains(variable(7), value("in(package4, truck1)", true)).
contains(variable(7), value("in(package4, truck2)", true)).

variable(variable(8)).
contains(variable(8), value("at(package3, s0)", true)).
contains(variable(8), value("at(package3, s1)", true)).
contains(variable(8), value("at(package3, s2)", true)).
contains(variable(8), value("in(package3, truck1)", true)).
contains(variable(8), value("in(package3, truck2)", true)).

variable(variable(9)).
contains(variable(9), value("at(package2, s0)", true)).
contains(variable(9), value("at(package2, s1)", true)).
contains(variable(9), value("at(package2, s2)", true)).
contains(variable(9), value("in(package2, truck1)", true)).
contains(variable(9), value("in(package2, truck2)", true)).

variable(variable(10)).
contains(variable(10), value("at(package1, s0)", true)).
contains(variable(10), value("at(package1, s1)", true)).
contains(variable(10), value("at(package1, s2)", true)).
contains(variable(10), value("in(package1, truck1)", true)).
contains(variable(10), value("in(package1, truck2)", true)).

% actions
action(action(("board-truck", "driver1", "truck1", "s0"))).
precondition(action(("board-truck", "driver1", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s0")), variable(4), value("at(driver1, s0)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s0")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s0")), effect(unconditional), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver1", "truck1", "s0")), 1).

action(action(("board-truck", "driver1", "truck1", "s1"))).
precondition(action(("board-truck", "driver1", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s1")), variable(4), value("at(driver1, s1)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s1")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s1")), effect(unconditional), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver1", "truck1", "s1")), 1).

action(action(("board-truck", "driver1", "truck1", "s2"))).
precondition(action(("board-truck", "driver1", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s2")), variable(4), value("at(driver1, s2)", true)).
precondition(action(("board-truck", "driver1", "truck1", "s2")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s2")), effect(unconditional), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("board-truck", "driver1", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver1", "truck1", "s2")), 1).

action(action(("board-truck", "driver1", "truck2", "s0"))).
precondition(action(("board-truck", "driver1", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s0")), variable(4), value("at(driver1, s0)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s0")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s0")), effect(unconditional), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver1", "truck2", "s0")), 1).

action(action(("board-truck", "driver1", "truck2", "s1"))).
precondition(action(("board-truck", "driver1", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s1")), variable(4), value("at(driver1, s1)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s1")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s1")), effect(unconditional), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver1", "truck2", "s1")), 1).

action(action(("board-truck", "driver1", "truck2", "s2"))).
precondition(action(("board-truck", "driver1", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s2")), variable(4), value("at(driver1, s2)", true)).
precondition(action(("board-truck", "driver1", "truck2", "s2")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s2")), effect(unconditional), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("board-truck", "driver1", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver1", "truck2", "s2")), 1).

action(action(("board-truck", "driver2", "truck1", "s0"))).
precondition(action(("board-truck", "driver2", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s0")), variable(5), value("at(driver2, s0)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s0")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s0")), effect(unconditional), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver2", "truck1", "s0")), 1).

action(action(("board-truck", "driver2", "truck1", "s1"))).
precondition(action(("board-truck", "driver2", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s1")), variable(5), value("at(driver2, s1)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s1")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s1")), effect(unconditional), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver2", "truck1", "s1")), 1).

action(action(("board-truck", "driver2", "truck1", "s2"))).
precondition(action(("board-truck", "driver2", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s2")), variable(5), value("at(driver2, s2)", true)).
precondition(action(("board-truck", "driver2", "truck1", "s2")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s2")), effect(unconditional), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("board-truck", "driver2", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver2", "truck1", "s2")), 1).

action(action(("board-truck", "driver2", "truck2", "s0"))).
precondition(action(("board-truck", "driver2", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s0")), variable(5), value("at(driver2, s0)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s0")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s0")), effect(unconditional), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver2", "truck2", "s0")), 1).

action(action(("board-truck", "driver2", "truck2", "s1"))).
precondition(action(("board-truck", "driver2", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s1")), variable(5), value("at(driver2, s1)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s1")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s1")), effect(unconditional), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver2", "truck2", "s1")), 1).

action(action(("board-truck", "driver2", "truck2", "s2"))).
precondition(action(("board-truck", "driver2", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s2")), variable(5), value("at(driver2, s2)", true)).
precondition(action(("board-truck", "driver2", "truck2", "s2")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s2")), effect(unconditional), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("board-truck", "driver2", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver2", "truck2", "s2")), 1).

action(action(("board-truck", "driver3", "truck1", "s0"))).
precondition(action(("board-truck", "driver3", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s0")), variable(6), value("at(driver3, s0)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s0")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s0")), effect(unconditional), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver3", "truck1", "s0")), 1).

action(action(("board-truck", "driver3", "truck1", "s1"))).
precondition(action(("board-truck", "driver3", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s1")), variable(6), value("at(driver3, s1)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s1")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s1")), effect(unconditional), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver3", "truck1", "s1")), 1).

action(action(("board-truck", "driver3", "truck1", "s2"))).
precondition(action(("board-truck", "driver3", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s2")), variable(6), value("at(driver3, s2)", true)).
precondition(action(("board-truck", "driver3", "truck1", "s2")), variable(0), value("empty(truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s2")), effect(unconditional), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("board-truck", "driver3", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", false)).
costs(action(("board-truck", "driver3", "truck1", "s2")), 1).

action(action(("board-truck", "driver3", "truck2", "s0"))).
precondition(action(("board-truck", "driver3", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s0")), variable(6), value("at(driver3, s0)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s0")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s0")), effect(unconditional), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver3", "truck2", "s0")), 1).

action(action(("board-truck", "driver3", "truck2", "s1"))).
precondition(action(("board-truck", "driver3", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s1")), variable(6), value("at(driver3, s1)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s1")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s1")), effect(unconditional), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver3", "truck2", "s1")), 1).

action(action(("board-truck", "driver3", "truck2", "s2"))).
precondition(action(("board-truck", "driver3", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s2")), variable(6), value("at(driver3, s2)", true)).
precondition(action(("board-truck", "driver3", "truck2", "s2")), variable(1), value("empty(truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s2")), effect(unconditional), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("board-truck", "driver3", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", false)).
costs(action(("board-truck", "driver3", "truck2", "s2")), 1).

action(action(("disembark-truck", "driver1", "truck1", "s0"))).
precondition(action(("disembark-truck", "driver1", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("disembark-truck", "driver1", "truck1", "s0")), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s0")), effect(unconditional), variable(4), value("at(driver1, s0)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver1", "truck1", "s0")), 1).

action(action(("disembark-truck", "driver1", "truck1", "s1"))).
precondition(action(("disembark-truck", "driver1", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("disembark-truck", "driver1", "truck1", "s1")), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s1")), effect(unconditional), variable(4), value("at(driver1, s1)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver1", "truck1", "s1")), 1).

action(action(("disembark-truck", "driver1", "truck1", "s2"))).
precondition(action(("disembark-truck", "driver1", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("disembark-truck", "driver1", "truck1", "s2")), variable(4), value("driving(driver1, truck1)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s2")), effect(unconditional), variable(4), value("at(driver1, s2)", true)).
postcondition(action(("disembark-truck", "driver1", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver1", "truck1", "s2")), 1).

action(action(("disembark-truck", "driver1", "truck2", "s0"))).
precondition(action(("disembark-truck", "driver1", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("disembark-truck", "driver1", "truck2", "s0")), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s0")), effect(unconditional), variable(4), value("at(driver1, s0)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver1", "truck2", "s0")), 1).

action(action(("disembark-truck", "driver1", "truck2", "s1"))).
precondition(action(("disembark-truck", "driver1", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("disembark-truck", "driver1", "truck2", "s1")), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s1")), effect(unconditional), variable(4), value("at(driver1, s1)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver1", "truck2", "s1")), 1).

action(action(("disembark-truck", "driver1", "truck2", "s2"))).
precondition(action(("disembark-truck", "driver1", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("disembark-truck", "driver1", "truck2", "s2")), variable(4), value("driving(driver1, truck2)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s2")), effect(unconditional), variable(4), value("at(driver1, s2)", true)).
postcondition(action(("disembark-truck", "driver1", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver1", "truck2", "s2")), 1).

action(action(("disembark-truck", "driver2", "truck1", "s0"))).
precondition(action(("disembark-truck", "driver2", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("disembark-truck", "driver2", "truck1", "s0")), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s0")), effect(unconditional), variable(5), value("at(driver2, s0)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver2", "truck1", "s0")), 1).

action(action(("disembark-truck", "driver2", "truck1", "s1"))).
precondition(action(("disembark-truck", "driver2", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("disembark-truck", "driver2", "truck1", "s1")), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s1")), effect(unconditional), variable(5), value("at(driver2, s1)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver2", "truck1", "s1")), 1).

action(action(("disembark-truck", "driver2", "truck1", "s2"))).
precondition(action(("disembark-truck", "driver2", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("disembark-truck", "driver2", "truck1", "s2")), variable(5), value("driving(driver2, truck1)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s2")), effect(unconditional), variable(5), value("at(driver2, s2)", true)).
postcondition(action(("disembark-truck", "driver2", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver2", "truck1", "s2")), 1).

action(action(("disembark-truck", "driver2", "truck2", "s0"))).
precondition(action(("disembark-truck", "driver2", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("disembark-truck", "driver2", "truck2", "s0")), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s0")), effect(unconditional), variable(5), value("at(driver2, s0)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver2", "truck2", "s0")), 1).

action(action(("disembark-truck", "driver2", "truck2", "s1"))).
precondition(action(("disembark-truck", "driver2", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("disembark-truck", "driver2", "truck2", "s1")), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s1")), effect(unconditional), variable(5), value("at(driver2, s1)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver2", "truck2", "s1")), 1).

action(action(("disembark-truck", "driver2", "truck2", "s2"))).
precondition(action(("disembark-truck", "driver2", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("disembark-truck", "driver2", "truck2", "s2")), variable(5), value("driving(driver2, truck2)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s2")), effect(unconditional), variable(5), value("at(driver2, s2)", true)).
postcondition(action(("disembark-truck", "driver2", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver2", "truck2", "s2")), 1).

action(action(("disembark-truck", "driver3", "truck1", "s0"))).
precondition(action(("disembark-truck", "driver3", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("disembark-truck", "driver3", "truck1", "s0")), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s0")), effect(unconditional), variable(6), value("at(driver3, s0)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s0")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver3", "truck1", "s0")), 1).

action(action(("disembark-truck", "driver3", "truck1", "s1"))).
precondition(action(("disembark-truck", "driver3", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("disembark-truck", "driver3", "truck1", "s1")), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s1")), effect(unconditional), variable(6), value("at(driver3, s1)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s1")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver3", "truck1", "s1")), 1).

action(action(("disembark-truck", "driver3", "truck1", "s2"))).
precondition(action(("disembark-truck", "driver3", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("disembark-truck", "driver3", "truck1", "s2")), variable(6), value("driving(driver3, truck1)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s2")), effect(unconditional), variable(6), value("at(driver3, s2)", true)).
postcondition(action(("disembark-truck", "driver3", "truck1", "s2")), effect(unconditional), variable(0), value("empty(truck1)", true)).
costs(action(("disembark-truck", "driver3", "truck1", "s2")), 1).

action(action(("disembark-truck", "driver3", "truck2", "s0"))).
precondition(action(("disembark-truck", "driver3", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("disembark-truck", "driver3", "truck2", "s0")), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s0")), effect(unconditional), variable(6), value("at(driver3, s0)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s0")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver3", "truck2", "s0")), 1).

action(action(("disembark-truck", "driver3", "truck2", "s1"))).
precondition(action(("disembark-truck", "driver3", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("disembark-truck", "driver3", "truck2", "s1")), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s1")), effect(unconditional), variable(6), value("at(driver3, s1)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s1")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver3", "truck2", "s1")), 1).

action(action(("disembark-truck", "driver3", "truck2", "s2"))).
precondition(action(("disembark-truck", "driver3", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("disembark-truck", "driver3", "truck2", "s2")), variable(6), value("driving(driver3, truck2)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s2")), effect(unconditional), variable(6), value("at(driver3, s2)", true)).
postcondition(action(("disembark-truck", "driver3", "truck2", "s2")), effect(unconditional), variable(1), value("empty(truck2)", true)).
costs(action(("disembark-truck", "driver3", "truck2", "s2")), 1).

action(action(("drive-truck", "truck1", "s0", "s1", "driver1"))).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver1")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s1", "driver1")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s0", "s1", "driver1")), 1).

action(action(("drive-truck", "truck1", "s0", "s1", "driver2"))).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver2")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s1", "driver2")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s0", "s1", "driver2")), 1).

action(action(("drive-truck", "truck1", "s0", "s1", "driver3"))).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s1", "driver3")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s1", "driver3")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s0", "s1", "driver3")), 1).

action(action(("drive-truck", "truck1", "s0", "s2", "driver1"))).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver1")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s2", "driver1")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s0", "s2", "driver1")), 1).

action(action(("drive-truck", "truck1", "s0", "s2", "driver2"))).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver2")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s2", "driver2")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s0", "s2", "driver2")), 1).

action(action(("drive-truck", "truck1", "s0", "s2", "driver3"))).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s0", "s2", "driver3")), variable(2), value("at(truck1, s0)", true)).
postcondition(action(("drive-truck", "truck1", "s0", "s2", "driver3")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s0", "s2", "driver3")), 1).

action(action(("drive-truck", "truck1", "s1", "s0", "driver1"))).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver1")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s0", "driver1")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s1", "s0", "driver1")), 1).

action(action(("drive-truck", "truck1", "s1", "s0", "driver2"))).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver2")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s0", "driver2")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s1", "s0", "driver2")), 1).

action(action(("drive-truck", "truck1", "s1", "s0", "driver3"))).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s0", "driver3")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s0", "driver3")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s1", "s0", "driver3")), 1).

action(action(("drive-truck", "truck1", "s1", "s2", "driver1"))).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver1")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s2", "driver1")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s1", "s2", "driver1")), 1).

action(action(("drive-truck", "truck1", "s1", "s2", "driver2"))).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver2")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s2", "driver2")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s1", "s2", "driver2")), 1).

action(action(("drive-truck", "truck1", "s1", "s2", "driver3"))).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s1", "s2", "driver3")), variable(2), value("at(truck1, s1)", true)).
postcondition(action(("drive-truck", "truck1", "s1", "s2", "driver3")), effect(unconditional), variable(2), value("at(truck1, s2)", true)).
costs(action(("drive-truck", "truck1", "s1", "s2", "driver3")), 1).

action(action(("drive-truck", "truck1", "s2", "s0", "driver1"))).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver1")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s0", "driver1")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s2", "s0", "driver1")), 1).

action(action(("drive-truck", "truck1", "s2", "s0", "driver2"))).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver2")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s0", "driver2")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s2", "s0", "driver2")), 1).

action(action(("drive-truck", "truck1", "s2", "s0", "driver3"))).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s0", "driver3")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s0", "driver3")), effect(unconditional), variable(2), value("at(truck1, s0)", true)).
costs(action(("drive-truck", "truck1", "s2", "s0", "driver3")), 1).

action(action(("drive-truck", "truck1", "s2", "s1", "driver1"))).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver1")), variable(4), value("driving(driver1, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver1")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s1", "driver1")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s2", "s1", "driver1")), 1).

action(action(("drive-truck", "truck1", "s2", "s1", "driver2"))).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver2")), variable(5), value("driving(driver2, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver2")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s1", "driver2")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s2", "s1", "driver2")), 1).

action(action(("drive-truck", "truck1", "s2", "s1", "driver3"))).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver3")), variable(6), value("driving(driver3, truck1)", true)).
precondition(action(("drive-truck", "truck1", "s2", "s1", "driver3")), variable(2), value("at(truck1, s2)", true)).
postcondition(action(("drive-truck", "truck1", "s2", "s1", "driver3")), effect(unconditional), variable(2), value("at(truck1, s1)", true)).
costs(action(("drive-truck", "truck1", "s2", "s1", "driver3")), 1).

action(action(("drive-truck", "truck2", "s0", "s1", "driver1"))).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver1")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s1", "driver1")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s0", "s1", "driver1")), 1).

action(action(("drive-truck", "truck2", "s0", "s1", "driver2"))).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver2")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s1", "driver2")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s0", "s1", "driver2")), 1).

action(action(("drive-truck", "truck2", "s0", "s1", "driver3"))).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s1", "driver3")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s1", "driver3")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s0", "s1", "driver3")), 1).

action(action(("drive-truck", "truck2", "s0", "s2", "driver1"))).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver1")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s2", "driver1")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s0", "s2", "driver1")), 1).

action(action(("drive-truck", "truck2", "s0", "s2", "driver2"))).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver2")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s2", "driver2")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s0", "s2", "driver2")), 1).

action(action(("drive-truck", "truck2", "s0", "s2", "driver3"))).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s0", "s2", "driver3")), variable(3), value("at(truck2, s0)", true)).
postcondition(action(("drive-truck", "truck2", "s0", "s2", "driver3")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s0", "s2", "driver3")), 1).

action(action(("drive-truck", "truck2", "s1", "s0", "driver1"))).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver1")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s0", "driver1")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s1", "s0", "driver1")), 1).

action(action(("drive-truck", "truck2", "s1", "s0", "driver2"))).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver2")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s0", "driver2")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s1", "s0", "driver2")), 1).

action(action(("drive-truck", "truck2", "s1", "s0", "driver3"))).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s0", "driver3")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s0", "driver3")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s1", "s0", "driver3")), 1).

action(action(("drive-truck", "truck2", "s1", "s2", "driver1"))).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver1")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s2", "driver1")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s1", "s2", "driver1")), 1).

action(action(("drive-truck", "truck2", "s1", "s2", "driver2"))).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver2")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s2", "driver2")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s1", "s2", "driver2")), 1).

action(action(("drive-truck", "truck2", "s1", "s2", "driver3"))).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s1", "s2", "driver3")), variable(3), value("at(truck2, s1)", true)).
postcondition(action(("drive-truck", "truck2", "s1", "s2", "driver3")), effect(unconditional), variable(3), value("at(truck2, s2)", true)).
costs(action(("drive-truck", "truck2", "s1", "s2", "driver3")), 1).

action(action(("drive-truck", "truck2", "s2", "s0", "driver1"))).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver1")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s0", "driver1")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s2", "s0", "driver1")), 1).

action(action(("drive-truck", "truck2", "s2", "s0", "driver2"))).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver2")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s0", "driver2")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s2", "s0", "driver2")), 1).

action(action(("drive-truck", "truck2", "s2", "s0", "driver3"))).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s0", "driver3")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s0", "driver3")), effect(unconditional), variable(3), value("at(truck2, s0)", true)).
costs(action(("drive-truck", "truck2", "s2", "s0", "driver3")), 1).

action(action(("drive-truck", "truck2", "s2", "s1", "driver1"))).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver1")), variable(4), value("driving(driver1, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver1")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s1", "driver1")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s2", "s1", "driver1")), 1).

action(action(("drive-truck", "truck2", "s2", "s1", "driver2"))).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver2")), variable(5), value("driving(driver2, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver2")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s1", "driver2")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s2", "s1", "driver2")), 1).

action(action(("drive-truck", "truck2", "s2", "s1", "driver3"))).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver3")), variable(6), value("driving(driver3, truck2)", true)).
precondition(action(("drive-truck", "truck2", "s2", "s1", "driver3")), variable(3), value("at(truck2, s2)", true)).
postcondition(action(("drive-truck", "truck2", "s2", "s1", "driver3")), effect(unconditional), variable(3), value("at(truck2, s1)", true)).
costs(action(("drive-truck", "truck2", "s2", "s1", "driver3")), 1).

action(action(("load-truck", "package1", "truck1", "s0"))).
precondition(action(("load-truck", "package1", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("load-truck", "package1", "truck1", "s0")), variable(10), value("at(package1, s0)", true)).
postcondition(action(("load-truck", "package1", "truck1", "s0")), effect(unconditional), variable(10), value("in(package1, truck1)", true)).
costs(action(("load-truck", "package1", "truck1", "s0")), 1).

action(action(("load-truck", "package1", "truck1", "s1"))).
precondition(action(("load-truck", "package1", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("load-truck", "package1", "truck1", "s1")), variable(10), value("at(package1, s1)", true)).
postcondition(action(("load-truck", "package1", "truck1", "s1")), effect(unconditional), variable(10), value("in(package1, truck1)", true)).
costs(action(("load-truck", "package1", "truck1", "s1")), 1).

action(action(("load-truck", "package1", "truck1", "s2"))).
precondition(action(("load-truck", "package1", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("load-truck", "package1", "truck1", "s2")), variable(10), value("at(package1, s2)", true)).
postcondition(action(("load-truck", "package1", "truck1", "s2")), effect(unconditional), variable(10), value("in(package1, truck1)", true)).
costs(action(("load-truck", "package1", "truck1", "s2")), 1).

action(action(("load-truck", "package1", "truck2", "s0"))).
precondition(action(("load-truck", "package1", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("load-truck", "package1", "truck2", "s0")), variable(10), value("at(package1, s0)", true)).
postcondition(action(("load-truck", "package1", "truck2", "s0")), effect(unconditional), variable(10), value("in(package1, truck2)", true)).
costs(action(("load-truck", "package1", "truck2", "s0")), 1).

action(action(("load-truck", "package1", "truck2", "s1"))).
precondition(action(("load-truck", "package1", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("load-truck", "package1", "truck2", "s1")), variable(10), value("at(package1, s1)", true)).
postcondition(action(("load-truck", "package1", "truck2", "s1")), effect(unconditional), variable(10), value("in(package1, truck2)", true)).
costs(action(("load-truck", "package1", "truck2", "s1")), 1).

action(action(("load-truck", "package1", "truck2", "s2"))).
precondition(action(("load-truck", "package1", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("load-truck", "package1", "truck2", "s2")), variable(10), value("at(package1, s2)", true)).
postcondition(action(("load-truck", "package1", "truck2", "s2")), effect(unconditional), variable(10), value("in(package1, truck2)", true)).
costs(action(("load-truck", "package1", "truck2", "s2")), 1).

action(action(("load-truck", "package2", "truck1", "s0"))).
precondition(action(("load-truck", "package2", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("load-truck", "package2", "truck1", "s0")), variable(9), value("at(package2, s0)", true)).
postcondition(action(("load-truck", "package2", "truck1", "s0")), effect(unconditional), variable(9), value("in(package2, truck1)", true)).
costs(action(("load-truck", "package2", "truck1", "s0")), 1).

action(action(("load-truck", "package2", "truck1", "s1"))).
precondition(action(("load-truck", "package2", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("load-truck", "package2", "truck1", "s1")), variable(9), value("at(package2, s1)", true)).
postcondition(action(("load-truck", "package2", "truck1", "s1")), effect(unconditional), variable(9), value("in(package2, truck1)", true)).
costs(action(("load-truck", "package2", "truck1", "s1")), 1).

action(action(("load-truck", "package2", "truck1", "s2"))).
precondition(action(("load-truck", "package2", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("load-truck", "package2", "truck1", "s2")), variable(9), value("at(package2, s2)", true)).
postcondition(action(("load-truck", "package2", "truck1", "s2")), effect(unconditional), variable(9), value("in(package2, truck1)", true)).
costs(action(("load-truck", "package2", "truck1", "s2")), 1).

action(action(("load-truck", "package2", "truck2", "s0"))).
precondition(action(("load-truck", "package2", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("load-truck", "package2", "truck2", "s0")), variable(9), value("at(package2, s0)", true)).
postcondition(action(("load-truck", "package2", "truck2", "s0")), effect(unconditional), variable(9), value("in(package2, truck2)", true)).
costs(action(("load-truck", "package2", "truck2", "s0")), 1).

action(action(("load-truck", "package2", "truck2", "s1"))).
precondition(action(("load-truck", "package2", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("load-truck", "package2", "truck2", "s1")), variable(9), value("at(package2, s1)", true)).
postcondition(action(("load-truck", "package2", "truck2", "s1")), effect(unconditional), variable(9), value("in(package2, truck2)", true)).
costs(action(("load-truck", "package2", "truck2", "s1")), 1).

action(action(("load-truck", "package2", "truck2", "s2"))).
precondition(action(("load-truck", "package2", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("load-truck", "package2", "truck2", "s2")), variable(9), value("at(package2, s2)", true)).
postcondition(action(("load-truck", "package2", "truck2", "s2")), effect(unconditional), variable(9), value("in(package2, truck2)", true)).
costs(action(("load-truck", "package2", "truck2", "s2")), 1).

action(action(("load-truck", "package3", "truck1", "s0"))).
precondition(action(("load-truck", "package3", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("load-truck", "package3", "truck1", "s0")), variable(8), value("at(package3, s0)", true)).
postcondition(action(("load-truck", "package3", "truck1", "s0")), effect(unconditional), variable(8), value("in(package3, truck1)", true)).
costs(action(("load-truck", "package3", "truck1", "s0")), 1).

action(action(("load-truck", "package3", "truck1", "s1"))).
precondition(action(("load-truck", "package3", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("load-truck", "package3", "truck1", "s1")), variable(8), value("at(package3, s1)", true)).
postcondition(action(("load-truck", "package3", "truck1", "s1")), effect(unconditional), variable(8), value("in(package3, truck1)", true)).
costs(action(("load-truck", "package3", "truck1", "s1")), 1).

action(action(("load-truck", "package3", "truck1", "s2"))).
precondition(action(("load-truck", "package3", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("load-truck", "package3", "truck1", "s2")), variable(8), value("at(package3, s2)", true)).
postcondition(action(("load-truck", "package3", "truck1", "s2")), effect(unconditional), variable(8), value("in(package3, truck1)", true)).
costs(action(("load-truck", "package3", "truck1", "s2")), 1).

action(action(("load-truck", "package3", "truck2", "s0"))).
precondition(action(("load-truck", "package3", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("load-truck", "package3", "truck2", "s0")), variable(8), value("at(package3, s0)", true)).
postcondition(action(("load-truck", "package3", "truck2", "s0")), effect(unconditional), variable(8), value("in(package3, truck2)", true)).
costs(action(("load-truck", "package3", "truck2", "s0")), 1).

action(action(("load-truck", "package3", "truck2", "s1"))).
precondition(action(("load-truck", "package3", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("load-truck", "package3", "truck2", "s1")), variable(8), value("at(package3, s1)", true)).
postcondition(action(("load-truck", "package3", "truck2", "s1")), effect(unconditional), variable(8), value("in(package3, truck2)", true)).
costs(action(("load-truck", "package3", "truck2", "s1")), 1).

action(action(("load-truck", "package3", "truck2", "s2"))).
precondition(action(("load-truck", "package3", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("load-truck", "package3", "truck2", "s2")), variable(8), value("at(package3, s2)", true)).
postcondition(action(("load-truck", "package3", "truck2", "s2")), effect(unconditional), variable(8), value("in(package3, truck2)", true)).
costs(action(("load-truck", "package3", "truck2", "s2")), 1).

action(action(("load-truck", "package4", "truck1", "s0"))).
precondition(action(("load-truck", "package4", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("load-truck", "package4", "truck1", "s0")), variable(7), value("at(package4, s0)", true)).
postcondition(action(("load-truck", "package4", "truck1", "s0")), effect(unconditional), variable(7), value("in(package4, truck1)", true)).
costs(action(("load-truck", "package4", "truck1", "s0")), 1).

action(action(("load-truck", "package4", "truck1", "s1"))).
precondition(action(("load-truck", "package4", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("load-truck", "package4", "truck1", "s1")), variable(7), value("at(package4, s1)", true)).
postcondition(action(("load-truck", "package4", "truck1", "s1")), effect(unconditional), variable(7), value("in(package4, truck1)", true)).
costs(action(("load-truck", "package4", "truck1", "s1")), 1).

action(action(("load-truck", "package4", "truck1", "s2"))).
precondition(action(("load-truck", "package4", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("load-truck", "package4", "truck1", "s2")), variable(7), value("at(package4, s2)", true)).
postcondition(action(("load-truck", "package4", "truck1", "s2")), effect(unconditional), variable(7), value("in(package4, truck1)", true)).
costs(action(("load-truck", "package4", "truck1", "s2")), 1).

action(action(("load-truck", "package4", "truck2", "s0"))).
precondition(action(("load-truck", "package4", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("load-truck", "package4", "truck2", "s0")), variable(7), value("at(package4, s0)", true)).
postcondition(action(("load-truck", "package4", "truck2", "s0")), effect(unconditional), variable(7), value("in(package4, truck2)", true)).
costs(action(("load-truck", "package4", "truck2", "s0")), 1).

action(action(("load-truck", "package4", "truck2", "s1"))).
precondition(action(("load-truck", "package4", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("load-truck", "package4", "truck2", "s1")), variable(7), value("at(package4, s1)", true)).
postcondition(action(("load-truck", "package4", "truck2", "s1")), effect(unconditional), variable(7), value("in(package4, truck2)", true)).
costs(action(("load-truck", "package4", "truck2", "s1")), 1).

action(action(("load-truck", "package4", "truck2", "s2"))).
precondition(action(("load-truck", "package4", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("load-truck", "package4", "truck2", "s2")), variable(7), value("at(package4, s2)", true)).
postcondition(action(("load-truck", "package4", "truck2", "s2")), effect(unconditional), variable(7), value("in(package4, truck2)", true)).
costs(action(("load-truck", "package4", "truck2", "s2")), 1).

action(action(("unload-truck", "package1", "truck1", "s0"))).
precondition(action(("unload-truck", "package1", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("unload-truck", "package1", "truck1", "s0")), variable(10), value("in(package1, truck1)", true)).
postcondition(action(("unload-truck", "package1", "truck1", "s0")), effect(unconditional), variable(10), value("at(package1, s0)", true)).
costs(action(("unload-truck", "package1", "truck1", "s0")), 1).

action(action(("unload-truck", "package1", "truck1", "s1"))).
precondition(action(("unload-truck", "package1", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("unload-truck", "package1", "truck1", "s1")), variable(10), value("in(package1, truck1)", true)).
postcondition(action(("unload-truck", "package1", "truck1", "s1")), effect(unconditional), variable(10), value("at(package1, s1)", true)).
costs(action(("unload-truck", "package1", "truck1", "s1")), 1).

action(action(("unload-truck", "package1", "truck1", "s2"))).
precondition(action(("unload-truck", "package1", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("unload-truck", "package1", "truck1", "s2")), variable(10), value("in(package1, truck1)", true)).
postcondition(action(("unload-truck", "package1", "truck1", "s2")), effect(unconditional), variable(10), value("at(package1, s2)", true)).
costs(action(("unload-truck", "package1", "truck1", "s2")), 1).

action(action(("unload-truck", "package1", "truck2", "s0"))).
precondition(action(("unload-truck", "package1", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("unload-truck", "package1", "truck2", "s0")), variable(10), value("in(package1, truck2)", true)).
postcondition(action(("unload-truck", "package1", "truck2", "s0")), effect(unconditional), variable(10), value("at(package1, s0)", true)).
costs(action(("unload-truck", "package1", "truck2", "s0")), 1).

action(action(("unload-truck", "package1", "truck2", "s1"))).
precondition(action(("unload-truck", "package1", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("unload-truck", "package1", "truck2", "s1")), variable(10), value("in(package1, truck2)", true)).
postcondition(action(("unload-truck", "package1", "truck2", "s1")), effect(unconditional), variable(10), value("at(package1, s1)", true)).
costs(action(("unload-truck", "package1", "truck2", "s1")), 1).

action(action(("unload-truck", "package1", "truck2", "s2"))).
precondition(action(("unload-truck", "package1", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("unload-truck", "package1", "truck2", "s2")), variable(10), value("in(package1, truck2)", true)).
postcondition(action(("unload-truck", "package1", "truck2", "s2")), effect(unconditional), variable(10), value("at(package1, s2)", true)).
costs(action(("unload-truck", "package1", "truck2", "s2")), 1).

action(action(("unload-truck", "package2", "truck1", "s0"))).
precondition(action(("unload-truck", "package2", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("unload-truck", "package2", "truck1", "s0")), variable(9), value("in(package2, truck1)", true)).
postcondition(action(("unload-truck", "package2", "truck1", "s0")), effect(unconditional), variable(9), value("at(package2, s0)", true)).
costs(action(("unload-truck", "package2", "truck1", "s0")), 1).

action(action(("unload-truck", "package2", "truck1", "s1"))).
precondition(action(("unload-truck", "package2", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("unload-truck", "package2", "truck1", "s1")), variable(9), value("in(package2, truck1)", true)).
postcondition(action(("unload-truck", "package2", "truck1", "s1")), effect(unconditional), variable(9), value("at(package2, s1)", true)).
costs(action(("unload-truck", "package2", "truck1", "s1")), 1).

action(action(("unload-truck", "package2", "truck1", "s2"))).
precondition(action(("unload-truck", "package2", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("unload-truck", "package2", "truck1", "s2")), variable(9), value("in(package2, truck1)", true)).
postcondition(action(("unload-truck", "package2", "truck1", "s2")), effect(unconditional), variable(9), value("at(package2, s2)", true)).
costs(action(("unload-truck", "package2", "truck1", "s2")), 1).

action(action(("unload-truck", "package2", "truck2", "s0"))).
precondition(action(("unload-truck", "package2", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("unload-truck", "package2", "truck2", "s0")), variable(9), value("in(package2, truck2)", true)).
postcondition(action(("unload-truck", "package2", "truck2", "s0")), effect(unconditional), variable(9), value("at(package2, s0)", true)).
costs(action(("unload-truck", "package2", "truck2", "s0")), 1).

action(action(("unload-truck", "package2", "truck2", "s1"))).
precondition(action(("unload-truck", "package2", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("unload-truck", "package2", "truck2", "s1")), variable(9), value("in(package2, truck2)", true)).
postcondition(action(("unload-truck", "package2", "truck2", "s1")), effect(unconditional), variable(9), value("at(package2, s1)", true)).
costs(action(("unload-truck", "package2", "truck2", "s1")), 1).

action(action(("unload-truck", "package2", "truck2", "s2"))).
precondition(action(("unload-truck", "package2", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("unload-truck", "package2", "truck2", "s2")), variable(9), value("in(package2, truck2)", true)).
postcondition(action(("unload-truck", "package2", "truck2", "s2")), effect(unconditional), variable(9), value("at(package2, s2)", true)).
costs(action(("unload-truck", "package2", "truck2", "s2")), 1).

action(action(("unload-truck", "package3", "truck1", "s0"))).
precondition(action(("unload-truck", "package3", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("unload-truck", "package3", "truck1", "s0")), variable(8), value("in(package3, truck1)", true)).
postcondition(action(("unload-truck", "package3", "truck1", "s0")), effect(unconditional), variable(8), value("at(package3, s0)", true)).
costs(action(("unload-truck", "package3", "truck1", "s0")), 1).

action(action(("unload-truck", "package3", "truck1", "s1"))).
precondition(action(("unload-truck", "package3", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("unload-truck", "package3", "truck1", "s1")), variable(8), value("in(package3, truck1)", true)).
postcondition(action(("unload-truck", "package3", "truck1", "s1")), effect(unconditional), variable(8), value("at(package3, s1)", true)).
costs(action(("unload-truck", "package3", "truck1", "s1")), 1).

action(action(("unload-truck", "package3", "truck1", "s2"))).
precondition(action(("unload-truck", "package3", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("unload-truck", "package3", "truck1", "s2")), variable(8), value("in(package3, truck1)", true)).
postcondition(action(("unload-truck", "package3", "truck1", "s2")), effect(unconditional), variable(8), value("at(package3, s2)", true)).
costs(action(("unload-truck", "package3", "truck1", "s2")), 1).

action(action(("unload-truck", "package3", "truck2", "s0"))).
precondition(action(("unload-truck", "package3", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("unload-truck", "package3", "truck2", "s0")), variable(8), value("in(package3, truck2)", true)).
postcondition(action(("unload-truck", "package3", "truck2", "s0")), effect(unconditional), variable(8), value("at(package3, s0)", true)).
costs(action(("unload-truck", "package3", "truck2", "s0")), 1).

action(action(("unload-truck", "package3", "truck2", "s1"))).
precondition(action(("unload-truck", "package3", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("unload-truck", "package3", "truck2", "s1")), variable(8), value("in(package3, truck2)", true)).
postcondition(action(("unload-truck", "package3", "truck2", "s1")), effect(unconditional), variable(8), value("at(package3, s1)", true)).
costs(action(("unload-truck", "package3", "truck2", "s1")), 1).

action(action(("unload-truck", "package3", "truck2", "s2"))).
precondition(action(("unload-truck", "package3", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("unload-truck", "package3", "truck2", "s2")), variable(8), value("in(package3, truck2)", true)).
postcondition(action(("unload-truck", "package3", "truck2", "s2")), effect(unconditional), variable(8), value("at(package3, s2)", true)).
costs(action(("unload-truck", "package3", "truck2", "s2")), 1).

action(action(("unload-truck", "package4", "truck1", "s0"))).
precondition(action(("unload-truck", "package4", "truck1", "s0")), variable(2), value("at(truck1, s0)", true)).
precondition(action(("unload-truck", "package4", "truck1", "s0")), variable(7), value("in(package4, truck1)", true)).
postcondition(action(("unload-truck", "package4", "truck1", "s0")), effect(unconditional), variable(7), value("at(package4, s0)", true)).
costs(action(("unload-truck", "package4", "truck1", "s0")), 1).

action(action(("unload-truck", "package4", "truck1", "s1"))).
precondition(action(("unload-truck", "package4", "truck1", "s1")), variable(2), value("at(truck1, s1)", true)).
precondition(action(("unload-truck", "package4", "truck1", "s1")), variable(7), value("in(package4, truck1)", true)).
postcondition(action(("unload-truck", "package4", "truck1", "s1")), effect(unconditional), variable(7), value("at(package4, s1)", true)).
costs(action(("unload-truck", "package4", "truck1", "s1")), 1).

action(action(("unload-truck", "package4", "truck1", "s2"))).
precondition(action(("unload-truck", "package4", "truck1", "s2")), variable(2), value("at(truck1, s2)", true)).
precondition(action(("unload-truck", "package4", "truck1", "s2")), variable(7), value("in(package4, truck1)", true)).
postcondition(action(("unload-truck", "package4", "truck1", "s2")), effect(unconditional), variable(7), value("at(package4, s2)", true)).
costs(action(("unload-truck", "package4", "truck1", "s2")), 1).

action(action(("unload-truck", "package4", "truck2", "s0"))).
precondition(action(("unload-truck", "package4", "truck2", "s0")), variable(3), value("at(truck2, s0)", true)).
precondition(action(("unload-truck", "package4", "truck2", "s0")), variable(7), value("in(package4, truck2)", true)).
postcondition(action(("unload-truck", "package4", "truck2", "s0")), effect(unconditional), variable(7), value("at(package4, s0)", true)).
costs(action(("unload-truck", "package4", "truck2", "s0")), 1).

action(action(("unload-truck", "package4", "truck2", "s1"))).
precondition(action(("unload-truck", "package4", "truck2", "s1")), variable(3), value("at(truck2, s1)", true)).
precondition(action(("unload-truck", "package4", "truck2", "s1")), variable(7), value("in(package4, truck2)", true)).
postcondition(action(("unload-truck", "package4", "truck2", "s1")), effect(unconditional), variable(7), value("at(package4, s1)", true)).
costs(action(("unload-truck", "package4", "truck2", "s1")), 1).

action(action(("unload-truck", "package4", "truck2", "s2"))).
precondition(action(("unload-truck", "package4", "truck2", "s2")), variable(3), value("at(truck2, s2)", true)).
precondition(action(("unload-truck", "package4", "truck2", "s2")), variable(7), value("in(package4, truck2)", true)).
postcondition(action(("unload-truck", "package4", "truck2", "s2")), effect(unconditional), variable(7), value("at(package4, s2)", true)).
costs(action(("unload-truck", "package4", "truck2", "s2")), 1).

action(action(("walk", "driver1", "p0-1", "s0"))).
precondition(action(("walk", "driver1", "p0-1", "s0")), variable(4), value("at(driver1, p0-1)", true)).
postcondition(action(("walk", "driver1", "p0-1", "s0")), effect(unconditional), variable(4), value("at(driver1, s0)", true)).
costs(action(("walk", "driver1", "p0-1", "s0")), 1).

action(action(("walk", "driver1", "p0-1", "s1"))).
precondition(action(("walk", "driver1", "p0-1", "s1")), variable(4), value("at(driver1, p0-1)", true)).
postcondition(action(("walk", "driver1", "p0-1", "s1")), effect(unconditional), variable(4), value("at(driver1, s1)", true)).
costs(action(("walk", "driver1", "p0-1", "s1")), 1).

action(action(("walk", "driver1", "p1-2", "s1"))).
precondition(action(("walk", "driver1", "p1-2", "s1")), variable(4), value("at(driver1, p1-2)", true)).
postcondition(action(("walk", "driver1", "p1-2", "s1")), effect(unconditional), variable(4), value("at(driver1, s1)", true)).
costs(action(("walk", "driver1", "p1-2", "s1")), 1).

action(action(("walk", "driver1", "p1-2", "s2"))).
precondition(action(("walk", "driver1", "p1-2", "s2")), variable(4), value("at(driver1, p1-2)", true)).
postcondition(action(("walk", "driver1", "p1-2", "s2")), effect(unconditional), variable(4), value("at(driver1, s2)", true)).
costs(action(("walk", "driver1", "p1-2", "s2")), 1).

action(action(("walk", "driver1", "s0", "p0-1"))).
precondition(action(("walk", "driver1", "s0", "p0-1")), variable(4), value("at(driver1, s0)", true)).
postcondition(action(("walk", "driver1", "s0", "p0-1")), effect(unconditional), variable(4), value("at(driver1, p0-1)", true)).
costs(action(("walk", "driver1", "s0", "p0-1")), 1).

action(action(("walk", "driver1", "s1", "p0-1"))).
precondition(action(("walk", "driver1", "s1", "p0-1")), variable(4), value("at(driver1, s1)", true)).
postcondition(action(("walk", "driver1", "s1", "p0-1")), effect(unconditional), variable(4), value("at(driver1, p0-1)", true)).
costs(action(("walk", "driver1", "s1", "p0-1")), 1).

action(action(("walk", "driver1", "s1", "p1-2"))).
precondition(action(("walk", "driver1", "s1", "p1-2")), variable(4), value("at(driver1, s1)", true)).
postcondition(action(("walk", "driver1", "s1", "p1-2")), effect(unconditional), variable(4), value("at(driver1, p1-2)", true)).
costs(action(("walk", "driver1", "s1", "p1-2")), 1).

action(action(("walk", "driver1", "s2", "p1-2"))).
precondition(action(("walk", "driver1", "s2", "p1-2")), variable(4), value("at(driver1, s2)", true)).
postcondition(action(("walk", "driver1", "s2", "p1-2")), effect(unconditional), variable(4), value("at(driver1, p1-2)", true)).
costs(action(("walk", "driver1", "s2", "p1-2")), 1).

action(action(("walk", "driver2", "p0-1", "s0"))).
precondition(action(("walk", "driver2", "p0-1", "s0")), variable(5), value("at(driver2, p0-1)", true)).
postcondition(action(("walk", "driver2", "p0-1", "s0")), effect(unconditional), variable(5), value("at(driver2, s0)", true)).
costs(action(("walk", "driver2", "p0-1", "s0")), 1).

action(action(("walk", "driver2", "p0-1", "s1"))).
precondition(action(("walk", "driver2", "p0-1", "s1")), variable(5), value("at(driver2, p0-1)", true)).
postcondition(action(("walk", "driver2", "p0-1", "s1")), effect(unconditional), variable(5), value("at(driver2, s1)", true)).
costs(action(("walk", "driver2", "p0-1", "s1")), 1).

action(action(("walk", "driver2", "p1-2", "s1"))).
precondition(action(("walk", "driver2", "p1-2", "s1")), variable(5), value("at(driver2, p1-2)", true)).
postcondition(action(("walk", "driver2", "p1-2", "s1")), effect(unconditional), variable(5), value("at(driver2, s1)", true)).
costs(action(("walk", "driver2", "p1-2", "s1")), 1).

action(action(("walk", "driver2", "p1-2", "s2"))).
precondition(action(("walk", "driver2", "p1-2", "s2")), variable(5), value("at(driver2, p1-2)", true)).
postcondition(action(("walk", "driver2", "p1-2", "s2")), effect(unconditional), variable(5), value("at(driver2, s2)", true)).
costs(action(("walk", "driver2", "p1-2", "s2")), 1).

action(action(("walk", "driver2", "s0", "p0-1"))).
precondition(action(("walk", "driver2", "s0", "p0-1")), variable(5), value("at(driver2, s0)", true)).
postcondition(action(("walk", "driver2", "s0", "p0-1")), effect(unconditional), variable(5), value("at(driver2, p0-1)", true)).
costs(action(("walk", "driver2", "s0", "p0-1")), 1).

action(action(("walk", "driver2", "s1", "p0-1"))).
precondition(action(("walk", "driver2", "s1", "p0-1")), variable(5), value("at(driver2, s1)", true)).
postcondition(action(("walk", "driver2", "s1", "p0-1")), effect(unconditional), variable(5), value("at(driver2, p0-1)", true)).
costs(action(("walk", "driver2", "s1", "p0-1")), 1).

action(action(("walk", "driver2", "s1", "p1-2"))).
precondition(action(("walk", "driver2", "s1", "p1-2")), variable(5), value("at(driver2, s1)", true)).
postcondition(action(("walk", "driver2", "s1", "p1-2")), effect(unconditional), variable(5), value("at(driver2, p1-2)", true)).
costs(action(("walk", "driver2", "s1", "p1-2")), 1).

action(action(("walk", "driver2", "s2", "p1-2"))).
precondition(action(("walk", "driver2", "s2", "p1-2")), variable(5), value("at(driver2, s2)", true)).
postcondition(action(("walk", "driver2", "s2", "p1-2")), effect(unconditional), variable(5), value("at(driver2, p1-2)", true)).
costs(action(("walk", "driver2", "s2", "p1-2")), 1).

action(action(("walk", "driver3", "p0-1", "s0"))).
precondition(action(("walk", "driver3", "p0-1", "s0")), variable(6), value("at(driver3, p0-1)", true)).
postcondition(action(("walk", "driver3", "p0-1", "s0")), effect(unconditional), variable(6), value("at(driver3, s0)", true)).
costs(action(("walk", "driver3", "p0-1", "s0")), 1).

action(action(("walk", "driver3", "p0-1", "s1"))).
precondition(action(("walk", "driver3", "p0-1", "s1")), variable(6), value("at(driver3, p0-1)", true)).
postcondition(action(("walk", "driver3", "p0-1", "s1")), effect(unconditional), variable(6), value("at(driver3, s1)", true)).
costs(action(("walk", "driver3", "p0-1", "s1")), 1).

action(action(("walk", "driver3", "p1-2", "s1"))).
precondition(action(("walk", "driver3", "p1-2", "s1")), variable(6), value("at(driver3, p1-2)", true)).
postcondition(action(("walk", "driver3", "p1-2", "s1")), effect(unconditional), variable(6), value("at(driver3, s1)", true)).
costs(action(("walk", "driver3", "p1-2", "s1")), 1).

action(action(("walk", "driver3", "p1-2", "s2"))).
precondition(action(("walk", "driver3", "p1-2", "s2")), variable(6), value("at(driver3, p1-2)", true)).
postcondition(action(("walk", "driver3", "p1-2", "s2")), effect(unconditional), variable(6), value("at(driver3, s2)", true)).
costs(action(("walk", "driver3", "p1-2", "s2")), 1).

action(action(("walk", "driver3", "s0", "p0-1"))).
precondition(action(("walk", "driver3", "s0", "p0-1")), variable(6), value("at(driver3, s0)", true)).
postcondition(action(("walk", "driver3", "s0", "p0-1")), effect(unconditional), variable(6), value("at(driver3, p0-1)", true)).
costs(action(("walk", "driver3", "s0", "p0-1")), 1).

action(action(("walk", "driver3", "s1", "p0-1"))).
precondition(action(("walk", "driver3", "s1", "p0-1")), variable(6), value("at(driver3, s1)", true)).
postcondition(action(("walk", "driver3", "s1", "p0-1")), effect(unconditional), variable(6), value("at(driver3, p0-1)", true)).
costs(action(("walk", "driver3", "s1", "p0-1")), 1).

action(action(("walk", "driver3", "s1", "p1-2"))).
precondition(action(("walk", "driver3", "s1", "p1-2")), variable(6), value("at(driver3, s1)", true)).
postcondition(action(("walk", "driver3", "s1", "p1-2")), effect(unconditional), variable(6), value("at(driver3, p1-2)", true)).
costs(action(("walk", "driver3", "s1", "p1-2")), 1).

action(action(("walk", "driver3", "s2", "p1-2"))).
precondition(action(("walk", "driver3", "s2", "p1-2")), variable(6), value("at(driver3, s2)", true)).
postcondition(action(("walk", "driver3", "s2", "p1-2")), effect(unconditional), variable(6), value("at(driver3, p1-2)", true)).
costs(action(("walk", "driver3", "s2", "p1-2")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(4), value("driving(driver1, truck1)", true)).
contains(mutexGroup(0), variable(5), value("driving(driver2, truck1)", true)).
contains(mutexGroup(0), variable(6), value("driving(driver3, truck1)", true)).
contains(mutexGroup(0), variable(0), value("empty(truck1)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(4), value("driving(driver1, truck2)", true)).
contains(mutexGroup(1), variable(5), value("driving(driver2, truck2)", true)).
contains(mutexGroup(1), variable(6), value("driving(driver3, truck2)", true)).
contains(mutexGroup(1), variable(1), value("empty(truck2)", true)).

% initial state
initialState(variable(0), value("empty(truck1)", true)).
initialState(variable(1), value("empty(truck2)", true)).
initialState(variable(2), value("at(truck1, s1)", true)).
initialState(variable(3), value("at(truck2, s0)", true)).
initialState(variable(4), value("at(driver1, s1)", true)).
initialState(variable(5), value("at(driver2, s1)", true)).
initialState(variable(6), value("at(driver3, s0)", true)).
initialState(variable(7), value("at(package4, s1)", true)).
initialState(variable(8), value("at(package3, s0)", true)).
initialState(variable(9), value("at(package2, s2)", true)).
initialState(variable(10), value("at(package1, s2)", true)).

% goal
goal(variable(2), value("at(truck1, s1)", true)).
goal(variable(3), value("at(truck2, s2)", true)).
goal(variable(4), value("at(driver1, s1)", true)).
goal(variable(5), value("at(driver2, s0)", true)).
goal(variable(6), value("at(driver3, s1)", true)).
goal(variable(7), value("at(package4, s0)", true)).
goal(variable(8), value("at(package3, s2)", true)).
goal(variable(9), value("at(package2, s2)", true)).
goal(variable(10), value("at(package1, s1)", true)).
