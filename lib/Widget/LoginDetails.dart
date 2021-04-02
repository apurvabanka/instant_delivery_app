import 'package:flutter/material.dart';
import 'package:instantdel/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instantdel/api_service.dart';
import 'package:instantdel/models/rider.dart';

class LoginDetails extends StatefulWidget {
  @override
  _LoginDetailsState createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {

  APIService apiService;
  String rid;

  @override
  void initState() {
    apiService = new APIService();
    rid = "";
    _getRiderId();
    super.initState();
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> setRiderId(int riderId) async {
    final prefs = await SharedPreferences.getInstance();
    print(riderId);
    await prefs.setInt("rider_id", riderId);
  }

  Future<Null> _getRiderId() async {
    final prefs = await SharedPreferences.getInstance();
    final riderId = prefs.getInt('rider_id');
    print(riderId.toString());
    if (riderId == null) {
      return null;
    }
    setState(() {
      rid = riderId.toString();
    });
  }

  Widget _riderInfo(){
    return new FutureBuilder(
        future: apiService.riderPayoutInfo(rid),
        builder: (
            BuildContext context,
            AsyncSnapshot<List<RiderInfo>> model,
            ){
          if(model.hasData){
            return _buildRiderInfo(model.data);
          }
          return Center(child: CircularProgressIndicator(),
          );
        }
    );
  }

  Widget _buildRiderInfo(List<RiderInfo> riders){
    return Container(
        child: Column(
        children: <Widget>[
            Container(
              child: Text("COD Remit "+riders[0].codReemmit.toString()),
            ),
          Container(
            child: Text("Pay out "+riders[0].payout.toString()),
          ),
          ]
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    if (rid == ""){
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
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    apiService.riderLogin(
                        int.parse(myController.text), myController2.text).then(
                            (value) =>
                            setState(() {
                              print(value);
                              if (value == true) {
                                print(value);
                                setRiderId(int.parse(myController.text));
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (_) => HomePage()));
                              }
                              else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Incorrect Rider ID or password"),
                                ));
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
            ],
          ),
        ),
      );
  }
    else{
      return Scaffold(
          body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 70.0,
                            child: new Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 70,
                            ),
                          )
                        ],
                      )
                  ),
                ),
                _riderInfo(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        "Hello, "+rid,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                        onPressed: () async{
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt("rider_id", null);
                            setState(() {
                              rid="";
                            });
                        },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
              ]
              ),
            ),
          );
    }
}
}
