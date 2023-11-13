import 'dart:ui';
import 'package:intl/intl.dart'; //Import intl in the file this is being done
import 'package:flutter/material.dart';
import 'package:ecommerce/components/coustom_bottom_nav_bar.dart';
import 'package:ecommerce/enums.dart';
import '../../main.dart';
import '../../models/productModel.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import '../../service/links.dart';
import 'package:intl/intl.dart';

class CarsScreen extends StatefulWidget {
  final String idCategory;
  final String nameCategory;
  const CarsScreen(
      {Key? key, required this.idCategory, required this.nameCategory})
      : super(key: key);
  @override
  State<CarsScreen> createState() => _CarsScreenState(idCategory, nameCategory);
}

class _CarsScreenState extends State<CarsScreen> {
  _CarsScreenState(this.idCategory, this.nameCategory);
  String idCategory;
  String nameCategory;
  @override
  void initState() {
    super.initState();
    print(idCategory);
    _Datas = getAll();
  }

  Future<void> _selectDate(BuildContext context, DateTime dateDeb) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateDeb,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dateDeb) {
      print(pickedDate);
      setState(() {
        dateDeb = pickedDate;
      });
    }
  }

  Future addReservation(prix, productID) async {
    try {
      /*  print(dateDeb.difference(dateFin).inDays);
      final Duration duration = dateFin.difference(dateDeb);*/
      String Url = "$postReservation";
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "datedebut": DateFormat('yyyy-MM-dd – kk:mm').format(dateDeb),
                "datefin": DateFormat('yyyy-MM-dd – kk:mm').format(dateFin),
                "agent": sharedPref?.getString("id"),
                "product": productID,
                "prix": prix * 2
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "rented !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
          setState(() {
            _Datas = getAll();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "error !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  List<ProductModel> mesData = [];

  late Future<List<ProductModel>> _Datas;
  Future<void> _showAlertDialog(String idElem, double width, prix) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Formulaire de reservation'),
          content: SingleChildScrollView(
            child: Container(
              width: width * 0.8,
              child: Column(
                children: [
                  Text(
                    "Prix par jour : 40Dt",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Color(0xFF5E40B8)),
                  ),
                  SizedBox(height: 20),
                  Text("Date de début :"),
                  SizedBox(height: 5),
                  RaisedButton(
                    onPressed: () => _selectDate(context, dateDeb),
                    child: Text('Choisir date'),
                  ),
                  SizedBox(height: 20),
                  Text("Date de fin :"),
                  SizedBox(height: 5),
                  RaisedButton(
                    onPressed: () => _selectDate(context, dateFin),
                    child: Text('Choisir date'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Réserver'),
              onPressed: () {
                addReservation(prix, idElem);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<ProductModel>> getAll() async {
    String Url = "$linkProductByCategory${idCategory}";
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return mesData = parsed
          .map<ProductModel>((json) => ProductModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  DateTime dateDeb = DateTime.now();
  DateTime dateFin = DateTime.now();

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCategory),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<ProductModel>>(
                future: _Datas,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.8,
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Center(
                                  /** Card Widget **/
                                  child: Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth * 1,
                                      height: 390,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                              child: Image(
                                                image: NetworkImage(snapshot
                                                    .data![index].productImage),
                                              ),
                                            ),
                                            //CircleAvatar
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Text(
                                              snapshot.data![index].productName,
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Color(0xFF5E40B8),
                                                fontWeight: FontWeight.w500,
                                              ), //Textstyle
                                            ), //Text
                                            const SizedBox(
                                              height: 20,
                                            ), //SizedBox
                                            Text(
                                              snapshot.data![index]
                                                  .productDescription,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ), //Textstyle
                                            ), //Text
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Container(
                                              width: SizeConfig.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 130,

                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          _showAlertDialog(
                                                              snapshot
                                                                  .data![index]
                                                                  .id,
                                                              width,
                                                              snapshot
                                                                  .data![index]
                                                                  .unitPrice),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .touch_app),
                                                            Text('Reserve')
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // RaisedButton is deprecated and should not be used
                                                    // Use ElevatedButton instead

                                                    // child: RaisedButton(
                                                    //   onPressed: () => null,
                                                    //   color: Colors.green,
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.all(4.0),
                                                    //     child: Row(
                                                    //       children: const [
                                                    //         Icon(Icons.touch_app),
                                                    //         Text('Visit'),
                                                    //       ],
                                                    //     ), //Row
                                                    //   ), //Padding
                                                    // ), //RaisedButton
                                                  ),
                                                  IconButton(
                                                    icon: SvgPicture.asset(
                                                        "assets/icons/Heart Icon.svg"),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ) //SizedBox
                                          ],
                                        ), //Column
                                      ), //Padding
                                    ), //SizedBox
                                  ), //Card
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Verifer votre connexion");
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
