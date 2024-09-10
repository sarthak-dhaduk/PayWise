import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';

class CurrencyConverter extends StatefulWidget {
  final Color color;

  const CurrencyConverter({
    Key? key,
    required this.color,
  }) : super(key: key);
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String _fromCurrency = 'INR';
  String _toCurrency = 'INR';
  double _amount = 0;
  String _result = '';
  final _amountController = TextEditingController();
  final TextEditingController _fromCurrencySearchController =
      TextEditingController();
  final TextEditingController _toCurrencySearchController =
      TextEditingController();

  final List<Map<String, String>> _currencies = [
    {'code': 'ANG', 'name': 'Netherlands Antillean Guilder (ANG)'},
    {'code': 'SVC', 'name': 'Salvadoran Colón (SVC)'},
    {'code': 'CAD', 'name': 'Canadian Dollar (CAD)'},
    {'code': 'XCD', 'name': 'East Caribbean Dollar (XCD)'},
    {'code': 'MVR', 'name': 'Maldivian Rufiyaa (MVR)'},
    {'code': 'HRK', 'name': 'Croatian Kuna (HRK)'},
    {'code': 'AUD', 'name': 'Australian Dollar (AUD)'},
    {'code': 'MWK', 'name': 'Malawian Kwacha (MWK)'},
    {'code': 'XAG', 'name': 'Silver Ounce (XAG)'},
    {'code': 'MAD', 'name': 'Moroccan Dirham (MAD)'},
    {'code': 'PHP', 'name': 'Philippine Peso (PHP)'},
    {'code': 'NAD', 'name': 'Namibian Dollar (NAD)'},
    {'code': 'GNF', 'name': 'Guinean Franc (GNF)'},
    {'code': 'KES', 'name': 'Kenyan Shilling (KES)'},
    {'code': 'MZN', 'name': 'Mozambican Metical (MZN)'},
    {'code': 'BTN', 'name': 'Bhutanese Ngultrum (BTN)'},
    {'code': 'MGA', 'name': 'Malagasy Ariary (MGA)'},
    {'code': 'AZN', 'name': 'Azerbaijani Manat (AZN)'},
    {'code': 'XAU', 'name': 'Gold Ounce (XAU)'},
    {'code': 'RON', 'name': 'Romanian Leu (RON)'},
    {'code': 'CHF', 'name': 'Swiss Franc (CHF)'},
    {'code': 'EGP', 'name': 'Egyptian Pound (EGP)'},
    {'code': 'BSD', 'name': 'Bahamian Dollar (BSD)'},
    {'code': 'TWD', 'name': 'New Taiwan Dollar (TWD)'},
    {'code': 'GGP', 'name': 'Guernsey Pound (GGP)'},
    {'code': 'LVL', 'name': 'Latvian Lats (LVL)'},
    {'code': 'MMK', 'name': 'Myanmar Kyat (MMK)'},
    {'code': 'WST', 'name': 'Samoan Tala (WST)'},
    {'code': 'ILS', 'name': 'Israeli New Shekel (ILS)'},
    {'code': 'BHD', 'name': 'Bahraini Dinar (BHD)'},
    {'code': 'GBP', 'name': 'British Pound (GBP)'},
    {'code': 'TZS', 'name': 'Tanzanian Shilling (TZS)'},
    {'code': 'SDG', 'name': 'Sudanese Pound (SDG)'},
    {'code': 'LAK', 'name': 'Lao Kip (LAK)'},
    {'code': 'DJF', 'name': 'Djiboutian Franc (DJF)'},
    {'code': 'BYN', 'name': 'Belarusian Ruble (BYN)'},
    {'code': 'LBP', 'name': 'Lebanese Pound (LBP)'},
    {'code': 'RWF', 'name': 'Rwandan Franc (RWF)'},
    {'code': 'PEN', 'name': 'Peruvian Sol (PEN)'},
    {'code': 'EUR', 'name': 'Euro (EUR)'},
    {'code': 'ZMK', 'name': 'Zambian Kwacha (ZMK)'},
    {'code': 'RSD', 'name': 'Serbian Dinar (RSD)'},
    {'code': 'INR', 'name': 'Indian Rupee (INR)'},
    {'code': 'MUR', 'name': 'Mauritian Rupee (MUR)'},
    {'code': 'BWP', 'name': 'Botswana Pula (BWP)'},
    {'code': 'GEL', 'name': 'Georgian Lari (GEL)'},
    {'code': 'KMF', 'name': 'Comorian Franc (KMF)'},
    {'code': 'UZS', 'name': 'Uzbekistani Som (UZS)'},
    {'code': 'RUB', 'name': 'Russian Ruble (RUB)'},
    {'code': 'CUC', 'name': 'Cuban Convertible Peso (CUC)'},
    {'code': 'BGN', 'name': 'Bulgarian Lev (BGN)'},
    {'code': 'JOD', 'name': 'Jordanian Dinar (JOD)'},
    {'code': 'NGN', 'name': 'Nigerian Naira (NGN)'},
    {'code': 'BDT', 'name': 'Bangladeshi Taka (BDT)'},
    {'code': 'PKR', 'name': 'Pakistani Rupee (PKR)'},
    {'code': 'BRL', 'name': 'Brazilian Real (BRL)'},
    {'code': 'KZT', 'name': 'Kazakhstani Tenge (KZT)'},
    {'code': 'CVE', 'name': 'Cape Verdean Escudo (CVE)'},
    {'code': 'HNL', 'name': 'Honduran Lempira (HNL)'},
    {'code': 'NZD', 'name': 'New Zealand Dollar (NZD)'},
    {'code': 'ERN', 'name': 'Eritrean Nakfa (ERN)'},
    {'code': 'NPR', 'name': 'Nepalese Rupee (NPR)'},
    {'code': 'ZMW', 'name': 'Zambian Kwacha (ZMW)'},
    {'code': 'FKP', 'name': 'Falkland Islands Pound (FKP)'},
    {'code': 'DZD', 'name': 'Algerian Dinar (DZD)'},
    {'code': 'JMD', 'name': 'Jamaican Dollar (JMD)'},
    {'code': 'CRC', 'name': 'Costa Rican Colón (CRC)'},
    {'code': 'GMD', 'name': 'Gambian Dalasi (GMD)'},
    {'code': 'PLN', 'name': 'Polish Złoty (PLN)'},
    {'code': 'AMD', 'name': 'Armenian Dram (AMD)'},
    {'code': 'BMD', 'name': 'Bermudian Dollar (BMD)'},
    {'code': 'BZD', 'name': 'Belize Dollar (BZD)'},
    {'code': 'BBD', 'name': 'Barbadian Dollar (BBD)'},
    {'code': 'SBD', 'name': 'Solomon Islands Dollar (SBD)'},
    {'code': 'IDR', 'name': 'Indonesian Rupiah (IDR)'},
    {'code': 'ALL', 'name': 'Albanian Lek (ALL)'},
    {'code': 'IQD', 'name': 'Iraqi Dinar (IQD)'},
    {'code': 'BIF', 'name': 'Burundian Franc (BIF)'},
    {'code': 'HKD', 'name': 'Hong Kong Dollar (HKD)'},
    {'code': 'GIP', 'name': 'Gibraltar Pound (GIP)'},
    {'code': 'BAM', 'name': 'Bosnia-Herzegovina Convertible Mark (BAM)'},
    {'code': 'LKR', 'name': 'Sri Lankan Rupee (LKR)'},
    {'code': 'QAR', 'name': 'Qatari Riyal (QAR)'},
    {'code': 'SAR', 'name': 'Saudi Riyal (SAR)'},
    {'code': 'TOP', 'name': 'Tongan Paʻanga (TOP)'},
    {'code': 'SEK', 'name': 'Swedish Krona (SEK)'},
    {'code': 'ZAR', 'name': 'South African Rand (ZAR)'},
    {'code': 'ARS', 'name': 'Argentine Peso (ARS)'},
    {'code': 'MYR', 'name': 'Malaysian Ringgit (MYR)'},
    {'code': 'BYR', 'name': 'Belarusian Ruble (BYR)'},
    {'code': 'KPW', 'name': 'North Korean Won (KPW)'},
    {'code': 'CZK', 'name': 'Czech Koruna (CZK)'},
    {'code': 'STD', 'name': 'São Tomé and Príncipe Dobra (STD)'},
    {'code': 'BTC', 'name': 'Bitcoin (BTC)'},
    {'code': 'ZWL', 'name': 'Zimbabwean Dollar (ZWL)'},
    {'code': 'LSL', 'name': 'Lesotho Loti (LSL)'},
    {'code': 'COP', 'name': 'Colombian Peso (COP)'},
    {'code': 'PAB', 'name': 'Panamanian Balboa (PAB)'},
    {'code': 'IRR', 'name': 'Iranian Rial (IRR)'},
    {'code': 'CNH', 'name': 'Chinese Yuan (CNH)'},
    {'code': 'NOK', 'name': 'Norwegian Krone (NOK)'},
    {'code': 'XPF', 'name': 'CFP Franc (XPF)'},
    {'code': 'XOF', 'name': 'West African CFA Franc (XOF)'},
    {'code': 'XDR', 'name': 'Special Drawing Rights (XDR)'},
    {'code': 'OMR', 'name': 'Omani Rial (OMR)'},
    {'code': 'CNY', 'name': 'Chinese Yuan (CNY)'},
    {'code': 'NIO', 'name': 'Nicaraguan Córdoba (NIO)'},
    {'code': 'AOA', 'name': 'Angolan Kwanza (AOA)'},
    {'code': 'SCR', 'name': 'Seychellois Rupee (SCR)'},
    {'code': 'MOP', 'name': 'Macanese Pataca (MOP)'},
    {'code': 'ISK', 'name': 'Icelandic Króna (ISK)'},
    {'code': 'VND', 'name': 'Vietnamese Đồng (VND)'},
    {'code': 'VES', 'name': 'Venezuelan Bolívar (VES)'},
    {'code': 'USD', 'name': 'United States Dollar (USD)'},
    {'code': 'UYU', 'name': 'Uruguayan Peso (UYU)'},
    {'code': 'VEF', 'name': 'Venezuelan Bolívar Fuerte (VEF)'},
    {'code': 'MRU', 'name': 'Mauritanian Ouguiya (MRU)'},
    {'code': 'UGX', 'name': 'Ugandan Shilling (UGX)'},
    {'code': 'DOP', 'name': 'Dominican Peso (DOP)'},
    {'code': 'UAH', 'name': 'Ukrainian Hryvnia (UAH)'},
    {'code': 'BOB', 'name': 'Bolivian Boliviano (BOB)'},
    {'code': 'TTD', 'name': 'Trinidad and Tobago Dollar (TTD)'},
    {'code': 'KGS', 'name': 'Kyrgyzstani Som (KGS)'},
    {'code': 'TND', 'name': 'Tunisian Dinar (TND)'},
    {'code': 'SGD', 'name': 'Singapore Dollar (SGD)'},
    {'code': 'TMT', 'name': 'Turkmenistani Manat (TMT)'},
    {'code': 'GHS', 'name': 'Ghanaian Cedi (GHS)'},
    {'code': 'TJS', 'name': 'Tajikistani Somoni (TJS)'},
    {'code': 'KHR', 'name': 'Cambodian Riel (KHR)'},
    {'code': 'ETB', 'name': 'Ethiopian Birr (ETB)'},
    {'code': 'PGK', 'name': 'Papua New Guinean Kina (PGK)'},
    {'code': 'THB', 'name': 'Thai Baht (THB)'},
    {'code': 'AED', 'name': 'United Arab Emirates Dirham (AED)'},
    {'code': 'GTQ', 'name': 'Guatemalan Quetzal (GTQ)'},
    {'code': 'LRD', 'name': 'Liberian Dollar (LRD)'},
    {'code': 'SYP', 'name': 'Syrian Pound (SYP)'},
    {'code': 'KYD', 'name': 'Cayman Islands Dollar (KYD)'},
    {'code': 'SRD', 'name': 'Surinamese Dollar (SRD)'},
    {'code': 'HTG', 'name': 'Haitian Gourde (HTG)'},
    {'code': 'LYD', 'name': 'Libyan Dinar (LYD)'},
    {'code': 'SLL', 'name': 'Sierra Leonean Leone (SLL)'},
    {'code': 'SLE', 'name': 'Sierra Leonean Leone (SLE)'},
    {'code': 'SHP', 'name': 'Saint Helena Pound (SHP)'},
    {'code': 'IMP', 'name': 'Isle of Man Pound (IMP)'},
    {'code': 'FJD', 'name': 'Fijian Dollar (FJD)'},
    {'code': 'PYG', 'name': 'Paraguayan Guaraní (PYG)'},
    {'code': 'KRW', 'name': 'South Korean Won (KRW)'},
    {'code': 'SZL', 'name': 'Eswatini Lilangeni (SZL)'},
    {'code': 'GYD', 'name': 'Guyanese Dollar (GYD)'},
    {'code': 'MDL', 'name': 'Moldovan Leu (MDL)'},
    {'code': 'MXN', 'name': 'Mexican Peso (MXN)'},
    {'code': 'CLP', 'name': 'Chilean Peso (CLP)'},
    {'code': 'LTL', 'name': 'Lithuanian Litas (LTL)'},
    {'code': 'SOS', 'name': 'Somali Shilling (SOS)'},
    {'code': 'MNT', 'name': 'Mongolian Tögrög (MNT)'},
    {'code': 'AFN', 'name': 'Afghan Afghani (AFN)'},
    {'code': 'CUP', 'name': 'Cuban Peso (CUP)'},
    {'code': 'CLF', 'name': 'Chilean Unit of Account (UF) (CLF)'},
    {'code': 'JPY', 'name': 'Japanese Yen (JPY)'},
    {'code': 'TRY', 'name': 'Turkish Lira (TRY)'},
    {'code': 'YER', 'name': 'Yemeni Rial (YER)'},
    {'code': 'HUF', 'name': 'Hungarian Forint (HUF)'},
    {'code': 'BND', 'name': 'Brunei Dollar (BND)'},
    {'code': 'JEP', 'name': 'Jersey Pound (JEP)'},
    {'code': 'MKD', 'name': 'Macedonian Denar (MKD)'},
    {'code': 'AWG', 'name': 'Aruban Florin (AWG)'},
    {'code': 'CDF', 'name': 'Congolese Franc (CDF)'},
    {'code': 'VUV', 'name': 'Vanuatu Vatu (VUV)'},
    {'code': 'XAF', 'name': 'Central African CFA Franc (XAF)'},
    {'code': 'KWD', 'name': 'Kuwaiti Dinar (KWD)'},
    {'code': 'DKK', 'name': 'Danish Krone (DKK)'},
  ];

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _result = 'Amount?';
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
          'https://currency-conversion-and-exchange-rates.p.rapidapi.com/convert?from=$_fromCurrency&to=$_toCurrency&amount=$_amount'),
      headers: {
        'X-Rapidapi-Key': '10c9117011msh3c078190ac01525p17ad91jsn085ab6bd036a',
        'X-Rapidapi-Host':
            'currency-conversion-and-exchange-rates.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        _result =
            double.parse(jsonResponse['result'].toString()).toStringAsFixed(2);
      });
    } else {
      setState(() {
        _result = 'Failed to convert';
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _fromCurrencySearchController.dispose();
    _toCurrencySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                    controller: _amountController,
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
                      setState(() {
                        _amount = double.tryParse(value) ?? 0;
                        _convertCurrency();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 50,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField2<String>(
                    value: _fromCurrency,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency['code'],
                        child:
                            Text('${currency['code']} - ${currency['name']}'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _convertCurrency();
                        _fromCurrency = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "From",
                      labelStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(127, 61, 255, 1)),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      iconSize: 36,
                      iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return _currencies.map<Widget>((currency) {
                        return Text(
                          currency['code']!,
                          style: TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: double.infinity,
                      isFullScreen: true,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: _fromCurrencySearchController,
                      searchInnerWidget: Container(
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 8,
                            left: 8,
                            bottom: 4,
                          ),
                          child: TextFormField(
                            controller: _fromCurrencySearchController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      searchInnerWidgetHeight: 60,
                      searchMatchFn: (item, searchValue) {
                        return (item.value as String)
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Converted',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 30),
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    maxLines: 1,
                    controller: TextEditingController(text: _result),
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 50,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField2<String>(
                    value: _toCurrency,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency['code'],
                        child:
                            Text('${currency['code']} - ${currency['name']}'),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _convertCurrency();
                        _toCurrency = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "To",
                      labelStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(127, 61, 255, 1)),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      iconSize: 36,
                      iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return _currencies.map<Widget>((currency) {
                        return Text(
                          currency['code']!,
                          style: TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: double.infinity,
                      isFullScreen: true,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: _toCurrencySearchController,
                      searchInnerWidget: Container(
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 8,
                            left: 8,
                            bottom: 4,
                          ),
                          child: TextFormField(
                            controller: _toCurrencySearchController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      searchInnerWidgetHeight: 60,
                      searchMatchFn: (item, searchValue) {
                        return (item.value as String)
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
