
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  // Favourite books list
  final List<Map<String, String>> favouriteBooks = [
    {
      'title': 'Database System',
      'price': '৳300',
      'rating': '★ 4.5',
    },
    {
      'title': 'Data Structures',
      'price': '৳250',
      'rating': '★ 4.7',
    },
    {
      'title': 'Computer Networks',
      'price': '৳280',
      'rating': '★ 4.3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------- APP BAR ----------------
      appBar: AppBar(
        title: const Text(
          'My Favourites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ---------------- FAVOURITE LIST ----------------
      body: favouriteBooks.isEmpty
          ? const Center(
              child: Text(
                'No favourite books yet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favouriteBooks.length,
              itemBuilder: (context, index) {
                final book = favouriteBooks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book),
                    ),

                    title: Text(
                      book['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${book['price']}   ${book['rating']}',
                    ),

                    // Remove from favourite
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                      ),
                      onPressed: () {
                        setState(() {
                          favouriteBooks.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

