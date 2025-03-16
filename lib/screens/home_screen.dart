import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login_screen.dart';
import 'cadastro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'half_life_1_screen.dart';
import 'half_life_2_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggedIn = false;
  String _userName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'Nome do Usuário';
      _isLoggedIn = prefs.containsKey('name');
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    setState(() {
      _isLoggedIn = false;
      _userName = 'Nome do Usuário';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/image1.jpg',
      'assets/images/image2.jpg',
      'assets/images/image3.jpg',
      'assets/images/image4.jpg',
      'assets/images/image5.jpg',
      'assets/images/image6.jpg',
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Half Life',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                ' WIKI',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),

      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF151515), Color(0xFF292929)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/images/Gordon_Freeman.png',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _userName,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.login, color: Colors.white),
                title: Text('Login', style: TextStyle(color: Colors.white)),
                onTap: () {
                  print('Clicou em Login');
                  if (_isLoggedIn) {
                    Navigator.pop(context);
                    print("Já está logado.");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
              ),

              ListTile(
                leading: Icon(Icons.app_registration, color: Colors.white),
                title: Text('Cadastro', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text('Sair', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            // Carrossel
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                scrollPhysics: BouncingScrollPhysics(),
              ),
              items:
                  imgList.map((imgPath) {
                    return Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
            ),
            SizedBox(height: 120),
            // Título da seção
            Text(
              'Escolha o Jogo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Botão para Half Life 1
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Fundo branco
                    foregroundColor: Colors.orange, // Texto laranja
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ), // Borda laranja
                    ),
                    elevation: 5, // Sombra leve
                  ),
                  onPressed: () {
                    if (!_isLoggedIn) {
                      _showLoginAlert();
                    } else {
                      print("Half Life 1 selecionado");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  HalfLife1Screen(), // Navega para HalfLife1Screen
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Half-Life_logo.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Half Life 1 + DLCs',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Botão para Half Life 2
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Fundo branco
                    foregroundColor: Colors.orange, // Texto laranja
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ), // Borda laranja
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (!_isLoggedIn) {
                      _showLoginAlert();
                    } else {
                      print("Half Life 2 selecionado");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  HalfLife2Screen(), // Navega para HalfLife1Screen
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Half-Life_2_Logo.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Half Life 2 + DLCs',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'V',
                      style: const TextStyle(
                        fontSize: 70,
                        color: Colors.black,
                        fontFamily: 'HalfLife',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginAlert() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Atenção'),
            content: Text('Por favor, faça login para jogar.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}
