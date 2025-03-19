import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/domain/repositories/shared_prefrence.dart';
import 'package:parking_management/features/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:parking_management/features/presentation/screens/login_screen.dart';
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';
import 'package:parking_management/features/presentation/widgets/snackbar.dart';
import 'package:parking_management/features/presentation/widgets/textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Create Account',
        showBackButton: true,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationSuccess && state.source == 'signup') {
            await SharedPrefrenceHelper().saveUserName(nameController.text);
            await SharedPrefrenceHelper().saverUserEmail(emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Signup Successfully",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is AuthenticationFailure) {
            showSnackbar(context, state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network('https://www.mindinventory.com/blog/wp-content/uploads/2022/10/car-parking-app.png'),
              
                const SizedBox(height: 40),
                SignupTextFormField(
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  controller: nameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your username' : null,
                ),
                const SizedBox(height: 20),
                SignupTextFormField(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: Colors.teal),
                    controller: emailController,
                    validator: emailValidator),
                const SizedBox(height: 20),
                SignupTextFormField(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                    controller: passwordController,
                    obscureText: true,
                    validator: passwordValidator),
                const SizedBox(height: 20),
                SignupTextFormField(
                  hintText: 'Confirm Password',
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.teal),
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (value) =>
                      confirmPasswordValidator(value, passwordController.text),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthenticationBloc>().add(SignupRequested(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            source: 'signup'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
