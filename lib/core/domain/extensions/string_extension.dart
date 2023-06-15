//

extension StringImprover on String {
  String removePlus() {
    return replaceAll('+', '');
  }

  String removeX() {
    return replaceAll('x', '').replaceAll('X', '');
  }

  bool containX() {
    return contains('x') || contains('X');
  }

  String removePrackets() {
    return replaceAll('[', '').replaceAll(']', '');
  }

  String removeQuotation() {
    return replaceAll('"', '');
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
