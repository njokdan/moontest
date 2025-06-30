import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 60, 1)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // ↓ Add the code below.
  var favorites = <WordPair>[];
  

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }


  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

/*
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;    
    
    // ↓ Add this.
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }             // ← Add this.


    var children = [
          //Text('Daniel, A random AWESOME idea:'),
          //SizedBox(height: 16), // Adds vertical space
          //Text(appState.current.asLowerCase),
          //SizedBox(height: 10), // Adds vertical space
          bigCard(pair: pair), 
          SizedBox(height: 10), // Adds vertical space
          // ↓ Add this.
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,  // ← Add this.
            mainAxisSize: MainAxisSize.min,   // ← Add this.
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  //print('button pressed!');
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  print('button pressed!');
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              SizedBox(width: 10), // Adds horizontal space
              ElevatedButton(
                onPressed: () {
                  print('Exit');
                  appState.getNext();
                },
                child: Text('Exit'),
              ), 
              SizedBox(width: 10), // Adds horizontal space
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Get Next'),
              ),
            ],
          ), 
          //SizedBox(height: 16), // Adds vertical space
          //SizedBox(height: 16), // Adds vertical space
        ];
    return Scaffold(
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,  // ← Add this.
          children: children,
        ),
      ),
    );
  }
}
*/

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;     // ← Add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = FavoritesPages();
        break; 
      /* case 3:
        page = Placeholder();//SettingsPage();
        break;
      case 4:
        page = Placeholder();//AboutPage();
        break;
      case 5:
        page = Placeholder();//HelpPage();
        break;
      case 6:
        // Handle exit logic here, if needed.
        // For now, we can just show a message.
        page = Center(child: Text('Exit selected'));
        break; */
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600, //false,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text('Favorites List'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.info),
                      label: Text('About'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.help),
                      label: Text('Help'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.exit_to_app),
                      label: Text('Exit'),
                    ),
                  ],
                  selectedIndex: selectedIndex,  // ← Add this.
                  onDestinationSelected: (value) {
                    //print('selected: $value');
                    // ↓ Replace print with this.
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page, //GeneratorPage(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          //SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    var favorites = appState.favorites;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("favorites:"),
          for (var favorite in favorites)
            ListTile(
              title: Center(child: Text(favorite.toString())), // Assuming `favorite` has a meaningful toString()
            ),
          BigCard(pair: pair),
          //SizedBox(height: 10),
          /*Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ), */
        ],
      ),
    );
  }
}

class FavoritesPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);       // ← Add this.
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );


    return Card(
      color: theme.colorScheme.primary,    // ← And also this.
      child:Padding(
      padding: const EdgeInsets.all(20),
      // ↓ Change this line.
      //  child: Text("${pair.first} ${pair.second}", style: style),
      // ↓ Make the following change.
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}