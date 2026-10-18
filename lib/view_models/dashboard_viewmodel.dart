import 'package:flutter/material.dart';
import 'package:wazuh_mobile_monitor/models/dashboard_model.dart';
import 'package:wazuh_mobile_monitor/repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository dashboardRepository;

  DashboardViewModel({required this.dashboardRepository});

  bool _isLoading = false;
  String? _errorMessage;
  DashboardSummary? _summary;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardSummary? get summary => _summary;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await dashboardRepository.fetchDashboardData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
