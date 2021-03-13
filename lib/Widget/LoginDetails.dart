import 'package:flutter/material.dart';
import 'package:instantdel/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instantdel/api_service.dart';

class LoginDetails extends StatefulWidget {
  @override
  _LoginDetailsState createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {

  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> setRiderId(int riderId) async{
    final prefs = await SharedPreferences.getInstance();
    print(riderId);
    await prefs.setInt("rider_id", riderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
             padding: const EdgeInsets.only(top: 50.0),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: myController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Rider ID',
                    hintText: 'Enter your rider ID'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                controller: myController2,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  apiService.riderLogin(int.parse(myController.text), myController2.text).then(
                          (value) => setState(() {
                            print(value);
                            if(value == true) {
                              print(value);
                              setRiderId(int.parse(myController.text));
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => HomePage()));
                            }
                            else{
                              print("Incorrect");
                            }
                          })
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
