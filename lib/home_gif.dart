import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_gif/favorite_gifs/favorite_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeGif extends StatefulWidget {
  HomeGif({super.key});

  @override
  _HomeGifPageState createState() => _HomeGifPageState();
}

class _HomeGifPageState extends State<HomeGif> {
  String apiKey = 'K0MFApvQfRkNfYIu6fgmuMELs0E0Cncd';
  TextEditingController _controller = TextEditingController();
  List<String> _gifs = [];
  List<String> _favoriteGifs = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteGifs();
  }

  Future<void> _loadFavoriteGifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteGifs = prefs.getStringList('favoriteGifs');
    if (favoriteGifs != null) {
      setState(() {
        _favoriteGifs = favoriteGifs;
      });
    }
  }

  Future<void> _saveFavoriteGifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteGifs', _favoriteGifs);
  }

  void _searchGifs(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$query&limit=50&offset=0&rating=G&lang=en'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final gifs = (data['data'] as List)
          .map((gif) => gif['images']['fixed_height']['url'] as String)
          .toList();
      setState(() {
        _gifs = gifs;
      });
    } else {
      throw Exception('Failed to load GIFs');
    }
  }

  void _toggleFavorite(String gifUrl) async {
    setState(() {
      if (_favoriteGifs.contains(gifUrl)) {
        _favoriteGifs.remove(gifUrl);
      } else {
        _favoriteGifs.add(gifUrl);
      }
    });
    await _saveFavoriteGifs();
  }

  bool _isFavorite(String gifUrl) {
    return _favoriteGifs.contains(gifUrl);
  }

  void _showGifDialog(String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: gifUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
                fit: BoxFit.cover,
              ),
              IconButton(
                icon: Icon(
                  _isFavorite(gifUrl) ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite(gifUrl) ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  _toggleFavorite(gifUrl);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pesquisar GIFs',
            style: TextStyle(
              color: Color.fromARGB(255, 5, 5, 5),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 201, 184),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 201, 184),
              Color.fromARGB(255, 0, 117, 92),
              Color.fromARGB(255, 0, 0, 0),
              //Color.fromARGB(255, 0, 0, 0),
            ],
          )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Pesquise GIFs:',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 7, 7, 7),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 14, 13, 13),
                      ),
                      onPressed: () {
                        _searchGifs(_controller.text);
                      },
                    ),
                  ),
                  onSubmitted: _searchGifs,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: _gifs.length,
                    itemBuilder: (context, index) {
                      final gifUrl = _gifs[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showGifDialog(gifUrl);
                              },
                              child: CachedNetworkImage(
                                imageUrl: gifUrl,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  _isFavorite(gifUrl)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite(gifUrl)
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  _toggleFavorite(gifUrl);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 0, 201, 184),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            ListTile(
              leading: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 248, 2, 2), //cor do icone favorito
                ),
                onPressed: () {
                  //rota para favoritos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteGifsPage(
                        favoriteGifs: _favoriteGifs,
                        toggleFavorite: (String) {},
                      ),
                    ),
                  );
                },
              ),

              title: const Text(
                "Favoritos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(
              //   "Gifs salvos",
              //   style: TextStyle(color: Color.fromARGB(255, 1, 63, 63)),
              // ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home,
                        color: Color.fromARGB(255, 3, 3, 3)),
                    title: const Text(
                      "Sair",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/');
                    },
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
