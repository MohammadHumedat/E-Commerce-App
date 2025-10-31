import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/models/product_item.dart';
import 'package:e_commerce_app/models/slider_carousel_model.dart';
import 'package:e_commerce_app/views/widgets/product_item_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          // circle Photo in the App bar.
                          backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/id/1457536828/photo/japanese-young-man-enjoy-traveling-alone.webp?a=1&s=612x612&w=0&k=20&c=S4hwiclbLQV2aMlztJVdjUuXEAMhYuuw2ifKERrAw44=',
                          ),
                          radius: 25,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          // Text behind the circle photo
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mohammad Hmedat',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Let\'s go shopping!',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ), // Row 1
                    Row(
                      // The icons at the end of App bar.
                      // Row 2
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                FlutterCarousel.builder(
                  itemCount: dummyCarousel.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = dummyCarousel[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image from the carousel model(Actually from the internet)
                          CachedNetworkImage(
                            imageUrl: item.ImageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                          ),

                          // Make a gradient over the image, to make the text more visible
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black26, Colors.transparent],
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
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Arrivals',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      'See All',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.primaryColor,

                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: productItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.70, // control height vs width ratio
                  ),

                  itemBuilder: (context, index) {
                    return ProductItemCard(productItem: productItems[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
