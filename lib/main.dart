import 'package:flutter/material.dart';
import 'tokens/token_loader.dart';
import 'tokens/token_models.dart';
import 'widgets/token_color_example.dart';
import 'widgets/token_spacing_example.dart';
import 'widgets/token_typography_example.dart';
import 'widgets/token_button.dart';


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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BoxShadow> _getEffectBoxShadow(TokenData tokens) {
    // For now, hardcoded to the Button/Hover effect token values
    return [
      BoxShadow(
        color: const Color(0xFFFFBE84), // TODO: Parse dynamically if effect tokens are loaded
        offset: const Offset(4, 4),
        blurRadius: 8,
        spreadRadius: 0,
      )
    ];
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TokenData>(
      future: TokenLoader.load('assets/token.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: \\n${snapshot.error}')),
          );
        }
        final tokens = snapshot.data!;
        final colorWidgets = tokens.colors.entries.map((entry) => TokenColorExample(name: entry.key, colorToken: entry.value, allColors: tokens.colors)).toList();
        final spacingWidgets = tokens.spacings.entries.map((entry) => TokenSpacingExample(name: entry.key, spacingToken: entry.value, allSpacings: tokens.spacings)).toList();
        final typographyWidgets = tokens.typographies.entries.map((entry) => TokenTypographyExample(name: entry.key, typographyToken: entry.value, allTypographies: tokens.typographies, allColors: tokens.colors)).toList();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: tokens.colors['Colors/Primary/Primary-500']?.toColor(tokens.colors) ?? Colors.blue,
            title: Text(widget.title, style: tokens.typographies['Text/Heading/H1']?.toTextStyle(tokens.typographies)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('All Token Colors:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...colorWidgets,
                const SizedBox(height: 24),
                const Text('All Token Spacing:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...spacingWidgets,
                const SizedBox(height: 24),
                const Text('All Token Typography:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...typographyWidgets,
                const SizedBox(height: 24),
                const Text('Example Shadow Effect:', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: tokens.colors['Colors/Neutral/Neutral-0']?.toColor(tokens.colors) ?? Colors.white,
                    boxShadow: _getEffectBoxShadow(tokens),
                  ),
                  child: Center(child: Text('Shadow Effect', style: tokens.typographies['Text/ButtonMedium']?.toTextStyle(tokens.typographies))),
                ),
                const SizedBox(height: 24),
                const Text('Token Buttons:', style: TextStyle(fontWeight: FontWeight.bold)),
                const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Text('PrimaryOutlined Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...['Small', 'Medium', 'Big'].expand((size) =>
                  ['', 'Hover', 'Disabled'].map((state) =>
                    TokenButton(variant: 'PrimaryOutlined', size: size, state: state, tokens: tokens, label: 'PrimaryOutlined $size${state.isNotEmpty ? ' ($state)' : ''}')
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 4),
                  child: Text('All Button Variants:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...['Primary', 'Secondary', 'Tertiary', 'PrimaryOutlined', 'SecondaryOutlined', 'TertiaryOutlined'].expand((variant) =>
                  ['Small', 'Medium', 'Big'].expand((size) =>
                    ['', 'Hover', 'Disabled'].map((state) =>
                      TokenButton(variant: variant, size: size, state: state, tokens: tokens)
                    )
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
