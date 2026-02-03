import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/ai_insight_card.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

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
                Icons.touch_app_outlined,
                size: 64,
                color: AppTheme.lightText,
              ),
              const SizedBox(height: 16),
              Text(
                'Selecione um atendimento',
                style: AppTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Toque em um card no Dashboard',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    final customer = appointment.customer;
    final insights = provider.getInsightsForCustomer(customer);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.cardBackground,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  provider.clearSelectedAppointment();
                  provider.setCurrentIndex(0);
                },
              ),
              title: Text(
                'Contexto 360°',
                style: AppTheme.headingSmall,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.phone_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
              ],
            ),

            // Customer Header
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text('👤', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: AppTheme.headingSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildTemperatureIndicator(customer.temperature),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Cliente há ${customer.yearsAsCustomer} ${customer.yearsAsCustomer == 1 ? 'ano' : 'anos'}',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              customer.address,
                              style: AppTheme.bodySmall.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI Insights Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: AppTheme.primaryPurple,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'I.Ajuda - Insights',
                      style: AppTheme.headingSmall,
                    ),
                  ],
                ),
              ),
            ),

            // AI Insights Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AIInsightCard(insight: insights[index]),
                    );
                  },
                  childCount: insights.length,
                ),
              ),
            ),

            // Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Produtos Contratados',
                  style: AppTheme.headingSmall,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = customer.products[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.lightPurple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getProductIcon(product.type),
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name, style: AppTheme.labelLarge),
                                const SizedBox(height: 4),
                                Text(
                                  'Desde ${DateFormat('MMM yyyy', 'pt_BR').format(product.installDate)}',
                                  style: AppTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.status,
                              style: AppTheme.labelSmall.copyWith(
                                color: AppTheme.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: customer.products.length,
                ),
              ),
            ),

            // Service History Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Histórico de Atendimentos',
                  style: AppTheme.headingSmall,
                ),
              ),
            ),

            if (customer.serviceHistory.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Nenhum histórico de atendimento',
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final history = customer.serviceHistory[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getHistoryColor(history.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getHistoryIcon(history.type),
                                color: _getHistoryColor(history.type),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(history.type, style: AppTheme.labelLarge),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(history.date),
                                        style: AppTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    history.description,
                                    style: AppTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Técnico: ${history.technicianName}',
                                    style: AppTheme.labelSmall.copyWith(
                                      color: AppTheme.primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: customer.serviceHistory.length,
                  ),
                ),
              ),

            // Start Service Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    provider.setCurrentIndex(2); // Go to checklist
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Iniciar Atendimento',
                        style: AppTheme.labelLarge.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureIndicator(CustomerTemperature temp) {
    Color color;
    String emoji;
    switch (temp) {
      case CustomerTemperature.hot:
        color = AppTheme.tempHot;
        emoji = '🔥';
        break;
      case CustomerTemperature.warm:
        color = AppTheme.tempWarm;
        emoji = '⚠️';
        break;
      case CustomerTemperature.cool:
        color = AppTheme.tempCool;
        emoji = '✅';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 14)),
    );
  }

  IconData _getProductIcon(String type) {
    switch (type.toLowerCase()) {
      case 'internet':
        return Icons.wifi;
      case 'tv':
        return Icons.tv;
      case 'voz':
        return Icons.phone;
      default:
        return Icons.devices;
    }
  }

  IconData _getHistoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'instalação':
        return Icons.build;
      case 'reparo':
        return Icons.handyman;
      case 'reclamação':
        return Icons.warning_amber;
      default:
        return Icons.history;
    }
  }

  Color _getHistoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'instalação':
        return AppTheme.success;
      case 'reparo':
        return AppTheme.warning;
      case 'reclamação':
        return AppTheme.error;
      default:
        return AppTheme.info;
    }
  }
}
