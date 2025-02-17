import 'dart:io';
import 'package:dio/dio.dart';
import 'package:instantdel/models/orders.dart';
import 'package:instantdel/models/rider.dart';
import 'package:instantdel/config.dart';

class APIService{
  Future<List<OrderDetails>> listOfOrders(String riderid) async{
    List<OrderDetails> data = new List<OrderDetails>();
    try{
      String url = Config.url + Config.myorders;
      var response = await Dio().post(
        url,
        data: {
          "rider_id" : riderid
        },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if (response.statusCode == 200) {
        //print(response.data);
        data = (response.data['data'] as List)
            .map((i) => OrderDetails.fromJson(i),).toList();
        print(data);
      }
    }on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<RiderInfo>> riderPayoutInfo(String riderid) async{
    List<RiderInfo> data = new List<RiderInfo> ();
    try{
      String url = Config.url + Config.riderInfo;
      var response = await Dio().post(
        url,
        data: {
          "rider_id" : riderid
        },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if (response.statusCode == 200) {
        //print(response.data);
        data = (response.data['data'] as List)
            .map((i) => RiderInfo.fromJson(i),).toList();
        print(data);
      }
    }on DioError catch (e) {
      print(e.response);
    }
    return data;
  }
  Future<List<OrderDetails>> listOfOrdersDelivered(String riderid) async{
    List<OrderDetails> data = new List<OrderDetails>();
    try{
      String url = Config.url + Config.myordersdelivered;
      var response = await Dio().post(
          url,
          data: {
            "rider_id" : riderid
          },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if (response.statusCode == 200) {
        //print(response.data);
        data = (response.data['data'] as List)
            .map((i) => OrderDetails.fromJson(i),).toList();
        print(data);
      }
    }on DioError catch (e) {
      print(e.response);
    }
    return data;
  }


  Future<bool> orderPickUp(String orderid,String riderid) async{
    bool ret = false;
    try{
      String url = Config.url + Config.orderpickup;
      var response = await Dio().post(
        url,
          data: {
          "order_id":orderid,
            "rider_id":riderid
          },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        print(response);
          ret = true;
      }
    }
    on DioError catch (e) {
      print(e.response);
      ret = false;
    }
    return ret;
  }

  Future <bool> orderDelivered(String orderid)async{
    bool ret = false;
    try{
      String url = Config.url + Config.orderDelivered;
      var response = await Dio().post(
          url,
          data: {
            "order_id":orderid,
          },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        ret = true;
      }
    }
    on DioError catch (e) {
      print(e.response);
      ret = false;
    }

    return ret;
  }

  Future <bool> riderLogin(int riderId,String riderPassword) async{
    bool ret = false;
    try{
      String url = Config.url + Config.loginRider;
      var response = await Dio().post(
        url,
        data:{
          "rider_id": riderId,
          "rider_password": riderPassword
        },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        ret = true;
      }
    }
    on DioError catch (e) {
      print(e.response);
      ret = false;
    }

    return ret;
  }

  Future<bool> markAsUndelivered(String riderId,String orderId, int orderReason) async{
    bool ret = false;
    try{
      String url = Config.url + Config.markUndelivered;
      var response = await Dio().post(
          url,
          data:{
            "order_id": orderId,
            "alloted_rider_id": riderId,
            "order_reason": orderReason
          },
          options: new Options(
              headers: {
                HttpHeaders
                    .contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        print(response);
        ret = true;
      }
    }
    on DioError catch (e) {
      print(e.response);
      ret = false;
    }

    return ret;

  }
}