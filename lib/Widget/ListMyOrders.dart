import 'package:flutter/material.dart';
import 'package:instantdel/api_service.dart';
import 'package:instantdel/models/orders.dart';
import 'package:instantdel/maps/map_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slider_button/slider_button.dart';
import 'package:instantdel/pages/homepage.dart';
import 'package:sizer/sizer.dart';

class ListMyOrders extends StatefulWidget {
  @override
  _ListMyOrdersState createState() => _ListMyOrdersState();
}

class _ListMyOrdersState extends State<ListMyOrders> {

  String rid;
  int _checked;

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

  Future<Null> _refreshLocalGallery() async{
    setState(() {
      _orderList();
    });

  }

Widget _buildOrderList(List<OrderDetails> orders){
  return Container(
    height: 70.0.h,
    width: 100.0.w,
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
                  color: data.typeOfOrder == "NRML" ? Colors.green : Colors.red ,
                  width: 5.0,
                ),
              ),
              margin: EdgeInsets.fromLTRB(1.0, 2.0, 2.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      leading: Text(
                        data.typeOfOrder,
                        style: TextStyle(
                          fontSize: 18.0.sp
                        ),
                      ),
                      title: Text(
                        data.customerName,
                      ),
                      subtitle: Text(
                           data.customerAddress1.toString()+" "+data.customerAddress2.toString(),
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        data.typeOfPayment == 'COD' ? 'Please collect Rs.'+data.orderValue.toString() : 'Prepaid Order',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 13.0.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                      RaisedButton(onPressed: (){
                        MapUtils.openMap(data.customerAddress1,data.customerAddress2);
                      },
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textColor: Colors.white,
                          color: Colors.blue,
                        child: Icon(Icons.map),
                      ),
                      RaisedButton(onPressed: (){
                        _makingPhoneCall(data.customerNumber);
                      },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(10),
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Icon(Icons.call),
                      ),
                        RaisedButton(onPressed: (){
                            setState(() {
                              _checked = 5;
                            });
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Reasons for Undelivered'),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      String text1 = data.typeOfOrder == "NRML"
                                          ? "Refused Order"
                                          : "Refused Pickup";
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets
                                                .symmetric(
                                                vertical: 0.0, horizontal: 0.0),
                                            title: Text(
                                                text1),
                                            leading: new Radio(
                                              value: 0,
                                              groupValue: _checked,
                                              onChanged: (newValue) =>
                                                  setState(() =>
                                                  _checked = newValue),
                                            ),
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets
                                                .symmetric(
                                                vertical: 0.0, horizontal: 0.0),
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
                                            contentPadding: EdgeInsets
                                                .symmetric(
                                                vertical: 0.0, horizontal: 0.0),
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
                                        apiService.markAsUndelivered(
                                            rid, data.orderId.toString(),
                                            _checked);
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (_) => HomePage()));
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textColor: Colors.white,
                          color: Colors.red,
                          child: Icon(Icons.backpack),
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
                            if(data.typeOfPayment == "COD"){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context)  {
                                      return AlertDialog(
                                        title: const Text('Mark Order'),
                                        content: new Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Collect cash Rs."+data.orderValue.toString()),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            onPressed: () {
                                              apiService.orderDelivered(data.orderId.toString());
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (_) => HomePage()));
                                            },
                                            textColor: Theme
                                                .of(context)
                                                .primaryColor,
                                            child: const Text('Cash Collected'),
                                          ),
                                        ],
                                      );
                                    },
                                );
                            }
                            else{
                              apiService.orderDelivered(data.orderId.toString());
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (_) => HomePage()));
                            }
                          },
                          width: 75.0.w,
                          label: Text(
                          "Slide To Complete",
                          style: TextStyle(
                          color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 15.0.sp),
                          ),
                          icon: Text(
                          "X",
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20.0.sp,
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
