class SliderCarouselModel {
  SliderCarouselModel({required this.id, required this.imageUrl});
  final int id;
  final String imageUrl;
}

List<SliderCarouselModel> dummyCarousel = [
  SliderCarouselModel(
    id: 1,
    imageUrl:
        'https://www.shutterstock.com/image-vector/ecommerce-website-banner-template-presents-260nw-2252124451.jpg',
  ),
  SliderCarouselModel(
    id: 2,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEchTn83gZbeXOA_C__U_5Ip7HT99HRoBbbMpfeaRGfcuxS0UB1x_aKxNwJVP--OofhA8&usqp=CAU',
  ),
  SliderCarouselModel(
    id: 3,
    imageUrl:
        'https://www.jdmedia.co.za/images/carousel/Ecommerce-Banner-1920.jpg',
  ),
  SliderCarouselModel(
    id: 4,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjWzuOQNxsbMqaEgwd-bgEq2kaS2WY9wjoEkKOamIedqPfGGkRIMDEP4yU5i40I6qpPMs&usqp=CAU',
  ),

  SliderCarouselModel(
    id: 5,
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_9T4J_ydWR1g72paCQaEj4y1AfRgfGvzEGA&s',
  ),
];
