import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_cubit/counter_cubit.dart';

class CubitCounterScreen extends StatelessWidget {
  const CubitCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: const _CubitCounterView(),
    );
  }
}

class _CubitCounterView extends StatelessWidget {
  const _CubitCounterView();

  @override
  Widget build(BuildContext context) {
    final counterCubit = context.watch<CounterCubit>();
    final counterState = counterCubit.state;

    return Scaffold(
      appBar: AppBar(
        title: context.select((CounterCubit counter) {
          return Text('Cubit trans counter: ${counter.state.transactionCount}');
        }),
        // title: Text('Cubit counter ${counterState.transactionCount}'),
        actions: [
          IconButton(
            onPressed: () => counterCubit.reset(),
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, CounterState>(
          builder: (context, state) {
            return Text('Counter value: ${state.counter}');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => counterCubit.increaseBy(3),
            heroTag: '1', // Indica cual es el que se ánima entre scaffolds
            child: Text('+3'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => counterCubit.increaseBy(2),
            heroTag: '2',
            child: Text('+2'), // Indica cual es el que se ánima entre scaffolds
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => counterCubit.increaseBy(1),
            heroTag: '3',
            child: Text('+1'), // Indica cual es el que se ánima entre scaffolds
          ),
        ],
      ),
    );
  }
}
