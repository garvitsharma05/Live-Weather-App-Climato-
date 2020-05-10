import 'package:flutter/material.dart';
import '../util/util.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _cityentered = util.dcity;
  
  
  @override
  Widget build(BuildContext context) {
    Future<Map>_gotonextscreen(BuildContext context) async{
      Map results = await Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (BuildContext context){
            return  new NextScreen();
          })

        );
         
    if(results == null)
    {
      _cityentered = util.dcity;
    }else{
_cityentered = results['info'];
    }
     
    
    }
    
    return Scaffold(
      appBar: new AppBar(
        title : new Text("Climato"),
        centerTitle: true,
        backgroundColor: Colors.purple.shade900,
        actions: <Widget>[
        new IconButton(icon: new Icon(Icons.arrow_drop_down), onPressed: (){
          _gotonextscreen(context);
        })
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: new Stack(
        alignment : Alignment.center,
        children: <Widget>[
          new Image.asset('images/klimate1.jpg',
          width: 490.0,
          height: 1280.0,
          fit: BoxFit.fill),
          new Container(
            alignment: Alignment.topCenter,
            margin: new EdgeInsets.fromLTRB(250.0,30.0,0.0 ,0.0),
            child: new Text(" CityId - $_cityentered",
            style: new TextStyle(color : Colors.yellow.shade700,
            fontSize : 20,
            fontWeight: FontWeight.bold),),
          ),
          new Container(
            alignment : Alignment.center,
            child : new Image.asset('images/light_rain.png',
            width : 100,
            height : 100)
          ),
          new Container(
            margin : new EdgeInsets.fromLTRB( 50 ,145.0, 220 , 50.0),
            alignment: Alignment.center,
            child  : upDateTempWidget(_cityentered),
            

          )
        ],
      ),
    );
  }
}
class NextScreen extends StatelessWidget {
  final TextEditingController _newscrncontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: new AppBar(
       title : new Text("Change city"),
       backgroundColor : Colors.purple.shade900
     ),
     backgroundColor: Colors.grey.shade900,
     body: new Stack(
       children: <Widget>[
         new Image.asset('images/flower.jpg',
         height: 1280.0,
         width: 490.0,
         fit: BoxFit.fill,
         ),
         new Container(
            child: new ListView(
              children : <Widget> [
                new ListTile(
                  title : new TextField(
                    controller : _newscrncontroller,
                    decoration : new InputDecoration(
                      icon: new Icon(Icons.change_history),
                      labelText: "Change city"),
                      )
                  
                  
                ),
                new ListTile(
                  title : new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'info' : _newscrncontroller.text});
                    },
                   child: new Text("OK!"),
                  )
                )
              ]
            ),
         )
       ],
     ),     
    );
  }
}
Future<Map>getWeather(String appid, String city) async{
  String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city,Haryana&appid=${util.appid}&units=metric";
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
Widget upDateTempWidget(String city){
  return new FutureBuilder(
    future: getWeather(util.appid, city == null ? util.dcity : city),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
       if(snapshot.hasData){
         Map content = snapshot.data;
         return new Container(
           alignment: Alignment.centerLeft,
           child : new Column(
             mainAxisAlignment : MainAxisAlignment.center,
             children : <Widget> [
               new Row(mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 new Text("TEMP :",
                 style : new TextStyle(fontWeight: FontWeight.w800, color : Colors.orange, fontSize: 20)),
                 new Text("${content['main']['temp']}C",
                 style: new TextStyle(color : Colors.white, fontSize : 20),)
               ],),
               new Padding(padding: new EdgeInsets.all(5.0)),
               new Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                 new Text("Pressure:",
                 style : new TextStyle(fontWeight: FontWeight.w800, color : Colors.orange, fontSize: 20)),
                 new Text("${content['main']['pressure']}",
                 style: new TextStyle(color : Colors.white, fontSize : 20),)
               ],),
               new Padding(padding: new EdgeInsets.all(5.0)),
               new Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                 new Text("Humidity",
                 style : new TextStyle(fontWeight: FontWeight.w800, color : Colors.orange, fontSize: 20)),
                 new Text("${content['main']['humidity']}",
                 style: new TextStyle(color : Colors.white, fontSize : 20),)
               ],),
             ]
           ),
          
           
         );
       }else{
         return new Container(child : new Text("Nothing"));       }
    });
}
