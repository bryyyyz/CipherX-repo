import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});
  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final amountCtrl = TextEditingController(text: '1');
  String from = 'USD';
  String to = 'EUR';
  double? rate;
  double? converted;
  String? localTime;

  static const frankfurter = 'https://api.frankfurter.app/latest';
  static const worldTime = 'https://worldtimeapi.org/api/timezone/';

  static const currencyToCity = {
    "USD": "America/New_York",
    "CAD": "America/Toronto",
    "MXN": "America/Mexico_City",
    "BRL": "America/Sao_Paulo",
    "ARS": "America/Argentina/Buenos_Aires",
    "EUR": "Europe/Berlin",
    "GBP": "Europe/London",
    "CHF": "Europe/Zurich",
    "RUB": "Europe/Moscow",
    "TRY": "Europe/Istanbul",
    "JPY": "Asia/Tokyo",
    "CNY": "Asia/Shanghai",
    "INR": "Asia/Kolkata",
    "KRW": "Asia/Seoul",
    "SGD": "Asia/Singapore",
    "AUD": "Australia/Sydney",
    "NZD": "Pacific/Auckland",
    "HKD": "Asia/Hong_Kong",
    "TWD": "Asia/Taipei",
    "THB": "Asia/Bangkok",
    "IDR": "Asia/Jakarta",
    "MYR": "Asia/Kuala_Lumpur",
    "PHP": "Asia/Manila",
    "VND": "Asia/Ho_Chi_Minh",
    "SAR": "Asia/Riyadh",
    "AED": "Asia/Dubai",
    "ZAR": "Africa/Johannesburg",
    "EGP": "Africa/Cairo",
    "SEK": "Europe/Stockholm",
    "NOK": "Europe/Oslo",
    "DKK": "Europe/Copenhagen",
    "PLN": "Europe/Warsaw",
    "HUF": "Europe/Budapest",
    "CZK": "Europe/Prague",
  };

  Future<void> _convert() async {
    final amt = double.tryParse(amountCtrl.text);
    if (amt == null) {
      setState(() {
        converted = null;
        rate = null;
      });
      return;
    }
    try {
      final uri = Uri.parse('$frankfurter?from=$from&to=$to');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) throw Exception('Exchange API ${res.statusCode}');
      final data = json.decode(res.body) as Map<String, dynamic>;
      final r = (data['rates'] as Map<String, dynamic>)[to];
      final rr = (r is num) ? r.toDouble() : double.parse(r.toString());
      setState(() {
        rate = rr;
        converted = amt * rr;
      });
      await _fetchLocalTime(to);
    } catch (_) {
      setState(() {
        rate = null;
        converted = null;
        localTime = 'Time data unavailable';
      });
    }
  }

  Future<void> _fetchLocalTime(String currency) async {
    final city = currencyToCity[currency];
    if (city == null) {
      setState(() => localTime = 'Time data not available');
      return;
    }
    try {
      final url = '$worldTime$city';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        setState(() => localTime = 'Time API unavailable (${res.statusCode})');
        return;
      }
      final data = json.decode(res.body) as Map<String, dynamic>;
      final dt = data['datetime'] as String?;
      if (dt == null || dt.isEmpty) {
        setState(() => localTime = 'Time data unavailable');
        return;
      }
      final ts = dt.split('.').first.replaceAll('T', ' ');
      setState(() => localTime = ts);
    } catch (_) {
      try {
        await _fetchLocalTimeAlternative(currency);
      } catch (_) {
        setState(() => localTime = 'Time data unavailable');
      }
    }
  }

  Future<void> _fetchLocalTimeAlternative(String currency) async {
    final city = currencyToCity[currency];
    if (city == null) {
      setState(() => localTime = 'Time data not available');
      return;
    }
    try {
      final url = 'https://timeapi.io/api/Time/current/zone?timeZone=$city';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final dateTime = data['dateTime'] as String?;
        if (dateTime != null) {
          final ts = dateTime.replaceAll('T', ' ').split('.').first;
          setState(() => localTime = ts);
          return;
        }
      }
    } catch (_) {
      try {
        final url = 'https://worldtimeapi.org/api/timezone/$city';
        final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
        if (res.statusCode == 200) {
          final data = json.decode(res.body) as Map<String, dynamic>;
          final dt = data['datetime'] as String?;
          if (dt != null) {
            final ts = dt.split('.').first.replaceAll('T', ' ');
            setState(() => localTime = ts);
            return;
          }
        }
      } catch (_) {
        setState(() => localTime = 'Time data unavailable');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final all = currencyToCity.keys.toList()..sort();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 20),
              child: Text(
                'Currency Converter',
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
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _CurrencyField(
                          label: 'FROM',
                          value: from,
                          items: all,
                          onChanged: (v) => setState(() => from = v),
                        ),
                        const SizedBox(height: 16),
                        _CurrencyField(
                          label: 'TO',
                          value: to,
                          items: all,
                          onChanged: (v) => setState(() => to = v),
                        ),
                        const SizedBox(height: 16),
                        _AmountField(
                          label: 'AMOUNT',
                          controller: amountCtrl,
                        ),
                        const SizedBox(height: 24),
                        _ConvertButton(onPressed: _convert),
                        if (rate != null && converted != null) ...[
                          const SizedBox(height: 24),
                          _ResultDisplay(
                            result: converted!,
                            to: to,
                            rate: rate!,
                            from: from,
                            localTime: localTime,
                          ),
                        ],
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

class _CurrencyField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _CurrencyField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F30).withOpacity(0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            dropdownColor: const Color(0xFF1A1F30),
            style: const TextStyle(color: Color(0xFFEAF2FF), fontSize: 16),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.7)),
            items: items.map((c) => DropdownMenuItem(
              value: c,
              child: Text(c),
            )).toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _AmountField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F30).withOpacity(0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: const TextStyle(color: Color(0xFFEAF2FF), fontSize: 16),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConvertButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ConvertButton({required this.onPressed});

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
              colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF60A5FA).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Convert',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  final double result;
  final String to;
  final double rate;
  final String from;
  final String? localTime;

  const _ResultDisplay({
    required this.result,
    required this.to,
    required this.rate,
    required this.from,
    this.localTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result: ${result.toStringAsFixed(2)} $to',
          style: const TextStyle(
            color: Color(0xFFEAF2FF),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rate: 1 $from = ${rate.toStringAsFixed(4)} $to',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        if (localTime != null) ...[
          const SizedBox(height: 8),
          Text(
            'Local Time ($to): $localTime',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}

