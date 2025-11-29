bool isLengthLessThan(String? value, int limit) {
  if (value == null) return true;
  return value.length < limit;
}
