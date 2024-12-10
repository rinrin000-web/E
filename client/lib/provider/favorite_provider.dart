import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Favorite {
  final int id;
  final String? user_email;
  final String? team_no;
  final bool? is_favorite;
  final String? favorited_at;
  Favorite(
      {required this.id,
      this.user_email,
      this.team_no,
      this.is_favorite,
      this.favorited_at});
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      user_email: json['user_email'],
      team_no: json['team_no'],
      is_favorite: json['is_favorite'] == 1,
      favorited_at: json['favorited_at'],
    );
  }
}

class FavoriteNotifier extends StateNotifier<List<Favorite>> {
  FavoriteNotifier() : super([]);
  final String baseUrl = 'http://127.0.0.1:8000/api/favorite';
  // Fetch and toggle the favorite status
  Future<void> fetchFavorite(String? user_email, int? event_id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/$user_email/$event_id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        state = data.map((json) => Favorite.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  Future<void> createFavorite(String? user_email, String? team_no) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'user_email': user_email,
          'team_no': team_no,
        }),
      );

      if (response.statusCode == 201) {
        final newFavorite =
            Favorite.fromJson(jsonDecode(response.body)['data']);
        state = [...state, newFavorite];
      } else {
        throw Exception('Failed to create favorite');
      }
    } catch (e) {
      throw Exception('Error creating favorite: $e');
    }
  }

  Future<void> deleteFavorite(String? user_email, String? team_no) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/$user_email/$team_no'));

      if (response.statusCode == 200) {
        state = state.where((fav) => fav.team_no != team_no).toList();
      } else {
        throw Exception('Failed to delete favorite');
      }
    } catch (e) {
      throw Exception('Error deleting favorite: $e');
    }
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Favorite>>((ref) {
  return FavoriteNotifier();
});
