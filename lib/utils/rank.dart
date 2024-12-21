import 'dart:ui';

class RankInfo {
  final String name;
  final Color color;
  final int minXP;

  RankInfo(this.name, this.color, this.minXP);
}

class RankUtils {
  static RankInfo getRankInfo(int xp) {
    if (xp >= 1000) {
      return RankInfo('Recovery Legend', const Color(0xFF6C63FF), 1000);
    } else if (xp >= 600) {
      return RankInfo('Master Returner', const Color(0xFF4CAF50), 600);
    } else if (xp >= 300) {
      return RankInfo('Expert Locator', const Color(0xFF2196F3), 300);
    } else if (xp >= 100) {
      return RankInfo('Community Helper', const Color(0xFFFFA726), 100);
    }
    return RankInfo('Novice Finder', const Color(0xFF78909C), 0);
  }
}
