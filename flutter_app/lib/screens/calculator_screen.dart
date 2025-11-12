import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '0';

  static const List<_CalcButton> buttons = [
    _CalcButton(label: 'C', type: _BtnType.clear),
    _CalcButton(label: '('),
    _CalcButton(label: ')'),
    _CalcButton(label: '÷', type: _BtnType.op, value: '/'),
    _CalcButton(label: '7'),
    _CalcButton(label: '8'),
    _CalcButton(label: '9'),
    _CalcButton(label: '×', type: _BtnType.op, value: '*'),
    _CalcButton(label: '4'),
    _CalcButton(label: '5'),
    _CalcButton(label: '6'),
    _CalcButton(label: '−', type: _BtnType.op, value: '-'),
    _CalcButton(label: '1'),
    _CalcButton(label: '2'),
    _CalcButton(label: '3'),
    _CalcButton(label: '+', type: _BtnType.op, value: '+'),
    _CalcButton(label: '0'),
    _CalcButton(label: '.'),
    _CalcButton(label: '=', type: _BtnType.equal),
  ];

  void _onPress(_CalcButton b) {
    setState(() {
      if (b.type == _BtnType.clear) {
        expression = '0';
        return;
      }
      if (b.type == _BtnType.equal) {
        _calculate();
        return;
      }
      final v = b.value ?? b.label;
      expression = (expression == '0' || expression == 'Error') ? v : expression + v;
    });
  }

  void _calculate() {
    try {
      final normalized = expression.replaceAll('÷', '/').replaceAll('×', '*').replaceAll('−', '-');
      final exp = Parser().parse(normalized);
      final result = exp.evaluate(EvaluationType.REAL, ContextModel());
      expression = _stripTrailingZeros(result);
    } catch (_) {
      expression = 'Error';
    }
  }

  String _stripTrailingZeros(num value) {
    final s = value.toString();
    if (s.contains('.')) {
      final t = s.replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1').replaceAll(RegExp(r'\.$'), '');
      return t.isEmpty ? '0' : t;
    }
    return s;
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Calculator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEAF2FF),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    child: _GlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Display(text: expression),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: buttons.length,
                            itemBuilder: (context, i) {
                              final b = buttons[i];
                              return _CalcButtonWidget(button: b, onPressed: () => _onPress(b));
                            },
                          ),
                        ],
                      ),
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

enum _BtnType { normal, op, clear, equal }

class _CalcButton {
  final String label;
  final _BtnType type;
  final String? value;
  const _CalcButton({required this.label, this.type = _BtnType.normal, this.value});
}

class _CalcButtonWidget extends StatelessWidget {
  final _CalcButton button;
  final VoidCallback onPressed;
  const _CalcButtonWidget({required this.button, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isOp = button.type == _BtnType.op;
    final isEqual = button.type == _BtnType.equal;
    final isClear = button.type == _BtnType.clear;

    Color bg;
    Color fg;
    
    if (isEqual) {
      bg = const Color(0xFF60A5FA);
      fg = Colors.white;
    } else if (isClear) {
      bg = const Color(0xFFFB7185).withOpacity(0.2);
      fg = const Color(0xFFFB7185);
    } else if (isOp) {
      bg = const Color(0xFF60A5FA).withOpacity(0.2);
      fg = const Color(0xFF60A5FA);
    } else {
      bg = const Color(0xFF1A1F30).withOpacity(0.6);
      fg = const Color(0xFFEAF2FF);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(isOp || isEqual ? 0.2 : 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              if (isEqual || isOp)
                BoxShadow(
                  color: bg.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 0),
                ),
            ],
          ),
          child: Center(
            child: Text(
              button.label,
              style: TextStyle(
                fontWeight: isOp || isEqual ? FontWeight.bold : FontWeight.w500,
                fontSize: 18,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Display extends StatelessWidget {
  final String text;
  const _Display({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      alignment: Alignment.centerRight,
      constraints: const BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F30).withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Color(0xFFEAF2FF),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.right,
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
      padding: const EdgeInsets.all(20),
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

