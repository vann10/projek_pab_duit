// login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class DigitPressed extends LoginEvent {
  final int digit;

  const DigitPressed(this.digit);

  @override
  List<Object> get props => [digit];
}

class BackspacePressed extends LoginEvent {}

class ResetPin extends LoginEvent {}

class TogglePinVisibility extends LoginEvent {}

class ValidatePin extends LoginEvent {}

// States
class LoginState extends Equatable {
  final String enteredPin;
  final bool isPinVisible;
  final bool isPinWrong;
  final bool isLoading;

  const LoginState({
    this.enteredPin = '',
    this.isPinVisible = false,
    this.isPinWrong = false,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? enteredPin,
    bool? isPinVisible,
    bool? isPinWrong,
    bool? isLoading,
  }) {
    return LoginState(
      enteredPin: enteredPin ?? this.enteredPin,
      isPinVisible: isPinVisible ?? this.isPinVisible,
      isPinWrong: isPinWrong ?? this.isPinWrong,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [enteredPin, isPinVisible, isPinWrong, isLoading];
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static const String correctPin = '1234';

  LoginBloc() : super(const LoginState()) {
    on<DigitPressed>(_onDigitPressed);
    on<BackspacePressed>(_onBackspacePressed);
    on<ResetPin>(_onResetPin);
    on<TogglePinVisibility>(_onTogglePinVisibility);
    on<ValidatePin>(_onValidatePin);
  }

  void _onDigitPressed(DigitPressed event, Emitter<LoginState> emit) {
    if (state.enteredPin.length < 4) {
      final newPin = state.enteredPin + event.digit.toString();
      emit(state.copyWith(enteredPin: newPin, isPinWrong: false));

      if (newPin.length == 4) {
        add(ValidatePin());
      }
    }
  }

  void _onBackspacePressed(BackspacePressed event, Emitter<LoginState> emit) {
    if (state.enteredPin.isNotEmpty) {
      emit(
        state.copyWith(
          enteredPin: state.enteredPin.substring(
            0,
            state.enteredPin.length - 1,
          ),
          isPinWrong: false,
        ),
      );
    }
  }

  void _onResetPin(ResetPin event, Emitter<LoginState> emit) {
    emit(state.copyWith(enteredPin: '', isPinWrong: false));
  }

  void _onTogglePinVisibility(
    TogglePinVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPinVisible: !state.isPinVisible));
  }

  Future<void> _onValidatePin(
    ValidatePin event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(milliseconds: 300));

    if (state.enteredPin == correctPin) {
      emit(state.copyWith(isPinWrong: false, isLoading: false));
      // Navigation akan ditangani di UI
    } else {
      emit(state.copyWith(isPinWrong: true, isLoading: false));

      // Reset PIN setelah delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(enteredPin: '', isPinWrong: false));
    }
  }
}
