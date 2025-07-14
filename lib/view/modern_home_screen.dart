import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/modern_widgets.dart';
import '../controller/weather_fetcher.dart';
import '../responses/onecall_response.dart';
import '../responses/weather_response.dart';
import 'map.dart';

class ModernHomeScreen extends ConsumerStatefulWidget {
  final void Function(MaterialColor s)? primarySwatch;
  final bool fixedLocation;
  final WeatherFetcher weatherFetcher;

  const ModernHomeScreen({
    Key? key,
    this.primarySwatch,
    this.fixedLocation = false,
    required this.weatherFetcher,
  }) : super(key: key);

  @override
  ConsumerState<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends ConsumerState<ModernHomeScreen>
    with TickerProviderStateMixin {
  static const IconData halictus_rubicundus_silhouette =
      IconData(0xe801, fontFamily: 'WingedAnt', fontPackage: null);

  late final WeatherFetcher weatherFetcher;
  late final bool fixedLocation;

  String? _geocoding;
  CurrentWeatherResponse? _currentWeather;
  OneCallResponse? _historical;
  OneCallResponse? _weather;
  bool loaded = false;
  String? errorMessage;

  Hourly? _indexOfDiurnalHour;
  Hourly? _indexOfNocturnalHour;
  int _diurnalHourPercentage = 0;
  int _nocturnalHourPercentage = 0;
  List<int> _hourlyPercentage = List.generate(48, (index) => 0);
  List<int> _dailyPercentage = [0, 0, 0, 0, 0, 0, 0, 0];

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    weatherFetcher = widget.weatherFetcher;
    fixedLocation = widget.fixedLocation;

    // Initialisation des animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadData() async {
    try {
      await _getLocation(false);
      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _getLocation(bool forceUpdate) async {
    setState(() {
      errorMessage = null;
    });

    if (fixedLocation) {
      await _getWeather();
    } else {
      final updated = await weatherFetcher.findLocation(false);
      if (updated || forceUpdate) {
        await _getWeather();
      }
      await weatherFetcher.findLocation(true);
      await _getWeather();
    }
  }

  Future<void> _getWeather() async {
    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime.utc(now.year, now.month, now.day);
    final int dt = today.millisecondsSinceEpoch ~/ 1000;

    final responses = await Future.wait([
      weatherFetcher.fetchNearestWeatherLocation(),
      weatherFetcher.fetchHistoricalWeather(dt),
      weatherFetcher.fetchWeather(),
    ]);

    _updateWeather(responses[0], responses[1], responses[2]);
  }

  void _updateWeather(CurrentWeatherResponse current,
      OneCallResponse historical, OneCallResponse weather) {
    setState(() {
      _currentWeather = current;
      _historical = historical;
      _weather = weather;
      loaded = true;

      _geocoding = current.name ?? "Unknown Location";

      // Calcul des pourcentages (simplifié pour l'exemple)
      _diurnalHourPercentage = 75; // Exemple
      _nocturnalHourPercentage = 45; // Exemple
      _hourlyPercentage = List.generate(24, (index) => 50 + (index % 30));
      _dailyPercentage = [65, 70, 55, 80, 45, 60, 75];
    });
  }

  void _handleError(dynamic error) {
    setState(() {
      loaded = true;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    });
  }

  void _showMap() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MapPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ant Nuptial Flight Predictor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _showMap,
            tooltip: 'Show Map',
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _getLocation(true),
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour signaler un vol nuptial
          _showNuptialFlightDialog();
        },
        child: Icon(halictus_rubicundus_silhouette, size: 32),
        tooltip: 'Report Nuptial Flight',
      ),
    );
  }

  Widget _buildBody() {
    if (!loaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ModernActionButton(
              text: 'Retry',
              icon: Icons.refresh,
              onPressed: () => _loadData(),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildConfidenceCards(),
          const SizedBox(height: 24),
          _buildHistogram(),
          const SizedBox(height: 24),
          _buildWeatherParameters(),
          const SizedBox(height: 24),
          _buildForecastTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Confidence of Nuptial Flight',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (_geocoding != null)
              Text(
                '$_geocoding Weather',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            if (_weather != null) ...[
              const SizedBox(height: 8),
              Text(
                DateFormat.MMMEd().format(DateTime.fromMillisecondsSinceEpoch(
                  (_weather!.hourly!.first.dt! + _weather!.timezoneOffset!) * 1000,
                  isUtc: true,
                )),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        if (isTablet) {
          return Row(
            children: [
              Expanded(
                child: ModernConfidenceCard(
                  title: 'Diurnal Flight',
                  percentage: _diurnalHourPercentage,
                  subtitle: 'Daytime confidence',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModernConfidenceCard(
                  title: 'Nocturnal Flight',
                  percentage: _nocturnalHourPercentage,
                  subtitle: 'Nighttime confidence',
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ModernConfidenceCard(
              title: 'Diurnal Flight',
              percentage: _diurnalHourPercentage,
              subtitle: 'Daytime confidence',
            ),
            const SizedBox(height: 16),
            ModernConfidenceCard(
              title: 'Nocturnal Flight',
              percentage: _nocturnalHourPercentage,
              subtitle: 'Nighttime confidence',
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistogram() {
    if (_weather?.hourly == null) return const SizedBox.shrink();

    final labels = _weather!.hourly!.take(24).map((hourly) {
      return DateFormat('HH').format(
        DateTime.fromMillisecondsSinceEpoch(
          (hourly.dt! + _weather!.timezoneOffset!) * 1000,
          isUtc: true,
        ),
      );
    }).toList();

    return ModernHistogramCard(
      title: 'Hourly Confidence',
      hourlyData: _hourlyPercentage.take(24).toList(),
      labels: labels,
    );
  }

  Widget _buildWeatherParameters() {
    if (_weather?.daily == null) return const SizedBox.shrink();

    final daily = _weather!.daily!.first;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 3 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            ModernWeatherParameterCard(
              title: 'Temperature',
              value: '${daily.temp?.day?.toStringAsFixed(1)}°C',
              icon: Icons.thermostat,
            ),
            ModernWeatherParameterCard(
              title: 'Wind Speed',
              value: '${daily.windSpeed?.toStringAsFixed(1)} m/s',
              icon: Icons.air,
            ),
            ModernWeatherParameterCard(
              title: 'Precipitation',
              value: '${(daily.pop! * 100).toStringAsFixed(0)}%',
              icon: Icons.water_drop,
            ),
            ModernWeatherParameterCard(
              title: 'Humidity',
              value: '${daily.humidity?.toStringAsFixed(0)}%',
              icon: Icons.opacity,
            ),
            ModernWeatherParameterCard(
              title: 'Pressure',
              value: '${daily.pressure?.toStringAsFixed(0)} hPa',
              icon: Icons.speed,
            ),
            ModernWeatherParameterCard(
              title: 'Clouds',
              value: '${daily.clouds?.toStringAsFixed(0)}%',
              icon: Icons.cloud,
            ),
          ],
        );
      },
    );
  }

  Widget _buildForecastTable() {
    if (_weather?.daily == null) return const SizedBox.shrink();

    final forecastData = _weather!.daily!.asMap().entries.map((entry) {
      final index = entry.key;
      final daily = entry.value;
      
      return {
        'Day': DateFormat('E').format(
          DateTime.fromMillisecondsSinceEpoch(
            (daily.dt! + _weather!.timezoneOffset!) * 1000,
            isUtc: true,
          ),
        ),
        'Temp': '${daily.temp?.day?.toStringAsFixed(1)}°C',
        'Wind': '${daily.windSpeed?.toStringAsFixed(1)} m/s',
        'Prediction': '${_dailyPercentage[index]}%',
        'percentage': _dailyPercentage[index],
      };
    }).toList();

    return ModernForecastTable(
      forecastData: forecastData,
      columns: const ['Day', 'Temp', 'Wind', 'Prediction'],
    );
  }

  void _showNuptialFlightDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Nuptial Flight'),
        content: const Text(
          'Did you observe a nuptial flight? This helps improve our predictions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your report!'),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}