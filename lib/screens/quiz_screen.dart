import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/data/list_country.dart';
import 'package:flutter_game_of_flags/models/country.dart';
import 'package:flutter_game_of_flags/models/round.dart';
import 'package:flutter_game_of_flags/screens/end_screen.dart';
import 'package:flutter_game_of_flags/widgets/option_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.number, required this.total, required this.hits, required this.chosen, required this.historic});
  final int number, total, hits;
  final List<Country> chosen;
  final List<Round> historic;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Country> options;
  late int correctIndex;
  late int points=widget.hits;
  late List<Country> selected;
  bool isAnswered = false;
  bool check = true;
  @override
  void initState() {
    super.initState();
    selected = List.from(widget.chosen);
    List<Country> countries = getCountryList();
    correctIndex = Random().nextInt(6);
    do {
      options = createOptions(countries);
      correctIndex = Random().nextInt(options.length);
    } while (repetitionCountries(options[correctIndex]));
    selected.add(options[correctIndex]);
  }
  bool repetitionCountries(Country c){
    return selected.contains(c);
  }
  List<Country> createOptions(List<Country> countries){
    List<Country> shuffled = List.from(countries)..shuffle();
    return shuffled.take(6).toList();
  }
  bool checkIndex(int option){
    if(option==correctIndex){
      return true;
    }
    else{
      return false;
    }
  }
  void handlePress(int option) {
    setState(() {
      isAnswered = true;
      if(option==correctIndex){
        points++;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    String img=options[correctIndex].getAddress();
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
            title: Text("Rodada ${widget.number}/${widget.total}", style: GoogleFonts.titanOne(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white)),
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.blue,
            shadowColor: Colors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
            actions: [
              IconButton(onPressed: isAnswered? (){
                if(widget.number<widget.total){
                  Navigator.pushReplacement(context, PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    duration: const Duration(milliseconds: 400),
                    reverseDuration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    child: QuizScreen(number: widget.number+1, total: widget.total, hits: points, chosen: selected, historic: widget.historic),
                  ));
                }
                else{
                  Navigator.pushReplacement(context, PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    duration: const Duration(milliseconds: 400),
                    reverseDuration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    child: EndScreen(total: widget.total, points: points, historic: widget.historic, selected: selected),
                  ));
                }
              } : null,
              icon: Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.black))
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text("De que país é esta bandeira?", textAlign: TextAlign.center, style: GoogleFonts.titanOne(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black)),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(img, height: 200),
                ),
                const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,              
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        OptionWidget(country: options[0], index: 0, isCorrect: checkIndex(0), isEnabled: !isAnswered, onPressed: handlePress),
                        OptionWidget(country: options[1], index: 1, isCorrect: checkIndex(1), isEnabled: !isAnswered, onPressed: handlePress),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        OptionWidget(country: options[2], index: 2, isCorrect: checkIndex(2), isEnabled: !isAnswered, onPressed: handlePress),
                        OptionWidget(country: options[3], index: 3, isCorrect: checkIndex(3), isEnabled: !isAnswered, onPressed: handlePress),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        OptionWidget(country: options[4], index: 4, isCorrect: checkIndex(4), isEnabled: !isAnswered, onPressed: handlePress),
                        OptionWidget(country: options[5], index: 5, isCorrect: checkIndex(5), isEnabled: !isAnswered, onPressed: handlePress),
                      ]),
                    ]
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}