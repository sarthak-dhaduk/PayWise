import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CustomLoader {
  // This function shows the loader overlay and executes the provided task
  static Future<void> showLoaderForTask({
    required BuildContext context,
    required Future<void> Function() task,
  }) async {
    // Show the loader before starting the task
    context.loaderOverlay.show(
      widgetBuilder: (context) => Container(
        color: Colors.white, // Set full-screen white background
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: const Color.fromARGB(255, 130, 41, 255), // Spinner color
            size: 60, // Spinner size
          ),
        ),
      ),
    );

    try {
      // Perform the task and wait for its completion
      await task();
    } finally {
      // Hide the loader once the task is completed
      context.loaderOverlay.hide();
    }
  }
}
