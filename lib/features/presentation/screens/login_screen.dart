import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:parking_management/features/presentation/screens/home_screen.dart';
import 'package:parking_management/features/presentation/screens/signup_screen.dart';
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';
import 'package:parking_management/features/presentation/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login Here!'),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationLoading) {}
          if (state is AuthenticationSuccess && state.source == 'login') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Login Successfully",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
          if (state is AuthenticationFailure && state.source == 'login') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Invalid Email and password'),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://opengeekslab.com/wp-content/uploads/2021/04/Why-a-Parking-App-Is-the-New-Black.png',
                     width: double.infinity,
                     
                  ),
                  
                  // Center(
                  //   child: Text(
                  //     'Welcome Back!',
                  //     style: TextStyle(
                  //       fontSize: 28,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.teal,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Welcome Back!',
                      
                      
                      style: TextStyle(fontSize: 28, color: Colors.teal,fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SignupTextFormField(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.teal),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SignupTextFormField(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.teal),
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'Forgot Password?',
                  //       style: TextStyle(color: Colors.teal),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _onLoginRequested();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          'Sign Up',
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
      ),
    );
  }

  void _onLoginRequested() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(LoginRequested(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          source: 'login'));
    }
  }
}
