class GenericPaged<T> {
  int pageCount;
  List<T> data;

  GenericPaged({
    this.pageCount,
    this.data,
  });
}
