///Merges [n] of maps into one map.
///
///```
/// Map<String, dynamic> map1 = {
///   "name": "Ahmed",
/// };
/// Map<String, dynamic> map2 = {
///   "job": "Software Engineeer",
///   "address": "Alex, Egypt",
/// };
///
/// Map compined = mergeMaps([map1, map2])
///
/// compined = {
///   "name": "Ahmed",
///   "job": "Software Engineeer",
///   "address": "Alex, Egypt",
/// }
/// ```
Map<K, V> mergeMaps<K, V>(List<Map<K, V>> maps) {
  final compinedMap = {
    for (var map in maps) ...map,
  };
  return compinedMap;
}
