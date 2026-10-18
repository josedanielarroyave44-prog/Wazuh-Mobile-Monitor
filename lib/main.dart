import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazuh_mobile_monitor/services/wazuh_auth_service.dart';
import 'package:wazuh_mobile_monitor/repositories/auth_repository.dart';
import 'package:wazuh_mobile_monitor/view_models/auth_viewmodel.dart';
import 'package:wazuh_mobile_monitor/views/login_view.dart';
import 'package:wazuh_mobile_monitor/services/wazuh_api_service.dart';
import 'package:wazuh_mobile_monitor/repositories/dashboard_repository.dart';
import 'package:wazuh_mobile_monitor/view_models/dashboard_viewmodel.dart';

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
        Provider(create: (_) => WazuhApiService()),
        Provider(
          create: (context) => AuthRepository(
            authService: context.read<WazuhAuthService>(),
            apiService: context.read<WazuhApiService>(),
          ),
        ),
        Provider(
          create: (context) => DashboardRepository(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(
            dashboardRepository: context.read<DashboardRepository>(),
          ),
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
