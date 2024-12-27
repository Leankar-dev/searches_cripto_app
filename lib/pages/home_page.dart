import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _value = '0';
  bool _isLoading = false;

  // void _updateValue() async {
  //   setState(() {
  //     String url = 'https://blockchain.info/ticker';
  //     http.get(Uri.parse(url)).then((response) {
  //       Map<String, dynamic> data = json.decode(response.body);
  //       setState(() {
  //         _value = data['BRL']['buy'].toString();
  //       });
  //     });
  //   });
  // }

  Future<void> _updateValue() async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://blockchain.info/ticker';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _value = data['BRL']['buy'].toString();
        });
      } else {
        throw Exception('Erro ao buscar dados');
      }
    } catch (e) {
      setState(() {
        _value = 'Erro';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitcoin Price'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple.shade200,
        padding: const EdgeInsets.all(32),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/bitcoin.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 100),
            ),
            Text(
              _isLoading ? 'Carregando...' : 'R\$ $_value',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _isLoading ? null : _updateValue,
              child: const Text(
                'Atualizar',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
