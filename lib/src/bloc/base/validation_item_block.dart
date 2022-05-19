import 'dart:async';
import 'package:rxdart/rxdart.dart';

class ValidationItemBloc<T> {
  final _subject$ = BehaviorSubject<T>();
  final List<ValidatorError> validators;
  final StreamTransformer streamTransformer;

  // STREAMS
  Stream<T> get itemStream => _subject$.stream.transform(streamTransformer);

  // SINKS
  Function(T) get addDataToStream => _subject$.sink.add;

  // RAW VALUE
  T get rawValue => _subject$.value;

  // RAW VALUE
  BehaviorSubject<T> get subject$ => _subject$;

  ValidationItemBloc({this.validators})
      : streamTransformer =
            StreamTransformer<T, T>.fromHandlers(handleData: (inputData, sink) {
          if (validators != null && validators.length > 0) {
            bool addToSink = true;
            String errorMessage;
            for (var i = 0; i < validators.length; i++) {
              if (!validators[i].validatorFunction(inputData)) {
                addToSink = false;
                errorMessage = validators[i].errorMessage;
                break;
              }
            }
            if (addToSink) {
              sink.add(inputData);
            } else {
              sink.add(null);
              sink.addError(errorMessage);
            }
          } else {
            sink.add(inputData);
          }
        });

  dispose() {
    _subject$.close();
  }
}

class ValidatorError {
  bool isAsync;
  String errorMessage;
  Function validatorFunction;

  ValidatorError(String errorMessage, Function validatorFunction) {
    this.isAsync = isAsync;
    this.errorMessage = errorMessage;
    this.validatorFunction = validatorFunction;
  }
}
