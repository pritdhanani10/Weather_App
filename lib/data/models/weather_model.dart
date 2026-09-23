import '../../domain/entities/weather.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required String cityName,
    required String main,
    required String description,
    required String iconCode,
    required double temperature,
    required int pressure,
    required int humidity,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    double? windSpeed,
    int? windDeg,
    String? country,
    int? sunrise,
    int? sunset,
  }) : super(
          cityName: cityName,
          main: main,
          description: description,
          iconCode: iconCode,
          temperature: temperature,
          pressure: pressure,
          humidity: humidity,
          feelsLike: feelsLike,
          tempMin: tempMin,
          tempMax: tempMax,
          windSpeed: windSpeed,
          windDeg: windDeg,
          country: country,
          sunrise: sunrise,
          sunset: sunset,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        cityName: json['name'] ?? '',
        main: json['weather'] != null && json['weather'].isNotEmpty
            ? json['weather'][0]['main'] ?? ''
            : '',
        description: json['weather'] != null && json['weather'].isNotEmpty
            ? json['weather'][0]['description'] ?? ''
            : '',
        iconCode: json['weather'] != null && json['weather'].isNotEmpty
            ? json['weather'][0]['icon'] ?? ''
            : '',
        temperature: (json['main']['temp'] as num).toDouble(),
        pressure: (json['main']['pressure'] as num).toInt(),
        humidity: (json['main']['humidity'] as num).toInt(),
        feelsLike: (json['main']['feels_like'] as num?)?.toDouble(),
        tempMin: (json['main']['temp_min'] as num?)?.toDouble(),
        tempMax: (json['main']['temp_max'] as num?)?.toDouble(),
        windSpeed: (json['wind']?['speed'] as num?)?.toDouble(),
        windDeg: (json['wind']?['deg'] as num?)?.toInt(),
        country: json['sys']?['country'] as String?,
        sunrise: (json['sys']?['sunrise'] as num?)?.toInt(),
        sunset: (json['sys']?['sunset'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'weather': [
          {
            'main': main,
            'description': description,
            'icon': iconCode,
          },
        ],
        'main': {
          'temp': temperature,
          'pressure': pressure,
          'humidity': humidity,
        },
        'name': cityName,
      };

  WeatherEntity toEntity() => WeatherEntity(
        cityName: cityName,
        main: main,
        description: description,
        iconCode: iconCode,
        temperature: temperature,
        pressure: pressure,
        humidity: humidity,
        feelsLike: feelsLike,
        tempMin: tempMin,
        tempMax: tempMax,
        windSpeed: windSpeed,
        windDeg: windDeg,
        country: country,
        sunrise: sunrise,
        sunset: sunset,
      );
}