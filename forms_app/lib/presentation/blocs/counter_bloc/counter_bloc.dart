import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncreased>((event, emit) {
      emit(
        state.copyWith(
          state.counter + event.value,
          state.transactionCounter + 1,
        ),
      );
    });
  }
}
