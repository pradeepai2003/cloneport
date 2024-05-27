import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cloneport/process1file.dart';
class Shop {
  final String id;
  final String name;
  final String about;
  final String process;
  final String prizes; // Added prize details
  final String shopAddress; // Added shop address
  final String status; // Added shop status
  Shop({
    required this.id,
    required this.name,
    required this.about,
    required this.process,
    required this.prizes,
    required this.shopAddress,
    required this.status,
  });
}
class ShopList extends StatefulWidget {
  @override
  _ShopListState createState() => _ShopListState();
}
class _ShopListState extends State<ShopList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Shop> _shops = [];
  late TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    fetchShopData();
  }
  Future<void> fetchShopData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('Admins').get();
      setState(() {
        _shops = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data()!;
          return Shop(
            id: doc.id,
            name: data['ShopName'] ?? '',
            about: data['ContactNumber'] ?? '',
            process: data['ShopProcess'] ?? '', // Assuming 'ShopProcess' is the
            correct field name for the process
          prizes: data['Prizes'] ?? '', // Adjust the field name as per your
            Firebase structure
            shopAddress: data['ShopAddress'] ?? '',
            status: data['ShopStatus'] ?? '', // Fetch shop status from Firestore
          );
        }).toList();
        if (_isSearching && _searchController.text.isNotEmpty) {
          _shops.sort((a, b) => a.name.startsWith(_searchController.text) ? -1
              : 1);
        }
      });
    } catch (e) {
      print('Error fetching shop data: $e');
      setState(() {
        _shops = [];
      });
    }
  }
  void _showShopDetailsDialog(Shop shop) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Shop Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Shop Name: ${shop.name}'),
              Text('Contact Number: ${shop.about}'),
              Text('Prizes: ${shop.prizes}'),
              Text('Shop Address: ${shop.shopAddress}'),
            ],
          ),
          actions: [
          TextButton(
          onPressed: () {
        Navigator.pop(context);
          },
            child: Text('Close'),
          ),
          ],
      );
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Shop List"),
    centerTitle: true,
    backgroundColor: Colors.black,
    foregroundColor: Colors.blue,
    leading: IconButton(
    icon: Icon(Icons.arrow_back_ios),
    onPressed: () {
    if (_isSearching) {
    setState(() {
    _isSearching = false;
    _searchController.clear();
    });
    } else {
    Navigator.pop(context);
    }
    },
    ),
    actions: _buildAppBarActions(),
    ),
    body: _shops.isEmpty
    ? Center(child: CircularProgressIndicator())
        : ListView.builder(
    itemCount: _shops.length,
    itemBuilder: (BuildContext context, int index) {
    return Card(
    child: Stack(
    children: [
    ListTile(
    title: Text(
    _shops[index].name,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    _shops[index].about,
    style: TextStyle(fontSize: 14),
    ),
    SizedBox(height: 8),
    Row(
    mainAxisAlignment:
    MainAxisAlignment.spaceBetween,
    children: [
    ElevatedButton(
    onPressed: () {
    _showShopDetailsDialog(_shops[index]);
    },
    child: Text(
    "About",
    style: TextStyle(
    color: Colors.white,
    ),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    ),
    ),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>
    UploadDocumentPage()),
    );
    },
    child: Text(
    "Process",
    style: TextStyle(
    color: Colors.white,
    ),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    ),
    ),
    ],
    ),
    ],
    ),
    ),
      Positioned(
        top: 8,
        right: 8,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _shops[index].status == 'available' ? Colors.green :
            Color.fromARGB(255, 55, 0, 255),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _shops[index].status,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
    ),
    );
    },
    ),
    );
  }
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search shop...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _isSearching = true;
          fetchShopData();
        });
      },
    );
  }
  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              fetchShopData();
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }
}
