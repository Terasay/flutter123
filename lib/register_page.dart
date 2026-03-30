import 'package:flutter/material.dart';

import 'auth/local_auth_db.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _isPolicyAccepted = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isSubmitting) {
      return;
    }

    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    if (account.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }
    if (password != repeatPassword) {
      _showMessage('Passwords do not match');
      return;
    }
    if (!_isPolicyAccepted) {
      _showMessage('Please agree with User Privacy Policy');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final registered = await LocalAuthDb.instance.register(
      account: account,
      password: password,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (!registered) {
      _showMessage('Account already exists or invalid data');
      return;
    }

    await LocalAuthDb.instance.setCurrentAccount(account);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/awrar.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x19000000),
                  Color(0x3D000000),
                  Color(0x63000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white70,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/images/logo.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 360),
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.46),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _accountController,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF4F4F4),
                                  hintText: 'Please enter your account',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF4F4F4),
                                  hintText: 'Please enter your password',
                                  prefixIcon: Icon(Icons.visibility_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _repeatPasswordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.black87),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF4F4F4),
                                  hintText: 'Please repeat your password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isPolicyAccepted,
                                    onChanged: (value) {
                                      setState(() {
                                        _isPolicyAccepted = value ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFFF3C406),
                                    side: const BorderSide(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'I have read and agreed ',
                                          ),
                                          TextSpan(
                                            text: 'User Privacy Policy',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF3C406),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Register'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
