import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: themeMode == ThemeMode.dark,
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Automatic system theme supported'),
                  onChanged: (value) => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
                ),
                ListTile(
                  title: const Text('Use System Theme'),
                  trailing: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'General',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text('About Shortcut Keys Hub'),
                  subtitle: const Text('Premium offline shortcut library'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_rounded),
                  title: const Text('Privacy Policy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.star_rate_rounded),
                  title: const Text('Rate App'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: const Text('Share App'),
                  onTap: () => Share.share(
                    'Check out Shortcut Keys Hub - a premium shortcut app!',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.keyboard_rounded),
                  title: const Text('Interactive Keyboard Viewer'),
                  onTap: () => context.go('/keyboard'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_border_rounded),
                  title: const Text('Reset Favorites'),
                  onTap: () => ref.read(favoritesProvider.notifier).clear(),
                ),
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text('Reset Recents'),
                  onTap: () => ref.read(recentProvider.notifier).clear(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Language',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.language_rounded),
                  title: Text('English (Default)'),
                  subtitle: Text('Multi-language support ready'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
