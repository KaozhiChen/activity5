import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

final TextEditingController _nameController = TextEditingController();

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  String petMood = "Neutral";
  String petEmoji = "😐";
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
        _updateHunger();
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

// Function to increase happiness and update hunger when playing with
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetMood();
    });
  }

// Function to decrease hunger and update happiness when feeding the
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetMood();
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

// Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void _updatePetMood() {
    if (happinessLevel > 70) {
      petMood = "Happy";
      petEmoji = "😃";
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      petMood = "Neutral";
      petEmoji = "😐";
    } else {
      petMood = "Unhappy";
      petEmoji = "😢";
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

  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30 && happinessLevel <= 70) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void _setPetName() {
    setState(() {
      petName = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/YellowDog.png'),
              backgroundColor: _getPetColor(),
            ),
            ElevatedButton(
              onPressed: _setPetName,
              child: const Text('Set Pet Name'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Pet Name',
                ),
              ),
            ),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Mood: $petMood $petEmoji',
              style: const TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
