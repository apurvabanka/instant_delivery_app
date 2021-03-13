import 'package:flutter/material.dart';
import 'package:instantdel/api_service.dart';
import 'package:instantdel/models/orders.dart';
import 'package:instantdel/maps/map_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ListCompletedOrders extends StatefulWidget {
  @override
  _ListCompletedOrdersState createState() => _ListCompletedOrdersState();
}

class _ListCompletedOrdersState extends State<ListCompletedOrders> {
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
        future: apiService.listOfOrdersDelivered(rid),
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
      height: 350,
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
                      Text("Order Delivered"),
                      SizedBox(height: 10.0,),
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
