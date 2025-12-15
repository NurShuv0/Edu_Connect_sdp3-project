import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller for lighting effect
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Create opacity animation (increases and decreases lighting)
    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900,
              Colors.indigo.shade700,
              Colors.indigo.shade500,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background glow effect
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.5,
                      colors: [
                        Colors.white.withValues(
                          alpha: _opacityAnimation.value * 0.15,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated loading circle with gradient
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(
                                alpha: _opacityAnimation.value * 0.5,
                              ),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer rotating ring
                            RotationTransition(
                              turns: Tween(
                                begin: 0.0,
                                end: 1.0,
                              ).animate(_animationController),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),

                            // Inner animated circle
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(
                                    alpha: _opacityAnimation.value * 0.7,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),

                            // Center dot
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(
                                  alpha: _opacityAnimation.value,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(
                                      alpha: _opacityAnimation.value * 0.8,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Animated EduConnect text
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: Tween(begin: 0.95, end: 1.05).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Text(
                          'EduConnect',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withValues(
                              alpha: _opacityAnimation.value,
                            ),
                            letterSpacing: 2,
                            shadows: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: _opacityAnimation.value * 0.6,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.indigo.withValues(
                                  alpha: _opacityAnimation.value * 0.4,
                                ),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Subtitle with fade effect
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Text(
                        'Connecting Learning, Changing Lives',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(
                            alpha: _opacityAnimation.value * 0.8,
                          ),
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom loading indicator with dots
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final delay = index * 0.3;
                        final adjustedValue =
                            (_animationController.value + delay) % 1.0;
                        final sineValue = math.sin(adjustedValue * math.pi);
                        final opacity = (sineValue + 1) / 2;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: opacity),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: opacity * 0.5,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
