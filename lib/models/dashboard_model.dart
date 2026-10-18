class TopAgent {
  final String name;
  final int alertCount;

  const TopAgent({required this.name, required this.alertCount});
}

class DashboardSummary {
  final int totalAgents;
  final int activeAgents;
  final int disconnectedAgents;
  final int neverConnectedAgents;
  final int highAlerts;
  final int criticalAlerts;
  final List<TopAgent> topAgents;

  const DashboardSummary({
    required this.totalAgents,
    required this.activeAgents,
    required this.disconnectedAgents,
    required this.neverConnectedAgents,
    required this.highAlerts,
    required this.criticalAlerts,
    required this.topAgents,
  });
}
