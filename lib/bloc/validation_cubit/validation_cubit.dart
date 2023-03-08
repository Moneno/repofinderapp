import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValidationCubit extends Cubit<ValidationCubitState> {
  ValidationCubit() : super(const ValidationCubitState());

  void onChanged(String value) =>
      emit(state.copyWith(isValid: value.length > 3, value: value));
}

class ValidationCubitState extends Equatable {
  const ValidationCubitState({this.isValid = false, this.value = ""});

  final bool isValid;
  final String value;

  ValidationCubitState copyWith({bool? isValid, String? value}) =>
      ValidationCubitState(
        isValid: isValid ?? this.isValid,
        value: value ?? this.value,
      );

  @override
  List<Object> get props => [isValid, value];
}
