import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddBookPage extends StatefulWidget {
const AddBookPage({super.key});

@override
State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {

// Text fields-এর controller
final titleController = TextEditingController();
final authorController = TextEditingController();
final priceController = TextEditingController();
final descriptionController = TextEditingController();

// Category
String selectedCategory = 'Academic';

// Book database-এ add করার function
Future<void> addBook() async {
print('ADD BOOK BUTTON PRESSED');

if (titleController.text.isEmpty ||
    authorController.text.isEmpty ||
    priceController.text.isEmpty) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please fill all required fields'),
    ),
  );

  return;
}

try {

  final response = await http.post(

    Uri.parse(
      'http://192.168.0.100:3000/api/books',
    ),

    headers: {
      'Content-Type': 'application/json',
    },

    body: jsonEncode({

      'title': titleController.text,

      'author': authorController.text,

      'price': double.parse(
        priceController.text,
      ),

      'category': selectedCategory,

      'description':
          descriptionController.text,

      'image_url': '',
    }),
  );
  
print('STATUS CODE: ${response.statusCode}');
print('RESPONSE: ${response.body}');

  if (response.statusCode == 201) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Book added successfully!',
        ),
      ),
    );

    // Form clear
    titleController.clear();
    authorController.clear();
    priceController.clear();
    descriptionController.clear();

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to add book',
        ),
      ),
    );
  }

} catch (e) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Error: $e',
      ),
    ),
  );
}


}

@override
Widget build(BuildContext context) {


return Scaffold(

  appBar: AppBar(
    title: const Text(
      'Sell a Book',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  body: SingleChildScrollView(

    padding: const EdgeInsets.all(16),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          'Add Your Book',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        // Book title
        TextField(
          controller: titleController,

          decoration: InputDecoration(
            labelText: 'Book Title',
            hintText: 'Enter book title',

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Author
        TextField(
          controller: authorController,

          decoration: InputDecoration(
            labelText: 'Author',
            hintText: 'Enter author name',

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Price
        TextField(
          controller: priceController,

          keyboardType:
              TextInputType.number,

          decoration: InputDecoration(
            labelText: 'Price',
            hintText: 'Enter price',

            prefixText: '৳ ',

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Category
        DropdownButtonFormField<String>(

          value: selectedCategory,

          decoration: InputDecoration(
            labelText: 'Category',

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),

          items: const [

            DropdownMenuItem(
              value: 'Academic',
              child: Text('Academic'),
            ),

            DropdownMenuItem(
              value: 'Story',
              child: Text('Story'),
            ),

            DropdownMenuItem(
              value: 'Islamic',
              child: Text('Islamic'),
            ),

            DropdownMenuItem(
              value: 'Poetry',
              child: Text('Poetry'),
            ),

            DropdownMenuItem(
              value: 'Novels',
              child: Text('Novels'),
            ),

            DropdownMenuItem(
              value: 'Biography',
              child: Text('Biography'),
            ),
          ],

          onChanged: (value) {

            setState(() {
              selectedCategory =
                  value!;
            });
          },
        ),

        const SizedBox(height: 15),

        // Description
        TextField(
          controller:
              descriptionController,

          maxLines: 5,

          decoration: InputDecoration(
            labelText: 'Description',
            hintText:
                'Enter book description',

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // Add button
        SizedBox(
          width: double.infinity,
          height: 50,

          child: ElevatedButton(

          onPressed: () {
              print('BUTTON PRESSED');
              addBook();
            },  

            child: const Text(
              'Add Book',
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);


}

@override
void dispose() {


titleController.dispose();
authorController.dispose();
priceController.dispose();
descriptionController.dispose();

super.dispose();


}
}
