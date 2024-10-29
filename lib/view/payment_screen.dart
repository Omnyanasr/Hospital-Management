import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/payment_icon.dart';
import 'package:hospital_managment_project/components/textformfield.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHeaderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String selectedPaymentMethod = 'Visa';
  bool isLoading = false; // To show loading indicator

  void updatePaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void _handlePayNow() async {
    if (selectedPaymentMethod != 'Paypal' &&
        (cardNumberController.text.isEmpty ||
            cardHeaderController.text.isEmpty ||
            expiryDateController.text.isEmpty ||
            cvvController.text.isEmpty ||
            amountController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    } else {
      setState(() {
        isLoading = true;
      });

      if (selectedPaymentMethod == 'Paypal') {
        // Simulate a redirect to PayPal and show a success message after a delay
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });

        // Display a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Payment Successful"),
              content: const Text("Thank you for your payment via PayPal."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Simulate processing for other payment methods
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing payment...')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => updatePaymentMethod('Visa'),
                      child: PaymentIcon(
                        imagePath: 'assets/visa.png',
                        isSelected: selectedPaymentMethod == 'Visa',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updatePaymentMethod('Paypal'),
                      child: PaymentIcon(
                        imagePath: 'assets/paypal.png',
                        isSelected: selectedPaymentMethod == 'Paypal',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updatePaymentMethod('Mastercard'),
                      child: PaymentIcon(
                        imagePath: 'assets/mastercard.png',
                        isSelected: selectedPaymentMethod == 'Mastercard',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updatePaymentMethod('Stripe'),
                      child: PaymentIcon(
                        imagePath: 'assets/stripe.png',
                        isSelected: selectedPaymentMethod == 'Stripe',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // UI for non-Paypal methods
                if (selectedPaymentMethod != 'Paypal') ...[
                  CustomTextForm(
                    labelText: 'Card Number',
                    hintText: '1234 5678 4567',
                    icon: const Icon(Icons.credit_card),
                    mycontroller: cardNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextForm(
                    labelText: 'Card Holder',
                    hintText: 'John Doe',
                    icon: const Icon(Icons.person),
                    mycontroller: cardHeaderController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the cardholder name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextForm(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          icon: const Icon(Icons.date_range),
                          mycontroller: expiryDateController,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter expiry date';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextForm(
                          labelText: 'CVV',
                          hintText: '123',
                          icon: const Icon(Icons.lock),
                          mycontroller: cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter CVV';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
                // Shared Amount field
                CustomTextForm(
                  labelText: 'Enter Amount',
                  hintText: '\$0.00',
                  icon: const Icon(Icons.attach_money),
                  mycontroller: amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _handlePayNow,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                    ),
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
