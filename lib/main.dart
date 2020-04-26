import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:covid_tracker/CovidData.dart';


void main() => runApp(MaterialApp(
  home: CovidHome(),
));

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CovidHome extends StatefulWidget {
  @override
  _CovidHomeState createState() => _CovidHomeState();
}

class _CovidHomeState extends State<CovidHome> {

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  String country = "";
  String flagURL;
  int noOfCases = 0;
  int noOfDeaths = 0;
  int noOfRecovered = 0;
  double maxNumberOfCases = 0.0;
  double minNumberOfCases = 0.0;
  Map histData = {};
  List<FlSpot> histSpots = [FlSpot(0.0,0.0)];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setData('India');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void setData(String countryNameQuery) async{
    CovidData cd = CovidData();
    await cd.getData(countryNameQuery);
    await cd.getHistData(countryNameQuery);
    histData = cd.histData;
    double i = 0.0;
    histSpots = [];
    List<FlSpot> histtemp = [];
    double temp1 = 0.0;
    double temp2 = noOfCases.toDouble();
    histData.forEach((k, v){
      if(v is int){
        histtemp.add(FlSpot(i, v.toDouble()));
        //print('$i - ${v.toDouble()}');
        temp1 = max(temp1, v.toDouble());
        temp2 = min(temp2, v.toDouble());
        i+=1.0;
      }
    });
    setState(() {
      country = cd.country;
      flagURL = cd.flagURL;
      noOfCases = cd.cases;
      noOfDeaths = cd.deaths;
      noOfRecovered = cd.recovered;
      //histData.clear();
      histSpots = histtemp;
      //print(histSpots.length);
      maxNumberOfCases = temp1;
      minNumberOfCases = temp2;
    });
  }

  @override
  Widget build(BuildContext context) {
    String whiteColor = "#F9F9F9";
    String greenColor = "#00e04f";
    List<Color> _colors = [HexColor('#F98C5D'), HexColor('#F9A95E')];
    List<double> _stops = [0.0, 1.0];
    return Scaffold(
      //backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            //color: HexColor('F99C5E'),
                            gradient: LinearGradient(
                              colors: _colors,
                              stops: _stops,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                          ),
                          height: 190.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Covid Tracker',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                                      child: TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.room,
                                            color: HexColor('#2ecc71'),
                                          ),
                                          hintText: "Search Country",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          fillColor: HexColor('#ffffff'),
                                          filled: true,
                                          enabledBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: HexColor('#ffffff'))
                                          ),
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color: HexColor('#ffffff'))
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 20.0, 30.0, 0),
                                    child: ButtonTheme(
                                      minWidth: 60.0,
                                      height: 60.0,
                                      buttonColor: HexColor('ffffff'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: RaisedButton(
                                        onPressed: () {
                                          setData(searchController.text);
                                        },
                                        child: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            '$flagURL',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                          child: Text(
                                            '$country',
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor('#34495e')
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  // card
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: HexColor(whiteColor),
                                    borderRadius: BorderRadius.circular(30.0),
                                    boxShadow: [BoxShadow(
                                      color: HexColor('#50595959'),
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ), 
                                    )]
                                  ),
                                  height: 200.0,
                                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    '$noOfCases',
                                                    style: TextStyle(
                                                      color: HexColor('#FF7E44'),
                                                      fontSize: 30.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ),
                                                Center(
                                                  child: Text(
                                                    '😷 Cases',
                                                    style: TextStyle(
                                                      color: HexColor('#FF7E44'),
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    '$noOfRecovered',
                                                    style: TextStyle(
                                                      color: HexColor(greenColor),
                                                      fontSize: 30.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ),
                                                Center(
                                                  child: Text(
                                                    '😀 Recovered',
                                                    style: TextStyle(
                                                      color: HexColor(greenColor),
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    '$noOfDeaths',
                                                    style: TextStyle(
                                                      color: HexColor('#FF4B4B'),
                                                      fontSize: 30.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ),
                                                Center(
                                                  child: Text(
                                                    '💀 Deaths',
                                                    style: TextStyle(
                                                      color: HexColor('#FF4B4B'),
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ),
                                // add chart here
                                Container(
                                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                                  child: LineChart(
                                    mainDataNew(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  LineChartData mainDataNew() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.5),
          
        ),
        
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      axisTitleData: FlAxisTitleData(
        show: true,
        topTitle: AxisTitle(
          showTitle: true,
          titleText: 'Historial Data (past 30 days)',
          textStyle: TextStyle(
            color: HexColor('#34495e'),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          margin: 10.0,
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: 'Time',
          textStyle: TextStyle(
            color: HexColor('#34495e'),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          margin: 10.0,
        ),
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: 'Cases',
          textStyle: TextStyle(
            color: HexColor('#2c3e50'),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          margin: 10.0,
        ),
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 22,
          textStyle:
              const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: histSpots.length.toDouble() - 1,
      minY: minNumberOfCases,
      maxY: maxNumberOfCases,
      lineBarsData: [
        LineChartBarData(
          spots: histSpots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}

