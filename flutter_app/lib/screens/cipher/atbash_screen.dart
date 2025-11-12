import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logic/cipher.dart';

class AtbashScreen extends StatefulWidget {
  const AtbashScreen({super.key});

  @override
  State<AtbashScreen> createState() => _AtbashScreenState();
}

class _AtbashScreenState extends State<AtbashScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String output = CipherLogic.atbash(_inputController.text);
    const Color accentColor = Color(0xFF22D3EE);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Atbash Cipher'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEAF2FF)),
        titleTextStyle: const TextStyle(
          color: Color(0xFFEAF2FF),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1224),
              Color(0xFF0F172A),
              Color(0xFF0A1224),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Modern gradient orbs
            Positioned(
              left: -150,
              top: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withOpacity(0.2),
                      accentColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -180,
              bottom: -180,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7C3AED).withOpacity(0.15),
                      const Color(0xFF7C3AED).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Modern header
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor.withOpacity(0.1),
                                accentColor.withOpacity(0.05),
                              ],
                            ),
                            border: Border.all(
                              color: accentColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      accentColor.withOpacity(0.3),
                                      accentColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: accentColor.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.swap_horiz_outlined,
                                  color: Color(0xFF22D3EE),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Atbash Cipher',
                                      style: TextStyle(
                                        color: Color(0xFFEAF2FF),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Mirror substitution: A↔Z, B↔Y',
                                      style: TextStyle(
                                        color: const Color(0xFFA7B0C6).withOpacity(0.9),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Input card
                        _ModernCard(
                          accentColor: accentColor,
                          title: 'Input Text',
                          icon: Icons.edit_outlined,
                          actions: [
                            _ModernIconButton(
                              icon: Icons.clear_rounded,
                              color: const Color(0xFFA7B0C6),
                              onPressed: () {
                                _inputController.clear();
                                setState(() {});
                              },
                            ),
                          ],
                          child: TextField(
                            controller: _inputController,
                            maxLines: null,
                            minLines: 5,
                            style: const TextStyle(
                              color: Color(0xFFEAF2FF),
                              fontSize: 16,
                              height: 1.6,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type or paste your text here...',
                              hintStyle: TextStyle(
                                color: const Color(0xFFA7B0C6).withOpacity(0.5),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => setState(() {}),
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Result card
                        _ModernCard(
                          accentColor: accentColor,
                          title: 'Result',
                          icon: Icons.check_circle_outline,
                          actions: [
                            if (output.isNotEmpty)
                              _ModernIconButton(
                                icon: Icons.copy_all_rounded,
                                color: accentColor,
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: output),
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: accentColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          const Text('Copied to clipboard'),
                                        ],
                                      ),
                                      backgroundColor: const Color(0xFF1A1F30),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                },
                              ),
                          ],
                          child: output.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.text_fields_outlined,
                                          color: const Color(0xFFA7B0C6).withOpacity(0.4),
                                          size: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Enter text above to see the result',
                                          style: TextStyle(
                                            color: const Color(0xFFA7B0C6).withOpacity(0.6),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: accentColor.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: SelectableText(
                                    output,
                                    style: const TextStyle(
                                      color: Color(0xFFD8E7FF),
                                      fontSize: 17,
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernCard extends StatelessWidget {
  const _ModernCard({
    required this.accentColor,
    required this.title,
    required this.child,
    this.icon,
    this.actions,
  });

  final Color accentColor;
  final String title;
  final Widget child;
  final IconData? icon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1F30).withOpacity(0.8),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
            spreadRadius: -5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFEAF2FF),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
          const SizedBox(height: 20),
          DefaultTextStyle(
            style: const TextStyle(color: Color(0xFFD8E7FF)),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ModernIconButton extends StatelessWidget {
  const _ModernIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
