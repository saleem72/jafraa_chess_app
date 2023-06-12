//

enum CastlingRights {
  both,
  short,
  long,
  none;

  CastlingRights disableLong() {
    switch (this) {
      case CastlingRights.both:
        return CastlingRights.short;
      case CastlingRights.short:
        return CastlingRights.short;
      case CastlingRights.long:
        return CastlingRights.none;
      case CastlingRights.none:
        return CastlingRights.none;
    }
  }

  CastlingRights disableShort() {
    switch (this) {
      case CastlingRights.both:
        return CastlingRights.long;
      case CastlingRights.short:
        return CastlingRights.none;
      case CastlingRights.long:
        return CastlingRights.long;
      case CastlingRights.none:
        return CastlingRights.none;
    }
  }
}
