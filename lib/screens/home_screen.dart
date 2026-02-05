import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/data/historic_storage.dart';
import 'package:flutter_game_of_flags/data/list_country.dart';
import 'package:flutter_game_of_flags/models/country.dart';
import 'package:flutter_game_of_flags/models/round.dart';
import 'package:flutter_game_of_flags/screens/historic_screen.dart';
import 'package:flutter_game_of_flags/screens/quiz_screen.dart';
import 'package:flutter_game_of_flags/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final player = AudioPlayer();
  final List<Country> countries = getCountryList();
  final random = Random();
  final ValueNotifier<String> dropValue = ValueNotifier("");
  final List<String> dropOptions = ["10", "15", "20", "25", "30"];
  List<Round> historic = [];
  final ValueNotifier<bool> withTimeValue = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    loadHistoric();
  }
  Future<void> loadHistoric() async {
    historic = await HistoricStorage.loadHistoric();
    setState(() {});
  }
  void playSound(String sound, {Duration duration = const Duration(seconds: 2)}) async {
    await player.stop();
    await player.play(AssetSource(sound));
    Future.delayed(duration, () {
      player.stop();
    });
  }
  void _showRoundSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Quantidade de rodadas:", style: GoogleFonts.pixelifySans(fontSize: 24, fontWeight: FontWeight.normal)),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: dropValue,
                builder: (context, String value, _) {
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    hint: const Text(""),
                    value: value.isEmpty ? null : value,
                    onChanged: (option) {
                      dropValue.value = option!;
                    },
                    items: dropOptions.map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option, style: GoogleFonts.titanOne(fontWeight: FontWeight.normal)),
                    )).toList(),
                  );
                },
              ),
              const SizedBox(height: 15),
              ValueListenableBuilder<bool>(
                valueListenable: withTimeValue,
                builder: (context, withTime, _) {
                  return SwitchListTile(
                    title: Text("Cronômetro", style: GoogleFonts.pixelifySans(fontSize: 20, color: Colors.black)),
                    secondary: Icon(Icons.timer),
                    value: withTime,
                    activeThumbColor: Colors.blueAccent,
                    onChanged: (value) => withTimeValue.value = value,
                  );
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    if (dropValue.value.isEmpty) {
                      return;
                    }
                    try{
                      playSound("start.mp3");
                    }
                    catch(e){}
                    final int totalRounds = int.parse(dropValue.value);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.bottomCenter,
                        duration: const Duration(milliseconds: 400),
                        reverseDuration: const Duration(milliseconds: 400),
                        curve: Curves.elasticOut,
                        child: QuizScreen(
                          number: 1,
                          total: totalRounds,
                          hits: 0,
                          chosen: [],
                          historic: historic,
                          withTime: withTimeValue.value,
                          time: 0,
                        ),
                      ),
                    );
                  },
                  child: Text("START", style: GoogleFonts.pixelifySans(fontSize: 30, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 159, 200, 221),
          appBar: AppBar(
            title: Text("Jogo das Bandeiras", style: GoogleFonts.titanOne(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white)),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.yellow[600],
            shadowColor: Colors.black,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/countries.png', width: 350),
                ),
                const SizedBox(height: 10),
                ButtonWidget(
                  text: "Jogar",
                  color: Colors.blue[700],
                  textColor: Colors.white,
                  onPressed: () => _showRoundSelector(context),
                ),
                const SizedBox(height: 30),
                ButtonWidget(text: "Histórico", color: Colors.red, textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.bottomCenter,
                        duration: const Duration(milliseconds: 400),
                        reverseDuration: const Duration(milliseconds: 400),
                        curve: Curves.elasticOut,
                        child: HistoricScreen(historic: historic),
                    ));
                  },
                ),
                const SizedBox(height: 50),
                Center(
                  child: Image.asset('assets/world.png', width: 400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}