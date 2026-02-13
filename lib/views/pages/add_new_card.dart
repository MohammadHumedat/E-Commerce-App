import 'package:e_commerce_app/Constants/app_colors.dart';
import 'package:e_commerce_app/Constants/payments_type.dart';
import 'package:e_commerce_app/view_model/payment_card/card_cubit.dart';
import 'package:e_commerce_app/view_model/payment_card/card_state.dart';
import 'package:e_commerce_app/views/widgets/payment_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  PaymentType _selectedPaymentType = PaymentType.visa;
  String _last4Digits = '****';
  String _cardHolderName = 'CARD HOLDER';
  String _expiryDate = 'MM/YY';

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateCardPreview);
    _cardHolderController.addListener(_updateCardPreview);
    _expiryDateController.addListener(_updateCardPreview);
    _emailController.addListener(_updateCardPreview);
  }

  void _updateCardPreview() {
    setState(() {
      String number = _cardNumberController.text.replaceAll(' ', '');
      if (number.length >= 4) {
        _last4Digits = number.substring(number.length - 4);
      } else {
        _last4Digits = '****';
      }

      _cardHolderName = _cardHolderController.text.isEmpty
          ? 'CARD HOLDER'
          : _cardHolderController.text.toUpperCase();

      _expiryDate = _expiryDateController.text.isEmpty
          ? 'MM/YY'
          : _expiryDateController.text;
    });
  }

  @override
  void dispose() { // Dispose controllers to free resources
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildCardPreview(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _selectedPaymentType.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _selectedPaymentType.gradientColors.first.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _selectedPaymentType.displayName,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PaymentIconWidget(
                  paymentType: _selectedPaymentType,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedPaymentType.isCardBased) ...[
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
          ] else if (_selectedPaymentType == PaymentType.paypal) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _emailController.text.isEmpty
                  ? 'your@email.com'
                  : _emailController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Holder',
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
              if (_selectedPaymentType.isCardBased)
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

  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Payment Type'),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: PaymentType.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final type = PaymentType.values[index];
              final isSelected = _selectedPaymentType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPaymentType = type;
                    _cardNumberController.clear();
                    _emailController.clear();
                  });
                },
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: type.gradientColors)
                        : null,
                    color: isSelected ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? type.gradientColors.first
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PaymentIconWidget(
                        paymentType: type,
                        size: 28,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        type.displayName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
          'Add Payment Method',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardPreview(context),
              _buildPaymentTypeSelector(),
              const SizedBox(height: 8),
              _buildLabel('Account Holder Name'),
              _buildTextFormField(
                controller: _cardHolderController,
                hintText: 'e.g., Mohammad Hmedat',
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person_outline,
                validator: (value) => value?.isEmpty == true
                    ? 'Please enter account holder name'
                    : null,
              ),
              if (_selectedPaymentType.isCardBased) ...[
                _buildLabel('Card Number'),
                _buildTextFormField(
                  controller: _cardNumberController,
                  hintText: '0000 0000 0000 0000',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.credit_card_rounded,
                  maxLength: 19,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CardNumberInputFormatter(),
                  ],
                  validator: (value) => value?.replaceAll(' ', '').length != 16
                      ? 'Card number must be 16 digits'
                      : null,
                ),
                Row(
                  children: [
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
                              _CardExpiryInputFormatter(),
                            ],
                            validator: (value) => value?.length != 5
                                ? 'Invalid date format'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
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
              ] else if (_selectedPaymentType == PaymentType.paypal) ...[
                _buildLabel('PayPal Email'),
                _buildTextFormField(
                  controller: _emailController,
                  hintText: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter your PayPal email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ] else ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You will be redirected to ${_selectedPaymentType.displayName} to complete setup',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          8 + MediaQuery.of(context).padding.bottom,
        ),
        child: BlocConsumer<AddCardCubit, AddCardState>(
          listener: (context, state) {
            if (state is CardLoaded && state.wasJustAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method added successfully!'),
                ),
              );
              Navigator.pop(context);
            } else if (state is CardFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          buildWhen: (previous, current) =>
              current is CardLoading ||
              current is CardLoaded ||
              current is CardFailure,
          builder: (context, state) {
            if (state is CardLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
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
                'Save Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() ?? false) {
      String accountIdentifier;

      if (_selectedPaymentType.isCardBased) {
        accountIdentifier = _cardNumberController.text.replaceAll(' ', '');
      } else if (_selectedPaymentType == PaymentType.paypal) {
        accountIdentifier = _emailController.text;
      } else {
        accountIdentifier = 'wallet_${DateTime.now().millisecondsSinceEpoch}';
      }

      context.read<AddCardCubit>().addCard(
        _cardHolderController.text,
        accountIdentifier,
        _expiryDateController.text.isEmpty ? 'N/A' : _expiryDateController.text,
        _cvvController.text.isEmpty ? '000' : _cvvController.text,
        _selectedPaymentType,
      );
    }
  }

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
        counterText: '',
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
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
        buffer.write(' ');
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
