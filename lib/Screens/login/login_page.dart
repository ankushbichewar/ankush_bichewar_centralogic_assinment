import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_event.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_state.dart';
import 'package:ankush_bichewar_centralogic_assinment/services/user_data_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/auth_bloc.dart';
import 'package:ankush_bichewar_centralogic_assinment/controllers/route_animation.dart';
import '../home/home_page.dart';
import 'register_page.dart';
import '../../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool remember = false;
  bool _obscurePassword = true;

  final LogindataStorage _storage = LogindataStorage();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Fire login event to AuthBloc
    context.read<AuthBloc>().add(LoginEvent(email, password));
  }

  Future<void> _saveUserData(String email) async {
    // You can adjust this as per your real user data
    final user = UserModel(name: "User", email: email, password: ""); 
    await _storage.saveUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            // Save user data on successful login
            await _saveUserData(emailController.text.trim());

            Navigator.pushReplacement(
              context,
              RouteAnimations.slideFromRight(const HomePage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 150),
                      const Text('Welcome Back',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD4AF37))),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD4AF37)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                hintText: 'Email/Phone',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: remember,
                                  onChanged: (val) {
                                    setState(() {
                                      remember = val!;
                                    });
                                  },
                                  activeColor: const Color(0xFFD4AF37),
                                ),
                                const Text(
                                  'Remember Me',
                                  style: TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 217,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                      return const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Forgot Password ?',
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don’t have account? ',
                                    style: TextStyle(color: Colors.white)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      RouteAnimations.slideFromRight(const RegisterPage()),
                                    );
                                  },
                                  child: const Text('Create one',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
