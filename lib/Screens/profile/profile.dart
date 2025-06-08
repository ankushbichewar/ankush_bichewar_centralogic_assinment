import 'package:ankush_bichewar_centralogic_assinment/services/user_data_storage.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../login/login_page.dart';
import 'package:ankush_bichewar_centralogic_assinment/controllers/route_animation.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final LogindataStorage _storage = LogindataStorage();
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _storage.getUser();
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _storage.clearUser();
    Navigator.pushReplacement(
      context,
      RouteAnimations.slideFromRight(const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(color: Colors.white70, fontSize: 18);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _user == null
              ? Center(
                  child: Text(
                    'No user data found!',
                    style: textStyle.copyWith(fontSize: 20),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.amber,
                        child: Text(
                          _user!.name.isNotEmpty
                              ? _user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _user!.name,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Divider(color: Colors.amber.shade200),
                      const SizedBox(height: 15),
                      _infoRow(Icons.email, 'Email', _user!.email),
                      const SizedBox(height: 12),
                      _infoRow(Icons.lock, 'Password', '*' * _user!.password.length),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 28),
        const SizedBox(width: 15),
        Text(
          '$label:',
          style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
