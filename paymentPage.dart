import 'package:e_cloneport/process1file.dart';
import 'package:e_cloneport/thanking.dart';
import 'package:e_cloneport/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class userpayment extends StatelessWidget {
  const userpayment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  late Razorpay razorpay;
  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        externalWalletHandler);
    super.initState();
  }
  TextEditingController amountController = TextEditingController();
  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: const Color.fromARGB(255, 142, 20, 11),
    ));
  }
  void successHandler(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: const Color.fromARGB(255, 177, 177, 177),
    ));

    // Save payment details to Firestore
    savePaymentDetails(response.paymentId!);
  }
  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: const Color.fromARGB(255, 194, 202, 194),
    ));
  }
  void savePaymentDetails(String paymentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email!;
        String userId = user.uid;
        // Add payment details to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userEmail).set({
          'payment_status': 'success',
          'payment_id': paymentId,
          'user_id': userId,
          'amount': num.parse(amountController.text),
          // Add other fields as needed
        });
        // You can add more logic here based on your requirements
      }
    } catch (e) {
      print('Error saving payment details: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Payment Process"),
    backgroundColor: Colors.black,
    foregroundColor: Colors.blue,
    centerTitle: true,
    leading: IconButton(
    icon: Icon(Icons.arrow_back_ios),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UploadDocumentPage()),
    );
    },
    ),
    ),
    backgroundColor: Colors.teal,
    body: Column(
    children: [
    Container(
    color: Colors.teal,
    child: Card(
    color: Colors.white10,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
    controller: amountController,
    decoration: const InputDecoration(
    hintText: "Amount",
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 0.0),
    ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 0.0),
    ),
    ),
    ),
    ),
    const SizedBox(height: 10),
    ElevatedButton(
    onPressed: () {
    // openCheckout();
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ThankYouPage()),
    );
    },
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 228, 0, 0),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "Pay now",
          style: TextStyle(fontSize: 15),
        ),
      ),
    ),
    ],
    ),
    ),
    ),
      const SizedBox(height: 20),
      Image.asset(
        'images/in1.png',
        height: 300,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    ],
    ),
    );
  }
  void openCheckout() {
    var options = {
    "key": "rzp_test_jhZcx2FoTUIseG",
      "amount": num.parse(amountController.text) * 100,
      "name": "Cloneport",
      "description": "This is the test payment",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "6383634491",
        "email": "mohanasundars909@gmail.com",
      }
    };
    razorpay.open(options);
  }
}

