import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncreased>(_onCounterIncreased);
    on<CounterReseat>(_onCounterReset);
  }

  void _onCounterIncreased(CounterIncreased event, Emitter<CounterState> emit) {
    emit(
      state.copyWith(state.counter + event.value, state.transactionCounter + 1),
    );
  }

  void _onCounterReset(CounterReseat event, Emitter<CounterState> emit) {
    emit(state.copyWith(0, state.transactionCounter));
  }

  void increaseBy([int value = 1]) {
    add(CounterIncreased(value));
  }
}
