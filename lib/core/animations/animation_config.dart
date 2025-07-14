import 'package:flutter/material.dart';

/// Configuration centralisée pour toutes les animations de l'application
class AnimationConfig {
  // Durées d'animation
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Courbes d'animation
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;

  // Animations d'entrée
  static Animation<double> fadeInAnimation(
    AnimationController controller, {
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  static Animation<Offset> slideInAnimation(
    AnimationController controller, {
    Duration duration = normal,
    Curve curve = easeOutCubic,
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  static Animation<double> scaleAnimation(
    AnimationController controller, {
    Duration duration = normal,
    Curve curve = elasticOut,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Animations de transition
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: end,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          )),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Animations de conteneur
  static AnimatedContainer animatedContainer({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeInOut,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    double? width,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }

  // Animations de liste
  static Widget staggeredList({
    required List<Widget> children,
    Duration staggerDuration = const Duration(milliseconds: 100),
    Duration itemDuration = normal,
    Curve curve = easeOutCubic,
  }) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds: (index * staggerDuration.inMilliseconds) + itemDuration.inMilliseconds,
          ),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: curve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: children[index],
              ),
            );
          },
        );
      },
    );
  }

  // Animations de pourcentage
  static Widget animatedPercentage({
    required int percentage,
    required TextStyle style,
    Duration duration = slow,
    Curve curve = easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: percentage / 100.0),
      curve: curve,
      builder: (context, value, child) {
        return Text(
          '${(value * percentage).round()}%',
          style: style,
        );
      },
    );
  }

  // Animations d'histogramme
  static Widget animatedHistogramBar({
    required double height,
    required Color color,
    Duration duration = slow,
    Curve curve = easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: height),
      curve: curve,
      builder: (context, value, child) {
        return Container(
          height: value,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  // Animations de bouton
  static Widget animatedButton({
    required Widget child,
    required VoidCallback? onPressed,
    Duration duration = fast,
    Curve curve = easeInOut,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 1.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Animations de carte
  static Widget animatedCard({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeInOut,
    VoidCallback? onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}