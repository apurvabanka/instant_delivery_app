import 'package:flutter/material.dart';
import 'package:instantdel/api_service.dart';
import 'package:instantdel/models/orders.dart';
import 'package:instantdel/maps/map_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slider_button/slider_button.dart';

class ListMyOrders extends StatefulWidget {
  @override
  _ListMyOrdersState createState() => _ListMyOrdersState();
}

class _ListMyOrdersState extends State<ListMyOrders> {

  String rid;
  int _checked;
  int _result;

  Future<Null> _getRiderId() async{
    final prefs = await SharedPreferences.getInstance();
    final riderId = prefs.getInt('rider_id');
    print(riderId.toString());
    if(riderId == null){
      return null;
    }
    setState(() {
      rid = riderId.toString();
    });
  }

  _makingPhoneCall(String contactNumber) async {
    String url = 'tel:'+contactNumber;
      await launch(url);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _checked = value;

      switch (_checked) {
        case 0:
          _result = 2;
          break;
        case 1:
          _result = 3;
          break;
        case 2:
          _result = 4;
          break;
      }
      print(_result);
      });
  }

  APIService apiService;
  @override
  void initState(){
    apiService = new APIService();
    rid="";
    _getRiderId();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _orderList(),
        ],
      ),
    );
  }

  Widget _orderList(){
    return new FutureBuilder(
        future: apiService.listOfOrders(rid),
      builder: (
        BuildContext context,
          AsyncSnapshot<List<OrderDetails>> model,
      ){
          if(model.hasData){
            return _buildOrderList(model.data);
          }
          return Center(child: CircularProgressIndicator(),
          );
        }
    );
}

  Future<Null> _refreshLocalGallery() async{
    setState(() {
      _orderList();
    });

  }

Widget _buildOrderList(List<OrderDetails> orders){
  return Container(
    height: 650,
    alignment: Alignment.centerLeft,
    child: new RefreshIndicator(
      onRefresh: _refreshLocalGallery,
    child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemCount: orders.length,
        itemBuilder: (context,index){
          var data = orders[index];
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: data.typeOfOrder == "PRE" ? Colors.green : Colors.red ,
                  width: 5.0,
                ),
              ),
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        "Order ID - "+data.orderId.toString()+" Order Type - "+data.typeOfOrder.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[600],
                        ),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                      RaisedButton(onPressed: (){
                        MapUtils.openMap(data.dropLat,data.dropLong);
                      },
                          padding: const EdgeInsets.all(10),
                          textColor: Colors.white,
                          color: Colors.blue,
                        child: Text('Navigate'),
                      ),
                      RaisedButton(onPressed: (){
                        _makingPhoneCall(data.customerNumber);
                      },
                        padding: const EdgeInsets.all(10),
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Call User'),
                      ),
                        RaisedButton(onPressed: (){
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context)  {
                              return AlertDialog(
                                title: const Text('Reasons for Undelivered'),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    String text1 = data.typeOfOrder == "PRE" ? "Refused Order" : "Refused Pickup";
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                          title: Text(
                                              text1 ),
                                          leading: new Radio(
                                            value: 0,
                                            groupValue: _checked,
                                            onChanged: (newValue) =>
                                                setState(() =>
                                                _checked = newValue),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                          title: const Text(
                                              "Didn't respond"),
                                          leading: new Radio(
                                            value: 1,
                                            groupValue: _checked,
                                            onChanged: (newValue) =>
                                                setState(() =>
                                                _checked = newValue),
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                          title: const Text("Other Reason"),
                                          leading: new Radio(
                                            value: 2,
                                            groupValue: _checked,
                                            onChanged: (newValue) =>
                                                setState(() =>
                                                _checked = newValue),
                                          ),
                                        ),
                                      ],
                                    );
                                  }, //builder
                                  ),

                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    textColor: Theme
                                        .of(context)
                                        .primaryColor,
                                    child: const Text('Submit'),
                                  ),
                                ],
                              );
                            },
//                            barrierDismissible: false,
                          );
                        },
                          padding: const EdgeInsets.all(10),
                          textColor: Colors.white,
                          color: Colors.red,
                          child: Text('Undelivered'),
                        ),
                  ]
                      ),
                    ),
//                    RaisedButton(
//                      onPressed: (){
//                      apiService.orderDelivered(data.orderId.toString());
//                    },
//                      padding: const EdgeInsets.all(10),
//                      textColor: Colors.white,
//                      color: Colors.red,
//                      child: Text('Mark As Delivered'),
//                    ),
                      Center(child: SliderButton(
                          action: () {
                            apiService.orderDelivered(data.orderId.toString());
                          },
                          width: 250,
                          label: Text(
                          "Slide To Complete",
                          style: TextStyle(
                          color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          icon: Text(
                          "X",
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 30,
                          ),
                          ),
                          )
                      )
                  ],
                ),
              ),
            ),
          );
        }
    ),
    ),
  );
  }
}
