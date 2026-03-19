import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String hfKey = '';
  static const String model = 'stabilityai/stable-diffusion-xl-base-1.0';

  // Task 2: Construct prompt and generate Poster
  static Future<String> generatePoster(Map<String, dynamic> data) async {
    try {
      final prompt = "A professional promotional poster for a ${data['theme']} event at ${data['location']}. High resolution, 4k, digital art style.";
      
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/$model'),
        headers: {'Authorization': 'Bearer $hfKey', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {'width': 1024, 'height': 576}
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return 'data:image/png;base64,${base64Encode(response.bodyBytes)}';
      }
      throw "HF API Error";
    } catch (e) {
      print('Image generation error: $e');
      return "https://picsum.photos/seed/${data['theme']}/1024/576";
    }
  }

  // Task 3: Firebase AI Logic Integration
  static Future<Map<String, dynamic>> getSuggestions(Map<String, dynamic> data) async {
    // In a real scenario, this would be a Firebase Vertex AI call
    await Future.delayed(const Duration(seconds: 1));
    
    // Task 3.3: Personalized suggestion in JSON format
    final theme = (data['theme'] as String?)?.trim() ?? 'Event';
    final duration = (data['duration'] is num) ? (data['duration'] as num).toInt() : 2;

    return {
      "catering": "Budget RM${data['budget']} allows for premium ${theme.toLowerCase()}-themed catering.",
      "activities": [
        "Registration & networking (15 min) - Guests arrive, collect badges, and grab refreshments.",
        "Opening & agenda overview (10 min) - Welcome by host and outline of the ${theme.toLowerCase()} schedule.",
        "$theme keynote session (min 60 min) - Main presentation focused on the core topic.",
        "Interactive breakout activity (30 min) - Small group discussions or hands-on exercises.",
        "Wrap-up & Q&A (15 min) - Final thoughts, feedback, and next steps.",
      ],
      "pro_tip": "Assign a point person to handle AV and timing so the event flows smoothly."
    };
  }
}