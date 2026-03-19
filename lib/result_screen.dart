import 'package:flutter/material.dart';
import 'package:student_event_planner/ai_service.dart';
import 'ai_service.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;
  const ResultScreen({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    final themeName = (eventData['theme'] as String?)?.trim();
    final displayTitle = themeName != null && themeName.isNotEmpty
        ? themeName
        : 'Your AI Plan';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(displayTitle)),
      body: FutureBuilder(
        future: Future.wait([
          AIService.generatePoster(eventData),
          AIService.getSuggestions(eventData),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          String posterUrl = snapshot.data![0];
          Map<String, dynamic> suggestions = snapshot.data![1];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Theme: $displayTitle',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Catering: ${suggestions['catering']}',
                  style: textTheme.bodyLarge,
                ),
                const Divider(),
                Text(
                  'Planned Activities:',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...suggestions['activities']
                    .map<Widget>(
                      (a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $a', style: textTheme.bodyMedium),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 10),
                Card(
                  color: colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Pro Tip: ${suggestions['pro_tip']}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
