import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget moderne pour afficher les pourcentages de confiance
class ModernConfidenceCard extends StatelessWidget {
  final String title;
  final int percentage;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool animate;

  const ModernConfidenceCard({
    Key? key,
    required this.title,
    required this.percentage,
    this.subtitle,
    this.onTap,
    this.animate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animate ? const Duration(milliseconds: 300) : Duration.zero,
      curve: Curves.easeInOut,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: animate ? _PercentageAnimation(percentage) : _StaticAnimation(percentage),
                  builder: (context, child) {
                    return Text(
                      '${animate ? (_PercentageAnimation(percentage).value * percentage).round() : percentage}%',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.getSuitabilityColor(percentage),
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget moderne pour afficher les paramètres météo
class ModernWeatherParameterCard extends StatelessWidget {
  final String title;
  final String value;
  final String? suitability;
  final IconData? icon;
  final Color? color;

  const ModernWeatherParameterCard({
    Key? key,
    required this.title,
    required this.value,
    this.suitability,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 24,
                color: color ?? Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color ?? Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (suitability != null) ...[
              const SizedBox(height: 4),
              Text(
                suitability!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget moderne pour l'histogramme
class ModernHistogramCard extends StatelessWidget {
  final List<int> hourlyData;
  final List<String> labels;
  final String title;

  const ModernHistogramCard({
    Key? key,
    required this.hourlyData,
    required this.labels,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  hourlyData.length,
                  (index) => _buildHistogramBar(context, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistogramBar(BuildContext context, int index) {
    final percentage = hourlyData[index];
    final maxPercentage = hourlyData.reduce((a, b) => a > b ? a : b);
    final heightFactor = maxPercentage > 0 ? percentage / maxPercentage : 0.0;
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              height: 80 * heightFactor,
              decoration: BoxDecoration(
                color: AppTheme.getSuitabilityColor(percentage),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              labels[index],
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget moderne pour la table des prévisions
class ModernForecastTable extends StatelessWidget {
  final List<Map<String, dynamic>> forecastData;
  final List<String> columns;

  const ModernForecastTable({
    Key? key,
    required this.forecastData,
    required this.columns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Week',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 48,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 48,
                horizontalMargin: 16,
                columnSpacing: 24,
                dividerThickness: 1,
                columns: columns.map((column) => DataColumn(
                  label: Text(
                    column,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )).toList(),
                rows: forecastData.map((data) => DataRow(
                  cells: columns.map((column) => DataCell(
                    Text(
                      data[column] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: data['percentage'] != null 
                          ? AppTheme.getSuitabilityColor(data['percentage'])
                          : null,
                      ),
                    ),
                  )).toList(),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget moderne pour les boutons d'action
class ModernActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;

  const ModernActionButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = ButtonType.filled,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button;
    
    switch (type) {
      case ButtonType.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildButtonContent(),
        );
        break;
      case ButtonType.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildButtonContent(),
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildButtonContent(),
        );
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: button,
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

enum ButtonType { filled, elevated, outlined }

/// Animations pour les pourcentages
class _PercentageAnimation extends Animation<double> {
  final int targetPercentage;
  
  _PercentageAnimation(this.targetPercentage);

  @override
  double get value => 1.0;

  @override
  void addListener(VoidCallback listener) {}
  
  @override
  void removeListener(VoidCallback listener) {}
  
  @override
  void addStatusListener(AnimationStatusListener listener) {}
  
  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}

class _StaticAnimation extends Animation<double> {
  final int targetPercentage;
  
  _StaticAnimation(this.targetPercentage);

  @override
  double get value => 1.0;

  @override
  void addListener(VoidCallback listener) {}
  
  @override
  void removeListener(VoidCallback listener) {}
  
  @override
  void addStatusListener(AnimationStatusListener listener) {}
  
  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}

/// Widget pour les transitions Hero
class HeroCard extends StatelessWidget {
  final Widget child;
  final String heroTag;

  const HeroCard({
    Key? key,
    required this.child,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}

/// Widget pour les animations de fade
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}