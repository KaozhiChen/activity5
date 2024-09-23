import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? increaseHungerTimer;
  Timer? _winTimer;
  DateTime? _startCheckHappiness;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinTimer();
  }

  @override
  void dispose() {
    increaseHungerTimer?.cancel();
    super.dispose();
  }

  // start the hungerTimer
  void _startHungerTimer() {
    increaseHungerTimer =
        Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      setState(() {
        _increaseHunger();
      });
    });
  }

  // Start the winTimer
  void _startWinTimer() {
    _winTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_startCheckHappiness != null) {
        final duration = DateTime.now().difference(_startCheckHappiness!);
        if (duration.inMinutes >= 3) {
          _showWinDialog();
          _winTimer?.cancel();
        }
      }
    });
  }

  // Display win dialog
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("You Win!"),
          content: Text("Your pet has been happy for 3 minutes!"),
        );
      },
    );
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _increaseHunger();
      _checkWinStatus();
      _checkLossStatus();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinStatus();
      _checkLossStatus();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _increaseHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Check win condition
  void _checkWinStatus() {
    if (happinessLevel > 80) {
      _startCheckHappiness ??= DateTime.now();
    } else {
      _startCheckHappiness = null;
    }
  }

  //check loss condition
  void _checkLossStatus() {
    if (happinessLevel <= 10 && hungerLevel == 100) {
      _showLossDialog();
    }
  }

  void _showLossDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Game Over!"),
          content: Text(
              "The hunger level reaches 100 and the happiness level drops to 10"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: const Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: const Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
