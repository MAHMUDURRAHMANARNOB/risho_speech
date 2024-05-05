import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/packagesProvider.dart';
import '../../ui/colors.dart';

class PackagesScreenTablet extends StatefulWidget {
  const PackagesScreenTablet({super.key});

  @override
  State<PackagesScreenTablet> createState() => _PackagesScreenTabletState();
}

class _PackagesScreenTabletState extends State<PackagesScreenTablet> {
  late int userid;
  bool isExpanded = false;
  Widget packagesCard(
    String name,
    String imagePath,
    String duration,
    int id,
    int noOfCourse,
    int noOfTickets,
    int noOfComments,
    String subDesc,
    double discountedPrice,
    double price,
    double discountinPer, {
    required VoidCallback onPackageSelected,
  }) {
    late String durationType;
    if (duration == "H") {
      durationType = " 6 months";
    } else if (duration == "Y") {
      durationType = " 12 months";
    } else if (duration == "M") {
      durationType = " 30 Days";
    } else if (duration == "U") {
      durationType = " Unlimited";
    }
    double finalPrice = price - discountedPrice;

    return Container(
      margin: EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.primaryCardColor,
      ),
      child: Column(
        children: [
          /*imagePath != null
              ? Image.network(imagePath)
              : Image.asset("assets/images/risho_guru_icon.png"),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/risho_guru_icon.png",
              height: 50,
              width: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColors.greyCard.withOpacity(0.1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                      child: Text(
                        subDesc,
                        maxLines: isExpanded ? null : 3,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Visibility(
                      visible: !isExpanded,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        icon: Icon(
                          Icons.expand_more_outlined,
                          size: 20.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Homework Tokens",
                  style: TextStyle(),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    noOfTickets.toString(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Question Tokens",
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    noOfComments.toString(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        "৳ ${price.toString()}",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        "৳ ${finalPrice.toString()}",
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  " / $durationType",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                ),
              ),
              onPressed: () {
                print("pressed id: $id");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceScreenMobile(
                        packageID: id,
                        packageName: name,
                        packageValue: price,
                        discountValue: discountedPrice,
                        payableAmount: finalPrice),
                  ),
                );*/
              },
              child: Text(
                "Purchase Now",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    userid = authProvider.user?.id ?? 0;
    final packagesProvider = PackagesProvider(userId: userid);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left),
          ),*/
          title: Text(
            'Packages',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                /*Packages List*/
                Container(
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    return FutureBuilder(
                      future: packagesProvider.fetchPackages(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitThreeInOut(
                            color: AppColors.primaryColor,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          print("Success ${packagesProvider.packages.length}");
                          // Display your list of tools
                          return SingleChildScrollView(
                            child: Column(
                              children:
                                  packagesProvider.packages.map((packages) {
                                /*bool isSelected =
                                  tool.toolsCode == widget.staticToolsCode;*/
                                print(packages.price);
                                return Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: packagesCard(
                                    packages.name!,
                                    packages.imagePath ?? "",
                                    packages.duration!,
                                    packages.id!,
                                    packages.noOfCourse ?? 0,
                                    packages.noOfTickets!,
                                    packages.noOfComments!,
                                    packages.subDesc!,
                                    packages.discountedPrice!,
                                    packages.price!,
                                    packages.discountinPer ?? 0.0,
                                    /*isSelected: isSelected,*/
                                    onPackageSelected: () {
                                      // Call the API when a tool is selected
                                      /*toolsDataProvider.fetchToolsData(
                                        userID,
                                        tool.toolID,
                                      );*/
                                      print(packages.id);
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            const snackBar = SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Homework Token is used for using tools. 1 token required for 1 response",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Question token is used for using Ask Question button. 1 token required for 1 Question",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: AppColors.primaryCardColor,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Icon(
            Icons.question_mark,
            color: AppColors.primaryColor,
          ),
          backgroundColor: AppColors.primaryCardColor,
        ),
      ),
    );
  }
}
