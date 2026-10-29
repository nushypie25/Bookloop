import 'package:flutter/material.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'add_book_page.dart';

import 'book_details_page.dart';

import 'favourite_page.dart';
import 'messages_page.dart';
import 'favourite_data.dart';
import 'dart:async';

class HomePage extends StatefulWidget {

const HomePage({super.key});

@override

State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

String searchText = '';
String selectedCategory = 'All';

int selectedIndex = 0;

List<dynamic> books = [];

int currentPage = 1;

int booksPerPage = 5;
Timer? searchDebounce;

bool isLoading = false;

@override

void initState() {

super.initState();
loadFavouriteBooks().then((_) {
    if (mounted) {
      setState(() {});
    }
  });

fetchBooks();

}
Future<void> fetchBooks() async {
setState(() {
isLoading = true;
});

try {
final uri = Uri.parse(
'${ApiConfig.baseUrl}/api/books',
).replace(
queryParameters: {
'page': currentPage.toString(),
'limit': booksPerPage.toString(),
'search': searchText.trim(),
},
);


final response = await http.get(uri);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);

  if (!mounted) return;

  setState(() {
    books = data['books'] ?? [];
  });
} else {
  debugPrint('Failed to load books: ${response.statusCode}');
}


} catch (e) {
debugPrint('Error loading books: $e');
} finally {
if (mounted) {
setState(() {
isLoading = false;
});
}
}
}


void nextPage() {

setState(() {

currentPage++;

});

fetchBooks();

}

void previousPage() {

if (currentPage > 1) {

setState(() {

currentPage--;

});

  fetchBooks();
}

}

@override

Widget build(BuildContext context) {
final List<dynamic> filteredBooks = books.where((book) {
  final String category =
      (book['category'] ?? '').toString().trim().toLowerCase();

  final List<String> regularCategories = [
    'academic',
    'story',
    'islamic',
    'poetry',
    'novels',
    'biography',
  ];

  final bool matchesCategory = selectedCategory == 'All'
      ? true
      : selectedCategory == 'More'
          ? category.isNotEmpty && !regularCategories.contains(category)
          : category == selectedCategory.toLowerCase();

  return matchesCategory;
}).toList();

return Scaffold(
  backgroundColor: Colors.white,

  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,

    title: const Text(
      'BookLoop',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),

    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.notifications_none,
          color: Colors.black,
        ),
      ),
IconButton(
  tooltip: 'Messages',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessagesPage(),
      ),
    );
  },
  icon: const Icon(
    Icons.message_outlined,
    color: Colors.black,
  ),
),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.person_outline,
          color: Colors.black,
        ),
      ),
    ],
  ),

  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Find Your Next Book',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Buy, sell, exchange and review books.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),

            child: TextField(
              onChanged: (value) {
              setState(() {
              searchText = value;
              currentPage = 1;
              });

             searchDebounce?.cancel();

             searchDebounce = Timer(
             const Duration(milliseconds: 400),
             () {
             fetchBooks();
             },
             );
             },


              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Search books...',
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 45,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: [
                _categoryChip('All'),
                _categoryChip('Academic'),
                _categoryChip('Story'),
                _categoryChip('Islamic'),
                _categoryChip('Poetry'),
                _categoryChip('Novels'),
                _categoryChip('Biography'),
                _categoryChip('More'),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Featured Books',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 250,

            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredBooks.isEmpty
                    ? const Center(
                        child: Text(
                          'No books found',
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: filteredBooks.length,

                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];

                          return _bookCard(
                            context,
                            book['title'] ?? 'No Title',
                            '৳${book['price'] ?? '0'}',
                            '★ 4.5',
                            book['author'] ?? 'Unknown Author',
                            book['category'] ?? 'Unknown Category',
                            book['description'] ?? '',
                          );
                        },
                      ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Recently Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          filteredBooks.isEmpty
              ? const Center(
                  child: Text(
                    'No books found',
                  ),
                )
              : Column(
                  children: filteredBooks.map((book) {
                    return _recentBookCard(
                      context,
                      book['title'] ?? 'No Title',
                      '৳${book['price'] ?? '0'}',
                      '★ 4.5',
                      book['author'] ?? 'Unknown Author',
                      book['category'] ?? 'Unknown Category',
                      book['description'] ?? '',
                    );
                  }).toList(),
                ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(
                onPressed: currentPage > 1
                    ? previousPage
                    : null,

                child: const Text(
                  'Previous',
                ),
              ),

              const SizedBox(width: 20),

              Text(
                'Page $currentPage',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: books.length == booksPerPage
                    ? nextPage
                    : null,

                child: const Text(
                  'Next',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  ),

  bottomNavigationBar: BottomNavigationBar(
    currentIndex: selectedIndex,

    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,

    onTap: (index) {
      setState(() {
        selectedIndex = index;
      });

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddBookPage(),
          ),
        );
      }

      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FavouritePage(),
          ),
        );
      }
    },

    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'Sell',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        label: 'Favourite',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ],
  ),
);

}

Widget _categoryChip(String title) {
  final bool isSelected = selectedCategory == title;

  return Container(
    margin: const EdgeInsets.only(right: 10),
    child: ChoiceChip(
      label: Text(title),
      selected: isSelected,
      selectedColor: Colors.blue.shade100,
      backgroundColor: Colors.grey.shade100,
      onSelected: (selected) {
        setState(() {
          selectedCategory = title;
        });
      },
    ),
  );
}

Widget _bookCard(

BuildContext context,

String title,

String price,

String rating,

String author,

String category,

String description,

) {

bool isFavourite = favouriteBooks.any(

(book) => book['title'] == title,

);

return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsPage(
          title: title,
          price: price,
          rating: rating,
          author: author,
          category: category,
          description: description,
        ),
      ),
    );
  },

  child: Container(
    width: 180,

    margin: const EdgeInsets.only(right: 15),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),

      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),

    child: Padding(
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            height: 110,
            width: double.infinity,

            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.menu_book,
              size: 50,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            price,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                rating,
                style: const TextStyle(
                  color: Colors.orange,
                ),
              ),

              IconButton(
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(),

                icon: Icon(
                  isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,

                  color: isFavourite
                      ? Colors.red
                      : Colors.grey,
                ),

                onPressed: () async {
                  setState(() {
                    if (isFavourite) {
                      favouriteBooks.removeWhere(
                        (book) =>
                            book['title'] == title,
                      );
                    } else {
                      favouriteBooks.add({
                        'title': title,
                        'price': price,
                        'rating': rating,
                      });
                    }
                  });
                  await saveFavouriteBooks();

                },
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);

}

Widget _recentBookCard(

BuildContext context,

String title,

String price,

String rating,

String author,

String category,

String description,

) {

return GestureDetector(

onTap: () {

Navigator.push(

context,

MaterialPageRoute(

builder: (context) => BookDetailsPage(

title: title,

price: price,

rating: rating,

author: author,

category: category,

description: description,

),

),

);

},

  child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),

      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.12),
          blurRadius: 6,
        ),
      ],
    ),

    child: Row(
      children: [
        Container(
          height: 70,
          width: 60,

          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),

          child: const Icon(
            Icons.menu_book,
            color: Colors.grey,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                price,

                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                rating,

                style: const TextStyle(
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

}

}
