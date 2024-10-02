import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paywise/screens/AccountPage.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage>
    with SingleTickerProviderStateMixin {
  String? selectedWallet;

  // Define account types
  List<String> _accountTypes = ['Wallet', 'UPI Account', 'Bank Account'];
  String? _selectedAccountType;

// Define UPI accounts
  List<Map<String, String>> _upiAccounts = [
    {'name': 'GPay Account', 'image': 'assets/images/gpay.png'},
    {'name': 'Paytm Account', 'image': 'assets/images/paytm.png'},
    {'name': 'PhonePe Account', 'image': 'assets/images/phonepay.png'},
  ];

// Define Bank accounts
  List<Map<String, String>> _bankAccounts = [
    {'name': 'State Bank of India', 'image': 'assets/listBank/sbi.png'},
    {
      'name': 'Punjab National Bank',
      'image': 'assets/listBank/PunjabNationalBank.png'
    },
    {'name': 'Bank of Baroda', 'image': 'assets/listBank/BankOfBaroda.png'},
    {'name': 'Canara Bank', 'image': 'assets/listBank/CanaraBank.png'},
    {
      'name': 'Union Bank of India',
      'image': 'assets/listBank/UnionBankOfIndia.png'
    },
    {'name': 'Indian Bank', 'image': 'assets/listBank/IndianBank.png'},
    {
      'name': 'Central Bank of India',
      'image': 'assets/listBank/CentralBankOfIndia.png'
    },
    {'name': 'UCO Bank', 'image': 'assets/listBank/UCOBank.png'},
    {'name': 'Bank of India', 'image': 'assets/listBank/BankOfIndia.png'},
    {
      'name': 'Indian Overseas Bank',
      'image': 'assets/listBank/IndianOverseasBank.png'
    },
    {'name': 'Axis Bank', 'image': 'assets/listBank/AxisBank.png'},
    {'name': 'HDFC Bank', 'image': 'assets/listBank/HDFCBank.png'},
    {'name': 'ICICI Bank', 'image': 'assets/listBank/ICICIBank.png'},
    {
      'name': 'Kotak Mahindra Bank',
      'image': 'assets/listBank/KotakMahindraBank.png'
    },
    {'name': 'Yes Bank', 'image': 'assets/listBank/YesBank.png'},
    {'name': 'IDFC First Bank', 'image': 'assets/listBank/IDFCFirstBank.png'},
    {'name': 'Bandhan Bank', 'image': 'assets/listBank/BandhanBank.png'},
    {'name': 'RBL Bank', 'image': 'assets/listBank/RBLBank.png'},
    {'name': 'DCB Bank', 'image': 'assets/listBank/DCBBank.png'},
    {'name': 'IndusInd Bank', 'image': 'assets/listBank/IndusIndBank.jpg'},
    {
      'name': 'Jammu & Kashmir Bank',
      'image': 'assets/listBank/JammuAndKashmirBank.png'
    },
    {'name': 'Karnataka Bank', 'image': 'assets/listBank/KarnatakaBank.png'},
    {'name': 'Karur Vysya Bank', 'image': 'assets/listBank/KarurVysyaBank.png'},
    {
      'name': 'Lakshmi Vilas Bank',
      'image': 'assets/listBank/LakshmiVilasBank.png'
    },
    {
      'name': 'South Indian Bank',
      'image': 'assets/listBank/SouthIndianBank.png'
    },
    {'name': 'City Union Bank', 'image': 'assets/listBank/CityUnionBank.png'},
    {
      'name': 'Tamilnad Mercantile Bank',
      'image': 'assets/listBank/TamilnadMercantileBank.png'
    },
    {'name': 'Federal Bank', 'image': 'assets/listBank/FederalBank.png'},
    {'name': 'Nainital Bank', 'image': 'assets/listBank/NainitalBank.jpg'},
    {'name': 'Dhanlaxmi Bank', 'image': 'assets/listBank/DhanlaxmiBank.png'},
    {'name': 'Saraswat Bank', 'image': 'assets/listBank/SaraswatBank.png'},
    {
      'name': 'Suryoday Small Finance Bank',
      'image': 'assets/listBank/SuryodaySmallFinanceBank.png'
    },
    {
      'name': 'Equitas Small Finance Bank',
      'image': 'assets/listBank/EquitasSmallFinanceBank.png'
    },
    {
      'name': 'Ujjivan Small Finance Bank',
      'image': 'assets/listBank/UjjivanSmallFinanceBank.png'
    },
    {
      'name': 'ESAF Small Finance Bank',
      'image': 'assets/listBank/ESAFSmallFinanceBank.png'
    },
    {
      'name': 'Fincare Small Finance Bank',
      'image': 'assets/listBank/FincareSmallFinanceBank.png'
    },
    {
      'name': 'Jana Small Finance Bank',
      'image': 'assets/listBank/JanaSmallFinanceBank.png'
    },
    {
      'name': 'Capital Small Finance Bank',
      'image': 'assets/listBank/CapitalSmallFinanceBank.jpg'
    },
    {
      'name': 'AU Small Finance Bank',
      'image': 'assets/listBank/AUSmallFinanceBank.png'
    },
    {
      'name': 'North East Small Finance Bank',
      'image': 'assets/listBank/NorthEastSmallFinanceBank.png'
    },
    {
      'name': 'Unity Small Finance Bank',
      'image': 'assets/listBank/UnitySmallFinanceBank.png'
    },
    {
      'name': 'Shivalik Small Finance Bank',
      'image': 'assets/listBank/ShivalikSmallFinanceBank.png'
    },
    {
      'name': 'Airtel Payments Bank',
      'image': 'assets/listBank/AirtelPaymentsBank.png'
    },
    {
      'name': 'India Post Payments Bank',
      'image': 'assets/listBank/IndiaPostPaymentsBank.png'
    },
    {
      'name': 'Fino Payments Bank',
      'image': 'assets/listBank/FinoPaymentsBank.png'
    },
    {
      'name': 'Paytm Payments Bank',
      'image': 'assets/listBank/PaytmPaymentsBank.png'
    },
    {
      'name': 'NSDL Payments Bank',
      'image': 'assets/listBank/NSDLPaymentsBank.png'
    },
    {
      'name': 'Jio Payments Bank',
      'image': 'assets/listBank/JioPaymentsBank.png'
    },
    {
      'name': 'Andhra Pragathi Grameena Bank',
      'image': 'assets/listBank/AndhraPragathiGrameenaBank.png'
    },
    {
      'name': 'Baroda Gujarat Gramin Bank',
      'image': 'assets/listBank/BarodaGujaratGraminBank.jpg'
    },
    {'name': 'Baroda UP Bank', 'image': 'assets/listBank/BarodaUPBank.jpg'},
    {
      'name': 'Bihar Gramin Bank',
      'image': 'assets/listBank/BiharGraminBank.png'
    },
    {
      'name': 'Dakshin Bihar Gramin Bank',
      'image': 'assets/listBank/DakshinBiharGraminBank.png'
    },
    {
      'name': 'Ellaquai Dehati Bank',
      'image': 'assets/listBank/EllaquaiDehatiBank.png'
    },
    {
      'name': 'Himachal Pradesh Gramin Bank',
      'image': 'assets/listBank/HimachalPradeshGraminBank.png'
    },
    {
      'name': 'Jammu & Kashmir Grameen Bank',
      'image': 'assets/listBank/JammuAndKashmirGrameenBank.png'
    },
    {
      'name': 'Jharkhand Rajya Gramin Bank',
      'image': 'assets/listBank/JharkhandRajyaGraminBank.png'
    },
    {
      'name': 'Karnataka Gramin Bank',
      'image': 'assets/listBank/KarnatakaGraminBank.png'
    },
    {
      'name': 'Karnataka Vikas Grameena Bank',
      'image': 'assets/listBank/KarnatakaVikasGrameenaBank.jpg'
    },
    {
      'name': 'Kerala Gramin Bank',
      'image': 'assets/listBank/KeralaGraminBank.png'
    },
    {
      'name': 'Madhya Pradesh Gramin Bank',
      'image': 'assets/listBank/MadhyaPradeshGraminBank.png'
    },
    {
      'name': 'Madhyanchal Gramin Bank',
      'image': 'assets/listBank/MadhyanchalGraminBank.png'
    },
    {
      'name': 'Maharashtra Gramin Bank',
      'image': 'assets/listBank/MaharashtraGraminBank.png'
    },
    {
      'name': 'Manipur Rural Bank',
      'image': 'assets/listBank/ManipurRuralBank.png'
    },
    {
      'name': 'Meghalaya Rural Bank',
      'image': 'assets/listBank/MeghalayaRuralBank.png'
    },
    {
      'name': 'Mizoram Rural Bank',
      'image': 'assets/listBank/MizoramRuralBank.png'
    },
    {
      'name': 'Nagaland Rural Bank',
      'image': 'assets/listBank/NagalandRuralBank.png'
    },
    {
      'name': 'Odisha Gramya Bank',
      'image': 'assets/listBank/OdishaGramyaBank.png'
    },
    {
      'name': 'Paschim Banga Gramin Bank',
      'image': 'assets/listBank/PaschimBangaGraminBank.png'
    },
    {
      'name': 'Prathama UP Gramin Bank',
      'image': 'assets/listBank/PrathamaUPGraminBank.png'
    },
    {
      'name': 'Puduvai Bharathiar Grama Bank',
      'image': 'assets/listBank/PuduvaiBharathiarGramaBank.png'
    },
    {
      'name': 'Punjab Gramin Bank',
      'image': 'assets/listBank/PunjabGraminBank.png'
    },
    {
      'name': 'Rajasthan Marudhara Gramin Bank',
      'image': 'assets/listBank/RajasthanMarudharaGraminBank.png'
    },
    {
      'name': 'Saptagiri Grameena Bank',
      'image': 'assets/listBank/SaptagiriGrameenaBank.png'
    },
    {
      'name': 'Sarva Haryana Gramin Bank',
      'image': 'assets/listBank/SarvaHaryanaGraminBank.png'
    },
    {
      'name': 'Saurashtra Gramin Bank',
      'image': 'assets/listBank/SaurashtraGraminBank.png'
    },
    {
      'name': 'Tamil Nadu Grama Bank',
      'image': 'assets/listBank/TamilNaduGramaBank.png'
    },
    {
      'name': 'Telangana Grameena Bank',
      'image': 'assets/listBank/TelanganaGrameenaBank.png'
    },
    {
      'name': 'Tripura Gramin Bank',
      'image': 'assets/listBank/TripuraGraminBank.png'
    },
    {
      'name': 'Utkal Grameen Bank',
      'image': 'assets/listBank/UtkalGrameenBank.png'
    },
    {
      'name': 'Uttarakhand Gramin Bank',
      'image': 'assets/listBank/UttarakhandGraminBank.png'
    },
    {
      'name': 'Vidarbha Konkan Gramin Bank',
      'image': 'assets/listBank/VidarbhaKonkanGraminBank.png'
    },
    {
      'name': 'Assam Gramin Vikash Bank',
      'image': 'assets/listBank/AssamGraminVikashBank.jpg'
    },
  ];

  String? _selectedUPIAccount;
  String? _selectedBankAccount;

// This controller is used for search functionality
  final TextEditingController _searchController = TextEditingController();

  double topContainerHeight = 450;
  double bottomContainerHeight = 350;
  double maxHeight = 650;
  double minHeight = 200;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Faster response time
    );
    _animation =
        Tween<double>(begin: bottomContainerHeight, end: bottomContainerHeight)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Increase sensitivity to make scrolling faster
      bottomContainerHeight -=
          details.delta.dy * 1.7; // Increase scroll sensitivity
      if (bottomContainerHeight > maxHeight) bottomContainerHeight = maxHeight;
      if (bottomContainerHeight < minHeight) bottomContainerHeight = minHeight;
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    // Adjust spring physics for a faster snap back and reaction
    final velocity = details.primaryVelocity ?? 0;
    final spring = SpringDescription(
      mass: 1,
      stiffness: 2000, // Increased stiffness for faster spring action
      damping: 7, // Further lowered damping for quicker response
    );

    final simulation = SpringSimulation(
        spring, bottomContainerHeight, bottomContainerHeight, velocity / 1000);

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(127, 61, 255, 1),
        centerTitle: true,
        title: Text('Add new account', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Color.fromRGBO(127, 61, 255, 1),
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'How Much?',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.64),
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: bottomContainerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                margin: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              DropdownButtonFormField2<String>(
                                value: _selectedAccountType,
                                items: _accountTypes.map((accountType) {
                                  return DropdownMenuItem<String>(
                                    value: accountType,
                                    child: Text(accountType),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAccountType = newValue;
                                    _selectedUPIAccount =
                                        null; // Reset UPI selection
                                    _selectedBankAccount =
                                        null; // Reset Bank selection
                                  });
                                },
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                  iconSize: 0,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Account Type",
                                  labelStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 50, 50, 50)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    borderSide: BorderSide(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(127, 61, 255, 1)),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    maxWidth: 35,
                                    maxHeight: 35,
                                  ),
                                  suffixIcon: Container(
                                      padding: EdgeInsets.only(right: 15),
                                      child: SvgPicture.asset(
                                          'assets/icons/Vector.svg')),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Conditionally show the UPI or Bank dropdown based on the account type selected
                              if (_selectedAccountType == 'UPI Account') ...[
                                DropdownButtonFormField2<String>(
                                  value: _selectedUPIAccount,
                                  items: _upiAccounts.map((upiAccount) {
                                    return DropdownMenuItem<String>(
                                      value: upiAccount['name'],
                                      child: Row(
                                        children: [
                                          Image.asset(upiAccount['image']!,
                                              width: 24, height: 24),
                                          SizedBox(width: 10),
                                          Text(upiAccount['name']!),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedUPIAccount = newValue;
                                    });
                                  },
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                    iconSize: 0,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Select UPI Account",
                                    labelStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 46, 46, 46)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(127, 61, 255, 1)),
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                      maxWidth: 35,
                                      maxHeight: 35,
                                    ),
                                    suffixIcon: Container(
                                        padding: EdgeInsets.only(right: 15),
                                        child: SvgPicture.asset(
                                            'assets/icons/Vector.svg')),
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: _searchController,
                                    searchInnerWidget: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search UPI...',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchInnerWidgetHeight:
                                        60, // Added height for the search widget
                                    searchMatchFn: (item, searchValue) {
                                      return (item.value as String)
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase());
                                    },
                                  ),
                                ),
                              ] else if (_selectedAccountType ==
                                  'Bank Account') ...[
                                DropdownButtonFormField2<String>(
                                  value: _selectedBankAccount,
                                  items: _bankAccounts.map((bankAccount) {
                                    return DropdownMenuItem<String>(
                                      value: bankAccount['name'],
                                      child: Row(
                                        children: [
                                          Image.asset(bankAccount['image']!,
                                              width: 24, height: 24),
                                          SizedBox(width: 10),
                                          Text(
                                            bankAccount['name']!,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedBankAccount = newValue;
                                    });
                                  },
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                    iconSize: 0,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Select Bank Account",
                                    labelStyle: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 67, 67, 67)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(127, 61, 255, 1)),
                                    ),
                                    suffixIconConstraints: BoxConstraints(
                                      maxWidth: 35,
                                      maxHeight: 35,
                                    ),
                                    suffixIcon: Container(
                                        padding: EdgeInsets.only(right: 15),
                                        child: SvgPicture.asset(
                                            'assets/icons/Vector.svg')),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    width: double.infinity,
                                    isFullScreen: true,
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: _searchController,
                                    searchInnerWidget: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search Bank...',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchInnerWidgetHeight:
                                        60, // Added height for the search widget
                                    searchMatchFn: (item, searchValue) {
                                      return (item.value as String)
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase());
                                    },
                                  ),
                                ),
                              ],
                              SizedBox(height: 16),
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => AccountPage()),
                                    );
                                  },
                                  child: Text('Continue',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(127, 61, 255, 1),
                                    minimumSize: Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
