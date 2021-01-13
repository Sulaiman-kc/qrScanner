import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  String cust_name = '';
  String password = '';
  bool error = true;
  bool valueError = false;
  final LocalStorage storage = new LocalStorage('data');
  List values =  ["Purchase", "Transfer", "Sale"];
  String value = '';
  String newUser = '';
  String newUserPassword = '';
  String authCode = '';
  bool isAuthTrue = false;
  List user = [];


  toaster(msg, color){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }



  void initState() {
    super.initState();
    setState(() {
        // storage.setItem('tabledata.json', []);
          this.storage.ready.then((value) => {
            if(storage.getItem('users.json') == null){
              storage.setItem('users.json', []),
              this.user = []
              // print(storage.getItem('tabledata.json')),
            }else{
              print(storage.getItem('users.json')),
              this.user = (storage.getItem('users.json')),
            },

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
    // this.error = false;
    this.valueError = false;
    for(var i = 0 ; user.length > i ; i++ ){
      if(this.username == user[i]['user'] && this.password == user[i]['password']){
        this.storage.ready.then((value) => {
          storage.setItem('isLoggedIn', 'true'),
          storage.setItem('type', this.value.toString()),
          storage.setItem('name', this.username.toString()),
          storage.setItem('customer', this.cust_name.toString())
        });

        setState(() {
          this.error = false;
        });
      }
      else if(this.value == ''){
        setState(() {
          this.valueError = true;
        });
      }
    }
    print(error);
    if(error){
      toaster('Incorrect username or password', Colors.red);
    }
    else if(this.value == ''){
      toaster('Select Type', Colors.red);
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => DashboardPage()
      ));
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
                          hintText: "User Name*",
                          hintStyle: TextStyle(color: Colors.grey.shade800),
                          border: InputBorder.none,
                          icon: Icon(Icons.account_circle, color: Colors.grey.shade800,)
                      ),
                      onChanged: (val){
                        setState(() {
                          this.error = true;
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
                          hintText: "Password*",
                          hintStyle: TextStyle(color: Colors.grey.shade800),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: Colors.grey.shade800,)
                      ),
                      onChanged: (val){
                        setState(() {
                          this.error = true;
                          this.password = val;
                        });
                      },
                    )
                ),
                Divider(color: Colors.grey.shade600,),
                ListTile(
                    title: TextField(
                      style: TextStyle(color: Colors.grey.shade800),
                      decoration: InputDecoration(
                          hintText: "Customer Name (optional)",
                          hintStyle: TextStyle(color: Colors.grey.shade800),
                          border: InputBorder.none,
                          icon: Icon(Icons.people_outline, color: Colors.grey.shade800,)
                      ),
                      onChanged: (val){
                        setState(() {
                          this.cust_name = val;
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
                // this.error?Text('Incorrect username or password', style: TextStyle(color: Colors.redAccent),):Container(),
                // this.valueError?Text('Select type', style: TextStyle(color: Colors.redAccent),):Container(),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          _openPopup(context);
                        },
                        color: Color(0xFF2CA3D4),
                        child: Text('Register User', style: TextStyle(color: Colors.white70, fontSize: 16.0),),
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
  _openPopup(context) {
    if(this.user.length == 0){
      Alert(
          context: context,
          title: "Register User",
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Username',
                ),
                onChanged: (val){
                  this.newUser = val;
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);
                  String encoded = stringToBase64.encode(this.newUser);
                  this.authCode = encoded;
                  print(encoded);
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                onChanged: (val){
                  this.newUserPassword = val;
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline),
                  labelText: 'Authentication',
                ),
                onChanged: (val){
                  print(val);
                  if(val == this.authCode){
                    this.isAuthTrue =true;
                  }
                },
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () async{
                var user = this.user;
                var json = {};
                if(isAuthTrue){
                  setState(() {
                    json['user'] = this.newUser;
                    json['password'] = this.newUserPassword;
                    user.add(json);
                  });
                  await this.storage.ready.then((value) =>
                  {
                    storage.setItem('users.json', user),
                  });
                  toaster('Successfully Registered', Colors.blue);
                  Navigator.pop(context);
                }
                else{
                  if(this.newUser == '' || this.newUserPassword == ''){
                    toaster('Enter username and password', Colors.red);
                  }
                  else{
                    toaster('Incorrect Authentication', Colors.red);
                  }
                }
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ]
      ).show();
    }
    else{
      toaster('User Already Exist', Color(0XFFFFAE42));
    }
  }
}