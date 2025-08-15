import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/constants.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for contrast
      appBar: AppBar(
        backgroundColor: const Color(0xff1D1E22),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'WEATHER',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xff1D1E22)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (query) {
                  context.read<WeatherBloc>().add(OnCityChanged(query));
                },
              ),
            ),
            const SizedBox(height: 36),
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xff1D1E22),
                      ),
                    ),
                  );
                }
                if (state is WeatherLoaded) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.result.cityName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Image(
                                image: NetworkImage(
                                  Urls.weatherIcon(state.result.iconCode),
                                ),
                                height: 40,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${state.result.main} | ${state.result.description}',
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.15,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(height: 30, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _WeatherInfoTile(
                                icon: Icons.thermostat,
                                label: 'Temp',
                                value: '${state.result.temperature}°C',
                                iconColor: Colors.orange,
                              ),
                              _WeatherInfoTile(
                                icon: Icons.water_drop,
                                label: 'Humidity',
                                value: '${state.result.humidity}%',
                                iconColor: Colors.blue,
                              ),
                              _WeatherInfoTile(
                                icon: Icons.speed,
                                label: 'Pressure',
                                value: '${state.result.pressure} hPa',
                                iconColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is WeatherLoadFailue) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

// Custom Tile for Weather Info Rows
class _WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _WeatherInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
