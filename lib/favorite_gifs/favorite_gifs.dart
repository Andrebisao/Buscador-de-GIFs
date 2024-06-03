import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteGifsPage extends StatelessWidget {
  final List<String> favoriteGifs;
  final Function(String) toggleFavorite;

  const FavoriteGifsPage(
      {required this.favoriteGifs, required this.toggleFavorite, Key? key})
      : super(key: key);

  void _showGifDialog(BuildContext context, String gifUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: gifUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    toggleFavorite(gifUrl);
                    Navigator.of(context).pop();
                  },
                ),
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
      backgroundColor: Color.fromARGB(255, 0, 201, 184),
      appBar: AppBar(
        title: const Text('GIFs Favoritos'),
        backgroundColor: Color.fromARGB(255, 0, 201, 184),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 5, 5, 5),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 5, 5),
        ),
      ),
      body: favoriteGifs.isEmpty
          ? const Center(
              child: Text(
                'Nenhum GIF favoritado',
                style: TextStyle(fontSize: 20),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: favoriteGifs.length,
              itemBuilder: (context, index) {
                final gifUrl = favoriteGifs[index];
                return GestureDetector(
                  onTap: () => _showGifDialog(context, gifUrl),
                  child: CachedNetworkImage(
                    imageUrl: gifUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
