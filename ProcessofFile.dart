import 'package:e_cloneport/usermainpage.dart';
import 'package:e_cloneport/userpayment.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(UploadDocumentPage());
}
class UploadDocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'File Picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FilePickerDemo(title: 'File Picker '),
    );
  }
}
class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({Key? key, required this.title});
  final String title;
  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}
class _FilePickerDemoState extends State<FilePickerDemo> {
  FilePickerResult? result;
  String orderId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("File Picker"),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mainpage()),
              );
            },
          ),
        ),
        body: Padding(
        padding: const EdgeInsets.all(30.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    if (result != null)
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'Selected file:',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(
    height: 10,
    ),
    ListView.separated(
    shrinkWrap: true,
    itemCount: result!.files.length,
    itemBuilder: (context, index) {
    return Row(
    children: [
    Expanded(
    child: Text(
    result!.files[index].name,
    style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    IconButton(
    icon: Icon(Icons.cancel),
    onPressed: () {
    setState(() {
    result!.files.removeAt(index);
    });
    },
    ),
    ],
    );
    },
    separatorBuilder: (BuildContext context, int index) {
    return const SizedBox(
    height: 5,
    );
    },
    )
    ],
    ),
    ),
    const Spacer(),
    if (result != null)
    Center(
    child: ElevatedButton(
    onPressed: () {
    // Show printing properties dialog
    _showPrintPropertiesDialog();
    },
    child: const Text("Print", style: TextStyle(fontSize: 18)),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Color.fromARGB(174, 255, 242, 0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 30.0,
    ),
    ),
    ),
    ),
    const SizedBox(height: 20),
    Center(
    child: ElevatedButton(
    onPressed: () async {
    await _uploadFileToStorage();
    // Handle file upload, print properties, and navigation
    _handleFileUploadAndPrint();
    },
    child: const Text("File Picker", style: TextStyle(fontSize: 18)),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: const Color.fromARGB(255, 111, 11, 11),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 30.0,
    ),
    ),
    ),
    ),
    ],
    ),
        ),
    );
  }
  void _handleFileUploadAndPrint() {
    // Generate a new order ID
    orderId = _generateOrderId();
    // Show printing properties dialog
    _showPrintPropertiesDialog();
  }
  void _showPrintPropertiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrintPropertiesDialog(
          onPrint: () async {
            // Handle printing logic with properties here
            print('Printing with properties:');
            print('Order ID: $orderId');
            print('Paper size: ${PrintPropertiesDialog.paperSize}');
            print('Orientation: ${PrintPropertiesDialog.orientation}');
            print('Color mode: ${PrintPropertiesDialog.colorMode}');
            print('Quality: ${PrintPropertiesDialog.quality}');
            print('Copies: ${PrintPropertiesDialog.copies}');
            print('Extra: ${PrintPropertiesDialog.extraneed}');
            // Store printing properties in Firestore
            await _storePrintingProperties();
            // Notify the user about successful upload and printing properties
            _notifyUser();
          },
        );
      },
    );
  }
  Future<void> _uploadFileToStorage() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      // Get the current user's authentication information
      var user = FirebaseAuth.instance.currentUser;
      // Upload the file to Firebase Storage
      var storageReference = FirebaseStorage.instance
          .ref()
          .child('user_files/${user?.uid}/${result?.files[0].name}');
      var uploadTask = storageReference.putData(result!.files[0].bytes!);
      // Wait for the upload to complete
      await uploadTask.whenComplete(() => setState(() {}));
    }
  }
  Future<void> _storePrintingProperties() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the current user's authentication email
      String userEmail = user.email!;
      // Store printing properties in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('Orders') // Assuming you have an 'Orders' collection
          .doc(orderId)
          .set({
        'OrderId': orderId,
        'PaperSize': PrintPropertiesDialog.paperSize,
        'Orientation': PrintPropertiesDialog.orientation,
        'ColorMode': PrintPropertiesDialog.colorMode,
        'Quality': PrintPropertiesDialog.quality,
        'Copies': PrintPropertiesDialog.copies,
        'ExtraNeed': PrintPropertiesDialog.extraneed,
      }, SetOptions(merge: true))
          .then((value) => print('Printing properties stored in Firestore'))
          .catchError(
              (error) => print('Failed to store printing properties: $error'));
    }
  }
  void _notifyUser() {
    // Show notification or alert box to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: const Text(
              'File and Printing Properties Uploaded Successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Redirect to the shipping page with the orderId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippingPage(orderId: orderId),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  String _generateOrderId() {
    // Replace this with your logic to generate a unique order ID
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
class PrintPropertiesDialog extends StatefulWidget {
  static String paperSize = 'Letter';
  static String orientation = 'Portrait';
  static String colorMode = 'Color';
  static String extraneed = 'Extra';
  static int quality = 5;
  static int copies = 1;
  static List<int> selectedPages = [];
  final VoidCallback onPrint;
  const PrintPropertiesDialog({Key? key, required this.onPrint})
      : super(key: key);
  @override
  _PrintPropertiesDialogState createState() => _PrintPropertiesDialogState();
}
class _PrintPropertiesDialogState extends State<PrintPropertiesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Print Properties'),
        content: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    Text('Paper size: ${PrintPropertiesDialog.paperSize}'),
    Text('Orientation: ${PrintPropertiesDialog.orientation}'),
    Text('Color mode: ${PrintPropertiesDialog.colorMode}'),
    Text('Quality: ${PrintPropertiesDialog.quality}'),
    Text('Copies: ${PrintPropertiesDialog.copies}'),
    Text('Extra: ${PrintPropertiesDialog.extraneed}'),
    const SizedBox(height: 16),
    const Text('Adjust Print Properties:'),
    DropdownButton<String>(
    value: PrintPropertiesDialog.paperSize,
    onChanged: (String? newValue) {
    setState(() {
    PrintPropertiesDialog.paperSize = newValue!;
    });
    },
    items: <String>['Letter', 'A4', 'Legal', 'Custom']
        .map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    DropdownButton<String>(
    value: PrintPropertiesDialog.orientation,
    onChanged: (String? newValue) {
    setState(() {
    PrintPropertiesDialog.orientation = newValue!;
    });
    },
    items: <String>['Portrait', 'Landscape'].map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    DropdownButton<String>(
    value: PrintPropertiesDialog.colorMode,
    onChanged: (String? newValue) {
    setState(() {
    PrintPropertiesDialog.colorMode = newValue!;
    });
    },
    items: <String>['Color', 'Black & White'].map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    TextField(
    decoration: const InputDecoration(labelText: 'Quality'),
    onChanged: (value) {
    setState(() {
    PrintPropertiesDialog.quality = int.tryParse(value) ?? 0;
    });
    },
    ),
    TextField(
    decoration: const InputDecoration(labelText: 'Copies'),
    onChanged: (value) {
    setState(() {
    PrintPropertiesDialog.copies = int.tryParse(value) ?? 0;
    });
    },
    ),
    TextField(
    decoration: const InputDecoration(labelText: 'Extra'),
    onChanged: (value) {
    setState(() {
    PrintPropertiesDialog.extraneed = value;
    });
    },
    ),
    const SizedBox(height: 16),
    const Text('Select Pages:'),
    Row(
    children: [
    Expanded(
    child: ElevatedButton(
    onPressed: () {
    // Show a dialog or navigate to another page to select pages
    _showPageSelectionDialog(context);
    },
    child: const Text('Select Pages'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.black,
    ),
    ),
    ),
    const SizedBox(width: 16),
    ElevatedButton(
    onPressed: () {
    // Show a preview of selected pages
    _showPreviewDialog(context);
    },
    child: const Text('Preview'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.black,
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    actions: [
    ElevatedButton(
    onPressed: () {
    widget.onPrint();
    },
    child: const Text('Print Now'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Color.fromARGB(255, 12, 200, 206),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 30.0,
    ),
    ),
    ),
    ],
    );
  }
  void _showPageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Pages'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(
                10,
                    (index) => CheckboxListTile(
                  title: Text('Page ${index + 1}'),
                  value: PrintPropertiesDialog.selectedPages.contains(index + 1),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          PrintPropertiesDialog.selectedPages.add(index + 1);
                        } else {
                          PrintPropertiesDialog.selectedPages.remove(index + 1);
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Preview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected Pages: ${PrintPropertiesDialog.selectedPages}'),
                // Add logic to display a preview of selected pages here
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}
class ShippingPage extends StatefulWidget {
  final String orderId;
  const ShippingPage({Key? key, required this.orderId}) : super(key: key);
  @override
  _ShippingPageState createState() => _ShippingPageState();
}
class _ShippingPageState extends State<ShippingPage> {
  String selectedShippingMethod = 'Free'; // Default shipping method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shipping Methods'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.blue,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              'Select Shipping Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildRadioListTile('Free', 'No cost', 'Free'),
            buildRadioListTile('Standard', '2-5 days', 'Standard'),
            buildRadioListTile('Express', '1 day', 'Express'),
            SizedBox(height: 20),
            Text(
              'Selected Method: $selectedShippingMethod',
              style: TextStyle(fontSize: 16),
            ),
            if (selectedShippingMethod == 'Express') SizedBox(height: 10),
    if (selectedShippingMethod == 'Express')
    Text(
    'Cost: ₹10.00', // Replace with the actual cost calculation logic
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 20),
    // Display the orderId in the shipping page
    Text(
    'Order ID: ${widget.orderId}',
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 20),
    ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => userpayment()),
        );
        // Continue to the payment page or perform additional actions
        // _navigateToPaymentPage(context);
      },
      child: Text("Continue to Payment"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue, backgroundColor: Colors.black,
      ),
    ),
              ],
            ),
        ),
    );
  }
  Widget buildRadioListTile(
      title, String subtitle, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio(
        value: value,
        groupValue: selectedShippingMethod,
        onChanged: (String? newValue) {
          setState(() {
            selectedShippingMethod = newValue!;
          });
        },
      ),
      onTap: () {
        setState(() {
          selectedShippingMethod = value;
        });
      },
    );
  }
}
