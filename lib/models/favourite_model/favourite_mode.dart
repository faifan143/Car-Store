class FavouriteModel {
 final int carId;
 final String carName;
 final String urlImage;
 final String description;
 bool isFavourted;
 final String price ;
  FavouriteModel({
    required this.carId,
    required this.urlImage,
    required this.description,
    required this.isFavourted,
    required this.price,
    required this.carName,
  });
 
}
