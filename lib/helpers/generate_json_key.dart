String generateJsonKey(String path, int id, {bool usePath = false}) {
  String filename = path.split('/').last.split('.').first;
  if (usePath) {
    List<String> splits = path.split('/');
    String directory = splits[splits.length - 2];
    return '${directory}_$filename';
  } else {
    return '${filename}_$id';
  }
}
