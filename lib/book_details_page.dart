import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class BookDetailsPage extends StatefulWidget {
final String title;
final String price;
final String rating;
final String author;
final String category;
final String description;

const BookDetailsPage({
super.key,
required this.title,
required this.price,
required this.rating,
required this.author,
required this.category,
required this.description,
});

@override
State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
bool isFavourite = false;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Book Details'),
actions: [
IconButton(
onPressed: () {
setState(() {
isFavourite = !isFavourite;
});


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavourite
                    ? 'Added to Favourite'
                    : 'Removed from Favourite',
              ),
            ),
          );
        },
        icon: Icon(
          isFavourite ? Icons.favorite : Icons.favorite_border,
          color: isFavourite ? Colors.red : null,
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

        // ---------------- AUTHOR ----------------
        Text(
          'Author: ${widget.author}',
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 15),

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
              style: const TextStyle(fontSize: 16),
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
        Text(
          'Category: ${widget.category}',
          style: const TextStyle(fontSize: 16),
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

        Text(
          widget.description.isEmpty
              ? 'No description available.'
              : widget.description,
          style: const TextStyle(fontSize: 15),
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
            // BUY BUTTON
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Buy Book'),
                        content: Text(
                          'Do you want to request this book?\n\n'
                          'Book: ${widget.title}\n'
                          'Price: ${widget.price}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
  onPressed: () async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/buy-requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'book_title': widget.title,
          'book_price': widget.price,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        Navigator.pop(dialogContext);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Buy request saved successfully!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save request: ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connection error: $e',
          ),
        ),
      );
    }
  },
  child: const Text('Confirm'),
),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Buy'),
              ),
            ),

            const SizedBox(width: 10),

            // EXCHANGE BUTTON
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Exchange Book'),
                        content: Text(
                          'Do you want to request an exchange for '
                          'this book?\n\n'
                          'Book: ${widget.title}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
  onPressed: () async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/exchange-requests',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'book_title': widget.title,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        Navigator.pop(dialogContext);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Exchange request saved successfully!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save exchange request: ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
        ),
      );
    }
  },
  child: const Text('Confirm'),
),
                        ],
                      );
                    },
                  );
                },
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
            onPressed: () async {
  String typedMessage = '';

  final String? message = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Contact Seller'),
        content: TextField(
          maxLines: 4,
          onChanged: (value) {
            typedMessage = value;
          },
          decoration: const InputDecoration(
            hintText: 'Write your message here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, typedMessage);
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );

  if (message == null || message.trim().isEmpty) {
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/contact-messages',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'book_title': widget.title,
        'message': message.trim(),
      }),
    );

    if (!context.mounted) return;

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send message: ${response.body}',
          ),
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection error: $e'),
      ),
    );
  }
},
            icon: const Icon(Icons.chat),
            label: const Text('Contact Seller'),
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
