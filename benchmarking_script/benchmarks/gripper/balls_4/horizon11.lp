#const horizon=11.

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
contains(variable(0), value("at-robby(rooma)", true)).
contains(variable(0), value("at-robby(roomb)", true)).

variable(variable(1)).
contains(variable(1), value("carry(ball1, left)", true)).
contains(variable(1), value("carry(ball2, left)", true)).
contains(variable(1), value("carry(ball3, left)", true)).
contains(variable(1), value("carry(ball4, left)", true)).
contains(variable(1), value("free(left)", true)).

variable(variable(2)).
contains(variable(2), value("carry(ball1, right)", true)).
contains(variable(2), value("carry(ball2, right)", true)).
contains(variable(2), value("carry(ball3, right)", true)).
contains(variable(2), value("carry(ball4, right)", true)).
contains(variable(2), value("free(right)", true)).

variable(variable(3)).
contains(variable(3), value("at(ball1, rooma)", true)).
contains(variable(3), value("at(ball1, roomb)", true)).
contains(variable(3), value(none)).

variable(variable(4)).
contains(variable(4), value("at(ball2, rooma)", true)).
contains(variable(4), value("at(ball2, roomb)", true)).
contains(variable(4), value(none)).

variable(variable(5)).
contains(variable(5), value("at(ball3, rooma)", true)).
contains(variable(5), value("at(ball3, roomb)", true)).
contains(variable(5), value(none)).

variable(variable(6)).
contains(variable(6), value("at(ball4, rooma)", true)).
contains(variable(6), value("at(ball4, roomb)", true)).
contains(variable(6), value(none)).

