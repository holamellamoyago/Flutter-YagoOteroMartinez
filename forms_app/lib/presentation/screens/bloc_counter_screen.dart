import 'package:flutter/material.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cubit counter'),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.refresh_rounded)),
        ],
      ),

      body: Center(child: const Text('Counter value: XX')),
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            onPressed: () => {},
            heroTag: '1', // Indica cual es el que se ánima entre scaffolds
            child: Text('+3'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => {},
            heroTag: '2',
            child: Text('+2'), // Indica cual es el que se ánima entre scaffolds
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => {},
            heroTag: '3',
            child: Text('+1'), // Indica cual es el que se ánima entre scaffolds
          ),
        ],
      ),
    );
  }
}
