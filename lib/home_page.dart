import 'package:flutter/material.dart';

import 'book_details_page.dart';
import 'favourite_page.dart';
import 'favourite_data.dart';

class HomePage extends StatelessWidget {
const HomePage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'BookLoop',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
actions: [
IconButton(
onPressed: () {},
icon: const Icon(Icons.notifications_none),
),
IconButton(
onPressed: () {},
icon: const Icon(Icons.person_outline),
),
],
),


  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find Your Next Book',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Buy, sell, exchange and review books.',
          style: TextStyle(
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          decoration: InputDecoration(
            hintText: 'Search books...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
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
              _category('Academic'),
              _category('Story'),
              _category('Islamic'),
              _category('Poetry'),
              _category('Novels'),
              _category('Biography'),
              _category('More'),
            ],
          ),
        ),

        const SizedBox(height: 25),

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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _bookCard(
                context,
                'Database System',
                '৳300',
                '★ 4.5',
              ),

              _bookCard(
                context,
                'Data Structures',
                '৳250',
                '★ 4.7',
              ),

              _bookCard(
                context,
                'Computer Networks',
                '৳280',
                '★ 4.3',
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Recently Added',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        _recentBook(
          'Operating System',
          '৳350',
          '★ 4.6',
        ),

        _recentBook(
          'Computer Architecture',
          '৳280',
          '★ 4.4',
        ),

        _recentBook(
          'Algorithms',
          '৳320',
          '★ 4.8',
        ),
      ],
    ),
  ),

  bottomNavigationBar: BottomNavigationBar(
    currentIndex: 0,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,

    onTap: (index) {
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
        icon: Icon(Icons.add_box_outlined),
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

Widget _category(String name) {
return Container(
margin: const EdgeInsets.only(right: 10),
child: Chip(
label: Text(name),
),
);
}

Widget _bookCard(
BuildContext context,
String title,
String price,
String rating,
) {
bool isFavourite = favouriteBooks.any(
(book) => book['title'] == title,
);


return Container(
  width: 170,
  margin: const EdgeInsets.only(right: 15),
  child: Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsPage(
                    title: title,
                    price: price,
                    rating: rating,
                  ),
                ),
              );
            },

            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: const Icon(
                Icons.menu_book,
                size: 55,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (isFavourite) {
                    favouriteBooks.removeWhere(
                      (book) => book['title'] == title,
                    );
                  } else {
                    favouriteBooks.add({
                      'title': title,
                      'price': price,
                      'rating': rating,
                    });
                  }

                  (context as Element).markNeedsBuild();
                },

                icon: Icon(
                  isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),

          Text(
            rating,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  ),
);


}

Widget _recentBook(
String title,
String price,
String rating,
) {
return Card(
margin: const EdgeInsets.only(bottom: 12),
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.menu_book),
),


    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    subtitle: Text(
      '$price   $rating',
    ),

    trailing: const Icon(
      Icons.favorite_border,
    ),
  ),
);
}
 
}
