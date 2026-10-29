

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, String>> favouriteBooks = [];

Future<void> loadFavouriteBooks() async {
final prefs = await SharedPreferences.getInstance();

final String? savedData = prefs.getString('favouriteBooks');

if (savedData != null) {
final List<dynamic> decodedData = jsonDecode(savedData);

favouriteBooks.clear();

favouriteBooks.addAll(
  decodedData.map(
    (item) => Map<String, String>.from(item),
  ),
);

}
}

Future<void> saveFavouriteBooks() async {
final prefs = await SharedPreferences.getInstance();

final String encodedData = jsonEncode(favouriteBooks);

await prefs.setString('favouriteBooks', encodedData);
}