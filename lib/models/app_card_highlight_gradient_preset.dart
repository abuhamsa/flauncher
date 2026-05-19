enum AppCardHighlightGradientPreset {
  moonlight,
  auroraBlue,
  nightSteel,
}

AppCardHighlightGradientPreset parseAppCardHighlightGradientPreset(String value) {
  return AppCardHighlightGradientPreset.values.firstWhere(
    (preset) => preset.name == value,
    orElse: () => AppCardHighlightGradientPreset.moonlight,
  );
}
