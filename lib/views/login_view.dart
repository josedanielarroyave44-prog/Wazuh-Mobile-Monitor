import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazuh_mobile_monitor/view_models/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
} //login widget

class _LoginViewState extends State<LoginView> {
  final _ipController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wazuh Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Manager IP Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'API User',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password API',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            if (authVM.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  authVM.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Lab Mode (Unsafe)'),
              subtitle: const Text('Allow Selfsigned Certificates'),
              value: authVM.allowSelfSigned,
              onChanged: (bool value) {
                authVM.toggleSelfSigned(value);
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: authVM.isLoading
                  ? null
                  : () async {
                      String ip = _ipController.text;
                      String username = _userController.text;
                      String password = _passController.text;

                      bool success = await authVM.login(
                        ip: ip,
                        username: username,
                        password: password,
                      );

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Connection succesful! Token Obtained',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              child: authVM.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
} //login widget state
