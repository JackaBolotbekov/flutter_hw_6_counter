import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

/// Бизнес-логика счётчика.
/// Хранит текущее значение в состоянии и управляет таймером авто-инкремента.
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterIdle(0));

  Timer? _autoTimer;

  // +1 / -1 обычные
  void increment() => emit(CounterIdle(state.value + 1));
  void decrement() => emit(CounterIdle(state.value - 1));

  /// Запустить авто-инкремент во время удержания
  void startAutoIncrement([Duration interval = const Duration(milliseconds: 80)]) {
    _autoTimer?.cancel();
    emit(CounterAuto(state.value)); // пометим, что сейчас режим hold
    _autoTimer = Timer.periodic(interval, (_) {
      emit(CounterAuto(state.value + 1));
    });
  }

  /// Остановить авто-инкремент (кнопку отпустили)
  void stopAutoIncrement() {
    _autoTimer?.cancel();
    _autoTimer = null;
    emit(CounterIdle(state.value));
  }

  @override
  Future<void> close() {
    _autoTimer?.cancel();
    return super.close();
  }
}
