import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controller/arangodb.dart';
import '../controller/weather_fetcher.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/modern_widgets.dart';
import 'modern_home_screen.dart';
import '../utils.dart';

class ModernMapScreen extends StatefulWidget {
  const ModernMapScreen({Key? key}) : super(key: key);

  @override
  State<ModernMapScreen> createState() => _ModernMapScreenState();
}

class _ModernMapScreenState extends State<ModernMapScreen>
    with TickerProviderStateMixin {
  WeatherFetcher _weatherFetcher = WeatherFetcher();
  MapController _mapController = MapController();
  final double defaultZoom = 3;
  List<Marker> _markers = <Marker>[];
  bool _isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
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

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadData() async {
    try {
      await _loadFlightData();
      await _loadLocation();
      _fadeController.forward();
    } catch (e) {
      // Gérer les erreurs
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFlightData() async {
    final flights = await ArangoSingleton().getRecentFlights();
    setState(() {
      _markers = flights.map((row) => Marker(
        point: LatLng(row['lat'], row['lon']),
        child: _ModernMarkerIcon(
          key: row['key'],
          size: row['size'],
          weather: row['weather'],
        ),
      )).toList();
    });
  }

  Future<void> _loadLocation() async {
    await _weatherFetcher.findLocation(false);
    _moveMap();
  }

  void _moveMap() {
    LatLng? latLng = _weatherFetcher.getLocation();
    if (latLng != LatLng(0, 0)) {
      _mapController.moveAndRotate(latLng, defaultZoom, 0.0);
    }
  }

  String _formatWmsBaseUrl(String baseUrl) {
    if (baseUrl.endsWith('?') || baseUrl.endsWith('/')) {
      return baseUrl;
    } else if (baseUrl.contains('?')) {
      return baseUrl + '&';
    } else {
      return baseUrl + '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Flight Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _moveMap,
            tooltip: 'Go to my location',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            _buildMap(),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            _buildInfoPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _weatherFetcher.getLocation(),
        initialZoom: defaultZoom,
        minZoom: 2,
        maxZoom: 9,
        onLongPress: (position, latLng) {
          _weatherFetcher.setLocation(latLng);
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ModernHomeScreen(
                fixedLocation: true,
                weatherFetcher: _weatherFetcher,
              ),
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
        },
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          cursorKeyboardRotationOptions: CursorKeyboardRotationOptions.disabled(),
        ),
      ),
      children: <Widget>[
        _buildBaseTileLayer(),
        _buildWeatherLayers(),
        MarkerLayer(markers: _markers),
        _buildAttribution(),
      ],
    );
  }

  Widget _buildBaseTileLayer() {
    return TileLayer(
      wmsOptions: WMSTileLayerOptions(
        baseUrl: _formatWmsBaseUrl(
          dotenv.env['MAP_TILES_URL'] ?? 'https://maps.example.com/service?',
        ),
        layers: ['backdrop'],
      ),
      subdomains: const ['a', 'b', 'c'],
      userAgentPackageName: 'fr.jessylange.nuptialflight',
      minZoom: 0,
      maxZoom: 20,
      additionalOptions: const {'ext': 'png'},
    );
  }

  Widget _buildWeatherLayers() {
    return Stack(
      children: [
        _buildWeatherLayer(
          'clouds_new',
          const ColorFilter.matrix(<double>[
            0, 0, 0, 510, 0, // R
            0, 0, 0, 0, 0, // G
            0, 0, 0, 0, 0, // B
            0, 0, 0, -2, 510, // A
          ]),
        ),
        _buildWeatherLayer(
          'wind_new',
          const ColorFilter.matrix(<double>[
            0, 0, 0, 637, 0, // R
            0, 0, 0, 0, 0, // G
            0, 0, 0, 0, 0, // B
            0, 0, 0, 637, 0, // A
          ]),
        ),
        _buildWeatherLayer(
          'temp_new',
          const ColorFilter.matrix(<double>[
            1, -2, 6, 0, -255, // R
            0, 0, 0, 0, 0, // G
            0, 0, 0, 0, 0, // B
            0, 0, 2, 0, -60, // A
          ]),
        ),
      ],
    );
  }

  Widget _buildWeatherLayer(String layer, ColorFilter colorFilter) {
    return Opacity(
      opacity: 0.165,
      child: TileLayer(
        wmsOptions: WMSTileLayerOptions(
          baseUrl: _formatWmsBaseUrl(
            dotenv.env['MAP_TILES_URL'] ?? 'https://maps.example.com/service?',
          ),
          layers: [layer],
        ),
        subdomains: const ['a', 'b', 'c'],
        userAgentPackageName: 'fr.jessylange.nuptialflight',
        minZoom: 0,
        maxZoom: 20,
        additionalOptions: const {'ext': 'png'},
      ),
    );
  }

  Widget _buildAttribution() {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: html.Html(
            data: '''
              <div style="color: #00ffff; font-size: 12px;">
                Markers show last 48hr nuptial flights.<br/>
                Marker size indicates species size.<br/>
                Weather <a href="http://openweathermap.org">&copy; OpenWeatherMap</a><br/>
                Tiles <a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a><br/>
                Map data <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a>
              </div>
            ''',
            onLinkTap: (url, attributes, element) => Utils.launchURL(url!),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      top: 100,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Map Legend',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _buildLegendItem('Red', 'Low confidence'),
              _buildLegendItem('Orange', 'Medium confidence'),
              _buildLegendItem('Green', 'High confidence'),
              const SizedBox(height: 12),
              Text(
                'Tap and hold to set location',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String color, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color == 'Red' 
                ? AppTheme.errorColor 
                : color == 'Orange' 
                  ? AppTheme.warningColor 
                  : AppTheme.successColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ModernMarkerIcon extends StatelessWidget {
  final String key;
  final int size;
  final String weather;

  const _ModernMarkerIcon({
    required this.key,
    required this.size,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMarkerInfo(context);
      },
      child: Container(
        width: size.toDouble(),
        height: size.toDouble(),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  void _showMarkerInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flight Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Species: $key'),
            const SizedBox(height: 8),
            Text('Size: $size'),
            const SizedBox(height: 8),
            Text('Weather: $weather'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}