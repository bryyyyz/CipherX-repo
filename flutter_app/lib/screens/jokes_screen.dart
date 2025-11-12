import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});
  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  String? joke;
  bool loading = false;

  Future<void> _fetchJoke() async {
    setState(() {
      loading = true;
    });
    try {
      final res = await http
          .get(Uri.parse('https://v2.jokeapi.dev/joke/Any?safe-mode'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        if (data['type'] == 'single') {
          joke = data['joke'] as String?;
        } else if (data['type'] == 'twopart') {
          joke = '${data['setup']} — ${data['delivery']}';
        } else {
          joke = 'No joke received.';
        }
      } else {
        joke = 'Could not fetch a joke right now.';
      }
    } catch (_) {
      joke = 'Could not fetch a joke right now.';
    } finally {
      if (mounted) setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchJoke();
  }

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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Random Joke',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEAF2FF),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF60A5FA),
                        )
                      : _GlassCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                joke ?? 'Tap refresh to get a joke.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFEAF2FF),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _AnotherOneButton(onPressed: _fetchJoke),
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

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F30).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AnotherOneButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AnotherOneButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFB7185), Color(0xFFEF4444)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFFFB7185).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Another one',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

