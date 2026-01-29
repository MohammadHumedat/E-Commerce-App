import 'package:e_commerce_app/models/category_model.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/models/slider_carousel_model.dart';
import 'package:e_commerce_app/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _homeService = HomeServiceImp();
  Future loadHomeData() async {
    emit(HomeLoading());
    try {
      final productItems = await _homeService
          .fetchHomeData(); // Fetch product items from the service
      // Simulate data loading for carousel and category
      final carouselData = dummyCarousel;
      final categoryData = dummyCategory;

      emit(
        HomeLoaded(
          dummyCarousel: carouselData,
          dummyCategory: categoryData,
          productItems: productItems,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
