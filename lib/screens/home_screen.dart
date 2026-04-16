import 'package:autumnui/screens/grand_key_club_screen.dart';
import 'package:autumnui/screens/music_companion_screen.dart';
import 'package:autumnui/screens/neumorphic_design_1_screen.dart';
import 'package:autumnui/screens/pinterest_screen.dart';
import 'package:autumnui/screens/profile_screen.dart';
import 'package:autumnui/screens/static_glow_element.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> screens = [
    {
      "screen": MusicCompanionScreen(),
      "title": "Music Companion Screen",
      "description": "Music Companion Screen",
    },
    {
      "screen": NeumorphicDesign1Screen(),
      "title": "Neumorphic Design 01",
      "description": "Neumorphic Design 01",
    },
    {
      "screen": StaticGlowElement(),
      "title": "Static Glowing element",
      "description": "static glowing element",
    },
    {
      "screen": GrandKeyClubScreen(),
      "title": "Grand Key Club",
      "description": "Grand Key Club",
    },
    {
      "screen": PinterestScreen(),
      "title": "Pinterest Screen",
      "description": "A pinterest style photo gallery",
    },
    {
      "screen": ProfileScreen(),
      "title": "Profile Screen",
      "description": "a profile screen",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'UI Screens',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final screen = screens[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildScreenCard(
                      context,
                      screen['title'] as String,
                      screen['description'] as String,
                      screen['screen'] as Widget,
                      index,
                    ),
                  );
                }, childCount: screens.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenCard(
    BuildContext context,
    String title,
    String description,
    Widget screenWidget,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screenWidget),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF1A1A1A), const Color(0xFF151515)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screenWidget),
                );
              },
              splashColor: Colors.white.withValues(alpha: 0.05),
              highlightColor: Colors.white.withValues(alpha: 0.02),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6366F1).withValues(alpha: 0.8),
                            Color(0xFF8B5CF6).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6366F1).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
