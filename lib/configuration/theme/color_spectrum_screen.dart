//

import 'package:flutter/material.dart';

class ColorSpectrumScreen extends StatelessWidget {
  const ColorSpectrumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Spectrum'),
      ),
      body: const SingleChildScrollView(
        child: ColorSpectrum(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ColorSpectrum extends StatelessWidget {
  const ColorSpectrum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(value: true, onChanged: (value) {}),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'primary',
          container: Theme.of(context).colorScheme.primary,
          onContainer: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'primaryContainer',
          container: Theme.of(context).colorScheme.primaryContainer,
          onContainer: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'secondary',
          container: Theme.of(context).colorScheme.secondary,
          onContainer: Theme.of(context).colorScheme.onSecondary,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'secondaryContainer',
          container: Theme.of(context).colorScheme.secondaryContainer,
          onContainer: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'tertiary',
          container: Theme.of(context).colorScheme.tertiary,
          onContainer: Theme.of(context).colorScheme.onTertiary,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'tertiaryContainer',
          container: Theme.of(context).colorScheme.tertiaryContainer,
          onContainer: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'error',
          container: Theme.of(context).colorScheme.error,
          onContainer: Theme.of(context).colorScheme.onError,
        ),
        const SizedBox(height: 16),
        ColorDisplayer(
          label: 'errorContainer',
          container: Theme.of(context).colorScheme.errorContainer,
          onContainer: Theme.of(context).colorScheme.onErrorContainer,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ColorDisplayer extends StatelessWidget {
  const ColorDisplayer({
    super.key,
    required this.container,
    required this.onContainer,
    required this.label,
  });
  final String label;
  final Color container;
  final Color onContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: container,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: onContainer,
                ),
          ),
        ],
      ),
    );
  }
}
