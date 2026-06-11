import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MainEntryPage(),
    );
  }
}

// --- THE MAIN ENTRY PAGE (Controls Navigation & Structure) ---
class MainEntryPage extends StatefulWidget {
  const MainEntryPage({super.key});

  @override
  State<MainEntryPage> createState() => _MainEntryPageState();
}

class _MainEntryPageState extends State<MainEntryPage> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    const HomeView(),
    const SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // LEARN: Scaffold Widget
    // The Scaffold is the "skeleton" of a screen. It provides slots for standard UI elements.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Learning Lab'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        // The menu icon will automatically appear when a 'drawer' is added!
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Scaffold provides the AppBar, Drawer, and Body!')),
              );
            },
          ),
        ],
      ),
      
      // LEARN: Scaffold.drawer
      // A side menu that slides in from the left.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  const Text('Learning Flutter', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Level: Beginner', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Cookbook Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Scaffold'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(context: context, applicationName: 'Learning Lab');
              },
            ),
          ],
        ),
      ),

      body: _views[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// --- HOME VIEW ---
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Scaffold Widget',
            content: 'Scaffold is the structural layout for Material widgets. It handles drawers, snackbars, and bottom sheets.',
            color: Colors.purpleAccent,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: 'Network Images',
            content: 'Use Image.network to display images directly from the internet via a URL.',
            color: Colors.lightBlueAccent,
          ),
          const Divider(height: 40),

          // LEARN: Network Image with placeholder (CoctoImage concept)
          const Text('Network Image Example:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.lightBlueAccent, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                height: 150,
                width: 250,
                fit: BoxFit.cover,
                // Placeholder while loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 150,
                    width: 250,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                // Error handling
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 150,
                  width: 250,
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                ),
              ),
            ),
          ),
          const Text('\nAbove is a GIF loaded from Flutter docs.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          
          const Divider(height: 40),
          
          _buildInfoCard(
            title: 'Opacity & Assets',
            content: 'Logo below is an Asset Image wrapped in an Opacity widget (0.5).',
            color: Colors.orangeAccent,
          ),
          const SizedBox(height: 20),
          
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/favicon.png',
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.red, size: 50),
              ),
            ),
          ),
          const Divider(height: 40),
          
          const Text('Interactive Counter:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_counter', style: Theme.of(context).textTheme.displayMedium),
              ElevatedButton.icon(
                onPressed: () => setState(() => _counter++),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- SETTINGS VIEW ---
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildInfoCard(
            title: 'App Theme',
            content: 'Dark Mode is currently active.',
            color: Colors.orangeAccent,
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('User Profile'),
            subtitle: const Text('Manage your account settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Configure app alerts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Spacer(),
          Center(
            child: Text(
              'App Version: 1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Shared Helper Widget
Widget _buildInfoCard({required String title, required String content, required Color color}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
  );
}
