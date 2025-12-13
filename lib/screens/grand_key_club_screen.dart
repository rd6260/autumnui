
import 'package:flutter/material.dart';

class GrandKeyClubScreen extends StatelessWidget {
  const GrandKeyClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5E8),
      body: SafeArea(
        child: Column(
          children: [
            // Header with wine tasting event
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2D5A4A),
                    Color(0xFF1A3D32),
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/wine_bg.jpg'), // You'll need to add this image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3),
                    BlendMode.overlay,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 24,
                        ),
                        Text(
                          'Grand Key Club',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 24),
                      ],
                    ),
                    Spacer(),
                    // Event info
                    Text(
                      '10/10/2019',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'October Wine Tasting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LEARN MORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Feature cards section
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    FeatureCard(
                      icon: Icons.people_outline,
                      title: 'Mobile CRM',
                      color: Colors.white,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    FeatureCard(
                      icon: Icons.golf_course,
                      title: 'Tee Time',
                      color: Color(0xFF4CAF50),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                    FeatureCard(
                      icon: Icons.folder_outlined,
                      title: 'Directory',
                      color: Colors.white,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    FeatureCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Calendar',
                      color: Colors.white,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    FeatureCard(
                      icon: Icons.restaurant_outlined,
                      title: 'Dining\nReservation',
                      color: Colors.white,
                      iconColor: Color(0xFF4CAF50),
                    ),
                    FeatureCard(
                      icon: Icons.receipt_outlined,
                      title: 'Billing',
                      color: Colors.white,
                      iconColor: Color(0xFF4CAF50),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color iconColor;
  final Color? textColor;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? Color(0xFF666666),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
