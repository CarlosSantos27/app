class ProductModel {
  int id;
  double price;
  bool active;
  String title;
  int quantity;
  String picture;
  String coinType;
  String description;

  ProductModel(
      {this.id,
      this.active,
      this.title,
      this.description,
      this.quantity,
      this.price,
      this.picture,
      this.coinType});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id          = json['id'];
    price       = json['price'];
    title       = json['title'];
    active      = json['active'];
    picture     = json['picture'];
    coinType    = json['coinType'];
    quantity    = json['quantity'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']          = this.id;
    data['price']       = this.price;
    data['title']       = this.title;
    data['active']      = this.active;
    data['picture']     = this.picture;
    data['coinType']    = this.coinType;
    data['quantity']    = this.quantity;
    data['description'] = this.description;
    return data;
  }
}

class ProductsModel {

  List<ProductModel> list=new List();

  ProductsModel.listFromJsonMap(List<dynamic> listJson){
    if (listJson == null) return;
    listJson.forEach((item){
      list.add(ProductModel.fromJson(item));
    });
    
  }
}