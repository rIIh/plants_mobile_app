List<T> insertBetween<T>(T object, List<T> target) {
  var result = [...target];
  if (result.length > 1) {
    for (var i = result.length - 1; i > 0 ; i--) {
      result.insert(i, object);
    }
  }
  return result;
}