import 'package:flutter/material.dart';
import 'package:frontendtemu/creditcardpage.dart';
import 'package:intl/intl.dart';
// import 'bayar.dart';
// import 'paymentbill.dart';

class BeriUangPage extends StatefulWidget {
  const BeriUangPage({super.key});

  @override
  _BeriUangPageState createState() => _BeriUangPageState();
}

class _BeriUangPageState extends State<BeriUangPage> {
  final List<int> moneyBoxes = [500000, 1000000, 2000000];
  int selectedMoney = 0;
  String eventId = "";
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void handleBoxTap(int value) {
    setState(() {
      selectedMoney = value;
      String formattedValue = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(value);
      amountController.text = formattedValue;
      amountController.selection =
          TextSelection.collapsed(offset: amountController.text.length);
    });
  }

  void handleAmountInput(String value) {
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanValue.isNotEmpty) {
      int amount = int.parse(cleanValue);
      String formattedValue = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(amount);

      setState(() {
        amountController.text = formattedValue;
        amountController.selection =
            TextSelection.collapsed(offset: formattedValue.length);
        selectedMoney = 0; // Reset pilihan jika user menginput manual
      });
    }
  }

  void handleEventIdInput(String value) {
    setState(() {
      eventId = value;
    });
  }

  void navigateToPaymentBill() {
    if (eventId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap masukkan ID acara')),
      );
      return;
    }

    int biayaSponsor = selectedMoney == 0
        ? int.tryParse(
                amountController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
            0
        : selectedMoney;

    if (biayaSponsor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap masukkan jumlah uang yang valid')),
      );
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beri Uang'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display selected Event ID and Organization Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nama  ",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextField(
                  controller: amountController,
                  onChanged: handleAmountInput,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Rp 0',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: moneyBoxes.map((money) {
                  return GestureDetector(
                    onTap: () => handleBoxTap(money),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedMoney == money
                            ? Colors.blueAccent
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: selectedMoney == money
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                      ),
                      child: Text(
                        currencyFormatter.format(money),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: navigateToPaymentBill,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Berikan Uang ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(
                        selectedMoney == 0
                            ? int.tryParse(amountController.text
                                    .replaceAll(RegExp(r'[^\d]'), '')) ??
                                0
                            : selectedMoney,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
