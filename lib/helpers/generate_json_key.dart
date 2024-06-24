String generateJsonKey(String path, int id, {bool usePath = false}) => usePath
    ? '${path.split('/')[path.split('/').length - 1].split('.').first}_$id'
    : '${path.split('/').last.split('.').first}_$id';
