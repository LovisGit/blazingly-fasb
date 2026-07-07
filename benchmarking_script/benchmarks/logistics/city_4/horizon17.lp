#const horizon=17.

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
contains(variable(0), value("at(tru2, apt2)", true)).
contains(variable(0), value("at(tru2, pos2)", true)).

variable(variable(1)).
contains(variable(1), value("at(tru1, apt1)", true)).
contains(variable(1), value("at(tru1, pos1)", true)).

variable(variable(2)).
contains(variable(2), value("at(apn1, apt1)", true)).
contains(variable(2), value("at(apn1, apt2)", true)).

variable(variable(3)).
contains(variable(3), value("at(obj23, apt1)", true)).
contains(variable(3), value("at(obj23, apt2)", true)).
contains(variable(3), value("at(obj23, pos1)", true)).
contains(variable(3), value("at(obj23, pos2)", true)).
contains(variable(3), value("in(obj23, apn1)", true)).
contains(variable(3), value("in(obj23, tru1)", true)).
contains(variable(3), value("in(obj23, tru2)", true)).

variable(variable(4)).
contains(variable(4), value("at(obj22, apt1)", true)).
contains(variable(4), value("at(obj22, apt2)", true)).
contains(variable(4), value("at(obj22, pos1)", true)).
contains(variable(4), value("at(obj22, pos2)", true)).
contains(variable(4), value("in(obj22, apn1)", true)).
contains(variable(4), value("in(obj22, tru1)", true)).
contains(variable(4), value("in(obj22, tru2)", true)).

variable(variable(5)).
contains(variable(5), value("at(obj21, apt1)", true)).
contains(variable(5), value("at(obj21, apt2)", true)).
contains(variable(5), value("at(obj21, pos1)", true)).
contains(variable(5), value("at(obj21, pos2)", true)).
contains(variable(5), value("in(obj21, apn1)", true)).
contains(variable(5), value("in(obj21, tru1)", true)).
contains(variable(5), value("in(obj21, tru2)", true)).

variable(variable(6)).
contains(variable(6), value("at(obj13, apt1)", true)).
contains(variable(6), value("at(obj13, apt2)", true)).
contains(variable(6), value("at(obj13, pos1)", true)).
contains(variable(6), value("at(obj13, pos2)", true)).
contains(variable(6), value("in(obj13, apn1)", true)).
contains(variable(6), value("in(obj13, tru1)", true)).
contains(variable(6), value("in(obj13, tru2)", true)).

variable(variable(7)).
contains(variable(7), value("at(obj12, apt1)", true)).
contains(variable(7), value("at(obj12, apt2)", true)).
contains(variable(7), value("at(obj12, pos1)", true)).
contains(variable(7), value("at(obj12, pos2)", true)).
contains(variable(7), value("in(obj12, apn1)", true)).
contains(variable(7), value("in(obj12, tru1)", true)).
contains(variable(7), value("in(obj12, tru2)", true)).

variable(variable(8)).
contains(variable(8), value("at(obj11, apt1)", true)).
contains(variable(8), value("at(obj11, apt2)", true)).
contains(variable(8), value("at(obj11, pos1)", true)).
contains(variable(8), value("at(obj11, pos2)", true)).
contains(variable(8), value("in(obj11, apn1)", true)).
contains(variable(8), value("in(obj11, tru1)", true)).
contains(variable(8), value("in(obj11, tru2)", true)).

% actions
action(action(("drive-truck", "tru1", "apt1", "pos1", "cit1"))).
precondition(action(("drive-truck", "tru1", "apt1", "pos1", "cit1")), variable(1), value("at(tru1, apt1)", true)).
postcondition(action(("drive-truck", "tru1", "apt1", "pos1", "cit1")), effect(unconditional), variable(1), value("at(tru1, pos1)", true)).
costs(action(("drive-truck", "tru1", "apt1", "pos1", "cit1")), 1).

action(action(("drive-truck", "tru1", "pos1", "apt1", "cit1"))).
precondition(action(("drive-truck", "tru1", "pos1", "apt1", "cit1")), variable(1), value("at(tru1, pos1)", true)).
postcondition(action(("drive-truck", "tru1", "pos1", "apt1", "cit1")), effect(unconditional), variable(1), value("at(tru1, apt1)", true)).
costs(action(("drive-truck", "tru1", "pos1", "apt1", "cit1")), 1).

