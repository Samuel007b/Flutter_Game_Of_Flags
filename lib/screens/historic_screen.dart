import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/data/historic_storage.dart';
import 'package:flutter_game_of_flags/models/round.dart';
import 'package:flutter_game_of_flags/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class HistoricScreen extends StatefulWidget {
  const HistoricScreen({super.key, required this.historic});
  final List<Round> historic;
  @override
  State<HistoricScreen> createState() => _HistoricScreenState();
}

class _HistoricScreenState extends State<HistoricScreen> {
  late List<Round> historic;
  late List<Round> sortedHistoric;
  @override
  void initState() {
    super.initState();
    historic = List.from(widget.historic);
    sortedHistoric = List.from(historic);
    sortedHistoric.sort((a, b) {
      int cmp = b.getUtilization().compareTo(a.getUtilization());
      if (cmp != 0) return cmp;
      cmp = b.getTotal().compareTo(a.getTotal());
      if (cmp != 0) return cmp;
      if (a.withTime != b.withTime) {
        return a.withTime ? -1 : 1;
      }
      if (a.withTime && b.withTime) {
        cmp = a.getTime().compareTo(b.getTime()); // menor primeiro
        if (cmp != 0) return cmp;
      }
      return b.getMoment().compareTo(a.getMoment());
    });
  }
  String getFinalTime(int time){
    if(time<60){
      return "${time}s";
    }
    else{
      if(time%60==0){
        return "${time/60}min";
      }
      else{
        return "${((time-time%60)/60).toStringAsFixed(0)}min ${time%60}s";
      }
    }
  }
  @override
  Widget build(BuildContext context) {
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
            title: Text("Histórico", style: GoogleFonts.titanOne(fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.red,
            shadowColor: Colors.black,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
            leading: IconButton(onPressed: () {
              Navigator.pushReplacement(context, PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                duration: const Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                child: HomeScreen(),
              ));
            },
            icon: Icon(Icons.home, color: Colors.black, size: 36)),
            actions: [
              IconButton(onPressed: () async {
                await HistoricStorage.clearHistoric();
                setState(() {
                  historic.clear();
                  sortedHistoric.clear();
                });
              },
              icon: Icon(Icons.delete_rounded, color: Colors.black, size: 30))
            ],
          ),
          body: historic.isEmpty? Center(child: Text("Nenhum jogo realizado", style: GoogleFonts.pixelifySans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)))
          : ListView.builder(padding: const EdgeInsets.only(top: 20), itemCount: sortedHistoric.length, itemBuilder: (context, index){ return sortedHistoric[index].withTime ?
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.orange, child: Text("${index + 1}", style: TextStyle(color: Colors.white))),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${DateFormat('dd/MM/yyyy HH:mm').format(sortedHistoric[index].getMoment())}    Tempo: ${getFinalTime(sortedHistoric[index].getTime())}",
                            style: GoogleFonts.alumniSansPinstripe(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Icon(Icons.timer, size: 30, color: Colors.black),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("Aproveitamento: ${(sortedHistoric[index].getUtilization() * 100).toStringAsFixed(1).replaceAll('.', ',')}% (${sortedHistoric[index].getPoints()}/${sortedHistoric[index].getTotal()})",
                      style: GoogleFonts.alumniSansPinstripe(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ) :
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.orange, child: Text("${index + 1}", style: TextStyle(color: Colors.white))),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(sortedHistoric[index].getMoment()),
                            style: GoogleFonts.alumniSansPinstripe(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        Icon(Icons.timer_off, size: 30, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("Aproveitamento: ${(sortedHistoric[index].getUtilization() * 100).toStringAsFixed(1).replaceAll('.', ',')}% (${sortedHistoric[index].getPoints()}/${sortedHistoric[index].getTotal()})",
                      style: GoogleFonts.alumniSansPinstripe(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}