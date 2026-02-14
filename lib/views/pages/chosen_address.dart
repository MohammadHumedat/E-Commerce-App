import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/view_model/location_cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChosenAddress extends StatefulWidget {
  const ChosenAddress({super.key});

  @override
  State<ChosenAddress> createState() => _ChosenAddressState();
}

class _ChosenAddressState extends State<ChosenAddress> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<LocationCubit>()
        .fetchLocations(); // Fetch locations when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Select Address',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state is LocationAdded) {
            _showFeedback(context, 'Location added!', Colors.green);
          } else if (state is LocationAddingFailure) {
            _showFeedback(context, state.message, Colors.redAccent);
          }
        },
        child: Column(
          children: [
            // Header Search Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: _buildSearchBar(),
            ),

            Expanded(
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  if (state is LocationsFetching) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is LocationsFetched) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      itemCount: state.locations.length,
                      itemBuilder: (context, index) {
                        final loc = state.locations[index];
                        final isSelected = loc.id == state.selectedId;
                        return _buildLocationCard(loc, isSelected);
                      },
                    );
                  }
                  return const Center(child: Text('No locations found.'));
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildConfirmButton(), // Confirm Button
    );
  }

  // UI COMPONENTS

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF1F3F5),
          hintText: 'Enter City - Country...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: AppColors.primaryColor,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                context.read<LocationCubit>().addLocation(
                  searchController.text,
                );
                searchController.clear();
              },
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(loc, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => context.read<LocationCubit>().selectLocation(loc.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 55,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: CachedNetworkImage(
                  imageUrl: loc.imgURL!,
                  fit: BoxFit.contain,
                  memCacheHeight: 100,
                  memCacheWidth: 100,
                  maxHeightDiskCache: 200,
                  maxWidthDiskCache: 200,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.country,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Selection Indicator
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.shade300,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        bool active = state is LocationsFetched;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: active
                  ? () {
                      // Confirm selected address and return to previous screen
                      final selected = state.locations.firstWhere(
                        (l) => l.id == state.selectedId,
                      );
                      Navigator.pop(context, selected);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 10,
                shadowColor: AppColors.primaryColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Use This Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFeedback(BuildContext context, String msg, Color color) {
    // SnackBar for feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
