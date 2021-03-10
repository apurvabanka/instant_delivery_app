import 'package:flutter/material.dart';
import 'package:instantdel/api_service.dart';
import 'package:instantdel/models/orders.dart';
import 'package:instantdel/maps/map_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ListMyOrders extends StatefulWidget {
  @override
  _ListMyOrdersState createState() => _ListMyOrdersState();
}

class _ListMyOrdersState extends State<ListMyOrders> {

  String rid;

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

Widget _buildOrderList(List<OrderDetails> orders){
  return Container(
    height: 450,
    alignment: Alignment.centerLeft,
    child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: orders.length,
        itemBuilder: (context,index){
          var data = orders[index];
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        "Order ID - "+data.orderId.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        ),
                    ),
                    SizedBox(height: 10.0,),
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
                      apiService.orderDelivered(data.orderId.toString());
                    },
                      padding: const EdgeInsets.all(10),
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('Mark As Delivered'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    ),
  );
  }
}
