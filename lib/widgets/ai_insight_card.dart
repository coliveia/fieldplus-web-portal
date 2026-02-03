import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class AIInsightCard extends StatelessWidget {
  final AIInsight insight;

  const AIInsightCard({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: _getInsightColor(insight.type).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getInsightColor(insight.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getInsightIcon(insight.type),
              color: _getInsightColor(insight.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTheme.labelLarge.copyWith(
                    color: _getInsightColor(insight.type),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: AppTheme.bodySmall,
                ),
                if (insight.action != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getInsightColor(insight.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          insight.action!,
                          style: AppTheme.labelSmall.copyWith(
                            color: _getInsightColor(insight.type),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: _getInsightColor(insight.type),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.alert:
        return AppTheme.error;
      case InsightType.warning:
        return AppTheme.warning;
      case InsightType.tip:
        return AppTheme.info;
      case InsightType.recommendation:
        return AppTheme.success;
    }
  }

  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.alert:
        return Icons.warning_amber_rounded;
      case InsightType.warning:
        return Icons.info_outline;
      case InsightType.tip:
        return Icons.lightbulb_outline;
      case InsightType.recommendation:
        return Icons.auto_awesome;
    }
  }
}
