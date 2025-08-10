import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _cityCtrl = TextEditingController(text: 'Casablanca');
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _data;

  Future<void> _fetch() async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() => _error = 'Missing OPENWEATHER_API_KEY in .env');
      return;
    }

    final city = _cityCtrl.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
      _data = null;
    });

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': apiKey,
      'units': 'metric',
    });

    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() => _data = json);
      } else {
        setState(() => _error = 'Error ${res.statusCode}: ${res.reasonPhrase}');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final main = _data?['main'] as Map<String, dynamic>?;
    final weatherList = _data?['weather'] as List<dynamic>?;
    final desc = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList.first['description']?.toString()
        : null;
    final temp = main?['temp']?.toString();
    final feels = main?['feels_like']?.toString();
    final hum = main?['humidity']?.toString();
    final pressure = main?['pressure']?.toString();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _cityCtrl,
            decoration: InputDecoration(
              labelText: 'City',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _loading ? null : _fetch,
              ),
            ),
            onSubmitted: (_) => _fetch(),
          ),
          const SizedBox(height: 16),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null) Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
          if (_data != null) Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: Text(_data?['name']?.toString() ?? ''),
                    subtitle: Text(desc ?? ''),
                    leading: const Icon(Icons.location_city),
                    trailing: Text(temp != null ? '$temp°C' : ''),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _chip('Feels like', feels != null ? '$feels°C' : '-'),
                        _chip('Humidity', hum != null ? '$hum%' : '-'),
                        _chip('Pressure', pressure != null ? '$pressure hPa' : '-'),
                      ],
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

  Widget _chip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      avatar: const Icon(Icons.info_outline),
    );
  }
}
