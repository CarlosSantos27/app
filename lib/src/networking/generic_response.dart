class GenericResponse<T> {
  T data;
  String message;
  int errorStatus;
  GenericResponseStatus status;

  GenericResponse.error(this.message, this.errorStatus)
      : status = GenericResponseStatus.ERROR;
  GenericResponse.completed(this.data)
      : status = GenericResponseStatus.COMPLETED;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum GenericResponseStatus { COMPLETED, ERROR }