action(action(("drive-truck", "tru2", "apt2", "pos2", "cit2"))).
precondition(action(("drive-truck", "tru2", "apt2", "pos2", "cit2")), variable(0), value("at(tru2, apt2)", true)).
postcondition(action(("drive-truck", "tru2", "apt2", "pos2", "cit2")), effect(unconditional), variable(0), value("at(tru2, pos2)", true)).
costs(action(("drive-truck", "tru2", "apt2", "pos2", "cit2")), 1).

action(action(("drive-truck", "tru2", "pos2", "apt2", "cit2"))).
precondition(action(("drive-truck", "tru2", "pos2", "apt2", "cit2")), variable(0), value("at(tru2, pos2)", true)).
postcondition(action(("drive-truck", "tru2", "pos2", "apt2", "cit2")), effect(unconditional), variable(0), value("at(tru2, apt2)", true)).
costs(action(("drive-truck", "tru2", "pos2", "apt2", "cit2")), 1).

action(action(("fly-airplane", "apn1", "apt1", "apt2"))).
precondition(action(("fly-airplane", "apn1", "apt1", "apt2")), variable(2), value("at(apn1, apt1)", true)).
postcondition(action(("fly-airplane", "apn1", "apt1", "apt2")), effect(unconditional), variable(2), value("at(apn1, apt2)", true)).
costs(action(("fly-airplane", "apn1", "apt1", "apt2")), 1).

action(action(("fly-airplane", "apn1", "apt2", "apt1"))).
precondition(action(("fly-airplane", "apn1", "apt2", "apt1")), variable(2), value("at(apn1, apt2)", true)).
postcondition(action(("fly-airplane", "apn1", "apt2", "apt1")), effect(unconditional), variable(2), value("at(apn1, apt1)", true)).
costs(action(("fly-airplane", "apn1", "apt2", "apt1")), 1).

