import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/appointment_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/technician_header.dart';
import '../widgets/ai_tooltip.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showAITip = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final technician = provider.currentTechnician;
    final appointments = provider.todayAppointments;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: TechnicianHeader(technician: technician),
                ),
                
                // Stats Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            icon: Icons.check_circle_outline,
                            value: '${technician.completedToday}/${technician.totalAppointments}',
                            label: 'Atendimentos',
                            color: AppTheme.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.star_outline,
                            value: '${technician.points}',
                            label: 'Pontos',
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatsCard(
                            icon: Icons.trending_up,
                            value: '${technician.rating}',
                            label: 'Avaliação',
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildQuickActions(context),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Atendimentos de Hoje',
                          style: AppTheme.headingSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('dd MMM', 'pt_BR').format(DateTime.now()),
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Appointments List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final appointment = appointments[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppointmentCard(
                            appointment: appointment,
                            onTap: () {
                              provider.selectAppointment(appointment);
                              Navigator.pushNamed(context, '/visit-timeline');
                            },
                          ),
                        );
                      },
                      childCount: appointments.length,
                    ),
                  ),
                ),

                // Bottom Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),

            // AI Tooltip
            if (_showAITip)
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: AITooltip(
                  message: 'Você tem 2 atendimentos com clientes "hot" hoje. Priorize eles para melhorar seu NPS!',
                  type: AITooltipType.recommendation,
                  actionLabel: 'Ver Prioridades',
                  onAction: () {
                    setState(() => _showAITip = false);
                  },
                  onDismiss: () {
                    setState(() => _showAITip = false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: AppTheme.primaryPurple, size: 20),
              const SizedBox(width: 8),
              Text('Acesso Rápido', style: AppTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                context,
                icon: Icons.build,
                label: 'Magic Tools',
                color: AppTheme.primaryPurple,
                route: '/magic-tools',
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.support_agent,
                label: 'Chat CO',
                color: Colors.blue,
                route: '/co-chat',
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.warning_amber,
                label: 'Exceções',
                color: AppTheme.warning,
                route: '/exceptions',
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.verified,
                label: 'Certificar',
                color: AppTheme.success,
                route: '/certification',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTheme.labelSmall.copyWith(
                color: AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
