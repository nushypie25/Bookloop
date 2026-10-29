import 'package:flutter/material.dart';
import 'favourite_data.dart';

class FavouritePage extends StatefulWidget {
const FavouritePage({super.key});

@override
State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'My Favourites',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

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
                  child: Icon(
                    Icons.menu_book,
                  ),
                ),

                title: Text(
                  book['title'] ?? 'Unknown Book',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  '${book['price'] ?? '৳0'}   ${book['rating'] ?? '★ 0'}',
                ),

                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
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