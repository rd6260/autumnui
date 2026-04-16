import 'package:flutter/material.dart';

const profileData = ProfileModel(
  name: "Rohan Das",
  username: "rd6260",
  bio: "talk is cheap, show me the code",
  pfp:
      "https://i.pinimg.com/736x/db/af/0c/dbaf0c88a5f007ffb398616ff640abae.jpg",
  banner:
      "https://i.pinimg.com/736x/bd/49/f9/bd49f9bec6002cba48f7fe3942eec143.jpg",
);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4EC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ProfileWidget(profile: profileData),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final ProfileModel profile;

  const ProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 44;
    const double avatarOverlap = 28;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEE1),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner + avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Banner image
              SizedBox(
                height: 110,
                width: double.infinity,
                child: Image.network(
                  profile.banner,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF8BAF6E)),
                ),
              ),

              // Circular avatar — overlaps banner bottom
              Positioned(
                bottom: -avatarOverlap,
                left: 16,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White ring
                    Container(
                      width: avatarRadius * 2 + 6,
                      height: avatarRadius * 2 + 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EEE1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: const Color(0xFFB5C9A2),
                          backgroundImage: NetworkImage(profile.pfp),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ),
                    ),

                    // Red block / remove badge
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xFFE8EEE1), width: 2),
                          ),
                        ),
                        child: const Icon(
                          Icons.catching_pokemon,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sticker badge — to the right of avatar
              Positioned(
                bottom: -avatarOverlap + 4,
                left: 16 + (avatarRadius * 2 + 6) + 8,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('🌿', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            ],
          ),

          // ── Body content ──
          Padding(
            padding: EdgeInsets.only(
              top: avatarOverlap + 10,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + snowflake icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2C1E),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('❄️', style: TextStyle(fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 6),

                // Username • bio + heart + social icons
                Row(
                  children: [
                    Text(
                      profile.username,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555548),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '•',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555548),
                        ),
                      ),
                    ),
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555548),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.favorite_border,
                      size: 15,
                      color: Color(0xFF555548),
                    ),
                    const Spacer(),
                    // Social icons row
                    // const _SocialIcons(),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x152C2822),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: Text(
                          "🌙 🍂 🕯️ 🫧",
                          style: TextStyle(fontSize: 16, wordSpacing: 0),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // CTA button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2822),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      'Follow ${profile.username}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileModel {
  final String name;
  final String username;
  final String bio;
  final String pfp;
  final String banner;

  const ProfileModel({
    required this.name,
    required this.username,
    required this.bio,
    required this.pfp,
    required this.banner,
  });
}
