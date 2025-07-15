import 'package:flutter/material.dart';
import 'base/base_button_config.dart';
import 'base/base_dynamic_button.dart';
import 'app/app_button_config_loader.dart';
import 'dart:convert';
import 'package:flutter/services.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<BaseButtonConfig>> _loadMergedButtonConfigs(BuildContext context) async {
    try {
      print('Loading base config...');
      final base = await loadBaseButtonConfig();
      print('Base config loaded: ' + base.toString());
      print('Loading variants...');
      final variants = await loadButtonVariants();
      print('Variants loaded: ' + variants.toString());
      final merged = mergeBaseWithVariants(base, variants);
      print('Merged configs: ' + merged.toString());
      return merged;
    } catch (e, stack) {
      print('Error loading button configs: $e\n$stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<BaseButtonConfig>>(
        future: _loadMergedButtonConfigs(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error:\n\t\t\t\t\u000b${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final configs = snapshot.data!;

          // Find outline and gradient variants by name
          final outlineConfig = configs.firstWhere(
            (c) => (c.icon == 'star_outline' && c.backgroundColor == '#FFFFFF'),
            orElse: () => configs.first,
          );
          final gradientConfig = configs.firstWhere(
            (c) => (c.icon == 'bolt' && c.gradientColors != null),
            orElse: () => configs.first,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Explicit Button Variant Examples', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),

              // OUTLINE BUTTON EXAMPLE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Outline Button', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Enabled'),
                            const SizedBox(height: 4),
                            BaseDynamicButton(
                              label: 'Outline (enabled)',
                              config: outlineConfig,
                              onPressed: () {},
                              disabled: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Disabled'),
                            const SizedBox(height: 4),
                            BaseDynamicButton(
                              label: '11111Outline (disabled)',
                              config: outlineConfig,
                              onPressed: () {},
                              disabled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // GRADIENT BUTTON EXAMPLE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gradient Button', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Enabled'),
                            const SizedBox(height: 4),
                            BaseDynamicButton(
                              label: 'Gradient (enabled)',
                              config: gradientConfig,
                              onPressed: () {},
                              disabled: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Disabled'),
                            const SizedBox(height: 4),
                            BaseDynamicButton(
                              label: 'Gradient (disabled)',
                              config: gradientConfig,
                              onPressed: () {},
                              disabled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Text('All Variants:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              // All Variants (explicit, no loop, no card)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Variant: arrow_forward', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'arrow_forward (enabled)',
                    config: configs[0],
                    onPressed: () {},
                    disabled: false,
                  ),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'arrow_forward (disabled)',
                    config: configs[0],
                    onPressed: () {},
                    disabled: true,
                  ),
                  const SizedBox(height: 24),

                  Text('Variant: star_outline', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'star_outline (enabled)',
                    config: configs[1],
                    onPressed: () {},
                    disabled: false,
                  ),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'star_outline (disabled)',
                    config: configs[1],
                    onPressed: () {},
                    disabled: true,
                  ),
                  const SizedBox(height: 24),

                  Text('Variant: bolt', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'bolt (enabled)',
                    config: configs[2],
                    onPressed: () {},
                    disabled: false,
                  ),
                  const SizedBox(height: 8),
                  BaseDynamicButton(
                    label: 'bolt (disabled)',
                    config: configs[2],
                    onPressed: () {},
                    disabled: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
