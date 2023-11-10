import 'dart:convert';

import 'package:github_api_demo/models/Stars.dart';
import 'package:github_api_demo/models/repositories.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class GitHubApi {
  final String baseUrl = 'https://api.github.com/';
  final String token = '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';

  Future<User?> findUser(String userName) async {
    final url = '${baseUrl}users/$userName';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var user = User.fromJson(json);

      return user;
    } else {
      return null;
    }
  }

  Future<List<User>> getFollowing(String userName) async {
    final url = '${baseUrl}users/$userName/following';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      var users = jsonList.map<User>((json) => User.fromJson(json)).toList();

      return users ?? [];
    } else {
      return [];
    }
  }

  Future<List<User>> getFollowers(String userName) async {
    final url = '${baseUrl}users/$userName/followers';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      var users = jsonList.map<User>((json) => User.fromJson(json)).toList();

      return users ?? [];
    } else {
      return [];
    }
  }

  Future<List<Repository>> getRepositories(String userName) async {
    final url = '${baseUrl}users/$userName/repos';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Repository> repositories =
          jsonList.map((json) => Repository.fromJson(json)).toList();
      return repositories;
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<List<StarredRepository>> getStarredRepositories(
      String userName) async {
    final url = '${baseUrl}users/$userName/starred';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<StarredRepository> starredRepositories =
          jsonList.map((json) => StarredRepository.fromJson(json)).toList();
      return starredRepositories;
    } else {
      throw Exception('Failed to load starred repositories');
    }
  }
}
