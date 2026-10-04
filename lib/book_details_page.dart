import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  final String title;
  final String price;
  final String rating;

  const BookDetailsPage({
    super.key,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  // Favourite status
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),

        // Favourite button
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavourite = !isFavourite;
              });
            },
            icon: Icon(
              isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ---------------- BOOK IMAGE ----------------

            Container(
              height: 250,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),

              child: const Icon(
                Icons.menu_book,
                size: 100,
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- BOOK TITLE ----------------

            Text(
              widget.title,

              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ---------------- RATING ----------------

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                const SizedBox(width: 5),

                Text(
                  widget.rating,

                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ---------------- PRICE ----------------

            Text(
              widget.price,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- CATEGORY ----------------

            const Text(
              'Category: Academic Books',

              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- DESCRIPTION ----------------

            const Text(
              'Description',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'This is a good quality book. '
              'The book is available for buying, '
              'selling or exchange.',

              style: TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- SELLER ----------------

            const Text(
              'Seller Information',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const ListTile(
              contentPadding: EdgeInsets.zero,

              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),

              title: Text('BookLoop User'),

              subtitle: Text('University Student'),
            ),

            const SizedBox(height: 25),

            // ---------------- BUY & EXCHANGE ----------------

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Buy'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Exchange'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------------- CONTACT SELLER ----------------

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(
                  Icons.chat,
                ),

                label: const Text(
                  'Contact Seller',
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- FAVOURITE MESSAGE ----------------

            if (isFavourite)
              const Center(
                child: Text(
                  '❤️ Added to Favourite',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}