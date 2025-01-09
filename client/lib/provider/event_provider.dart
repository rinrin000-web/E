import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Event {
  final int id;
  final String event_name;
  final String event_date;
  final String images;

  Event({
    required this.id,
    required this.event_name,
    required this.event_date,
    required this.images,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      event_name: json['event_name'],
      event_date: json['event_date'],
      images: 'http://127.0.0.1:8000/api/events/${json['images']}',
    );
  }

  @override
  String toString() {
    return 'Event(event_name: $event_name, event_date: $event_date, images: $images, id: $id)';
  }
}

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super([]) {
    _loadSelectedEventId(); // Load selected event ID on initialization
  }

  final String baseUrl = 'http://127.0.0.1:8000/api/events';

  int? _selectedEventId; // Store selected event ID

  // Save the selected event ID to SharedPreferences
  Future<void> saveSelectedEventId(int eventId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedEventId', eventId);
    _selectedEventId = eventId; // Save the ID locally as well
  }

  // Synchronously retrieve the selected event ID
  int? getSelectedEventIdSync() {
    return _selectedEventId;
  }

  // Load the selected event ID from SharedPreferences
  Future<void> _loadSelectedEventId() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedEventId = prefs.getInt('selectedEventId');
    if (_selectedEventId == null) {
      print('No selectedEventId found in SharedPreferences');
    } else {
      print('Loaded selectedEventId: $_selectedEventId');
    }
  }

  // Fetch events from the API and update the state
  Future<void> fetchEvent() async {
    await _loadSelectedEventId(); // Ensure the selected event ID is loaded before fetching events

    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        state = body.map((json) => Event.fromJson(json)).toList();
        print("Fetched events: $state");

        // If a selected event ID exists, set it to the state or do something based on it
        if (_selectedEventId != null) {
          // Optionally, you can filter or highlight the selected event here
          print("Selected event ID: $_selectedEventId");
        }
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load events');
    }
  }

  Future<void> updateEvents({
    required int? eventId,
    String? event_name,
    String? event_date,
    Uint8List? imageBytes,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/$eventId'));

      if (event_name?.isNotEmpty ?? false) {
        request.fields['event_name'] = event_name!;
      }
      if (event_date?.isNotEmpty ?? false) {
        request.fields['event_date'] = event_date!;
      }
      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'images',
          imageBytes,
          filename: 'event_image.jpg',
        ));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = json.decode(responseData);
        print(data);
      } else {
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }
  }

  Future<void> deleteEvent(int? eventId) async {
    final url = Uri.parse('$baseUrl/$eventId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Remove the deleted event from the state
        state = state.where((event) => event.id != eventId).toList();
        print("Event deleted successfully");
      } else {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to delete event');
    }
  }
}

// Define the event provider
final eventProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier();
});
