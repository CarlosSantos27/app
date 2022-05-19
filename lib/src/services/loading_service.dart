import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class LoadingService {
  final _showErrorMesagge$ = BehaviorSubject<String>();
  final _showLoading$ = BehaviorSubject<bool>.seeded(false);

  LoadingService();

  Stream<bool> get showLoading$ => _showLoading$;
  Stream<String> get showErrorMesagge$ => _showErrorMesagge$;

  void showLoadingScreen() {
    _showLoading$.sink.add(true);
  }

  void hideLoadingScreen() {
    if (_showLoading$.value) _showLoading$.sink.add(false);
  }

  void showErrorSnackbar(String errorMessage) {
    if(!(Get.isSnackbarOpen ?? false)){
      _showErrorMesagge$.sink.add(errorMessage);
    }
  }

  dispose() {
    _showLoading$.close();
    _showErrorMesagge$.close();
  }
}
