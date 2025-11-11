import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/models/slider_carousel_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHomeData() {
    emit(HomeLoading());
    try {
      // Simulate data loading
      final carouselData = dummyCarousel;
      final categoryData = dummyCategory;
      final dummyProductItems = productItems;

      emit(
        HomeLoaded(
          dummyCarousel: carouselData,
          dummyCategory: categoryData,
          productItems: dummyProductItems,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
