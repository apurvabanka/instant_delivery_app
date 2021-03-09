import 'package:flutter/material.dart';
import 'package:instantdel/Widget/ListCompletedOrders.dart';
import 'package:instantdel/Widget/LoginDetails.dart';
import 'package:instantdel/utils/cart_icons.dart';
import 'package:instantdel/Widget/ListMyOrders.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:instantdel/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  APIService apiService;
  @override
  void initState(){
    apiService = new APIService();
    super.initState();
  }

  int _index  = 0;

  final List<Widget> _children = [
    ListMyOrders(),
    ListCompletedOrders(),
    LoginDetails()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon:Icon(
              CartIcons.home,
            ),
            title: Text(
              'To Do`',
              style: TextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon:Icon(
              CartIcons.cart,
            ),
            title: Text(
              'Completed',
              style: TextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon:Icon(
              CartIcons.account,
            ),
            title: Text(
              'My Account',
              style: TextStyle(),
            ),
          ),

        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor:Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap:(index){
          setState((){
            _index = index;
          });
        },
      ),
      body:_children[_index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
      String cameraScanResult = await scanner.scan();
      print(cameraScanResult);
      if(cameraScanResult.length != 0){
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: const Text('Accept Order'),
                content: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Do you want to accept Order?"),
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      apiService.orderPickUp(cameraScanResult, "24216");
                      Navigator.of(context).pop();
                    },
                    textColor: Theme
                        .of(context)
                        .primaryColor,
                    child: const Text('Yes'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Theme
                        .of(context)
                        .primaryColor,
                    child: const Text('No'),
                  ),
                ],
              ),
          barrierDismissible: false,
        );
      }
        },
        label: Text('Scan QR'),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.blue,
      ),
    );
  }
  Widget _buildAppBar() {
    return AppBar(
        centerTitle:true,
        brightness:Brightness.dark,
        elevation: 0,
        backgroundColor:Colors.blue,
        automaticallyImplyLeading:false,
        title:Text(
          "Instant Delivery",
          style: TextStyle(color:Colors.white),
        ),
    );
  }
}
