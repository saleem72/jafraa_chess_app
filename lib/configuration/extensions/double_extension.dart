//

import 'dart:math' as math;

extension RadianToDegree on double {
  double toRadian() {
    // 360 = 2 * pi
    // 1 = 2 * pi / 360
    // 1 = pi / 180
    return this * math.pi / 180;
  }
}
