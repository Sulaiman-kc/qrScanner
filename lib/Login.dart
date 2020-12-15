import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'Dashboard.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  bool _isLogin = false;
  String username = '';
  String password = '';
  bool error = false;
  final LocalStorage storage = new LocalStorage('data');


  void initState() {
    super.initState();
    setState(() {
        // storage.setItem('tabledata.json', '[]');
        this.storage.ready.then((value) => {
            setState((){
              _isLogin = true;
            }),
            if(storage.getItem('isLoggedIn') == 'true' ){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => DashboardPage()
            ))
          },
          print(value),
          // print(storage.getItem('tabledata.json')),
            if(storage.getItem('tabledata.json') == null){
              storage.setItem('tabledata.json', '[]'),
              // print(storage.getItem('tabledata.json')),
            }
        });
    });
  }

  _login(){
    if(this.username == 'admin' && this.password == 'admin'){
      this.storage.ready.then((value) => {
        storage.setItem('isLoggedIn', 'true')
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => DashboardPage()
      ));
    }
    else{
      setState(() {
        this.error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLogin?Container(
        color: Colors.black87,
        child: Center(
          child: Loading(indicator: BallPulseIndicator(), size: 100.0),
        ),
      ):
      Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey.shade800,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Container(width: 200, child: Image.asset('assets/ISFRC.png',height: 150,),),//child: PNetworkImage(rocket),
                SizedBox(height: 50,),
                ListTile(
                    title: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "User name:",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          icon: Icon(Icons.email, color: Colors.white30,)
                      ),
                      onChanged: (val){
                        setState(() {
                          this.error = false;
                          this.username = val;
                        });
                      },
                    )
                ),
                Divider(color: Colors.grey.shade600,),
                ListTile(
                    title: TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password:",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: Colors.white30,)
                      ),
                      onChanged: (val){
                        setState(() {
                          this.error = false;
                          this.password = val;
                        });
                      },
                    )
                ),
                Divider(color: Colors.grey.shade600,),
                SizedBox(height: 20,),
                this.error?Text('Incorrect username or password', style: TextStyle(color: Colors.redAccent),):Container(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: _login,
                        color: Colors.cyan,
                        child: Text('Login', style: TextStyle(color: Colors.white70, fontSize: 16.0),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                // Text('Forgot your password?', style: TextStyle(color: Colors.grey.shade500),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}