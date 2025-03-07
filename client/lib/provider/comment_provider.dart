import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  // final int id;
  final String? team_no;
  final String? comment_user;
  final int? rank;
  final int? present;
  final int? plan;
  final int? design;
  final int? tech;
  final String? comment;
  final bool? ispublic;
  final String? commented_at;

  Comment(
      {
      // required this.id,
      this.team_no,
      this.comment_user,
      this.rank,
      this.present,
      this.plan,
      this.design,
      this.tech,
      this.comment,
      this.ispublic,
      this.commented_at});
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      team_no: json['team_no'],
      comment_user: json['comment_user'],
      rank: json['rank'],
      present: json['present'],
      plan: json['plan'],
      design: json['design'],
      tech: json['tech'],
      comment: json['comment'],
      ispublic: json[' ispublic'],
      commented_at: json['commented_at'],
    );
  }
}

class CommentNotifier extends StateNotifier<List<Comment>> {
  CommentNotifier() : super([]);
  final String baseUrl = '${BaseUrlE.baseUrl}/api/comments';
  Future<List<Comment>> fetchComment(String? teamNo) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$teamNo'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load comment');
    }
  }

  Future<List<Comment>> getCommentsByUser(
      String? team_no, String? commentUser) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/$team_no/$commentUser'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> createComment(Comment comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'team_no': comment.team_no,
        'comment_user': comment.comment_user,
        'rank': comment.rank,
        'present': comment.present,
        'plan': comment.plan,
        'design': comment.design,
        'tech': comment.tech,
        'comment': comment.comment,
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<Comment> updateComment(
      String? teamNo, String? commentUser, Comment comment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$teamNo/$commentUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'rank': comment.rank,
        'present': comment.present,
        'plan': comment.plan,
        'design': comment.design,
        'tech': comment.tech,
        'comment': comment.comment,
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<void> updateIsPublic(String? commentUser, bool ispublic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/updateIsPublic/$commentUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ispublic': ispublic,
      }),
    );

    if (response.statusCode == 200) {
      print('Updated isPublic: $ispublic');
    } else {
      print('Error updating isPublic: ${response.body}');
    }
  }
}

final commentProvider =
    StateNotifierProvider<CommentNotifier, List<Comment>>((ref) {
  return CommentNotifier();
});
