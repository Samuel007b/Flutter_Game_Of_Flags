class Country{
  int id;
  String name;
  String address;

  Country({
    required this.id,
    required this.name,
    required this.address,
  });

  @override
  bool operator == (Object other) => identical(this, other) || other is Country && id == other.id;

  @override
  int get hashCode => name.hashCode;

  int getId(){
    return id;
  }
  void setId(int id){
    this.id=id;
  }
  String getName(){
    return name;
  }
  void setName(String name){
    this.name=name;
  }
  String getAddress(){
    return address;
  }
  void setAddress(String address){
    this.address=address;
  }

}