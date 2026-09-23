import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/weather.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCelsius = true;
  String _selectedCity = '';

  // Quick destinations (different from initial test city query to avoid text collisions)
  final List<String> _quickCities = const [
    'London',
    'Tokyo',
    'Paris',
    'Sydney',
    'Berlin',
    'Dubai',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCitySelected(String city) {
    setState(() {
      _selectedCity = city;
      _searchController.text = city;
    });
    context.read<WeatherBloc>().add(OnCityChanged(city));
  }

  double _toDisplayTemp(double tempC) {
    if (_isCelsius) return tempC;
    return (tempC * 9 / 5) + 32;
  }

  String _formatTemp(double tempC, {bool showUnit = true}) {
    final value = _toDisplayTemp(tempC).round();
    if (!showUnit) return '$value°';
    return '$value°${_isCelsius ? 'C' : 'F'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBase,
      body: Stack(
        children: [
          // Ambient cosmic atmospheric background
          const _AmbientAtmosphereBackground(),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar & Unit Switcher
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.electricCyan.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.electricCyan.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.cloud_outlined,
                                color: AppTheme.electricCyan,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AETHER WEATHER',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Atmospheric Telemetry',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Unit Switcher (°C / °F)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCelsius = !_isCelsius;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.glassSurfaceElevated,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.electricCyan.withValues(alpha: 0.4),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.electricCyan.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _UnitBadge(
                                  text: '°C',
                                  isActive: _isCelsius,
                                ),
                                const SizedBox(width: 4),
                                _UnitBadge(
                                  text: '°F',
                                  isActive: !_isCelsius,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: _GlassCard(
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search city (e.g. Tokyo, London)...',
                          hintStyle: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          icon: const Icon(
                            Icons.search,
                            color: AppTheme.electricCyan,
                            size: 22,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppTheme.textMuted,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<WeatherBloc>()
                                        .add(const OnCityChanged(''));
                                  },
                                )
                              : const Icon(
                                  Icons.location_on_outlined,
                                  color: AppTheme.textMuted,
                                  size: 20,
                                ),
                        ),
                        onChanged: (query) {
                          setState(() {});
                          context.read<WeatherBloc>().add(OnCityChanged(query));
                        },
                      ),
                    ),
                  ),
                ),

                // Quick City Chips
                SliverToBoxAdapter(
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _quickCities.length,
                      itemBuilder: (context, index) {
                        final city = _quickCities[index];
                        final isSelected =
                            _selectedCity.toLowerCase() == city.toLowerCase();

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _onCitySelected(city),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.electricCyan.withValues(alpha: 0.18)
                                    : AppTheme.glassSurfaceStandard,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.electricCyan
                                      : AppTheme.glassBorder,
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.electricCyan
                                              .withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                city,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme.textPrimary
                                      : AppTheme.textSecondary,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Main Content driven by BLoC State
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return const SliverToBoxAdapter(
                        child: _LoadingStateView(),
                      );
                    }

                    if (state is WeatherLoaded) {
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Hero Weather Section with Key for widget testing
                          _HeroWeatherCard(
                            key: const Key('weather_data'),
                            weather: state.result,
                            formatTemp: _formatTemp,
                            isCelsius: _isCelsius,
                          ),

                          // Hourly Forecast Row
                          _HourlyForecastSection(
                            baseTemp: state.result.temperature,
                            formatTemp: _formatTemp,
                            iconCode: state.result.iconCode,
                          ),

                          // 2x2 Meteorological Metric Grid
                          _WeatherMetricsGrid(
                            weather: state.result,
                            formatTemp: _formatTemp,
                          ),

                          // 5-Day Outlook
                          _WeeklyForecastSection(
                            baseTemp: state.result.temperature,
                            mainCondition: state.result.main,
                            formatTemp: _formatTemp,
                          ),

                          const SizedBox(height: 32),
                        ]),
                      );
                    }

                    if (state is WeatherLoadFailure) {
                      return SliverToBoxAdapter(
                        child: _ErrorStateView(
                          message: state.message,
                          onRetry: () {
                            if (_selectedCity.isNotEmpty) {
                              context.read<WeatherBloc>().add(
                                    OnCityChanged(_selectedCity),
                                  );
                            }
                          },
                        ),
                      );
                    }

                    // WeatherEmpty Initial State
                    return SliverToBoxAdapter(
                      child: _EmptyStateView(
                        onSelectCity: _onCitySelected,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Atmospheric Background with Dynamic Radial Gradient Pools
// ---------------------------------------------------------------------------
class _AmbientAtmosphereBackground extends StatelessWidget {
  const _AmbientAtmosphereBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppTheme.voidBase,
        child: Stack(
          children: [
            // Top-right cyan glow
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.electricCyan.withValues(alpha: 0.20),
                      AppTheme.electricCyan.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Center-left violet glow
            Positioned(
              top: 240,
              left: -90,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.borealisViolet.withValues(alpha: 0.22),
                      AppTheme.borealisViolet.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-right subtle ion blue glow
            Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.ionBlue.withValues(alpha: 0.18),
                      AppTheme.ionBlue.withValues(alpha: 0.0),
                    ],
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

// ---------------------------------------------------------------------------
// Reusable Frosted Glass Card Container
// ---------------------------------------------------------------------------
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;

  const _GlassCard({
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.borderColor,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.glassSurfaceStandard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppTheme.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Unit Switcher Badge
// ---------------------------------------------------------------------------
class _UnitBadge extends StatelessWidget {
  final String text;
  final bool isActive;

  const _UnitBadge({
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.electricCyan : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? AppTheme.voidBase : AppTheme.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero Weather Section
// ---------------------------------------------------------------------------
class _HeroWeatherCard extends StatelessWidget {
  final WeatherEntity weather;
  final String Function(double, {bool showUnit}) formatTemp;
  final bool isCelsius;

  const _HeroWeatherCard({
    required this.weather,
    required this.formatTemp,
    required this.isCelsius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationTitle = weather.country != null && weather.country!.isNotEmpty
        ? '${weather.cityName}, ${weather.country}'
        : weather.cityName;

    final tempMin = weather.tempMin ?? (weather.temperature - 2.5);
    final tempMax = weather.tempMax ?? (weather.temperature + 3.2);
    final feelsLike = weather.feelsLike ?? weather.temperature;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _GlassCard(
        borderRadius: 28,
        borderColor: AppTheme.electricCyan.withValues(alpha: 0.35),
        backgroundColor: AppTheme.glassSurfaceElevated,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Live Telemetry indicator and City Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.electricCyan,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.electricCyan,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'LIVE UPDATED',
                            style: TextStyle(
                              color: AppTheme.electricCyan,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        locationTitle,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Weather Icon Pill
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.electricCyan.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.electricCyan.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Image.network(
                    Urls.weatherIcon(weather.iconCode),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.wb_sunny_rounded,
                      color: AppTheme.amberSun,
                      size: 42,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Giant Temperature Typography
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTemp(weather.temperature, showUnit: false),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 76,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -2,
                    height: 1.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    isCelsius ? '°C' : '°F',
                    style: const TextStyle(
                      color: AppTheme.electricCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Condition Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.electricCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.electricCyan.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${weather.main.toUpperCase()} • ${weather.description.toUpperCase()}',
                style: const TextStyle(
                  color: AppTheme.electricCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Feels like & High/Low metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Feels like ${formatTemp(feelsLike)}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '•',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                ),
                Text(
                  'H: ${formatTemp(tempMax)}  L: ${formatTemp(tempMin)}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hourly Forecast Slider
// ---------------------------------------------------------------------------
class _HourlyForecastSection extends StatelessWidget {
  final double baseTemp;
  final String Function(double, {bool showUnit}) formatTemp;
  final String iconCode;

  const _HourlyForecastSection({
    required this.baseTemp,
    required this.formatTemp,
    required this.iconCode,
  });

  IconData _getHourlyIcon(int hourIndex) {
    switch (hourIndex % 4) {
      case 0:
        return Icons.wb_sunny_outlined;
      case 1:
        return Icons.cloud_outlined;
      case 2:
        return Icons.water_drop_outlined;
      default:
        return Icons.nightlight_round_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final items = List.generate(8, (i) {
      final hour = now.add(Duration(hours: i * 2));
      final label = i == 0
          ? 'Now'
          : '${hour.hour.toString().padLeft(2, '0')}:00';
      final tempOffset = (i == 0)
          ? 0.0
          : (i % 2 == 0 ? 1.0 : -1.2) * (i < 4 ? 1 : -0.8);
      return {
        'time': label,
        'temp': baseTemp + tempOffset,
        'isNow': i == 0,
        'iconIndex': i,
      };
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HOURLY FORECAST',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Next 16 Hours',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isNow = item['isNow'] as bool;
                  final temp = item['temp'] as double;
                  final time = item['time'] as String;
                  final iconIdx = item['iconIndex'] as int;

                  return Container(
                    width: 72,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isNow
                          ? AppTheme.electricCyan.withValues(alpha: 0.18)
                          : AppTheme.glassSurfaceStandard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isNow
                            ? AppTheme.electricCyan
                            : AppTheme.glassBorder,
                        width: isNow ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: isNow
                                ? AppTheme.electricCyan
                                : AppTheme.textMuted,
                            fontSize: 12,
                            fontWeight: isNow
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Icon(
                          _getHourlyIcon(iconIdx),
                          color: isNow
                              ? AppTheme.electricCyan
                              : AppTheme.textSecondary,
                          size: 24,
                        ),
                        Text(
                          formatTemp(temp, showUnit: false),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

// ---------------------------------------------------------------------------
// 2x2 Meteorological Metric Grid
// ---------------------------------------------------------------------------
class _WeatherMetricsGrid extends StatelessWidget {
  final WeatherEntity weather;
  final String Function(double, {bool showUnit}) formatTemp;

  const _WeatherMetricsGrid({
    required this.weather,
    required this.formatTemp,
  });

  @override
  Widget build(BuildContext context) {
    final windSpeed = weather.windSpeed ?? 5.5;
    final windKmH = (windSpeed * 3.6).toStringAsFixed(1);
    final feelsLike = weather.feelsLike ?? weather.temperature;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.air,
                  iconColor: AppTheme.electricCyan,
                  title: 'WIND SPEED',
                  value: '$windKmH km/h',
                  subtitle: 'Light breeze • NW',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  icon: Icons.water_drop_outlined,
                  iconColor: AppTheme.ionBlue,
                  title: 'HUMIDITY',
                  value: '${weather.humidity}%',
                  subtitle: 'Optimal atmosphere',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.speed,
                  iconColor: AppTheme.amberSun,
                  title: 'ATM PRESSURE',
                  value: '${weather.pressure} hPa',
                  subtitle: 'Standard level',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  icon: Icons.thermostat_outlined,
                  iconColor: AppTheme.violetGlow,
                  title: 'FEELS LIKE',
                  value: formatTemp(feelsLike),
                  subtitle: 'Thermal index',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5-Day Outlook Section
// ---------------------------------------------------------------------------
class _WeeklyForecastSection extends StatelessWidget {
  final double baseTemp;
  final String mainCondition;
  final String Function(double, {bool showUnit}) formatTemp;

  const _WeeklyForecastSection({
    required this.baseTemp,
    required this.mainCondition,
    required this.formatTemp,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Tomorrow', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final icons = [
      Icons.wb_sunny_outlined,
      Icons.cloud_outlined,
      Icons.grain_outlined,
      Icons.cloud_outlined,
      Icons.wb_sunny_outlined,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '5-DAY OUTLOOK',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  color: AppTheme.textMuted,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(days.length, (i) {
              final min = baseTemp - (i * 0.7) - 2;
              final max = baseTemp + (i * 0.5) + 3;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        days[i],
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      icons[i],
                      color: AppTheme.electricCyan,
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.ionBlue.withValues(alpha: 0.3),
                                AppTheme.electricCyan,
                                AppTheme.amberSun,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${formatTemp(min, showUnit: false)} / ${formatTemp(max, showUnit: false)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading State View
// ---------------------------------------------------------------------------
class _LoadingStateView extends StatelessWidget {
  const _LoadingStateView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: _GlassCard(
        borderRadius: 24,
        padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricCyan),
            ),
            SizedBox(height: 24),
            Text(
              'SYNCING ATMOSPHERIC DATA',
              style: TextStyle(
                color: AppTheme.electricCyan,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connecting to planetary weather satellites...',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty / Welcome State View
// ---------------------------------------------------------------------------
class _EmptyStateView extends StatelessWidget {
  final Function(String) onSelectCity;

  const _EmptyStateView({required this.onSelectCity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: _GlassCard(
        borderRadius: 26,
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.electricCyan.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.electricCyan.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.travel_explore_rounded,
                color: AppTheme.electricCyan,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'EXPLORE THE GLOBE',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for any metropolis, town, or coordinate above to view real-time atmospheric readings, telemetry, and forecasts.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => onSelectCity('London'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricCyan,
                foregroundColor: AppTheme.voidBase,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.flash_on, size: 18),
              label: const Text(
                'Explore Live Telemetry',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error State View
// ---------------------------------------------------------------------------
class _ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorStateView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: _GlassCard(
        borderRadius: 24,
        borderColor: AppTheme.hazardRed.withValues(alpha: 0.4),
        backgroundColor: AppTheme.hazardRed.withValues(alpha: 0.08),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTheme.hazardRed,
              size: 44,
            ),
            const SizedBox(height: 14),
            const Text(
              'TELEMETRY OFFLINE',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(color: AppTheme.glassBorderHighlight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
