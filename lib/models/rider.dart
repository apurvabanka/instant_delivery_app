class RiderInfo{
  String name;
  double codReemmit;
  double payout;

  RiderInfo({
    this.name,
   this.codReemmit,
   this.payout
});

  RiderInfo.fromJson(Map<String,dynamic> json){
    name = json['rider_name'];
    codReemmit = json['cod_reemit_amount'];
    payout =json['payout_amount'];
  }
}