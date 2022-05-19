import 'dart:async';

class Validators {
  final emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email no es correcto');
    }
  });

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 5) {
      sink.add(password);
    } else {
      sink.addError('Contraseña necesita más de 5 caracteres.');
    }
  });

  //number minStringlength,
  final stringLengthValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (inputText, sink) {
      if (inputText.length >= 6) {
        sink.add(inputText);
      } else {
        sink.addError('Input necesita más de 6 caracteres.');
      }
    },
    handleError:
        (Object error, StackTrace stackTrace, EventSink<String> sink) =>
            print('ERROR EN LA VALIDACION'),
  );

  static bool stringLengthValidators<String>(inputString, int minSize) {
    return inputString.length >= minSize;
  }

  static bool stringsEquals(String inputString, String secondeString) {
    return inputString == secondeString;
  }

  static Function minLength(int minSize) {
    return (String inputString) {
      return inputString.length >= minSize;
    };
  }

  static bool emailValidatorFunc<String>(email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(email);
  }

  static bool accept<T>(bool data) {
    return data ? true : false;
  }

  static bool exist<T>(data) => data != null && data.toString().length > 0;
}
