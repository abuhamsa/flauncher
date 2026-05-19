enum AppCardHighlightAnimationStyle {
  rotate,
  blink,
}

AppCardHighlightAnimationStyle parseAppCardHighlightAnimationStyle(String value) {
  return AppCardHighlightAnimationStyle.values.firstWhere(
    (style) => style.name == value,
    orElse: () => AppCardHighlightAnimationStyle.rotate,
  );
}
