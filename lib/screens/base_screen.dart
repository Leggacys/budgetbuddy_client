// Base screen class for consistent structure
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart' as common;

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  // Override these methods in child classes
  PreferredSizeWidget? buildAppBar() => null;
  Widget? buildFloatingActionButton() => null;
  Widget? buildBottomNavigationBar() => null;

  Widget buildBody() {
    if (isLoading) {
      return const common.LoadingWidget(message: 'Loading...');
    }

    if (errorMessage != null) {
      return common.ErrorWidget(message: errorMessage!, onRetry: onRetry);
    }

    return buildContent();
  }

  // Child classes must implement this
  Widget buildContent();

  // Override for retry functionality
  void onRetry() {
    setState(() {
      errorMessage = null;
    });
  }

  // Helper methods
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void setError(String error) {
    if (mounted) {
      setState(() {
        isLoading = false;
        errorMessage = error;
      });
    }
  }

  void clearError() {
    if (mounted) {
      setState(() {
        errorMessage = null;
      });
    }
  }
}

// Example implementation
class ExampleScreen extends BaseScreen {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends BaseScreenState<ExampleScreen> {
  @override
  PreferredSizeWidget? buildAppBar() {
    return AppBar(title: const Text('Example Screen'));
  }

  @override
  Widget buildContent() {
    return const Center(
      child: Text('This is an example screen using the base structure'),
    );
  }
}
