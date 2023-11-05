import 'package:flutter/material.dart';
import 'package:rickandmortyapp/models/character_model.dart';
import 'package:http/http.dart' as http;
import 'package:rickandmortyapp/models/episode.dart';

class ApiProvider with ChangeNotifier {
  final url = "rickandmortyapi.com";
  List<Result> characters = [];
  List<Episode> episodes = [];

  Future<void> getCharacters(int page) async {
    final result = await http
        .get(Uri.https(url, "/api/character", {"page": page.toString()}));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }

  Future<List<Result>> getCharacter(String name) async {
    final result =
        await http.get(Uri.https(url, "/api/character/", {"name": name}));
    final response = characterResponseFromJson(result.body);
    return response.results!;
  }

  Future<List<Episode>> getEpisodes(Result character) async {
    episodes = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = episodeFromJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }
}
