class RiderInfo{
  double codReemmit;
  double payout;

  RiderInfo({
   this.codReemmit,
   this.payout
});

  RiderInfo.fromJson(Map<String,dynamic> json){
    codReemmit = json['cod_reemit_amount'];
    payout =json['payout_amount'];
  }
}