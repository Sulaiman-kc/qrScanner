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
  bool valueError = false;
  final LocalStorage storage = new LocalStorage('data');
  List values =  ["Purchase", "Transfer", "Sale"];
  String value = '';

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
    this.error = false;
    this.valueError = false;
    if(this.username == 'admin' && this.password == 'admin' && this.value != ''){
      this.storage.ready.then((value) => {
        storage.setItem('isLoggedIn', 'true'),
        storage.setItem('type', this.value.toString()),
        storage.setItem('name', this.username.toString())
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => DashboardPage()
      ));
    }
    else if(this.username != 'admin' || this.password != 'admin'){
      setState(() {
        this.error = true;
      });
    }
    else{
      setState(() {
        this.valueError = true;
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
        color: Colors.white70,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Container(width: 200, child: Image.asset('assets/ISFRC.png',height: 150,),),//child: PNetworkImage(rocket),
                SizedBox(height: 50,),
                ListTile(
                    title: TextField(
                      style: TextStyle(color: Colors.grey.shade800),
                      decoration: InputDecoration(
                          hintText: "User name:",
                          hintStyle: TextStyle(color: Colors.grey.shade800),
                          border: InputBorder.none,
                          icon: Icon(Icons.email, color: Colors.grey.shade800,)
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
                      style: TextStyle(color: Colors.grey.shade800),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password:",
                          hintStyle: TextStyle(color: Colors.grey.shade800),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: Colors.grey.shade800,)
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          groupValue: value,
                          value: this.values[0],
                          onChanged: (value1) {
                            setState(() {
                              this.value = value1;
                            });
                          },
                        ),
                        Text(this.values[0]),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: value,
                          value: this.values[1],
                          onChanged: (value1) {
                            setState(() {
                              print(value1);
                              this.value = value1;
                            });
                          },
                        ),
                        Text(this.values[1]),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: value,
                          value: this.values[2],
                          onChanged: (value1) {
                            setState(() {
                              print(value1);
                              this.value = value1;
                            });
                          },
                        ),
                        Text(this.values[2]),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                this.error?Text('Incorrect username or password', style: TextStyle(color: Colors.redAccent),):Container(),
                this.valueError?Text('Select type', style: TextStyle(color: Colors.redAccent),):Container(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: _login,
                        color: Color(0xFF2CA3D4),
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