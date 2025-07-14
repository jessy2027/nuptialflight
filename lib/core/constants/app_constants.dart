/// Constantes centralisées pour l'application Ant Nuptial Flight Predictor
class AppConstants {
  // API Keys
  static const String kGoogleApiKey = 'AIzaSyDNaPQ01hKnTmVRQoT_FM1ZTTxDnw6GoOU';

  // Seuils de confiance
  static const int greenThreshold = 60;
  static const int amberThreshold = 50;

  // Dimensions d'écran
  static const int largeScreenHeight = 800;
  static const int tabletBreakpoint = 600;
  static const int desktopBreakpoint = 1200;

  // Espacements
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Bordures arrondies
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // Élévations
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationLarge = 4.0;
  static const double elevationXLarge = 8.0;

  // Tailles d'icônes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Durées d'animation
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // Messages d'erreur
  static const String errorLocationNotFound = 'Location not found';
  static const String errorWeatherData = 'Unable to fetch weather data';
  static const String errorNetworkConnection = 'Network connection error';
  static const String errorUnknown = 'An unexpected error occurred';

  // Messages de succès
  static const String successLocationUpdated = 'Location updated successfully';
  static const String successWeatherUpdated = 'Weather data updated';
  static const String successFlightReported = 'Flight reported successfully';

  // Textes de l'interface
  static const String appTitle = 'Ant Nuptial Flight Predictor';
  static const String confidenceTitle = 'Confidence of Nuptial Flight';
  static const String diurnalFlightTitle = 'Diurnal Flight';
  static const String nocturnalFlightTitle = 'Nocturnal Flight';
  static const String hourlyConfidenceTitle = 'Hourly Confidence';
  static const String upcomingWeekTitle = 'Upcoming Week';
  static const String mapTitle = 'Flight Map';
  static const String mapLegendTitle = 'Map Legend';

  // Paramètres météo
  static const String temperatureTitle = 'Temperature';
  static const String windSpeedTitle = 'Wind Speed';
  static const String precipitationTitle = 'Precipitation';
  static const String humidityTitle = 'Humidity';
  static const String pressureTitle = 'Air Pressure';
  static const String cloudsTitle = 'Clouds';

  // Unités
  static const String temperatureUnit = '°C';
  static const String windSpeedUnit = 'm/s';
  static const String pressureUnit = 'hPa';
  static const String percentageUnit = '%';

  // Actions
  static const String actionRetry = 'Retry';
  static const String actionRefresh = 'Refresh';
  static const String actionClose = 'Close';
  static const String actionReport = 'Report';
  static const String actionCancel = 'Cancel';

  // Tooltips
  static const String tooltipShowMap = 'Show Map';
  static const String tooltipRefreshLocation = 'Refresh Location';
  static const String tooltipReportFlight = 'Report Nuptial Flight';
  static const String tooltipGoToLocation = 'Go to my location';

  // URLs
  static const String openWeatherMapUrl = 'http://openweathermap.org';
  static const String mapTilerUrl = 'https://www.maptiler.com/copyright/';
  static const String openStreetMapUrl = 'https://www.openstreetmap.org/copyright';

  // Formats de date
  static const String dateFormat = 'yyyy-MM-dd';
  static const String longDateFormat = 'MMMEd';
  static const String weekdayFormat = 'E';
  static const String timeOfDayFormat = 'ha';
  static const String timeOfDay24HourFormat = 'HH';

  // Configuration de la carte
  static const double defaultMapZoom = 3.0;
  static const double minMapZoom = 2.0;
  static const double maxMapZoom = 9.0;
  static const double weatherLayerOpacity = 0.165;

  // Configuration des marqueurs
  static const double markerBorderWidth = 2.0;
  static const double markerShadowBlur = 4.0;
  static const double markerShadowOffset = 2.0;

  // Configuration des histogrammes
  static const double histogramHeight = 120.0;
  static const double histogramBarSpacing = 2.0;
  static const double histogramBarBorderRadius = 4.0;

  // Configuration des grilles
  static const int mobileGridColumns = 2;
  static const int tabletGridColumns = 3;
  static const double gridChildAspectRatio = 1.2;
  static const double gridSpacing = 16.0;

  // Configuration des cartes
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 16.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  // Configuration des boutons
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 12.0,
  );
  static const double buttonBorderRadius = 12.0;

  // Configuration des tables
  static const double tableHeadingRowHeight = 48.0;
  static const double tableDataRowMinHeight = 48.0;
  static const double tableDataRowMaxHeight = 48.0;
  static const double tableHorizontalMargin = 16.0;
  static const double tableColumnSpacing = 24.0;
  static const double tableDividerThickness = 1.0;

  // Configuration des animations
  static const double animationScaleBegin = 0.95;
  static const double animationScaleEnd = 1.0;
  static const Offset animationSlideBegin = Offset(0, 0.3);
  static const Offset animationSlideEnd = Offset.zero;
  static const Offset animationSlideRightBegin = Offset(1.0, 0.0);
  static const Offset animationSlideRightEnd = Offset.zero;

  // Configuration des transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration fadeTransitionDuration = Duration(milliseconds: 300);
  static const Duration slideTransitionDuration = Duration(milliseconds: 300);

  // Configuration des délais
  static const Duration errorDisplayDelay = Duration(milliseconds: 3000);
  static const Duration locationUpdateDelay = Duration(milliseconds: 3000);
  static const Duration animationStaggerDelay = Duration(milliseconds: 100);

  // Configuration des limites
  static const int maxHourlyDataPoints = 24;
  static const int maxDailyDataPoints = 7;
  static const int maxHistogramBars = 24;

  // Configuration des couleurs par défaut
  static const int defaultPrimaryColor = 0xFF6750A4;
  static const int defaultSecondaryColor = 0xFF625B71;
  static const int defaultTertiaryColor = 0xFF7D5260;

  // Configuration des polices
  static const String defaultFontFamily = 'Roboto';
  static const String customFontFamily = 'WingedAnt';
  static const double defaultFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double xlargeFontSize = 18.0;
  static const double xxlargeFontSize = 20.0;
  static const double xxxlargeFontSize = 24.0;

  // Configuration des poids de police
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w900;

  // Configuration des espacements de lettres
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.1;
  static const double letterSpacingExtraWide = 0.5;

  // Configuration des hauteurs de ligne
  static const double lineHeightTight = 0.9;
  static const double lineHeightNormal = 1.0;
  static const double lineHeightRelaxed = 1.2;
  static const double lineHeightLoose = 1.5;
}