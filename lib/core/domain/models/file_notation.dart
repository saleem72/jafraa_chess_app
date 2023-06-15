//

enum FileNotation {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h;

  String get label {
    switch (this) {
      case FileNotation.a:
        return 'A';
      case FileNotation.b:
        return 'B';
      case FileNotation.c:
        return 'C';
      case FileNotation.d:
        return 'D';
      case FileNotation.e:
        return 'E';
      case FileNotation.f:
        return 'F';
      case FileNotation.g:
        return 'G';
      case FileNotation.h:
        return 'H';
    }
  }

  factory FileNotation.fromValue(int value) {
    return FileNotation.values.firstWhere((element) => element.value == value);
  }

  factory FileNotation.fromLetter(String letter) {
    final temp = FileNotation.values
        .firstWhere((element) => element.label == letter.toUpperCase());

    return temp;
  }

  int get value {
    switch (this) {
      case FileNotation.a:
        return 0;
      case FileNotation.b:
        return 1;
      case FileNotation.c:
        return 2;
      case FileNotation.d:
        return 3;
      case FileNotation.e:
        return 4;
      case FileNotation.f:
        return 5;
      case FileNotation.g:
        return 6;
      case FileNotation.h:
        return 7;
    }
  }
  // potentialPieces

  static const List<String> potentialFiles = [
    'a',
    'A',
    'b',
    'B',
    'c',
    'C',
    'd',
    'D',
    'e',
    'E',
    'f',
    'F',
    'g',
    'G',
    'h',
    'H',
  ];
}
