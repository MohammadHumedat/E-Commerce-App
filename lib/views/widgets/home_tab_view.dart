import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/Constants/app_routes.dart';

import 'package:e_commerce_app/view_model/home_cubit/home_cubit.dart';
import 'package:e_commerce_app/views/widgets/product_item_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      // Listen for favorite actions to show feedback
      listener: (context, state) {
        if (state is FavoriteItemAddError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message} for the product ID ${state.productId}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      },
      buildWhen: (previous, current) =>
          current is HomeLoaded ||
          current is HomeLoading ||
          current is HomeError,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is HomeLoaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    FlutterCarousel.builder(
                      itemCount: state.carouselItems.length,
                      itemBuilder: (context, index, realIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Image from the carousel model
                              CachedNetworkImage(
                                imageUrl: state.carouselItems[index].imageUrl,
                                fit: BoxFit.fill,
                                memCacheHeight: 150,
                                memCacheWidth: 300,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                  ),
                                ),
                              ),
                              // Gradient overlay
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black26,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: FlutterCarouselOptions(
                        height: 150,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 8),
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: true,
                        showIndicator: true,
                        indicatorMargin: 4.0,
                        slideIndicator: CircularSlideIndicator(
                          slideIndicatorOptions: const SlideIndicatorOptions(
                            indicatorBorderColor: Colors.transparent,
                            indicatorBackgroundColor: Colors.white54,
                            currentIndicatorColor: Colors.orange,
                            indicatorRadius: 2.5,
                            padding: EdgeInsets.only(bottom: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Arrivals',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: AppColors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          'See All',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      padding: const EdgeInsets.all(5),
                      itemCount: state.productItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.70,
                          ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigate to product details page
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(
                              AppRoutes.productDetails,
                              arguments: state.productItems[index].id,
                            );
                          },
                          child: ProductItemCard(
                            productItem: state.productItems[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
