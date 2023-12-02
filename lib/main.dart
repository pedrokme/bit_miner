import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(BitcoinClickerApp());

class BitcoinClickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin Clicker',
      home: BitcoinClicker(),
    );
  }
}

class BitcoinClicker extends StatefulWidget {
  @override
  _BitcoinClickerState createState() => _BitcoinClickerState();
}

class _BitcoinClickerState extends State<BitcoinClicker> {
  double bitcoins = 0.0;
  double clickValue = 0.0001;
  double clickPerSecond = 0.0;

  @override
  void initState() {
    super.initState();
    // Inicia o temporizador para atualizar os bitcoins por segundo
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        bitcoins += clickPerSecond;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Clicker'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundo.gif'), // Substitua pelo caminho correto do seu arquivo GIF
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Bitcoins: ${bitcoins.toStringAsFixed(3)}',
                  style: TextStyle(fontSize: 24.0, color: Colors.white)
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bitcoins += clickValue;
                    });
                  },
                  child: Text('Clique para ganhar Bitcoin'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Bitcoins por segundo: ${clickPerSecond.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)
                ),
                ElevatedButton(
                  onPressed: () {
                    if (bitcoins >= 0.010) {
                      setState(() {
                        bitcoins -= 0.0010;
                        clickValue += 0.0001;
                      });
                    }
                  },
                  child: Text('Melhorar o valor do clique (10 bitcoins)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (bitcoins >= 0.0050) {
                      setState(() {
                        bitcoins -= 0.0050;
                        clickPerSecond += 0.0005;
                      });
                    }
                  },
                  child: Text('Melhorar os bitcoins por segundo (50 bitcoins)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
