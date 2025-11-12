import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = const Color(0xFFE6E9F2);
    final Color mutedColor = const Color(0xFFA7B0C6);
    final Color accentColor = const Color(0xFF93C5FD);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            // Soft glows to mimic the old hero background ambiance
            Positioned(
              left: -80,
              top: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x5593C5FD),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x4493C5FD),
                      blurRadius: 120,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -100,
              bottom: -100,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x444C1D95),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x334C1D95),
                      blurRadius: 140,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 48,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 96,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 980,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'CIPHERX',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 12,
                                  letterSpacing: 3.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Encrypt. Decode. Secure.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 56,
                                  height: 1.0,
                                  fontWeight: FontWeight.w800,
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x73000000),
                                      blurRadius: 40,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 720,
                                ),
                                child: Text(
                                  'Experience interactive encryption and decryption with a rewarding virtual currency system.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 14,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Pill-shaped primary action
                              SizedBox(
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pushNamed('/dashboard'),
                                  icon: const Icon(
                                    Icons.lock_open,
                                    color: Color(0xFF0F172A),
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .2,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 10,
                                    shadowColor: const Color(0x5960A5FA),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
