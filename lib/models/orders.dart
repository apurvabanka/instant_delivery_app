class OrderDetails {
  int orderId;
//  int trackingId;
  double pickupLat;
  double pickupLong;
  double dropLat;
  double dropLong;
//  DateTime orderDate;
  double orderValue;
  String customerNumber;
  String typeOfOrder;
  String typeOfPayment;

  OrderDetails({
    this.orderId,
//    this.trackingId,
    this.pickupLat,
    this.pickupLong,
    this.dropLat,
    this.dropLong,
//    this.orderDate,
    this.orderValue,
    this.customerNumber,
    this.typeOfOrder,
    this.typeOfPayment
  });

  OrderDetails.fromJson(Map<String,dynamic> json){
    orderId = json['order_id'];
//    trackingId = json['tracking_id'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    dropLat = json['drop_lat'];
    dropLong = json['drop_long'];
//    orderDate = json['order_date'];
    orderValue = json['order_value'];
    customerNumber = json['customer_number'];
    typeOfOrder = json['type_of_order'];
    typeOfPayment = json['type_of_payment'];
  }
}