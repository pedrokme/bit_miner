import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(BitcoinClickerApp());

class Upgrade {
  String name;
  double baseCost;
  double clickRateIncrease;

  Upgrade({required this.name, required this.baseCost, required this.clickRateIncrease});
}

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
  double clickValue = 1.0;
  double clickPerSecond = 0.0;
  int manualClicks = 0;
  int clickUpgradeLevel = 0; // Nível do upgrade de clique
  int clickPerSecondUpgradeLevel = 0; // Nível do upgrade de cliques por segundo
  List<Upgrade> upgrades = [
    Upgrade(name: 'Placa de Vídeo', baseCost: 40.0, clickRateIncrease: 1.5),
    // Adicione mais upgrades conforme necessário
  ];

  bool showUpgrades = false;

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

  void buyUpgrade(Upgrade upgrade) {
    if (bitcoins >= upgrade.baseCost) {
      setState(() {
        bitcoins -= upgrade.baseCost;
        clickPerSecond += upgrade.clickRateIncrease;
        upgrade.baseCost *= 2; // Ajuste conforme necessário para o custo do próximo upgrade
      });

      if (upgrade == upgrades[0]) {
        // Se o upgrade for de clique, aumenta o nível do upgrade de clique
        clickUpgradeLevel++;
        clickValue *= 2;
      } else {
        // Se o upgrade for de cliques por segundo, aumenta o nível do upgrade de cliques por segundo
        clickPerSecondUpgradeLevel++;
      }
    }
  }

  void manualClick() {
    setState(() {
      bitcoins += clickValue;
      manualClicks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  'Bitcoins: ${bitcoins.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Ink.image(
                    image: AssetImage('assets/button.png'), // Substitua pelo caminho correto da sua imagem
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () => manualClick(),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(''), // Adicione um Text vazio ou qualquer outro widget se desejar algum texto sobre a imagem
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Bitcoins por segundo: ${clickPerSecond.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                Text(
                  'Valor do Clique: $clickValue',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 10.0),
                Visibility(
                  visible: manualClicks > 0,
                  child: Text(
                    'Cliques Manuais: $manualClicks',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (bitcoins >= 10.0) {
                      setState(() {
                        bitcoins -= 10.0;
                        clickValue += 1.0;
                      });
                    }
                  },
                  child: Text('Melhorar o valor do clique (10 bitcoins)', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (bitcoins >= 50.0) {
                      setState(() {
                        bitcoins -= 50.0;
                        clickPerSecond += 0.5;
                      });
                    }
                  },
                  child: Text('Melhorar os bitcoins por segundo (50 bitcoins)', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          if (showUpgrades)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: 200,
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: Text(
                        'Loja de Upgrades',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var upgrade in upgrades)
                      ListTile(
                        title: Text('${upgrade.name} - ${upgrade.baseCost} bitcoins'),
                        subtitle: Text('Aumento por segundo: +${upgrade.clickRateIncrease}'),
                        onTap: () => buyUpgrade(upgrade),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showUpgrades = !showUpgrades;
          });
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
