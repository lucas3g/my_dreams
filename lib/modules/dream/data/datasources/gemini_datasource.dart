abstract class GeminiDatasource {
  Future<String> getMeaning(String dreamText);

  Future<String> createImage(String dreamText);
}
