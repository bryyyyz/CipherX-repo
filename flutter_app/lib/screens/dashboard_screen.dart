import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEAF2FF)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1224), Color(0xFF0A1224)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ambient glows similar to the HTML version
            Positioned(
              left: -120,
              top: -100,
              child: _GlowCircle(color: const Color(0x5958C7F8), size: 380),
            ),
            Positioned(
              right: -140,
              bottom: -120,
              child: _GlowCircle(color: const Color(0x4D7C3AED), size: 460),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Title(),
                            const SizedBox(height: 32),
                            const _SectionHeading(text: 'Cipher Tools'),
                            const SizedBox(height: 20),
                            // Cipher cards in a vertical list for better visibility
                            const _FeatureCard(
                              accent: Color(0xFF60A5FA),
                              pill: 'Cipher',
                              title: 'Caesar Cipher',
                              description:
                                  'Shift letters forward or backward to encrypt or decode messages.',
                              icon: Icons.lock_outline,
                              routeName: '/cipher/caesar',
                            ),
                            const SizedBox(height: 16),
                            const _FeatureCard(
                              accent: Color(0xFFA78BFA),
                              pill: 'Cipher',
                              title: 'Vigenère Cipher',
                              description:
                                  'Use a keyword to encode or decode alphabetic text securely.',
                              icon: Icons.vpn_key_outlined,
                              routeName: '/cipher/vigenere',
                            ),
                            const SizedBox(height: 16),
                            const _FeatureCard(
                              accent: Color(0xFF22D3EE),
                              pill: 'Cipher',
                              title: 'Atbash Cipher',
                              description:
                                  'Mirror substitution cipher: A↔Z, B↔Y for quick encoding.',
                              icon: Icons.swap_horiz_outlined,
                              routeName: '/cipher/atbash',
                            ),
                            const SizedBox(height: 40),
                            const _SectionHeading(text: 'Tools & Fun'),
                            const SizedBox(height: 20),
                            // Tools and fun cards in same vertical list layout
                            const _FeatureCard(
                              accent: Color(0xFF34D399),
                              pill: 'Tool',
                              title: 'Currency',
                              description:
                                  'Live exchange rates and quick conversions across major currencies worldwide.',
                              icon: Icons.attach_money_outlined,
                              routeName: '/currency',
                            ),
                            const SizedBox(height: 16),
                            const _FeatureCard(
                              accent: Color(0xFF60A5FA),
                              pill: 'Tool',
                              title: 'Calculator',
                              description:
                                  'Fast arithmetic calculations for quick math operations while you work.',
                              icon: Icons.calculate_outlined,
                              routeName: '/calculator',
                            ),
                            const SizedBox(height: 16),
                            const _FeatureCard(
                              accent: Color(0xFFFB7185),
                              pill: 'Fun',
                              title: 'Random Jokes',
                              description:
                                  'Lighten up your day with safe-mode jokes fetched from JokeAPI.',
                              icon: Icons.emoji_emotions_outlined,
                              routeName: '/jokes',
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Do you want to Encrypt or Decode messages?',
      style: const TextStyle(
        color: Color(0xFFEAF2FF),
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: .3,
        shadows: [
          Shadow(
            color: Color(0x59000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFD8E7FF),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: .2,
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.accent,
    required this.pill,
    required this.title,
    required this.description,
    this.routeName,
    this.disabled = false,
    this.icon,
  });

  final Color accent;
  final String pill;
  final String title;
  final String description;
  final String? routeName;
  final bool disabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool isClickable = routeName != null && !disabled;
    final Color borderColor = accent;
    final Color pillBg = Color.alphaBlend(
      accent.withOpacity(.22),
      Colors.white,
    );
    final Color pillBorder = Color.alphaBlend(
      accent.withOpacity(.6),
      Colors.white,
    );

    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xF7FFFFFF),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Icon on the left
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon ?? Icons.lock_outline, color: accent, size: 32),
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: pillBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: pillBorder, width: 1),
                      ),
                      child: Text(
                        pill.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF06121A),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .4,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (disabled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(
                            color: accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      Icon(Icons.arrow_forward_ios, color: accent, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0B1324),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isClickable) {
      card = InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(routeName!),
        child: card,
      );
    }

    return card;
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: size / 3, spreadRadius: size / 6),
        ],
      ),
    );
  }
}
