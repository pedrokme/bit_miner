import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(BitcoinClickerApp());

class Upgrade {
  String name;
  double baseCost;

  double clickRateMultiplier;
  double clickRateBase;
  double autoClickIndvValue;
  double clickIndvValue;
  int upgradeLevel;

  double manualClickMultiplier;

  String iconPath;

  Upgrade({
    required this.name,
    required this.baseCost,
    required this.clickRateMultiplier,
    required this.autoClickIndvValue,
    required this.clickIndvValue,
    required this.upgradeLevel,
    required this.manualClickMultiplier,
    required this.clickRateBase,
    required this.iconPath,
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
    Upgrade(name: 'Valor do Click', baseCost: 10, clickRateMultiplier: 0, autoClickIndvValue: 0, clickIndvValue: 0, upgradeLevel: 0, manualClickMultiplier: 0.3, clickRateBase: 0, iconPath: '../assets/upgradesIcons/mouse.png'),
    Upgrade(name: 'MTX 340', baseCost: 40.0, clickRateMultiplier: 0.5, autoClickIndvValue: 0, clickIndvValue: 0, upgradeLevel: 0, manualClickMultiplier: 0, clickRateBase: 1, iconPath: '../assets/upgradesIcons/placa_video_upgrade_1.png'),
    Upgrade(name: 'MTX 720', baseCost: 300, clickRateMultiplier: 2.7, autoClickIndvValue: 0, clickIndvValue: 0, upgradeLevel: 0, manualClickMultiplier: 5, clickRateBase: 10, iconPath: '../assets/upgradesIcons/placa_video_upgrade_2.png')
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

        if (upgrade.upgradeLevel == 0) {
          clickPerSecond += upgrade.clickRateBase;
          upgrade.autoClickIndvValue += upgrade.clickRateBase;
        } else {
          clickPerSecond += upgrade.clickRateBase * upgrade.clickRateMultiplier;
          upgrade.autoClickIndvValue += upgrade.clickRateBase * upgrade.clickRateMultiplier;
        }

        clickValue += upgrade.manualClickMultiplier;
        upgrade.clickIndvValue += upgrade.manualClickMultiplier;
        upgrade.upgradeLevel++;

        if (upgrade.name == 'Valor do Click') {
          upgrade.baseCost *= 1.22;
        } else if (upgrade.name == 'MTX 340') {
          upgrade.baseCost *= 1.34;
        } else if (upgrade.name == 'MTX 720') {
          upgrade.baseCost *= 1.56;
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/1.png'), // Substitua pelo caminho correto do seu arquivo GIF
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => manualClick(),
                      child: Image.asset(
                        '../assets/moeda.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Bitcoins por segundo: ${(clickPerSecond/10000).toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                Text(
                  'Valor do Clique: ${(clickValue/10000).toStringAsFixed(4)}',
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
          AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: 0,
      bottom: 0,
      right: showUpgrades ? 0 : -400,
      child: Container(
        width: 400,
        padding: EdgeInsets.only(left: 20, top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../assets/janelafundo.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text(
                'Loja de Upgrades',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 37, 37, 37)),
              ),
            ),
            for (var upgrade in upgrades)
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backgroundupgrade.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ListTile(
                  leading: Image.asset(upgrade.iconPath, width: 100, height: 100),
                  title: Text(
                    '${upgrade.name} - ${((upgrade.baseCost) / 10000).toStringAsFixed(4)} bitcoins',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitcoins por segundo: +${(upgrade.autoClickIndvValue / 10000).toStringAsFixed(5)}',
                        style: TextStyle(fontSize: 18, color: Color.fromRGBO(1, 255, 1, 1)),
                      ),
                      Text(
                        'Bitcoins por click: +${(upgrade.clickIndvValue / 10000).toStringAsFixed(5)}',
                        style: TextStyle(fontSize: 18, color: Color.fromRGBO(1, 175, 255, 1)),
                      ),
                      Text(
                        'Aumento por segundo: +${((upgrade.clickRateMultiplier) / 10000).toStringAsFixed(5)}',
                        style: TextStyle(fontSize: 16, color: Color.fromRGBO(199, 199, 199, 1)),
                      ),
                      Text(
                        'Aumento para cliques: +${((upgrade.manualClickMultiplier) / 10000).toStringAsFixed(5)}',
                        style: TextStyle(fontSize: 16, color: Color.fromRGBO(199, 199, 199, 1)),
                      ),
                    ],
                  ),
                  onTap: () => buyUpgrade(upgrade),
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
        child: showUpgrades
          ? Icon(Icons.close)
          :Image.asset('../assets/23.png', width: 100, height: 100),
      ),
    );
  }
}
