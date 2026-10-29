import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<dynamic> messages = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/api/contact-messages',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          messages = data['messages'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception(
          'Failed to load messages: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: fetchMessages,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh messages',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: fetchMessages,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchMessages,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.message),
                              ),
                              title: Text(
                                message['book_title']?.toString() ??
                                    'Unknown Book',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['message']?.toString() ??
                                          '',
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Status: ${message['status'] ?? 'Unread'}',
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sent: ${message['sent_at'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}