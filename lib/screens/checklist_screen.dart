import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final appointment = provider.selectedAppointment;

    if (appointment == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.checklist_outlined,
                size: 64,
                color: AppTheme.lightText,
              ),
              const SizedBox(height: 16),
              Text(
                'Selecione um atendimento',
                style: AppTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    final checklist = appointment.checklist;
    final preVisitItems = checklist.where((c) => c.phase == ChecklistPhase.preVisit).toList();
    final duringItems = checklist.where((c) => c.phase == ChecklistPhase.during).toList();
    final postVisitItems = checklist.where((c) => c.phase == ChecklistPhase.postVisit).toList();

    final completedCount = checklist.where((c) => c.isCompleted).length;
    final progress = completedCount / checklist.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => provider.setCurrentIndex(1),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Checklist de Atendimento',
                              style: AppTheme.headingSmall,
                            ),
                            Text(
                              appointment.customer.name,
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$completedCount/${checklist.length}',
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress Bar
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: progress,
                    backgroundColor: AppTheme.divider,
                    linearGradient: AppTheme.primaryGradient,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppTheme.mediumText,
                      labelStyle: AppTheme.labelSmall.copyWith(fontWeight: FontWeight.w600),
                      tabs: [
                        Tab(text: 'Pré-Visita (${preVisitItems.where((c) => c.isCompleted).length}/${preVisitItems.length})'),
                        Tab(text: 'Durante (${duringItems.where((c) => c.isCompleted).length}/${duringItems.length})'),
                        Tab(text: 'Pós-Visita (${postVisitItems.where((c) => c.isCompleted).length}/${postVisitItems.length})'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChecklistTab(preVisitItems, appointment.id, provider),
                  _buildChecklistTab(duringItems, appointment.id, provider),
                  _buildChecklistTab(postVisitItems, appointment.id, provider),
                ],
              ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCameraDialog(context);
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Capturar Evidência'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryPurple,
                        side: const BorderSide(color: AppTheme.primaryPurple),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: progress == 1.0 ? () {
                        _showCompletionDialog(context);
                      } : null,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Finalizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: progress == 1.0 ? AppTheme.success : AppTheme.divider,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistTab(List<ChecklistItem> items, String appointmentId, AppProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
            border: item.isCompleted
                ? Border.all(color: AppTheme.success.withOpacity(0.5), width: 2)
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  item.isCompleted = !item.isCompleted;
                  if (item.isCompleted) {
                    item.completedAt = DateTime.now();
                  } else {
                    item.completedAt = null;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: item.isCompleted ? AppTheme.primaryGradient : null,
                        color: item.isCompleted ? null : AppTheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: item.isCompleted
                            ? null
                            : Border.all(color: AppTheme.divider, width: 2),
                      ),
                      child: item.isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTheme.labelLarge.copyWith(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCompleted
                                  ? AppTheme.lightText
                                  : AppTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (item.evidence != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppTheme.info,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.camera_alt, color: AppTheme.primaryPurple),
            ),
            const SizedBox(width: 12),
            const Text('Capturar Evidência'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: AppTheme.lightText,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Câmera simulada',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(MVP - Funcionalidade demonstrativa)',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.success, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'IA validará automaticamente a imagem',
                      style: AppTheme.bodySmall.copyWith(color: AppTheme.success),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      const Text('Evidência capturada com sucesso!'),
                    ],
                  ),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Capturar'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.celebration, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Atendimento Concluído!',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Parabéns! Você ganhou +100 pontos',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRewardBadge('⭐', '+100 pts'),
                const SizedBox(width: 16),
                _buildRewardBadge('🏆', 'Nível 5'),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                provider.clearSelectedAppointment();
                provider.setCurrentIndex(0);
              },
              child: const Text('Voltar ao Dashboard'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBadge(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