% actions
action(action(("drop", "ball1", "rooma", "left"))).
precondition(action(("drop", "ball1", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball1", "rooma", "left")), variable(1), value("carry(ball1, left)", true)).
postcondition(action(("drop", "ball1", "rooma", "left")), effect(unconditional), variable(3), value("at(ball1, rooma)", true)).
postcondition(action(("drop", "ball1", "rooma", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball1", "rooma", "left")), 1).

action(action(("drop", "ball1", "rooma", "right"))).
precondition(action(("drop", "ball1", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball1", "rooma", "right")), variable(2), value("carry(ball1, right)", true)).
postcondition(action(("drop", "ball1", "rooma", "right")), effect(unconditional), variable(3), value("at(ball1, rooma)", true)).
postcondition(action(("drop", "ball1", "rooma", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball1", "rooma", "right")), 1).

action(action(("drop", "ball1", "roomb", "left"))).
precondition(action(("drop", "ball1", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball1", "roomb", "left")), variable(1), value("carry(ball1, left)", true)).
postcondition(action(("drop", "ball1", "roomb", "left")), effect(unconditional), variable(3), value("at(ball1, roomb)", true)).
postcondition(action(("drop", "ball1", "roomb", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball1", "roomb", "left")), 1).

action(action(("drop", "ball1", "roomb", "right"))).
precondition(action(("drop", "ball1", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball1", "roomb", "right")), variable(2), value("carry(ball1, right)", true)).
postcondition(action(("drop", "ball1", "roomb", "right")), effect(unconditional), variable(3), value("at(ball1, roomb)", true)).
postcondition(action(("drop", "ball1", "roomb", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball1", "roomb", "right")), 1).

action(action(("drop", "ball2", "rooma", "left"))).
precondition(action(("drop", "ball2", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball2", "rooma", "left")), variable(1), value("carry(ball2, left)", true)).
postcondition(action(("drop", "ball2", "rooma", "left")), effect(unconditional), variable(4), value("at(ball2, rooma)", true)).
postcondition(action(("drop", "ball2", "rooma", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball2", "rooma", "left")), 1).

action(action(("drop", "ball2", "rooma", "right"))).
precondition(action(("drop", "ball2", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball2", "rooma", "right")), variable(2), value("carry(ball2, right)", true)).
postcondition(action(("drop", "ball2", "rooma", "right")), effect(unconditional), variable(4), value("at(ball2, rooma)", true)).
postcondition(action(("drop", "ball2", "rooma", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball2", "rooma", "right")), 1).

action(action(("drop", "ball2", "roomb", "left"))).
precondition(action(("drop", "ball2", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball2", "roomb", "left")), variable(1), value("carry(ball2, left)", true)).
postcondition(action(("drop", "ball2", "roomb", "left")), effect(unconditional), variable(4), value("at(ball2, roomb)", true)).
postcondition(action(("drop", "ball2", "roomb", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball2", "roomb", "left")), 1).

action(action(("drop", "ball2", "roomb", "right"))).
precondition(action(("drop", "ball2", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball2", "roomb", "right")), variable(2), value("carry(ball2, right)", true)).
postcondition(action(("drop", "ball2", "roomb", "right")), effect(unconditional), variable(4), value("at(ball2, roomb)", true)).
postcondition(action(("drop", "ball2", "roomb", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball2", "roomb", "right")), 1).

action(action(("drop", "ball3", "rooma", "left"))).
precondition(action(("drop", "ball3", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball3", "rooma", "left")), variable(1), value("carry(ball3, left)", true)).
postcondition(action(("drop", "ball3", "rooma", "left")), effect(unconditional), variable(5), value("at(ball3, rooma)", true)).
postcondition(action(("drop", "ball3", "rooma", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball3", "rooma", "left")), 1).

action(action(("drop", "ball3", "rooma", "right"))).
precondition(action(("drop", "ball3", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball3", "rooma", "right")), variable(2), value("carry(ball3, right)", true)).
postcondition(action(("drop", "ball3", "rooma", "right")), effect(unconditional), variable(5), value("at(ball3, rooma)", true)).
postcondition(action(("drop", "ball3", "rooma", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball3", "rooma", "right")), 1).

action(action(("drop", "ball3", "roomb", "left"))).
precondition(action(("drop", "ball3", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball3", "roomb", "left")), variable(1), value("carry(ball3, left)", true)).
postcondition(action(("drop", "ball3", "roomb", "left")), effect(unconditional), variable(5), value("at(ball3, roomb)", true)).
postcondition(action(("drop", "ball3", "roomb", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball3", "roomb", "left")), 1).

action(action(("drop", "ball3", "roomb", "right"))).
precondition(action(("drop", "ball3", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball3", "roomb", "right")), variable(2), value("carry(ball3, right)", true)).
postcondition(action(("drop", "ball3", "roomb", "right")), effect(unconditional), variable(5), value("at(ball3, roomb)", true)).
postcondition(action(("drop", "ball3", "roomb", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball3", "roomb", "right")), 1).

action(action(("drop", "ball4", "rooma", "left"))).
precondition(action(("drop", "ball4", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball4", "rooma", "left")), variable(1), value("carry(ball4, left)", true)).
postcondition(action(("drop", "ball4", "rooma", "left")), effect(unconditional), variable(6), value("at(ball4, rooma)", true)).
postcondition(action(("drop", "ball4", "rooma", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball4", "rooma", "left")), 1).

action(action(("drop", "ball4", "rooma", "right"))).
precondition(action(("drop", "ball4", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("drop", "ball4", "rooma", "right")), variable(2), value("carry(ball4, right)", true)).
postcondition(action(("drop", "ball4", "rooma", "right")), effect(unconditional), variable(6), value("at(ball4, rooma)", true)).
postcondition(action(("drop", "ball4", "rooma", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball4", "rooma", "right")), 1).

action(action(("drop", "ball4", "roomb", "left"))).
precondition(action(("drop", "ball4", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball4", "roomb", "left")), variable(1), value("carry(ball4, left)", true)).
postcondition(action(("drop", "ball4", "roomb", "left")), effect(unconditional), variable(6), value("at(ball4, roomb)", true)).
postcondition(action(("drop", "ball4", "roomb", "left")), effect(unconditional), variable(1), value("free(left)", true)).
costs(action(("drop", "ball4", "roomb", "left")), 1).

action(action(("drop", "ball4", "roomb", "right"))).
precondition(action(("drop", "ball4", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("drop", "ball4", "roomb", "right")), variable(2), value("carry(ball4, right)", true)).
postcondition(action(("drop", "ball4", "roomb", "right")), effect(unconditional), variable(6), value("at(ball4, roomb)", true)).
postcondition(action(("drop", "ball4", "roomb", "right")), effect(unconditional), variable(2), value("free(right)", true)).
costs(action(("drop", "ball4", "roomb", "right")), 1).

action(action(("move", "rooma", "roomb"))).
precondition(action(("move", "rooma", "roomb")), variable(0), value("at-robby(rooma)", true)).
postcondition(action(("move", "rooma", "roomb")), effect(unconditional), variable(0), value("at-robby(roomb)", true)).
costs(action(("move", "rooma", "roomb")), 1).

action(action(("move", "roomb", "rooma"))).
precondition(action(("move", "roomb", "rooma")), variable(0), value("at-robby(roomb)", true)).
postcondition(action(("move", "roomb", "rooma")), effect(unconditional), variable(0), value("at-robby(rooma)", true)).
costs(action(("move", "roomb", "rooma")), 1).

action(action(("pick", "ball1", "rooma", "left"))).
precondition(action(("pick", "ball1", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball1", "rooma", "left")), variable(3), value("at(ball1, rooma)", true)).
precondition(action(("pick", "ball1", "rooma", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball1", "rooma", "left")), effect(unconditional), variable(3), value(none)).
postcondition(action(("pick", "ball1", "rooma", "left")), effect(unconditional), variable(1), value("carry(ball1, left)", true)).
costs(action(("pick", "ball1", "rooma", "left")), 1).

action(action(("pick", "ball1", "rooma", "right"))).
precondition(action(("pick", "ball1", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball1", "rooma", "right")), variable(3), value("at(ball1, rooma)", true)).
precondition(action(("pick", "ball1", "rooma", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball1", "rooma", "right")), effect(unconditional), variable(3), value(none)).
postcondition(action(("pick", "ball1", "rooma", "right")), effect(unconditional), variable(2), value("carry(ball1, right)", true)).
costs(action(("pick", "ball1", "rooma", "right")), 1).

action(action(("pick", "ball1", "roomb", "left"))).
precondition(action(("pick", "ball1", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball1", "roomb", "left")), variable(3), value("at(ball1, roomb)", true)).
precondition(action(("pick", "ball1", "roomb", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball1", "roomb", "left")), effect(unconditional), variable(3), value(none)).
postcondition(action(("pick", "ball1", "roomb", "left")), effect(unconditional), variable(1), value("carry(ball1, left)", true)).
costs(action(("pick", "ball1", "roomb", "left")), 1).

action(action(("pick", "ball1", "roomb", "right"))).
precondition(action(("pick", "ball1", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball1", "roomb", "right")), variable(3), value("at(ball1, roomb)", true)).
precondition(action(("pick", "ball1", "roomb", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball1", "roomb", "right")), effect(unconditional), variable(3), value(none)).
postcondition(action(("pick", "ball1", "roomb", "right")), effect(unconditional), variable(2), value("carry(ball1, right)", true)).
costs(action(("pick", "ball1", "roomb", "right")), 1).

action(action(("pick", "ball2", "rooma", "left"))).
precondition(action(("pick", "ball2", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball2", "rooma", "left")), variable(4), value("at(ball2, rooma)", true)).
precondition(action(("pick", "ball2", "rooma", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball2", "rooma", "left")), effect(unconditional), variable(4), value(none)).
postcondition(action(("pick", "ball2", "rooma", "left")), effect(unconditional), variable(1), value("carry(ball2, left)", true)).
costs(action(("pick", "ball2", "rooma", "left")), 1).

action(action(("pick", "ball2", "rooma", "right"))).
precondition(action(("pick", "ball2", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball2", "rooma", "right")), variable(4), value("at(ball2, rooma)", true)).
precondition(action(("pick", "ball2", "rooma", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball2", "rooma", "right")), effect(unconditional), variable(4), value(none)).
postcondition(action(("pick", "ball2", "rooma", "right")), effect(unconditional), variable(2), value("carry(ball2, right)", true)).
costs(action(("pick", "ball2", "rooma", "right")), 1).

action(action(("pick", "ball2", "roomb", "left"))).
precondition(action(("pick", "ball2", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball2", "roomb", "left")), variable(4), value("at(ball2, roomb)", true)).
precondition(action(("pick", "ball2", "roomb", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball2", "roomb", "left")), effect(unconditional), variable(4), value(none)).
postcondition(action(("pick", "ball2", "roomb", "left")), effect(unconditional), variable(1), value("carry(ball2, left)", true)).
costs(action(("pick", "ball2", "roomb", "left")), 1).

action(action(("pick", "ball2", "roomb", "right"))).
precondition(action(("pick", "ball2", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball2", "roomb", "right")), variable(4), value("at(ball2, roomb)", true)).
precondition(action(("pick", "ball2", "roomb", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball2", "roomb", "right")), effect(unconditional), variable(4), value(none)).
postcondition(action(("pick", "ball2", "roomb", "right")), effect(unconditional), variable(2), value("carry(ball2, right)", true)).
costs(action(("pick", "ball2", "roomb", "right")), 1).

action(action(("pick", "ball3", "rooma", "left"))).
precondition(action(("pick", "ball3", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball3", "rooma", "left")), variable(5), value("at(ball3, rooma)", true)).
precondition(action(("pick", "ball3", "rooma", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball3", "rooma", "left")), effect(unconditional), variable(5), value(none)).
postcondition(action(("pick", "ball3", "rooma", "left")), effect(unconditional), variable(1), value("carry(ball3, left)", true)).
costs(action(("pick", "ball3", "rooma", "left")), 1).

action(action(("pick", "ball3", "rooma", "right"))).
precondition(action(("pick", "ball3", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball3", "rooma", "right")), variable(5), value("at(ball3, rooma)", true)).
precondition(action(("pick", "ball3", "rooma", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball3", "rooma", "right")), effect(unconditional), variable(5), value(none)).
postcondition(action(("pick", "ball3", "rooma", "right")), effect(unconditional), variable(2), value("carry(ball3, right)", true)).
costs(action(("pick", "ball3", "rooma", "right")), 1).

action(action(("pick", "ball3", "roomb", "left"))).
precondition(action(("pick", "ball3", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball3", "roomb", "left")), variable(5), value("at(ball3, roomb)", true)).
precondition(action(("pick", "ball3", "roomb", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball3", "roomb", "left")), effect(unconditional), variable(5), value(none)).
postcondition(action(("pick", "ball3", "roomb", "left")), effect(unconditional), variable(1), value("carry(ball3, left)", true)).
costs(action(("pick", "ball3", "roomb", "left")), 1).

action(action(("pick", "ball3", "roomb", "right"))).
precondition(action(("pick", "ball3", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball3", "roomb", "right")), variable(5), value("at(ball3, roomb)", true)).
precondition(action(("pick", "ball3", "roomb", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball3", "roomb", "right")), effect(unconditional), variable(5), value(none)).
postcondition(action(("pick", "ball3", "roomb", "right")), effect(unconditional), variable(2), value("carry(ball3, right)", true)).
costs(action(("pick", "ball3", "roomb", "right")), 1).

action(action(("pick", "ball4", "rooma", "left"))).
precondition(action(("pick", "ball4", "rooma", "left")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball4", "rooma", "left")), variable(6), value("at(ball4, rooma)", true)).
precondition(action(("pick", "ball4", "rooma", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball4", "rooma", "left")), effect(unconditional), variable(6), value(none)).
postcondition(action(("pick", "ball4", "rooma", "left")), effect(unconditional), variable(1), value("carry(ball4, left)", true)).
costs(action(("pick", "ball4", "rooma", "left")), 1).

action(action(("pick", "ball4", "rooma", "right"))).
precondition(action(("pick", "ball4", "rooma", "right")), variable(0), value("at-robby(rooma)", true)).
precondition(action(("pick", "ball4", "rooma", "right")), variable(6), value("at(ball4, rooma)", true)).
precondition(action(("pick", "ball4", "rooma", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball4", "rooma", "right")), effect(unconditional), variable(6), value(none)).
postcondition(action(("pick", "ball4", "rooma", "right")), effect(unconditional), variable(2), value("carry(ball4, right)", true)).
costs(action(("pick", "ball4", "rooma", "right")), 1).

action(action(("pick", "ball4", "roomb", "left"))).
precondition(action(("pick", "ball4", "roomb", "left")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball4", "roomb", "left")), variable(6), value("at(ball4, roomb)", true)).
precondition(action(("pick", "ball4", "roomb", "left")), variable(1), value("free(left)", true)).
postcondition(action(("pick", "ball4", "roomb", "left")), effect(unconditional), variable(6), value(none)).
postcondition(action(("pick", "ball4", "roomb", "left")), effect(unconditional), variable(1), value("carry(ball4, left)", true)).
costs(action(("pick", "ball4", "roomb", "left")), 1).

action(action(("pick", "ball4", "roomb", "right"))).
precondition(action(("pick", "ball4", "roomb", "right")), variable(0), value("at-robby(roomb)", true)).
precondition(action(("pick", "ball4", "roomb", "right")), variable(6), value("at(ball4, roomb)", true)).
precondition(action(("pick", "ball4", "roomb", "right")), variable(2), value("free(right)", true)).
postcondition(action(("pick", "ball4", "roomb", "right")), effect(unconditional), variable(6), value(none)).
postcondition(action(("pick", "ball4", "roomb", "right")), effect(unconditional), variable(2), value("carry(ball4, right)", true)).
costs(action(("pick", "ball4", "roomb", "right")), 1).

% mutex groups
mutexGroup(mutexGroup(0)).
contains(mutexGroup(0), variable(3), value("at(ball1, rooma)", true)).
contains(mutexGroup(0), variable(3), value("at(ball1, roomb)", true)).
contains(mutexGroup(0), variable(1), value("carry(ball1, left)", true)).
contains(mutexGroup(0), variable(2), value("carry(ball1, right)", true)).

mutexGroup(mutexGroup(1)).
contains(mutexGroup(1), variable(4), value("at(ball2, rooma)", true)).
contains(mutexGroup(1), variable(4), value("at(ball2, roomb)", true)).
contains(mutexGroup(1), variable(1), value("carry(ball2, left)", true)).
contains(mutexGroup(1), variable(2), value("carry(ball2, right)", true)).

mutexGroup(mutexGroup(2)).
contains(mutexGroup(2), variable(5), value("at(ball3, rooma)", true)).
contains(mutexGroup(2), variable(5), value("at(ball3, roomb)", true)).
contains(mutexGroup(2), variable(1), value("carry(ball3, left)", true)).
contains(mutexGroup(2), variable(2), value("carry(ball3, right)", true)).

mutexGroup(mutexGroup(3)).
contains(mutexGroup(3), variable(6), value("at(ball4, rooma)", true)).
contains(mutexGroup(3), variable(6), value("at(ball4, roomb)", true)).
contains(mutexGroup(3), variable(1), value("carry(ball4, left)", true)).
contains(mutexGroup(3), variable(2), value("carry(ball4, right)", true)).

% initial state
initialState(variable(0), value("at-robby(rooma)", true)).
initialState(variable(1), value("free(left)", true)).
initialState(variable(2), value("free(right)", true)).
initialState(variable(3), value("at(ball1, rooma)", true)).
initialState(variable(4), value("at(ball2, rooma)", true)).
initialState(variable(5), value("at(ball3, rooma)", true)).
initialState(variable(6), value("at(ball4, rooma)", true)).

% goal
goal(variable(3), value("at(ball1, roomb)", true)).
goal(variable(4), value("at(ball2, roomb)", true)).
goal(variable(5), value("at(ball3, roomb)", true)).
goal(variable(6), value("at(ball4, roomb)", true)).
