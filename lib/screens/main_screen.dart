import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pokedex_flutter/config/theme/app_theme.dart';
import 'package:pokedex_flutter/data/bbdd.dart';
import 'package:pokedex_flutter/extensions/extensions.dart';
import 'package:pokedex_flutter/providers/pokemon_provider.dart';
import 'package:pokedex_flutter/screens/pokemon_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _offset = 0;
  bool _isGridView = false;
  String _searchQuery = '';
  bool _orderByName = false;
  String _selectedType = 'All';
  Set<int> _favorites = {};
  bool _isDarkMode = true;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    context.read<PokemonProvider>().checkLocalDatabase();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false)
          .fetchPokemon(_offset);
    });
    _initializeNotifications();
    _isDarkMode ? AppTheme().getDarkTheme() : AppTheme().getLightTheme();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showFavoriteNotification(String name, String imageUrl) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Added to Favorites',
      name,
      platformChannelSpecifics,
      payload: imageUrl,
    );
  }

  void _toggleFavorite(int id, String name, String imageUrl) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
        _showFavoriteNotification(name, imageUrl);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '${_favorites.contains(id) ? '$name added to' : '$name removed from'} favorites'),
      duration: const Duration(seconds: 1),
    ));
  }

  void _fetchAllPokemon() {
    Provider.of<PokemonProvider>(context, listen: false).fetchAllPokemon();
  }

  void _showRandomPokemon() {
    final random = Random();
    final randomPokemon = Provider.of<PokemonProvider>(context, listen: false)
        .pokemonList[random.nextInt(
            Provider.of<PokemonProvider>(context, listen: false).pokemonList.length)];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        Provider.of<PokemonProvider>(context, listen: false)
            .changePokemon(idPokemon: randomPokemon.id);
        return PokemonScreen(randomPokemon.id);
      }),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMorePokemon();
    }
  }

  Future<void> _loadMorePokemon() async {
    setState(() {
      _isLoadingMore = true;
    });
    _offset += 20;
    await Provider.of<PokemonProvider>(context, listen: false)
        .fetchPokemon(_offset);
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _switchTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleFavoritesView() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getLightTheme(),
      darkTheme: AppTheme().getDarkTheme(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkMode ? Colors.black : Colors.white,
          title: Text('POKEAPP', style: GoogleFonts.pressStart2p(),),
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view,
                  ),
              onPressed: _toggleView,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchAllPokemon,
            ),
            IconButton(onPressed: () {PokemonDatabase().saveAllPokemons(Provider.of<PokemonProvider>(context, listen: false)
                .pokemonList);}, icon: Icon(Icons.download)),
            IconButton(
              icon: const Icon(Icons.shuffle),
              onPressed: _showRandomPokemon,
            ),
            IconButton(
              icon: Icon(
                _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: _toggleFavoritesView,
            ),
            IconButton(
              onPressed: _switchTheme,
              icon: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Pokemon...',
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: _selectedType,
                  items: [
                    'All',
                    'normal',
                    'fire',
                    'water',
                    'grass',
                    'electric',
                    'ice',
                    'fighting',
                    'poison',
                    'ground',
                    'flying',
                    'psychic',
                    'bug',
                    'rock',
                    'ghost',
                    'dark',
                    'dragon',
                    'steel',
                    'fairy'
                  ]
                      .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type,)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                Row(
                  children: [
                    const Text('ID'),
                    Switch(
                      value: _orderByName,
                      onChanged: (value) {
                        setState(() {
                          _orderByName = value;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                    const Text('Name'),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Consumer<PokemonProvider>(
                builder: (context, pokemonProvider, child) {
                  var filteredList = pokemonProvider.pokemonList.where((pokemon) {
                    return pokemon.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) &&
                        (_selectedType == 'All' ||
                            pokemon.types.contains(_selectedType));
                  }).toList();

                  if (_showFavoritesOnly) {
                    filteredList = filteredList
                        .where((pokemon) => _favorites.contains(pokemon.id))
                        .toList();
                  }

                  if (_orderByName) {
                    filteredList.sort((a, b) => a.name.compareTo(b.name));
                  } else {
                    filteredList.sort((a, b) => a.id.compareTo(b.id));
                  }

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Image.asset('assets/images/spinnerPokeball.gif',
                          width: MediaQuery.of(context).size.width * 0.1),
                    );
                  }

                  Future.delayed(const Duration(seconds: 3), () {
                    AlertDialog(
                      title: const Text('Error'),
                      content: const Text('There\'s some issue with your search/filter or your internet connection'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  });

                  Future.delayed(const Duration(seconds: 15), () {
                    _fetchAllPokemon();
                  });


                  return _isGridView
                      ? GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount:
                              filteredList.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredList.length) {
                              return Center(
                                child: Image.asset(
                                    'assets/images/spinnerPokeball.gif',
                                    width:
                                        MediaQuery.of(context).size.width * 0.1),
                              );
                            }
                            return _buildPokemonCard(filteredList[index]);
                          },
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              filteredList.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredList.length) {
                              return Center(
                                child: Image.asset(
                                    'assets/images/spinnerPokeball.gif',
                                    width:
                                        MediaQuery.of(context).size.width * 0.1),
                              );
                            }
                            return _buildPokemonCardList(filteredList[index]);
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(pokemon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            Provider.of<PokemonProvider>(context, listen: false)
                .changePokemon(idPokemon: pokemon.id);
            return PokemonScreen(pokemon.id);
          }),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 8,
        color: _getColorByType(pokemon.types.first),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(pokemon.image, height: 80, width: 80),
            Text(pokemon.name.toString().capitalize(),
                style: GoogleFonts.lato(fontSize: 18, color: Colors.white)),
            IconButton(
              icon: Icon(
                  _favorites.contains(pokemon.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.redAccent),
              onPressed: () {
                _toggleFavorite(pokemon.id, pokemon.name, pokemon.image);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCardList(pokemon) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        color: _getColorByType(pokemon.types.first),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          leading: Image.network(pokemon.image),
          title: Text(
            pokemon.name.toString().capitalize(),
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${pokemon.id}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4.0),
              Text(
                'Stadistics: ${pokemon.stadistics.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                  _favorites.contains(pokemon.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.redAccent),
              onPressed: () {
                _toggleFavorite(pokemon.id, pokemon.name, pokemon.image);
              }),
          onTap: () {
            context
                .read<PokemonProvider>()
                .changePokemon(idPokemon: pokemon.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonScreen(pokemon.id),
              ),
            );
          },
        ));
  }

  Color _getColorByType(String type) {
    switch (type) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      // Add more cases for other types
      default:
        return Colors.grey[900]!;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
