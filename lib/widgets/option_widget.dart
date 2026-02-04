import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/models/country.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class OptionWidget extends StatefulWidget {
  const OptionWidget({super.key, required this.country, required this.isCorrect, required this.onPressed, required this.isEnabled, required this.index});
  final Country country;
  final bool isCorrect;
  final bool isEnabled;
  final void Function(int) onPressed;
  final int index;
  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  final player = AudioPlayer();
  late ConfettiController _btnController;
  Color? backColor = Colors.yellow[100];
  @override
  void initState() {
    super.initState();
    _btnController = ConfettiController(duration: const Duration(seconds: 1));
  }
  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }
  void playSound(String sound, {Duration duration = const Duration(seconds: 2)}) async {
    await player.stop();
    await player.play(AssetSource(sound));
    Future.delayed(duration, () {
      player.stop();
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 2.5 * screenWidth / 6,
            height: 80,
            child: ElevatedButton(
              onPressed: widget.isEnabled ? () {
                if (widget.isCorrect) {
                  setState(() {
                    backColor = Colors.green;
                    _btnController.play();
                    try{
                      if(widget.country.getId()==26){
                        playSound("brasil.mp3");
                      }
                      else{
                        playSound("applause.mp3");
                      }
                    }
                    catch(e){}
                  });
                }
                else {
                  setState(() {
                    backColor = Colors.red;
                    try{
                      playSound("failure.mp3");
                    }
                    catch(e){}
                  });
                }
                widget.onPressed(widget.index);
              } : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: backColor, 
                backgroundColor: backColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              child: Text(widget.country.getName(), textAlign: TextAlign.center, style: GoogleFonts.pixelifySans(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
            ),
          ),
          ConfettiWidget(
            confettiController: _btnController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.red, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.orange],
            minimumSize: const Size(5, 5),
            maximumSize: const Size(10, 10),
          ),
        ],
      ),
    );
  }
}