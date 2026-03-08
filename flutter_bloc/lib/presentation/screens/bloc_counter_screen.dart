import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/counter_bloc/counter_bloc.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const BlocCounterView(),
    );
  }
}

class BlocCounterView extends StatelessWidget {
  const BlocCounterView({super.key});

  void increseCounterBy(BuildContext context, [int value = 1]) {
    context.read<CounterBloc>().add(CounterIncreased(value));
  }

  void resetCounter(BuildContext context) {
    context.read<CounterBloc>().add(const CounterReseat());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (CounterBloc counterBloc) =>
              Text('Cubit counter: ${counterBloc.state.transactionCounter}'),
        ),
        actions: [
          IconButton(
            onPressed: () => resetCounter(context),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Center(
        child: context.select(
          (CounterBloc counterBloc) =>
              Text('Counter Bloc: ${counterBloc.state.counter}'),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => increseCounterBy(context, 3),
            heroTag: '1', // Indica cual es el que se ánima entre scaffolds
            child: const Text('+3'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => increseCounterBy(context, 2),
            heroTag: '2',
            child: const Text(
              '+2',
            ), // Indica cual es el que se ánima entre scaffolds
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => increseCounterBy(context),
            heroTag: '3',
            child: const Text(
              '+1',
            ), // Indica cual es el que se ánima entre scaffolds
          ),
        ],
      ),
    );
  }
}
