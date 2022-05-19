class UserCoinsBalanceModel {
  int goldCoins;
  int diamondCoins;

  UserCoinsBalanceModel({
    this.goldCoins,
    this.diamondCoins,
  });

  UserCoinsBalanceModel.fromJsonMap(Map<String, dynamic> json) {
    this.goldCoins = json['goldenBalloons'];
    this.diamondCoins = json['diamondCoins'];
  }
}