action(action(("load-airplane", "obj11", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj11", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj11", "apn1", "apt1")), variable(8), value("at(obj11, apt1)", true)).
postcondition(action(("load-airplane", "obj11", "apn1", "apt1")), effect(unconditional), variable(8), value("in(obj11, apn1)", true)).
costs(action(("load-airplane", "obj11", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj11", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj11", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj11", "apn1", "apt2")), variable(8), value("at(obj11, apt2)", true)).
postcondition(action(("load-airplane", "obj11", "apn1", "apt2")), effect(unconditional), variable(8), value("in(obj11, apn1)", true)).
costs(action(("load-airplane", "obj11", "apn1", "apt2")), 1).

action(action(("load-airplane", "obj12", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj12", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj12", "apn1", "apt1")), variable(7), value("at(obj12, apt1)", true)).
postcondition(action(("load-airplane", "obj12", "apn1", "apt1")), effect(unconditional), variable(7), value("in(obj12, apn1)", true)).
costs(action(("load-airplane", "obj12", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj12", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj12", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj12", "apn1", "apt2")), variable(7), value("at(obj12, apt2)", true)).
postcondition(action(("load-airplane", "obj12", "apn1", "apt2")), effect(unconditional), variable(7), value("in(obj12, apn1)", true)).
costs(action(("load-airplane", "obj12", "apn1", "apt2")), 1).

action(action(("load-airplane", "obj13", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj13", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj13", "apn1", "apt1")), variable(6), value("at(obj13, apt1)", true)).
postcondition(action(("load-airplane", "obj13", "apn1", "apt1")), effect(unconditional), variable(6), value("in(obj13, apn1)", true)).
costs(action(("load-airplane", "obj13", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj13", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj13", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj13", "apn1", "apt2")), variable(6), value("at(obj13, apt2)", true)).
postcondition(action(("load-airplane", "obj13", "apn1", "apt2")), effect(unconditional), variable(6), value("in(obj13, apn1)", true)).
costs(action(("load-airplane", "obj13", "apn1", "apt2")), 1).

action(action(("load-airplane", "obj21", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj21", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj21", "apn1", "apt1")), variable(5), value("at(obj21, apt1)", true)).
postcondition(action(("load-airplane", "obj21", "apn1", "apt1")), effect(unconditional), variable(5), value("in(obj21, apn1)", true)).
costs(action(("load-airplane", "obj21", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj21", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj21", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj21", "apn1", "apt2")), variable(5), value("at(obj21, apt2)", true)).
postcondition(action(("load-airplane", "obj21", "apn1", "apt2")), effect(unconditional), variable(5), value("in(obj21, apn1)", true)).
costs(action(("load-airplane", "obj21", "apn1", "apt2")), 1).

action(action(("load-airplane", "obj22", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj22", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj22", "apn1", "apt1")), variable(4), value("at(obj22, apt1)", true)).
postcondition(action(("load-airplane", "obj22", "apn1", "apt1")), effect(unconditional), variable(4), value("in(obj22, apn1)", true)).
costs(action(("load-airplane", "obj22", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj22", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj22", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj22", "apn1", "apt2")), variable(4), value("at(obj22, apt2)", true)).
postcondition(action(("load-airplane", "obj22", "apn1", "apt2")), effect(unconditional), variable(4), value("in(obj22, apn1)", true)).
costs(action(("load-airplane", "obj22", "apn1", "apt2")), 1).

action(action(("load-airplane", "obj23", "apn1", "apt1"))).
precondition(action(("load-airplane", "obj23", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("load-airplane", "obj23", "apn1", "apt1")), variable(3), value("at(obj23, apt1)", true)).
postcondition(action(("load-airplane", "obj23", "apn1", "apt1")), effect(unconditional), variable(3), value("in(obj23, apn1)", true)).
costs(action(("load-airplane", "obj23", "apn1", "apt1")), 1).

action(action(("load-airplane", "obj23", "apn1", "apt2"))).
precondition(action(("load-airplane", "obj23", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("load-airplane", "obj23", "apn1", "apt2")), variable(3), value("at(obj23, apt2)", true)).
postcondition(action(("load-airplane", "obj23", "apn1", "apt2")), effect(unconditional), variable(3), value("in(obj23, apn1)", true)).
costs(action(("load-airplane", "obj23", "apn1", "apt2")), 1).

action(action(("load-truck", "obj11", "tru1", "apt1"))).
precondition(action(("load-truck", "obj11", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj11", "tru1", "apt1")), variable(8), value("at(obj11, apt1)", true)).
postcondition(action(("load-truck", "obj11", "tru1", "apt1")), effect(unconditional), variable(8), value("in(obj11, tru1)", true)).
costs(action(("load-truck", "obj11", "tru1", "apt1")), 1).

action(action(("load-truck", "obj11", "tru1", "pos1"))).
precondition(action(("load-truck", "obj11", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj11", "tru1", "pos1")), variable(8), value("at(obj11, pos1)", true)).
postcondition(action(("load-truck", "obj11", "tru1", "pos1")), effect(unconditional), variable(8), value("in(obj11, tru1)", true)).
costs(action(("load-truck", "obj11", "tru1", "pos1")), 1).

action(action(("load-truck", "obj11", "tru2", "apt2"))).
precondition(action(("load-truck", "obj11", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj11", "tru2", "apt2")), variable(8), value("at(obj11, apt2)", true)).
postcondition(action(("load-truck", "obj11", "tru2", "apt2")), effect(unconditional), variable(8), value("in(obj11, tru2)", true)).
costs(action(("load-truck", "obj11", "tru2", "apt2")), 1).

action(action(("load-truck", "obj11", "tru2", "pos2"))).
precondition(action(("load-truck", "obj11", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj11", "tru2", "pos2")), variable(8), value("at(obj11, pos2)", true)).
postcondition(action(("load-truck", "obj11", "tru2", "pos2")), effect(unconditional), variable(8), value("in(obj11, tru2)", true)).
costs(action(("load-truck", "obj11", "tru2", "pos2")), 1).

action(action(("load-truck", "obj12", "tru1", "apt1"))).
precondition(action(("load-truck", "obj12", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj12", "tru1", "apt1")), variable(7), value("at(obj12, apt1)", true)).
postcondition(action(("load-truck", "obj12", "tru1", "apt1")), effect(unconditional), variable(7), value("in(obj12, tru1)", true)).
costs(action(("load-truck", "obj12", "tru1", "apt1")), 1).

action(action(("load-truck", "obj12", "tru1", "pos1"))).
precondition(action(("load-truck", "obj12", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj12", "tru1", "pos1")), variable(7), value("at(obj12, pos1)", true)).
postcondition(action(("load-truck", "obj12", "tru1", "pos1")), effect(unconditional), variable(7), value("in(obj12, tru1)", true)).
costs(action(("load-truck", "obj12", "tru1", "pos1")), 1).

action(action(("load-truck", "obj12", "tru2", "apt2"))).
precondition(action(("load-truck", "obj12", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj12", "tru2", "apt2")), variable(7), value("at(obj12, apt2)", true)).
postcondition(action(("load-truck", "obj12", "tru2", "apt2")), effect(unconditional), variable(7), value("in(obj12, tru2)", true)).
costs(action(("load-truck", "obj12", "tru2", "apt2")), 1).

action(action(("load-truck", "obj12", "tru2", "pos2"))).
precondition(action(("load-truck", "obj12", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj12", "tru2", "pos2")), variable(7), value("at(obj12, pos2)", true)).
postcondition(action(("load-truck", "obj12", "tru2", "pos2")), effect(unconditional), variable(7), value("in(obj12, tru2)", true)).
costs(action(("load-truck", "obj12", "tru2", "pos2")), 1).

action(action(("load-truck", "obj13", "tru1", "apt1"))).
precondition(action(("load-truck", "obj13", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj13", "tru1", "apt1")), variable(6), value("at(obj13, apt1)", true)).
postcondition(action(("load-truck", "obj13", "tru1", "apt1")), effect(unconditional), variable(6), value("in(obj13, tru1)", true)).
costs(action(("load-truck", "obj13", "tru1", "apt1")), 1).

action(action(("load-truck", "obj13", "tru1", "pos1"))).
precondition(action(("load-truck", "obj13", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj13", "tru1", "pos1")), variable(6), value("at(obj13, pos1)", true)).
postcondition(action(("load-truck", "obj13", "tru1", "pos1")), effect(unconditional), variable(6), value("in(obj13, tru1)", true)).
costs(action(("load-truck", "obj13", "tru1", "pos1")), 1).

action(action(("load-truck", "obj13", "tru2", "apt2"))).
precondition(action(("load-truck", "obj13", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj13", "tru2", "apt2")), variable(6), value("at(obj13, apt2)", true)).
postcondition(action(("load-truck", "obj13", "tru2", "apt2")), effect(unconditional), variable(6), value("in(obj13, tru2)", true)).
costs(action(("load-truck", "obj13", "tru2", "apt2")), 1).

action(action(("load-truck", "obj13", "tru2", "pos2"))).
precondition(action(("load-truck", "obj13", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj13", "tru2", "pos2")), variable(6), value("at(obj13, pos2)", true)).
postcondition(action(("load-truck", "obj13", "tru2", "pos2")), effect(unconditional), variable(6), value("in(obj13, tru2)", true)).
costs(action(("load-truck", "obj13", "tru2", "pos2")), 1).

action(action(("load-truck", "obj21", "tru1", "apt1"))).
precondition(action(("load-truck", "obj21", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj21", "tru1", "apt1")), variable(5), value("at(obj21, apt1)", true)).
postcondition(action(("load-truck", "obj21", "tru1", "apt1")), effect(unconditional), variable(5), value("in(obj21, tru1)", true)).
costs(action(("load-truck", "obj21", "tru1", "apt1")), 1).

action(action(("load-truck", "obj21", "tru1", "pos1"))).
precondition(action(("load-truck", "obj21", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj21", "tru1", "pos1")), variable(5), value("at(obj21, pos1)", true)).
postcondition(action(("load-truck", "obj21", "tru1", "pos1")), effect(unconditional), variable(5), value("in(obj21, tru1)", true)).
costs(action(("load-truck", "obj21", "tru1", "pos1")), 1).

action(action(("load-truck", "obj21", "tru2", "apt2"))).
precondition(action(("load-truck", "obj21", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj21", "tru2", "apt2")), variable(5), value("at(obj21, apt2)", true)).
postcondition(action(("load-truck", "obj21", "tru2", "apt2")), effect(unconditional), variable(5), value("in(obj21, tru2)", true)).
costs(action(("load-truck", "obj21", "tru2", "apt2")), 1).

action(action(("load-truck", "obj21", "tru2", "pos2"))).
precondition(action(("load-truck", "obj21", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj21", "tru2", "pos2")), variable(5), value("at(obj21, pos2)", true)).
postcondition(action(("load-truck", "obj21", "tru2", "pos2")), effect(unconditional), variable(5), value("in(obj21, tru2)", true)).
costs(action(("load-truck", "obj21", "tru2", "pos2")), 1).

action(action(("load-truck", "obj22", "tru1", "apt1"))).
precondition(action(("load-truck", "obj22", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj22", "tru1", "apt1")), variable(4), value("at(obj22, apt1)", true)).
postcondition(action(("load-truck", "obj22", "tru1", "apt1")), effect(unconditional), variable(4), value("in(obj22, tru1)", true)).
costs(action(("load-truck", "obj22", "tru1", "apt1")), 1).

action(action(("load-truck", "obj22", "tru1", "pos1"))).
precondition(action(("load-truck", "obj22", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj22", "tru1", "pos1")), variable(4), value("at(obj22, pos1)", true)).
postcondition(action(("load-truck", "obj22", "tru1", "pos1")), effect(unconditional), variable(4), value("in(obj22, tru1)", true)).
costs(action(("load-truck", "obj22", "tru1", "pos1")), 1).

action(action(("load-truck", "obj22", "tru2", "apt2"))).
precondition(action(("load-truck", "obj22", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj22", "tru2", "apt2")), variable(4), value("at(obj22, apt2)", true)).
postcondition(action(("load-truck", "obj22", "tru2", "apt2")), effect(unconditional), variable(4), value("in(obj22, tru2)", true)).
costs(action(("load-truck", "obj22", "tru2", "apt2")), 1).

action(action(("load-truck", "obj22", "tru2", "pos2"))).
precondition(action(("load-truck", "obj22", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj22", "tru2", "pos2")), variable(4), value("at(obj22, pos2)", true)).
postcondition(action(("load-truck", "obj22", "tru2", "pos2")), effect(unconditional), variable(4), value("in(obj22, tru2)", true)).
costs(action(("load-truck", "obj22", "tru2", "pos2")), 1).

action(action(("load-truck", "obj23", "tru1", "apt1"))).
precondition(action(("load-truck", "obj23", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("load-truck", "obj23", "tru1", "apt1")), variable(3), value("at(obj23, apt1)", true)).
postcondition(action(("load-truck", "obj23", "tru1", "apt1")), effect(unconditional), variable(3), value("in(obj23, tru1)", true)).
costs(action(("load-truck", "obj23", "tru1", "apt1")), 1).

action(action(("load-truck", "obj23", "tru1", "pos1"))).
precondition(action(("load-truck", "obj23", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("load-truck", "obj23", "tru1", "pos1")), variable(3), value("at(obj23, pos1)", true)).
postcondition(action(("load-truck", "obj23", "tru1", "pos1")), effect(unconditional), variable(3), value("in(obj23, tru1)", true)).
costs(action(("load-truck", "obj23", "tru1", "pos1")), 1).

action(action(("load-truck", "obj23", "tru2", "apt2"))).
precondition(action(("load-truck", "obj23", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("load-truck", "obj23", "tru2", "apt2")), variable(3), value("at(obj23, apt2)", true)).
postcondition(action(("load-truck", "obj23", "tru2", "apt2")), effect(unconditional), variable(3), value("in(obj23, tru2)", true)).
costs(action(("load-truck", "obj23", "tru2", "apt2")), 1).

action(action(("load-truck", "obj23", "tru2", "pos2"))).
precondition(action(("load-truck", "obj23", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("load-truck", "obj23", "tru2", "pos2")), variable(3), value("at(obj23, pos2)", true)).
postcondition(action(("load-truck", "obj23", "tru2", "pos2")), effect(unconditional), variable(3), value("in(obj23, tru2)", true)).
costs(action(("load-truck", "obj23", "tru2", "pos2")), 1).

action(action(("unload-airplane", "obj11", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj11", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj11", "apn1", "apt1")), variable(8), value("in(obj11, apn1)", true)).
postcondition(action(("unload-airplane", "obj11", "apn1", "apt1")), effect(unconditional), variable(8), value("at(obj11, apt1)", true)).
costs(action(("unload-airplane", "obj11", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj11", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj11", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj11", "apn1", "apt2")), variable(8), value("in(obj11, apn1)", true)).
postcondition(action(("unload-airplane", "obj11", "apn1", "apt2")), effect(unconditional), variable(8), value("at(obj11, apt2)", true)).
costs(action(("unload-airplane", "obj11", "apn1", "apt2")), 1).

action(action(("unload-airplane", "obj12", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj12", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj12", "apn1", "apt1")), variable(7), value("in(obj12, apn1)", true)).
postcondition(action(("unload-airplane", "obj12", "apn1", "apt1")), effect(unconditional), variable(7), value("at(obj12, apt1)", true)).
costs(action(("unload-airplane", "obj12", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj12", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj12", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj12", "apn1", "apt2")), variable(7), value("in(obj12, apn1)", true)).
postcondition(action(("unload-airplane", "obj12", "apn1", "apt2")), effect(unconditional), variable(7), value("at(obj12, apt2)", true)).
costs(action(("unload-airplane", "obj12", "apn1", "apt2")), 1).

action(action(("unload-airplane", "obj13", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj13", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj13", "apn1", "apt1")), variable(6), value("in(obj13, apn1)", true)).
postcondition(action(("unload-airplane", "obj13", "apn1", "apt1")), effect(unconditional), variable(6), value("at(obj13, apt1)", true)).
costs(action(("unload-airplane", "obj13", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj13", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj13", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj13", "apn1", "apt2")), variable(6), value("in(obj13, apn1)", true)).
postcondition(action(("unload-airplane", "obj13", "apn1", "apt2")), effect(unconditional), variable(6), value("at(obj13, apt2)", true)).
costs(action(("unload-airplane", "obj13", "apn1", "apt2")), 1).

action(action(("unload-airplane", "obj21", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj21", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj21", "apn1", "apt1")), variable(5), value("in(obj21, apn1)", true)).
postcondition(action(("unload-airplane", "obj21", "apn1", "apt1")), effect(unconditional), variable(5), value("at(obj21, apt1)", true)).
costs(action(("unload-airplane", "obj21", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj21", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj21", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj21", "apn1", "apt2")), variable(5), value("in(obj21, apn1)", true)).
postcondition(action(("unload-airplane", "obj21", "apn1", "apt2")), effect(unconditional), variable(5), value("at(obj21, apt2)", true)).
costs(action(("unload-airplane", "obj21", "apn1", "apt2")), 1).

action(action(("unload-airplane", "obj22", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj22", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj22", "apn1", "apt1")), variable(4), value("in(obj22, apn1)", true)).
postcondition(action(("unload-airplane", "obj22", "apn1", "apt1")), effect(unconditional), variable(4), value("at(obj22, apt1)", true)).
costs(action(("unload-airplane", "obj22", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj22", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj22", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj22", "apn1", "apt2")), variable(4), value("in(obj22, apn1)", true)).
postcondition(action(("unload-airplane", "obj22", "apn1", "apt2")), effect(unconditional), variable(4), value("at(obj22, apt2)", true)).
costs(action(("unload-airplane", "obj22", "apn1", "apt2")), 1).

action(action(("unload-airplane", "obj23", "apn1", "apt1"))).
precondition(action(("unload-airplane", "obj23", "apn1", "apt1")), variable(2), value("at(apn1, apt1)", true)).
precondition(action(("unload-airplane", "obj23", "apn1", "apt1")), variable(3), value("in(obj23, apn1)", true)).
postcondition(action(("unload-airplane", "obj23", "apn1", "apt1")), effect(unconditional), variable(3), value("at(obj23, apt1)", true)).
costs(action(("unload-airplane", "obj23", "apn1", "apt1")), 1).

action(action(("unload-airplane", "obj23", "apn1", "apt2"))).
precondition(action(("unload-airplane", "obj23", "apn1", "apt2")), variable(2), value("at(apn1, apt2)", true)).
precondition(action(("unload-airplane", "obj23", "apn1", "apt2")), variable(3), value("in(obj23, apn1)", true)).
postcondition(action(("unload-airplane", "obj23", "apn1", "apt2")), effect(unconditional), variable(3), value("at(obj23, apt2)", true)).
costs(action(("unload-airplane", "obj23", "apn1", "apt2")), 1).

action(action(("unload-truck", "obj11", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj11", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj11", "tru1", "apt1")), variable(8), value("in(obj11, tru1)", true)).
postcondition(action(("unload-truck", "obj11", "tru1", "apt1")), effect(unconditional), variable(8), value("at(obj11, apt1)", true)).
costs(action(("unload-truck", "obj11", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj11", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj11", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj11", "tru1", "pos1")), variable(8), value("in(obj11, tru1)", true)).
postcondition(action(("unload-truck", "obj11", "tru1", "pos1")), effect(unconditional), variable(8), value("at(obj11, pos1)", true)).
costs(action(("unload-truck", "obj11", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj11", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj11", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj11", "tru2", "apt2")), variable(8), value("in(obj11, tru2)", true)).
postcondition(action(("unload-truck", "obj11", "tru2", "apt2")), effect(unconditional), variable(8), value("at(obj11, apt2)", true)).
costs(action(("unload-truck", "obj11", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj11", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj11", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj11", "tru2", "pos2")), variable(8), value("in(obj11, tru2)", true)).
postcondition(action(("unload-truck", "obj11", "tru2", "pos2")), effect(unconditional), variable(8), value("at(obj11, pos2)", true)).
costs(action(("unload-truck", "obj11", "tru2", "pos2")), 1).

action(action(("unload-truck", "obj12", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj12", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj12", "tru1", "apt1")), variable(7), value("in(obj12, tru1)", true)).
postcondition(action(("unload-truck", "obj12", "tru1", "apt1")), effect(unconditional), variable(7), value("at(obj12, apt1)", true)).
costs(action(("unload-truck", "obj12", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj12", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj12", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj12", "tru1", "pos1")), variable(7), value("in(obj12, tru1)", true)).
postcondition(action(("unload-truck", "obj12", "tru1", "pos1")), effect(unconditional), variable(7), value("at(obj12, pos1)", true)).
costs(action(("unload-truck", "obj12", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj12", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj12", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj12", "tru2", "apt2")), variable(7), value("in(obj12, tru2)", true)).
postcondition(action(("unload-truck", "obj12", "tru2", "apt2")), effect(unconditional), variable(7), value("at(obj12, apt2)", true)).
costs(action(("unload-truck", "obj12", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj12", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj12", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj12", "tru2", "pos2")), variable(7), value("in(obj12, tru2)", true)).
postcondition(action(("unload-truck", "obj12", "tru2", "pos2")), effect(unconditional), variable(7), value("at(obj12, pos2)", true)).
costs(action(("unload-truck", "obj12", "tru2", "pos2")), 1).

action(action(("unload-truck", "obj13", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj13", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj13", "tru1", "apt1")), variable(6), value("in(obj13, tru1)", true)).
postcondition(action(("unload-truck", "obj13", "tru1", "apt1")), effect(unconditional), variable(6), value("at(obj13, apt1)", true)).
costs(action(("unload-truck", "obj13", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj13", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj13", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj13", "tru1", "pos1")), variable(6), value("in(obj13, tru1)", true)).
postcondition(action(("unload-truck", "obj13", "tru1", "pos1")), effect(unconditional), variable(6), value("at(obj13, pos1)", true)).
costs(action(("unload-truck", "obj13", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj13", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj13", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj13", "tru2", "apt2")), variable(6), value("in(obj13, tru2)", true)).
postcondition(action(("unload-truck", "obj13", "tru2", "apt2")), effect(unconditional), variable(6), value("at(obj13, apt2)", true)).
costs(action(("unload-truck", "obj13", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj13", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj13", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj13", "tru2", "pos2")), variable(6), value("in(obj13, tru2)", true)).
postcondition(action(("unload-truck", "obj13", "tru2", "pos2")), effect(unconditional), variable(6), value("at(obj13, pos2)", true)).
costs(action(("unload-truck", "obj13", "tru2", "pos2")), 1).

action(action(("unload-truck", "obj21", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj21", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj21", "tru1", "apt1")), variable(5), value("in(obj21, tru1)", true)).
postcondition(action(("unload-truck", "obj21", "tru1", "apt1")), effect(unconditional), variable(5), value("at(obj21, apt1)", true)).
costs(action(("unload-truck", "obj21", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj21", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj21", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj21", "tru1", "pos1")), variable(5), value("in(obj21, tru1)", true)).
postcondition(action(("unload-truck", "obj21", "tru1", "pos1")), effect(unconditional), variable(5), value("at(obj21, pos1)", true)).
costs(action(("unload-truck", "obj21", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj21", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj21", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj21", "tru2", "apt2")), variable(5), value("in(obj21, tru2)", true)).
postcondition(action(("unload-truck", "obj21", "tru2", "apt2")), effect(unconditional), variable(5), value("at(obj21, apt2)", true)).
costs(action(("unload-truck", "obj21", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj21", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj21", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj21", "tru2", "pos2")), variable(5), value("in(obj21, tru2)", true)).
postcondition(action(("unload-truck", "obj21", "tru2", "pos2")), effect(unconditional), variable(5), value("at(obj21, pos2)", true)).
costs(action(("unload-truck", "obj21", "tru2", "pos2")), 1).

action(action(("unload-truck", "obj22", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj22", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj22", "tru1", "apt1")), variable(4), value("in(obj22, tru1)", true)).
postcondition(action(("unload-truck", "obj22", "tru1", "apt1")), effect(unconditional), variable(4), value("at(obj22, apt1)", true)).
costs(action(("unload-truck", "obj22", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj22", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj22", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj22", "tru1", "pos1")), variable(4), value("in(obj22, tru1)", true)).
postcondition(action(("unload-truck", "obj22", "tru1", "pos1")), effect(unconditional), variable(4), value("at(obj22, pos1)", true)).
costs(action(("unload-truck", "obj22", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj22", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj22", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj22", "tru2", "apt2")), variable(4), value("in(obj22, tru2)", true)).
postcondition(action(("unload-truck", "obj22", "tru2", "apt2")), effect(unconditional), variable(4), value("at(obj22, apt2)", true)).
costs(action(("unload-truck", "obj22", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj22", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj22", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj22", "tru2", "pos2")), variable(4), value("in(obj22, tru2)", true)).
postcondition(action(("unload-truck", "obj22", "tru2", "pos2")), effect(unconditional), variable(4), value("at(obj22, pos2)", true)).
costs(action(("unload-truck", "obj22", "tru2", "pos2")), 1).

action(action(("unload-truck", "obj23", "tru1", "apt1"))).
precondition(action(("unload-truck", "obj23", "tru1", "apt1")), variable(1), value("at(tru1, apt1)", true)).
precondition(action(("unload-truck", "obj23", "tru1", "apt1")), variable(3), value("in(obj23, tru1)", true)).
postcondition(action(("unload-truck", "obj23", "tru1", "apt1")), effect(unconditional), variable(3), value("at(obj23, apt1)", true)).
costs(action(("unload-truck", "obj23", "tru1", "apt1")), 1).

action(action(("unload-truck", "obj23", "tru1", "pos1"))).
precondition(action(("unload-truck", "obj23", "tru1", "pos1")), variable(1), value("at(tru1, pos1)", true)).
precondition(action(("unload-truck", "obj23", "tru1", "pos1")), variable(3), value("in(obj23, tru1)", true)).
postcondition(action(("unload-truck", "obj23", "tru1", "pos1")), effect(unconditional), variable(3), value("at(obj23, pos1)", true)).
costs(action(("unload-truck", "obj23", "tru1", "pos1")), 1).

action(action(("unload-truck", "obj23", "tru2", "apt2"))).
precondition(action(("unload-truck", "obj23", "tru2", "apt2")), variable(0), value("at(tru2, apt2)", true)).
precondition(action(("unload-truck", "obj23", "tru2", "apt2")), variable(3), value("in(obj23, tru2)", true)).
postcondition(action(("unload-truck", "obj23", "tru2", "apt2")), effect(unconditional), variable(3), value("at(obj23, apt2)", true)).
costs(action(("unload-truck", "obj23", "tru2", "apt2")), 1).

action(action(("unload-truck", "obj23", "tru2", "pos2"))).
precondition(action(("unload-truck", "obj23", "tru2", "pos2")), variable(0), value("at(tru2, pos2)", true)).
precondition(action(("unload-truck", "obj23", "tru2", "pos2")), variable(3), value("in(obj23, tru2)", true)).
postcondition(action(("unload-truck", "obj23", "tru2", "pos2")), effect(unconditional), variable(3), value("at(obj23, pos2)", true)).
costs(action(("unload-truck", "obj23", "tru2", "pos2")), 1).

% initial state
initialState(variable(0), value("at(tru2, pos2)", true)).
initialState(variable(1), value("at(tru1, pos1)", true)).
initialState(variable(2), value("at(apn1, apt2)", true)).
initialState(variable(3), value("at(obj23, pos2)", true)).
initialState(variable(4), value("at(obj22, pos2)", true)).
initialState(variable(5), value("at(obj21, pos2)", true)).
initialState(variable(6), value("at(obj13, pos1)", true)).
initialState(variable(7), value("at(obj12, pos1)", true)).
initialState(variable(8), value("at(obj11, pos1)", true)).

% goal
goal(variable(3), value("at(obj23, pos1)", true)).
goal(variable(5), value("at(obj21, pos1)", true)).
goal(variable(6), value("at(obj13, apt1)", true)).
goal(variable(8), value("at(obj11, apt1)", true)).
