import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/view_model/payment_card/card_cubit.dart';
import 'package:e_commerce_app/view_model/payment_card/card_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for FilteringTextInputFormatter

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  //Initialize Controllers for all form fields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // Dummy State for Card Display (can be replaced with provider/bloc)
  String _last4Digits = '****';
  String _cardHolderName = 'CARD HOLDER';
  String _expiryDate = 'MM/YY';

  @override
  void initState() {
    super.initState();
    //Listen to changes for the Card Preview
    _cardNumberController.addListener(_updateCardPreview);
    _cardHolderController.addListener(_updateCardPreview);
    _expiryDateController.addListener(_updateCardPreview);
  }

  void _updateCardPreview() {
    setState(() {
      //Update Card Number Preview (last 4 digits)
      String number = _cardNumberController.text.replaceAll(' ', '');
      if (number.length >= 4) {
        _last4Digits = number.substring(number.length - 4);
      } else {
        _last4Digits = '****';
      }

      //Update Card Holder Name
      _cardHolderName = _cardHolderController.text.isEmpty
          ? 'CARD HOLDER'
          : _cardHolderController.text.toUpperCase();

      //Update Expiry Date
      _expiryDate = _expiryDateController.text.isEmpty
          ? 'MM/YY'
          : _expiryDateController.text;
    });
  }

  @override
  void dispose() {
    //Performance: Dispose controllers to free up memory
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  //Custom Widget for the Card Preview (Modern UI)
  Widget _buildCardPreview(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'My Credit Card',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.credit_card_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),

          const Spacer(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Card Number',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '**** **** **** $_last4Digits',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Holder',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    _cardHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expires',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    _expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add New Card',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Allow scrolling if keyboard hides fields
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Card Preview
              _buildCardPreview(context),

              // Card Holder Name
              _buildLabel('Card Holder Name'),
              _buildTextFormField(
                controller: _cardHolderController,
                hintText: 'e.g., Mohammad Hmedat',
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person_outline,
                validator: (value) => value?.isEmpty == true
                    ? 'Please enter card holder name'
                    : null,
              ),

              // Card Number
              _buildLabel('Card Number'),
              _buildTextFormField(
                controller: _cardNumberController,
                hintText: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.credit_card_rounded,
                maxLength: 19, // 16 digits + 3 spaces
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Custom formatter to add spaces after every 4 digits for UX
                  _CardNumberInputFormatter(),
                ],
                validator: (value) => value?.replaceAll(' ', '').length != 19
                    ? 'Card number must be 16 digits'
                    : null,
              ),

              // Expiry Date and CVV Row
              Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Expiry Date'),
                        _buildTextFormField(
                          controller: _expiryDateController,
                          hintText: 'MM/YY',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.calendar_today_outlined,
                          maxLength: 5,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Custom formatter for MM/YY
                            _CardExpiryInputFormatter(),
                          ],
                          validator: (value) =>
                              value?.length != 5 ? 'Invalid date format' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // CVV
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CVV'),
                        _buildTextFormField(
                          controller: _cvvController,
                          hintText: 'XXX',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.lock_outline,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          obscureText: true,
                          validator: (value) => value?.length != 3
                              ? 'CVV must be 3 digits'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //  Modern Bottom Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          8 + MediaQuery.of(context).padding.bottom,
        ),
        child: BlocConsumer<AddCardCubit, AddCardState>(
          listener: (context, state) {
            if (state is CardSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card added successfully!')),
              );
              Navigator.pop(context); // Go back after successful save
            } else if (state is CardFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },

          buildWhen: (previous, current) =>
              current is! CardLoading ||
              current is CardSuccess ||
              current is CardFailure,
          bloc: BlocProvider.of<AddCardCubit>(context),
          builder: (context, state) {
            if (state is CardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Card',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Helper function for submission logic
  void _saveCard() {
    // if (_cardHolderController.text.isEmpty ||
    //     _cardNumberController.text.replaceAll(' ', '').length != 16 ||
    //     _expiryDateController.text.length != 5 ||
    //     _cvvController.text.length != 3) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please fill all fields correctly.')),
    //   );
    //   return;
    // }
    if (_formKey.currentState?.validate() ?? false) {
      // Logic to save the card details securely (API call)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card details valid. Proceeding to save...'),
        ),
      );
      // Navigator.pop(context); // Go back after successful save
    }
  }

  // Helper Widget for Input Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
    );
  }

  // Helper Widget for consistent TextFields (efficiency)
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '', // Hide the maxLength counter
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.primaryColor, // Replaced hardcoded color
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor:
            Theme.of(context).inputDecorationTheme.fillColor ?? AppColors.grey3,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}

// 6. Custom Input Formatters for better UX
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    String text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Add space
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final text = newValue.text.replaceAll('/', '');

    if (text.length > 2) {
      String formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return newValue;
  }
}
