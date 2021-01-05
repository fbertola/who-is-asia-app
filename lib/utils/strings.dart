
String cleanClassificationLabel(String sentence) {
  return sentence.replaceAll(new RegExp('[\\W_\\d]+'), ' ').trim();
}
