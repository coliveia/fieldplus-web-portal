import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final technician = provider.currentTechnician;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          technician.avatar,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      technician.name,
                      style: AppTheme.headingMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Nível ${technician.level} - Técnico Sênior',
                        style: AppTheme.bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('${technician.points}', 'Pontos', Icons.star),
                        _buildStatItem('${technician.rating}', 'Avaliação', Icons.thumb_up),
                        _buildStatItem('${technician.completedToday}', 'Hoje', Icons.check_circle),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Level Progress
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progresso para Nível ${technician.level + 1}', style: AppTheme.labelLarge),
                        Text(
                          '${technician.points}/3000 pts',
                          style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryPurple),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearPercentIndicator(
                      lineHeight: 12,
                      percent: technician.points / 3000,
                      backgroundColor: AppTheme.divider,
                      linearGradient: AppTheme.primaryGradient,
                      barRadius: const Radius.circular(6),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Faltam ${3000 - technician.points} pontos para o próximo nível!',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Achievements Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Conquistas', style: AppTheme.headingSmall),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildListDelegate([
                  _buildAchievementCard('🏆', 'Top 10', true),
                  _buildAchievementCard('⚡', 'Veloz', true),
                  _buildAchievementCard('💯', 'Perfeito', true),
                  _buildAchievementCard('🎯', 'Precisão', false),
                  _buildAchievementCard('🌟', 'Estrela', false),
                  _buildAchievementCard('🚀', 'Foguete', false),
                ]),
              ),
            ),

            // Menu Options
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Configurações', style: AppTheme.headingSmall),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuItem(Icons.person_outline, 'Meus Dados', () {}),
                  _buildMenuItem(Icons.notifications_outlined, 'Notificações', () {}),
                  _buildMenuItem(Icons.help_outline, 'Ajuda', () {}),
                  _buildMenuItem(Icons.info_outline, 'Sobre o App', () {}),
                  _buildMenuItem(Icons.logout, 'Sair', () {}, isDestructive: true),
                ]),
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

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.headingSmall.copyWith(color: Colors.white, fontSize: 20),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(String emoji, String title, bool unlocked) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? AppTheme.cardBackground : AppTheme.divider.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: unlocked ? AppTheme.cardShadow : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 32,
              color: unlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.labelSmall.copyWith(
              color: unlocked ? AppTheme.darkText : AppTheme.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.error : AppTheme.primaryPurple,
        ),
        title: Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: isDestructive ? AppTheme.error : AppTheme.darkText,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? AppTheme.error : AppTheme.lightText,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
