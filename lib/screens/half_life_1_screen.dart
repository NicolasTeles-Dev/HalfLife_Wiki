import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HalfLife1Screen extends StatefulWidget {
  @override
  _HalfLife1ScreenState createState() => _HalfLife1ScreenState();
}

class _HalfLife1ScreenState extends State<HalfLife1Screen> {
  Map<String, dynamic>? jogo;
  List<dynamic> dlcs = [];
  List<dynamic> personagens = [];
  List<dynamic> eventos = [];
  List<dynamic> mapas = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final jogoResponse = await http.get(
      Uri.parse('http://localhost:3000/jogos'),
    );
    if (jogoResponse.statusCode == 200) {
      final jogoData = json.decode(jogoResponse.body);

      // Se a resposta for uma lista, pegamos o primeiro item
      if (jogoData is List && jogoData.isNotEmpty) {
        final jogo = jogoData.firstWhere(
          (jogoItem) => jogoItem['jogoId'] == 1,
          orElse: () => null,
        );

        setState(() {
          this.jogo = jogo; // Pega o jogo com jogoId igual a 1
        });
      } else {
        setState(() {
          jogo = null;
        });
      }
    }

    // Para DLCs
    final dlcResponse = await http.get(Uri.parse('http://localhost:3000/dlcs'));
    if (dlcResponse.statusCode == 200) {
      final dlcData = json.decode(dlcResponse.body);
      final filteredDlcs = dlcData.where((dlc) => dlc['jogoId'] == 1).toList();

      setState(() {
        dlcs = filteredDlcs; // Filtra DLCs com jogoId igual a 1
      });
    }

    // Para personagens
    final personagensResponse = await http.get(
      Uri.parse('http://localhost:3000/personagens'),
    );
    if (personagensResponse.statusCode == 200) {
      final personagensData = json.decode(personagensResponse.body);
      final filteredPersonagens =
          personagensData
              .where((personagem) => personagem['jogoId'] == 1)
              .toList();

      setState(() {
        personagens =
            filteredPersonagens; // Filtra personagens com jogoId igual a 1
      });
    }

    // Para eventos
    final eventosResponse = await http.get(
      Uri.parse('http://localhost:3000/eventos'),
    );
    if (eventosResponse.statusCode == 200) {
      final eventosData = json.decode(eventosResponse.body);
      final filteredEventos =
          eventosData.where((evento) => evento['jogoId'] == 1).toList();

      setState(() {
        eventos = filteredEventos; // Filtra eventos com jogoId igual a 1
      });
    }

    // Para mapas
    final mapasResponse = await http.get(
      Uri.parse('http://localhost:3000/mapas'),
    );
    if (mapasResponse.statusCode == 200) {
      final mapasData = json.decode(mapasResponse.body);
      final filteredMapas =
          mapasData.where((mapa) => mapa['jogoId'] == 1).toList();

      setState(() {
        mapas = filteredMapas; // Filtra mapas com jogoId igual a 1
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(jogo?['titulo'] ?? 'Carregando...')),
      body:
          jogo == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(jogo!['imagem'], fit: BoxFit.cover),
                      SizedBox(height: 16),
                      Text(
                        jogo!['titulo'],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ano: ${jogo!['ano']}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(jogo!['historia'], style: TextStyle(fontSize: 16)),
                      Divider(),
                      _buildSection('DLCs', dlcs),
                      _buildSection('Personagens', personagens),
                      _buildSection('Eventos', eventos),
                      _buildSection('Mapas', mapas),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    if (items.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(children: items.map((item) => _buildCard(item)).toList()),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCard(dynamic item) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item['imagem'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['nome'] ?? item['titulo'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item['descricao'] ?? item['papel'] ?? ''),
      ),
    );
  }
}
