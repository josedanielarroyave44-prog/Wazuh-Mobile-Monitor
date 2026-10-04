import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazuh_mobile_monitor/services/wazuh_auth_service.dart';
import 'package:wazuh_mobile_monitor/repositories/auth_repository.dart';
import 'package:wazuh_mobile_monitor/view_models/auth_viewmodel.dart';
import 'package:wazuh_mobile_monitor/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => WazuhAuthService()),
        Provider(
          create: (context) =>
              AuthRepository(authService: context.read<WazuhAuthService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthViewModel(authRepository: context.read<AuthRepository>()),
        ),
      ],
      child: const MaterialApp(title: 'Wazuh Monitor', home: LoginView()),
    );
  }
}
