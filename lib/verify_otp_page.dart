import 'dart:convert';
import 'api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class VerifyOtpPage extends StatefulWidget {
final String email;

const VerifyOtpPage({
super.key,
required this.email,
});

@override
State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
final otpController = TextEditingController();

bool isLoading = false;

final String baseUrl = ApiConfig.baseUrl;

@override
void dispose() {
otpController.dispose();
super.dispose();
}

Future<void> verifyOtp() async {
final otp = otpController.text.trim();


if (otp.length != 6) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please enter the 6-digit OTP.'),
    ),
  );
  return;
}

setState(() {
  isLoading = true;
});

try {
  final response = await http
      .post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': widget.email,
          'otp': otp,
        }),
      )
      .timeout(const Duration(seconds: 20));

  final data =
      jsonDecode(response.body) as Map<String, dynamic>;

  if (!mounted) return;

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email verified successfully! Please log in.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data['message'] ?? 'OTP verification failed.',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
} catch (error) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Could not connect to server. Check your backend and IP address.',
      ),
    ),
  );

  debugPrint('OTP verification error: $error');
} finally {
  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
}


}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Verify Email'),
),
body: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(
Icons.mark_email_read_outlined,
size: 75,
),
const SizedBox(height: 20),
const Text(
'Email Verification',
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Text(
'We sent a 6-digit verification code to ${widget.email}.',
textAlign: TextAlign.center,
),
const SizedBox(height: 25),
TextField(
controller: otpController,
keyboardType: TextInputType.number,
maxLength: 6,
decoration: InputDecoration(
labelText: 'Enter OTP',
prefixIcon: const Icon(Icons.lock_clock),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
height: 50,
child: ElevatedButton(
onPressed: isLoading ? null : verifyOtp,
child: isLoading
? const CircularProgressIndicator()
: const Text(
'Verify OTP',
style: TextStyle(fontSize: 18),
),
),
),
],
),
),
);
}
}
