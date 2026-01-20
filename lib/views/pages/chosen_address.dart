import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/models/location_item_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';

class ChosenAddress extends StatefulWidget {
  const ChosenAddress({super.key});

  @override
  State<ChosenAddress> createState() => _ChosenAddressState();
}

class _ChosenAddressState extends State<ChosenAddress> {
  final TextEditingController searchController = TextEditingController();
  int selectedLocation = 0;
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Address',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  hintText: 'Search for your location',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_location_alt_outlined),
                    tooltip: 'Add Location',
                    color: AppColors.primaryColor,
                    onPressed: () {},
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), // Rounder corners
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Let\'s find your unforgettable event. Choose a location below to get started.',
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
              ),

              const SizedBox(height: 25),

              //Current Location Row
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.my_location_rounded,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'San Diego, CA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Current Location',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Select Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 15),

              // List View
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyLocationItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final item = dummyLocationItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: item.imgURL,
                            memCacheHeight: 150,
                            memCacheWidth: 150,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline, size: 20),
                          ),
                        ),
                      ),
                      title: Text(
                        item.city,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item.country,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      trailing: Radio(
                        value: index,
                        groupValue: selectedLocation,
                        activeColor: AppColors.primaryColor,
                        onChanged: (int? value) {
                          setState(() {
                            selectedLocation = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedLocation = index;
                        });
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: AppColors.primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Confirm Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
