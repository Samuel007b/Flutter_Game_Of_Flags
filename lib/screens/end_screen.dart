import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/data/historic_storage.dart';
import 'package:flutter_game_of_flags/models/country.dart';
import 'package:flutter_game_of_flags/models/round.dart';
import 'package:flutter_game_of_flags/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:audioplayers/audioplayers.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key, required this.total, required this.points, required this.historic, required this.selected});
  final int total, points;
  final List<Round> historic;
  final List<Country> selected;
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    List<Round> history = List<Round>.from(historic);
    double note = points/total;
    Round r = Round(total: total, points: points, utilization: note, moment: DateTime.now());
    history.add(r);
    HistoricStorage.saveHistoric(history);
    Row showRow(int a){
      return Row(
        spacing: 10, mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(selected[a].getAddress(), height: 36),
          Image.asset(selected[a+1].getAddress(), height: 36),
          Image.asset(selected[a+2].getAddress(), height: 36),
          Image.asset(selected[a+3].getAddress(), height: 36),
          Image.asset(selected[a+4].getAddress(), height: 36),
        ]
      );
    }
    SingleChildScrollView showFlags(int length){
      if(length==10){
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            showRow(0),
            const SizedBox(height: 10),
            showRow(5),
          ]
        ));
      }
      else if(length==15){
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            showRow(0),
            const SizedBox(height: 10),
            showRow(5),
            const SizedBox(height: 10),
            showRow(10),
          ]
        ));
      }
      else if(length==20){
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            showRow(0),
            const SizedBox(height: 10),
            showRow(5),
            const SizedBox(height: 10),
            showRow(10),
            const SizedBox(height: 10),
            showRow(15),
          ]
        ));
      }
      else if(length==25){
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            showRow(0),
            const SizedBox(height: 10),
            showRow(5),
            const SizedBox(height: 10),
            showRow(10),
            const SizedBox(height: 10),
            showRow(15),
            const SizedBox(height: 10),
            showRow(20),
          ]
        ));
      }
      else{
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            showRow(0),
            const SizedBox(height: 10),
            showRow(5),
            const SizedBox(height: 10),
            showRow(10),
            const SizedBox(height: 10),
            showRow(15),
            const SizedBox(height: 10),
            showRow(20),
            const SizedBox(height: 10),
            showRow(25),
          ]
        ));
      }
    }
    void playSound(String sound, {Duration duration = const Duration(seconds: 6)}) async {
      await player.stop();
      await player.play(AssetSource(sound));
      Future.delayed(duration, () {
        player.stop();
      });
    }
    String address, text;
    if(note<=0.25){
      address = "assets/terrible.jpg";
      text="Bandeiras são símbolos nacionais, sabia?";
      try{
        playSound("terrible.mp3");
      }
      catch(e){}
    }
    else if(note<=0.5){
      address = "assets/bad.jpg";
      text = "Parece que alguém faltou às aulas de Geografia...";
      try{
        playSound("bad.mp3");
      }
      catch(e){}
    }
    else if(note<=0.75){
      address = "assets/good.jpg";
      text = "Você sabe mais do que a maioria, mas pode melhorar.";
      try{
        playSound("good.mp3");
      }
      catch(e){}
    }
    else if(note<1){
      address = "assets/great.jpg";
      text = "Parabéns, você já tem seu passaporte carimbado!";
      try{
        playSound("great.mp3");
      }
      catch(e){}
    }
    else{
      address = "assets/excelent.jpg";
      text = "Impecável, só falta virar diplomata!";
      try{
        playSound("excelent.mp3");
      }
      catch(e){}
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 159, 200, 221),
          appBar: AppBar(
            title: Text("Fim de Jogo", style: GoogleFonts.titanOne(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white)),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.brown,
            shadowColor: Colors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
            actions: [
              IconButton(onPressed: () {
                Navigator.pushReplacement(context, PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 400),
                  reverseDuration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  child: HomeScreen(),
                ));
              },
              icon: Icon(Icons.home, color: Colors.black, size: 36))
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(address, width: 300),
                ),
                const SizedBox(height: 40),
                Text("Você obteve $points/$total pontos.\n$text", textAlign: TextAlign.center, style: GoogleFonts.titanOne(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.black)),
                const SizedBox(height: 40),
                showFlags(selected.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}