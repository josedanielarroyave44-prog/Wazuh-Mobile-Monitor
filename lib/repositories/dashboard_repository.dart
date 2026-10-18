import 'package:wazuh_mobile_monitor/models/dashboard_model.dart';
import 'package:wazuh_mobile_monitor/repositories/auth_repository.dart';

class DashboardRepository {
  final AuthRepository authRepository;

  DashboardRepository({required this.authRepository});

  Future<DashboardSummary> fetchDashboardData() async {
    try {
      final statusResponse = await authRepository.makeAuthenticatedRequest(
        '/agents/summary/status',
      );

      final connectionData = statusResponse['data']?['connection'] ?? {};
      final int active = connectionData['active'] ?? 0;
      final int disconnected = connectionData['disconnected'] ?? 0;
      final int neverConnected = connectionData['never_connected'] ?? 0;
      final int total =
          connectionData['total'] ?? (active + disconnected + neverConnected);

      final agentsResponse = await authRepository.makeAuthenticatedRequest(
        '/agents?select=id,name,ip,status&limit=500',
      );

      final List<dynamic> affectedAgents =
          agentsResponse['data']?['affected_items'] ?? [];

      final List<TopAgent> realAgents = affectedAgents
          .where((agent) => agent['id'] != '000')
          .map<TopAgent>((agent) {
            return TopAgent(
              name: agent['name']?.toString() ?? 'Agente sin nombre',
              alertCount: 0,
            );
          })
          .toList();

      if (realAgents.isEmpty && affectedAgents.isNotEmpty) {
        for (final agent in affectedAgents) {
          realAgents.add(
            TopAgent(
              name: agent['name']?.toString() ?? 'Wazuh Manager',
              alertCount: 0,
            ),
          );
        }
      }

      int highAlertsCount = 0;
      int criticalAlertsCount = 0;

      try {
        final statsResponse = await authRepository.makeAuthenticatedRequest(
          '/manager/stats',
        );
        final List<dynamic> statsItems =
            statsResponse['data']?['affected_items'] ?? [];

        for (final hourStat in statsItems) {
          final List<dynamic> alertsList = hourStat['alerts'] ?? [];
          for (final alert in alertsList) {
            final int level = alert['level'] ?? 0;
            final int times = alert['times'] ?? 0;

            if (level >= 10 && level <= 11) {
              highAlertsCount += times;
            } else if (level >= 12) {
              criticalAlertsCount += times;
            }
          }
        }
      } catch (_) {}

      return DashboardSummary(
        totalAgents: total,
        activeAgents: active,
        disconnectedAgents: disconnected,
        neverConnectedAgents: neverConnected,
        highAlerts: highAlertsCount,
        criticalAlerts: criticalAlertsCount,
        topAgents: realAgents,
      );
    } catch (e) {
      throw Exception('Error obtaining dashboard data: $e');
    }
  }
}
