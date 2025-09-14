import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_cubit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CounterCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Счётчик + Cubit')),
      body: SafeArea(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (_, s) => Text(
                '${s.value}',
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 24),

            const SizedBox(height: 12),

            // Кнопка "+": tap = +1; удержание = авто-инкремент
            BlocBuilder<CounterCubit, CounterState>(
              buildWhen: (p, n) => p.runtimeType != n.runtimeType, // перерисовать цвет только при смене режима
              builder: (context, s) {
                final isAuto = s is CounterAuto;
                return GestureDetector(
                  onTap: cubit.increment, // короткое нажатие
                  onLongPressStart: (_) => cubit.startAutoIncrement(), // удержание — старт таймера
                  onLongPressEnd:   (_) => cubit.stopAutoIncrement(),  // отпустил — стоп
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    decoration: BoxDecoration(
                      color: isAuto ? Colors.orange.shade700 : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 28, color: Colors.white)),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
