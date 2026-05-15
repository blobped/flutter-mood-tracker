# Flutter Mood Tracker

A single-screen Flutter web mood tracker built for a take-home evaluation.

## Live Demo

Deployment URL: pending

## Requirements Covered

- Tap to log how the user feels.
- Show the past 7 entries in a horizontal timeline.
- Tap a past entry to briefly animate it.
- Draw all mood faces with `CustomPainter` using canvas primitives.
- Include the date, drawn face, and a color accent for each timeline entry.

## Running Locally

```powershell
flutter pub get
flutter run -d chrome
```

## Implementation Notes

State is managed with a small `ChangeNotifier` controller. The controller owns
the mood entries, exposes an immutable view to the UI, keeps the list capped to
the latest seven items, and persists those entries to browser local storage.

Mood faces are drawn by `MoodFacePainter`, a `CustomPainter` that uses canvas
primitives instead of images, emoji, or icon fonts. Each mood changes the drawn
geometry: the happy face uses raised brows and an upward mouth arc, the calm
face uses closed eyes and a straight mouth, and the sad face uses angled brows
with a curved path for the frown.

## Loom Walkthrough Notes

- State management: `MoodController` extends `ChangeNotifier`, stores entries,
  trims to seven, notifies the screen, and saves to local storage.
- CustomPainter: `MoodFacePainter` switches on the mood and draws the face,
  features, brows, and mouth directly on the canvas.
- With more time: add optional notes and a calendar or chart view so the user
  can spot mood patterns over longer periods.
