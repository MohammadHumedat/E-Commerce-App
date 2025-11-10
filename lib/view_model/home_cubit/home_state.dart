part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({required this.dummyCarousel, required this.dummyCategory});
  List<SliderCarouselModel> dummyCarousel;
  List<CategoryModel> dummyCategory;
}
final class HomeError extends HomeState {
  HomeError({required this.message});
  final String message;
}