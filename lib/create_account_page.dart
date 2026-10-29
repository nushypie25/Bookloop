import 'dart:convert';
import 'verify_otp_page.dart';
import 'api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
const CreateAccountPage({super.key});

@override 
State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
final nameController = TextEditingController();
final usernameController = TextEditingController();
final emailController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

bool isLoading = false;
bool obscurePassword = true;
bool obscureConfirmPassword = true;

final String baseUrl = ApiConfig.baseUrl;

@override
void dispose() {
nameController.dispose();
usernameController.dispose();
emailController.dispose();
phoneController.dispose();
passwordController.dispose();
confirmPasswordController.dispose();
super.dispose();
}

Future<void> createAccount() async {
final name = nameController.text.trim();
final email = emailController.text.trim();
final phone = phoneController.text.trim();
final password = passwordController.text;
final confirmPassword = confirmPasswordController.text;


if (name.isEmpty || email.isEmpty || password.isEmpty) {
  showMessage('Please fill in your name, email and password.');
  return;
}

if (password.length < 8) {
  showMessage('Password must be at least 8 characters long.');
  return;
}

if (password != confirmPassword) {
  showMessage('Passwords do not match.');
  return;
}

setState(() {
  isLoading = true;
});

try {
  final response = await http
      .post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      )
      .timeout(const Duration(seconds: 20));

  final data = jsonDecode(response.body);

  if (!mounted) return;

  if (response.statusCode == 201) {
    showMessage('OTP sent to your email!');

    // OTP verification page will be connected in the next step.
    Navigator.push(
context,
MaterialPageRoute(
builder: (context) => VerifyOtpPage(
email: emailController.text.trim(),
),
),
);

  } else {
    showMessage(data['message'] ?? 'Registration failed.');
  }
} catch (error) {
  if (!mounted) return;

  showMessage(
    'Could not connect to server. Check the backend and IP address.',
  );

  debugPrint('Registration error: $error');
} finally {
  if (mounted) {
    setState(() {
      isLoading = false;
    });
  }
}


}

void showMessage(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(message)),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Create Account'),
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
children: [
const SizedBox(height: 10),
const Icon(
Icons.person_add_rounded,
size: 70,
),
const SizedBox(height: 15),
const Text(
'Join BookLoop',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 25),


        buildField(
          controller: nameController,
          label: 'Full Name',
          icon: Icons.person,
        ),
        const SizedBox(height: 15),

        buildField(
          controller: usernameController,
          label: 'Username',
          icon: Icons.alternate_email,
        ),
        const SizedBox(height: 15),

        buildField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 15),

        buildField(
          controller: phoneController,
          label: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 15),

        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  obscureConfirmPassword =
                      !obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : createAccount,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
        ),
      ],
    ),
  ),
);


}

Widget buildField({
required TextEditingController controller,
required String label,
required IconData icon,
TextInputType keyboardType = TextInputType.text,
}) {
return TextField(
controller: controller,
keyboardType: keyboardType,
decoration: InputDecoration(
labelText: label,
prefixIcon: Icon(icon),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
);
}
}
