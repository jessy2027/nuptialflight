import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controller/weather_fetcher.dart';
import '../../responses/onecall_response.dart';
import '../../controller/nuptials.dart';

// Provides a single global WeatherFetcher instance
final weatherFetcherProvider = Provider<WeatherFetcher>((ref) {
  return WeatherFetcher();
});

// Current location of the user
final locationProvider = FutureProvider<LatLng>((ref) async {
  final fetcher = ref.watch(weatherFetcherProvider);
  await fetcher.findLocation(false);
  return fetcher.getLocation();
});

// Current weather data (OneCall API)
final weatherProvider = FutureProvider<OneCallResponse>((ref) async {
  final fetcher = ref.watch(weatherFetcherProvider);
  return await fetcher.fetchWeather();
});

// Stream provider that refreshes weather every 60 minutes automatically
final weatherStreamProvider = StreamProvider<OneCallResponse>((ref) async* {
  final fetcher = ref.watch(weatherFetcherProvider);
  // Emit immediately
  yield await fetcher.fetchWeather();
  // Then every hour
  await for (final _ in Stream.periodic(const Duration(hours: 1))) {
    yield await fetcher.fetchWeather();
  }
});

// Daily percentage list for next 8 days
final dailyPercentagesProvider = Provider<AsyncValue<List<int>>>((ref) {
  final weatherAsync = ref.watch(weatherStreamProvider);
  return weatherAsync.whenData((weather) {
    final List<int> percentages = List.filled(8, 0);
    for (int i = 0; i < 8 && i < weather.daily!.length; i++) {
      percentages[i] = (nuptialDailyPercentageModel(
                  weather.lat!, weather.lon!, weather.daily![i]) *
              100)
          .toInt();
    }
    return percentages;
  });
});

// Hourly percentage list for next 48 hours
final hourlyPercentagesProvider = Provider<AsyncValue<List<int>>>((ref) {
  final weatherAsync = ref.watch(weatherStreamProvider);
  return weatherAsync.whenData((weather) {
    final List<int> percentages = List.filled(48, 0);
    for (int i = 0; i < 48 && i < weather.hourly!.length; i++) {
      percentages[i] = (nuptialHourlyPercentageModel(
                  weather.lat!, weather.lon!, weather.hourly![i]) *
              100)
          .toInt();
    }
    return percentages;
  });
});
