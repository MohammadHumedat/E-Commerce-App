class LocationItemModel {

  factory LocationItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    return LocationItemModel(
      id: documentId,
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      imgURL: data['imgURL'] ?? '',
    );
  }
  LocationItemModel({
    required this.id,
    required this.city,
    required this.country,
    required this.imgURL,
  });
  String id;
  String city;
  String country;
  String imgURL;
  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'country': country,
      'imgURL': imgURL,
    };
  }
}

List<LocationItemModel> dummyLocationItems = [
  LocationItemModel(
    id: '1',
    city: 'Hebron',
    country: 'Palestine',
    imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
  ),
  LocationItemModel(
    id: '2',
    city: 'Amman',
    country: 'Jordan',
    imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
  ),
  LocationItemModel(
    id: '3',
    city: 'Moscow',
    country: 'russia',
    imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
  ),
  LocationItemModel(
    id: '4',
    city: 'CA',
    country: 'USA',
    imgURL: 'https://cdn-icons-png.flaticon.com/512/1865/1865269.png',
  ),
];
