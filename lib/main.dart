import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'mood_controller.dart';
import 'mood_entry.dart';
import 'mood_face.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      scrollBehavior: const _MoodScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF184E77),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F3EA),
        useMaterial3: true,
      ),
      home: const MoodHomePage(),
    );
  }
}

class _MoodScrollBehavior extends MaterialScrollBehavior {
  const _MoodScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class MoodHomePage extends StatefulWidget {
  const MoodHomePage({super.key});

  @override
  State<MoodHomePage> createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  final MoodController _controller = MoodController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (!_controller.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Header(),
                        const SizedBox(height: 28),
                        _MoodPicker(
                          onMoodSelected: _controller.logMood,
                          latestEntry: _controller.latestEntry,
                        ),
                        const SizedBox(height: 28),
                        _MoodTimeline(entries: _controller.entries),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Tracker',
          style: textTheme.displaySmall?.copyWith(
            color: const Color(0xFF263238),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap a face to log how you feel today.',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF56636A),
          ),
        ),
      ],
    );
  }
}

class _MoodPicker extends StatelessWidget {
  const _MoodPicker({
    required this.onMoodSelected,
    required this.latestEntry,
  });

  final ValueChanged<MoodType> onMoodSelected;
  final MoodEntry? latestEntry;

  @override
  Widget build(BuildContext context) {
    final latest = latestEntry;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2DCCF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              latest == null
                  ? 'How are you feeling?'
                  : 'Latest mood: ${latest.mood.label}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF263238),
                  ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: MoodType.values.map((mood) {
                return _MoodButton(
                  mood: mood,
                  onPressed: () => onMoodSelected(mood),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.mood,
    required this.onPressed,
  });

  final MoodType mood;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: mood.accent.withValues(alpha: 0.14),
          foregroundColor: const Color(0xFF263238),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MoodFace(mood: mood, size: 62),
            const SizedBox(height: 8),
            Text(
              mood.label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodTimeline extends StatelessWidget {
  const _MoodTimeline({required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox(
        height: 190,
        child: _EmptyTimeline(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past 7 entries',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF263238),
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        _TimelineScroller(entries: entries),
      ],
    );
  }
}

class _TimelineScroller extends StatefulWidget {
  const _TimelineScroller({required this.entries});

  final List<MoodEntry> entries;

  @override
  State<_TimelineScroller> createState() => _TimelineScrollerState();
}

class _TimelineScrollerState extends State<_TimelineScroller> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 16),
          scrollDirection: Axis.horizontal,
          itemCount: widget.entries.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            return _TimelineEntryCard(entry: widget.entries[index]);
          },
        ),
      ),
    );
  }
}

class _TimelineEntryCard extends StatefulWidget {
  const _TimelineEntryCard({required this.entry});

  final MoodEntry entry;

  @override
  State<_TimelineEntryCard> createState() => _TimelineEntryCardState();
}

class _TimelineEntryCardState extends State<_TimelineEntryCard> {
  bool _isAnimating = false;

  void _playAnimation() {
    setState(() => _isAnimating = true);
    Future<void>.delayed(const Duration(milliseconds: 260), () {
      if (mounted) {
        setState(() => _isAnimating = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return GestureDetector(
      onTap: _playAnimation,
      child: AnimatedScale(
        scale: _isAnimating ? 1.07 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 154,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isAnimating ? entry.mood.accent : const Color(0xFFE2DCCF),
              width: _isAnimating ? 3 : 1,
            ),
            boxShadow: [
              if (_isAnimating)
                BoxShadow(
                  color: entry.mood.accent.withValues(alpha: 0.28),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 34,
                  height: 5,
                  decoration: BoxDecoration(
                    color: entry.mood.accent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              MoodFace(mood: entry.mood, size: 72),
              Column(
                children: [
                  Text(
                    entry.mood.label,
                    style: const TextStyle(
                      color: Color(0xFF263238),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(entry.loggedAt),
                    style: const TextStyle(
                      color: Color(0xFF69777E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[value.month - 1]} ${value.day}';
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2DCCF)),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Your timeline will appear after you log a mood.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF56636A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
