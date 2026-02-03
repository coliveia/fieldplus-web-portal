import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Time Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('HH:mm').format(appointment.scheduledTime),
                            style: AppTheme.labelLarge.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Customer Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.customer.name,
                                  style: AppTheme.labelLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildTemperatureIndicator(appointment.customer.temperature),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.type,
                            style: AppTheme.bodySmall.copyWith(
                              color: _getTypeColor(appointment.type),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  appointment.description,
                  style: AppTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Address Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.primaryPurple,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appointment.customer.address,
                          style: AppTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.navigation_outlined,
                              color: AppTheme.primaryPurple,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Navegar',
                              style: AppTheme.labelSmall.copyWith(
                                color: AppTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Products Row
                Row(
                  children: [
                    ...appointment.customer.products.take(3).map((product) => 
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.lightPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getProductIcon(product.type),
                              size: 14,
                              color: AppTheme.primaryPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.type,
                              style: AppTheme.labelSmall.copyWith(
                                color: AppTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.lightText,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 14)),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'reparo urgente':
        return AppTheme.error;
      case 'reparo':
        return AppTheme.warning;
      case 'instalação':
        return AppTheme.success;
      case 'manutenção':
        return AppTheme.info;
      case 'upgrade':
        return AppTheme.primaryPurple;
      default:
        return AppTheme.mediumText;
    }
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
}
