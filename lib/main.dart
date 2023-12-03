import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(BitcoinClickerApp());

class Upgrade {
  String name;
  double baseCost;

  double clickRateMultiplier;
  double clickRateBase;
  double clickIndvValue;

  double manualClickMultiplier;

  Upgrade({
    required this.name,
    required this.baseCost,
    required this.clickRateMultiplier,
    required this.clickIndvValue,
    required this.manualClickMultiplier,
    required this.clickRateBase,
  });
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
  int clickUpgradeLevel = 0;
  int manualClickUpgradeLevel = 0;
  List<Upgrade> upgrades = [
    Upgrade(name: 'Valor do Click', baseCost: 10, clickRateMultiplier: 0, clickIndvValue: 0, manualClickMultiplier: 1, clickRateBase: 0),
    Upgrade(name: 'Placa de Vídeo', baseCost: 40.0, clickRateMultiplier: 0.3, clickIndvValue: 0, manualClickMultiplier: 0, clickRateBase: 1),
    // Adicione mais upgrades conforme necessário
  ];

  bool showUpgrades = false;

  @override
  void initState() {
    super.initState();
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

        if (upgrade.clickRateBase == 0) {
          clickPerSecond += upgrade.clickRateBase;
          upgrade.clickIndvValue += upgrade.clickRateBase;
        } else {
          clickPerSecond += upgrade.clickRateBase * upgrade.clickRateMultiplier;
          upgrade.clickIndvValue += upgrade.clickRateBase * upgrade.clickRateMultiplier;
        }

        clickValue += upgrade.manualClickMultiplier;

        if (upgrade.name == 'Placa de Vídeo') {
          upgrade.baseCost *= 1.5;
        } else if (upgrade.name == 'Valor do Click') {
          upgrade.baseCost *= 1.32;
        }
      });

      if (upgrade == upgrades[0]) {
        clickUpgradeLevel++;
      } else {
        manualClickUpgradeLevel++;
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
                  'Bitcoins: ${(bitcoins / 10000).toStringAsFixed(4)}',
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
                        child: Text(''),
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
                width: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backgroundupgrade.jpg'), // Substitua pelo caminho correto da sua imagem de fundo
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: Text(
                        'Loja de Upgrades',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    for (var upgrade in upgrades)
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(27, 75, 114, 1), // Cor de fundo do upgrade
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Tooltip(
                          message: 'Bitcoins por segundo: +${upgrade.clickIndvValue.toStringAsFixed(1)}\n'
                              'Aumento por segundo: +${(upgrade.clickRateMultiplier * 100).toStringAsFixed(0)}%\n'
                              'Aumento para cliques manuais: +${(upgrade.manualClickMultiplier * 100).toStringAsFixed(0)}%',
                          child: ListTile(
                            textColor: Colors.white,
                            title: Text('${upgrade.name} - ${(upgrade.baseCost).toStringAsFixed(1)} bitcoins'),
                            onTap: () => buyUpgrade(upgrade),
                          ),
                        ),
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
