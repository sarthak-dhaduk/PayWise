import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, String>> _upiAccounts = [
    {'name': 'GPay Account', 'image': 'assets/images/gpay.png'},
    {'name': 'Paytm Account', 'image': 'assets/images/paytm.png'},
    {'name': 'PhonePe Account', 'image': 'assets/images/phonepay.png'},
  ];

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

  // Function to add account to Firebase
  Future<void> addNewAccount({
    required String accountType,
    required String? accountName,
    required double balance,
    String? selectedUPIAccount,
    String? selectedBankAccount,
  }) async {
    // Get the email from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email == null) {
      throw Exception("No email found in SharedPreferences.");
    }

    // Generate a unique account ID
    var uuid = Uuid();
    String accountId = uuid.v4();

    // Set the account image and name based on the selected account type
    String accountImage;
    String accountNameToInsert;

    if (accountType == 'Wallet') {
      accountImage = 'assets/images/wallet.png';
      accountNameToInsert = accountName?.isEmpty ?? true ? 'Wallet' : accountName!;
    } else if (accountType == 'UPI Account') {
      var selectedAccount = _upiAccounts.firstWhere(
          (account) => account['name'] == selectedUPIAccount,
          orElse: () => {'name': 'Unknown', 'image': 'assets/images/wallet.png'});
      accountImage = selectedAccount['image']!;
      accountNameToInsert = accountName?.isEmpty ?? true ? selectedAccount['name']! : accountName!;
    } else if (accountType == 'Bank Account') {
      var selectedBank = _bankAccounts.firstWhere(
          (bank) => bank['name'] == selectedBankAccount,
          orElse: () => {'name': 'Unknown', 'image': 'assets/images/wallet.png'});
      accountImage = selectedBank['image']!;
      accountNameToInsert = accountName?.isEmpty ?? true ? selectedBank['name']! : accountName!;
    } else {
      throw Exception("Invalid account type selected.");
    }

    // Insert data into Firebase
    await _firestore.collection('accounts').doc(accountId).set({
      'account_id': accountId,
      'account_name': accountNameToInsert,
      'account_image': accountImage,
      'balance': balance.toString(),
      'email': email,
    });
  }
}
