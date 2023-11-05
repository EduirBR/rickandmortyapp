import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmortyapp/models/character_model.dart';
import 'package:rickandmortyapp/provider/api_provider.dart';

class CharacterScreen extends StatelessWidget {
  final Result character;
  const CharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name!,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: size.height * 0.35,
            child: Hero(
              tag: character.id!,
              child: Image.network(
                character.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: size.height * 0.14,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cardData("Status: ", character.status!),
                cardData("Specie: ", character.species!),
                cardData("Gender:", character.gender!),
                cardData("Location: ", character.location!.name!),
                cardData("Origin: ", character.origin!.name!),
              ],
            ),
          ),
          const Text(
            "Episodes",
            style: TextStyle(fontSize: 17),
          ),
          EpisodeList(size: size, character: character)
        ]),
      ),
    );
  }

  Widget cardData(String key, value) {
    return Expanded(
        child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(key),
          Text(
            value,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    ));
  }
}

class EpisodeList extends StatefulWidget {
  const EpisodeList({super.key, required this.size, required this.character});

  final Size size;
  final Result character;

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return SizedBox(
      height: widget.size.height * 0.35,
      child: ListView.builder(
          itemCount: apiProvider.episodes.length,
          itemBuilder: (context, index) {
            final episode = apiProvider.episodes[index];
            return ListTile(
              leading: Text(episode.episode!),
              title: Text(episode.name!),
              trailing: Text(episode.airDate!),
            );
          }),
    );
  }
}
