part of 'counter_cubit.dart';

@immutable
sealed class CounterState {
  final int value;
  const CounterState(this.value);
}

/// Обычный режим (нет удержания)
final class CounterIdle extends CounterState {
  const CounterIdle(int value) : super(value);
}

/// Идёт удержание: таймер тикает
final class CounterAuto extends CounterState {
  const CounterAuto(int value) : super(value);
}
