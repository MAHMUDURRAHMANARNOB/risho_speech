import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/AboutScreen.dart';

import '../../providers/auth_provider.dart';
import '../../providers/subscriptionStatus_provider.dart';
import '../../ui/colors.dart';
import '../DeleteAccount.dart';
import '../LoginScreen.dart';
import '../packages_screen.dart';

class ProfileScreenMobile extends StatefulWidget {
  const ProfileScreenMobile({super.key});

  @override
  State<ProfileScreenMobile> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<ProfileScreenMobile> {
  final SubscriptionStatusProvider subscriptionStatusProvider =
      SubscriptionStatusProvider();
  late int userId = Provider.of<AuthProvider>(context).user!.id;
  late String userName;

  Future<void> _refresh() async {
    // userId = Provider.of<AuthProvider>(context).user!.id;
    // userName = Provider.of<AuthProvider>(context).user!.name;
    // final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    await subscriptionStatusProvider.fetchSubscriptionData(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    userId = Provider.of<AuthProvider>(context).user!.id;
    userName = Provider.of<AuthProvider>(context).user!.username;
    subscriptionStatusProvider.fetchSubscriptionData(userId!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionStatusProvider>().fetchSubscriptionData(userId);
    });

    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),*/
        body: RefreshIndicator(
          onRefresh: _refresh,
          // showChildOpacityTransition: false,
          // springAnimationDurationInMilliseconds: 1000,
          color: AppColors.secondaryCardColor,
          backgroundColor: AppColors.primaryColor,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(
                            image: AssetImage("assets/images/team.png"),
                          ),
                        ),
                      ),
                      /*Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.primaryColor),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    // "username",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Student"),
                  const SizedBox(height: 10),
                  /*PERSONAL INFORMATION*/
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryCardColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        /*FullName*/
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("Full Name: "),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "${Provider.of<AuthProvider>(context).user?.name ?? 'John Doe'}",
                                  // "John doe",
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Email*/
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mail_rounded,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("Email: "),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "${Provider.of<AuthProvider>(context).user?.email ?? 'johndoe@gmail.com'}",
                                  // "johndoe@gmail.com",
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Phone*/
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("Phone: "),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "${Provider.of<AuthProvider>(context).user?.mobile ?? '+8801**********'}",
                                  // "+8801**********",
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  /*TOKENS*/
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*Homework Token*/
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryCardColor,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/golf_flag.png",
                                  width: 50,
                                  height: 55,
                                ),
                                const Text(
                                  "Homework Token",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Used",
                                        style: TextStyle(),
                                      ),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return const SpinKitPulse(
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text(
                                                          'No subscription data available.'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${subscriptionProvider.subscriptionStatus!.ticketUsed}',
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "***",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Remaining",
                                        style: TextStyle(),
                                      ),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return const SpinKitPulse(
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .ticketsAvailable
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : const Text(
                                              "**",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        /*Question Token*/
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryCardColor,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/diamond.png",
                                  width: 45,
                                  height: 55,
                                ),
                                Text(
                                  "Question Token",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Used",
                                        style: TextStyle(),
                                      ),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return const SpinKitPulse(
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .commentUsed
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "***",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Remaining",
                                          style: TextStyle(),
                                        ),
                                        userId != null
                                            ? Consumer<
                                                SubscriptionStatusProvider>(
                                                builder: (context,
                                                    subscriptionProvider,
                                                    child) {
                                                  if (subscriptionProvider
                                                      .isFetching) {
                                                    return const SpinKitPulse(
                                                        color: AppColors
                                                            .primaryColor,
                                                        size: 14);
                                                  }

                                                  if (subscriptionProvider
                                                          .subscriptionStatus ==
                                                      null) {
                                                    return Center(
                                                        child: Text('--'));
                                                  }

                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          subscriptionProvider
                                                              .subscriptionStatus!
                                                              .commentsAvailable
                                                              .toString(),
                                                        ),
                                                        // Add more details as needed
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : Text(
                                                "**",
                                                style: TextStyle(),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*Audio Token*/
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primaryCardColor,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/audio_minute.png",
                                  width: 50,
                                  height: 55,
                                ),
                                Text(
                                  "Audio Minutes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Used",
                                        style: TextStyle(),
                                      ),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return const SpinKitPulse(
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .audioMinutesUsed
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "***",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Remaining",
                                        style: TextStyle(),
                                      ),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return const SpinKitPulse(
                                                      color: AppColors
                                                          .primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .audioReamins
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "**",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  /*SUBSCRIPTION*/
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCardColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Text("Subscription Details"),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Active Package: "),
                                userId != null
                                    ? Consumer<SubscriptionStatusProvider>(
                                        builder: (context, subscriptionProvider,
                                            child) {
                                          if (subscriptionProvider.isFetching) {
                                            return const SpinKitPulse(
                                                color: AppColors.primaryColor,
                                                size: 14);
                                          }

                                          if (subscriptionProvider
                                                  .subscriptionStatus ==
                                              null) {
                                            return Center(child: Text('--'));
                                          }

                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  subscriptionProvider
                                                      .subscriptionStatus!
                                                      .packageName
                                                      .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                // Add more details as needed
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Text(
                                        "Invalid User",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 20,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              /*Purchased*/
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Purchased Date"),
                                    userId != null
                                        ? Consumer<SubscriptionStatusProvider>(
                                            builder: (context,
                                                subscriptionProvider, child) {
                                              if (subscriptionProvider
                                                  .isFetching) {
                                                return const SpinKitPulse(
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 14);
                                              }

                                              if (subscriptionProvider
                                                      .subscriptionStatus ==
                                                  null) {
                                                return Center(
                                                    child: Text('--'));
                                              }

                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      subscriptionProvider
                                                          .subscriptionStatus!
                                                          .datePurchased
                                                          .toString(),
                                                    ),
                                                    // Add more details as needed
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : Text(
                                            "***",
                                            style: TextStyle(),
                                          ),
                                  ],
                                ),
                              ),
                              /*Validity*/
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Validity Till"),
                                    userId != null
                                        ? Consumer<SubscriptionStatusProvider>(
                                            builder: (context,
                                                subscriptionProvider, child) {
                                              if (subscriptionProvider
                                                  .isFetching) {
                                                return const SpinKitPulse(
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 14);
                                              }

                                              if (subscriptionProvider
                                                      .subscriptionStatus ==
                                                  null) {
                                                return Center(
                                                    child: Text('--'));
                                              }

                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      subscriptionProvider
                                                          .subscriptionStatus!
                                                          .validityDate
                                                          .toString(),
                                                    ),
                                                    // Add more details as needed
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : Text(
                                            "***",
                                            style: TextStyle(),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  /*Purchase Subscription package*/
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PackagesScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCardColor,
                      padding: EdgeInsets.all(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subscription Plans",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  /*HISTORY*/
                  /*ElevatedButton(
                    onPressed: () {
                      */ /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryScreen()),
                      );*/ /*
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCardColor,
                      padding: EdgeInsets.all(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),*/

                  /*About*/
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCardColor,
                      padding: EdgeInsets.all(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.info,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  //Delete Account
                  ElevatedButton(
                    onPressed: () {
                      // Call the logout method from AuthProvider

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Account"),
                            content: Text("Are you sure you want to Proceed?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primaryColor.withOpacity(0.1),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.secondaryColor.withOpacity(0.1),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DeleteAccount()),
                                  );
                                },
                                child: Text("Proceed",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor)),
                              ),
                            ],
                          );
                        },
                      );
                      // Navigate back to the login screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCardColor,
                      padding: EdgeInsets.all(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.delete_rounded,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  /*Logout*/
                  ElevatedButton(
                    onPressed: () {
                      // Call the logout method from AuthProvider

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Logout"),
                            content: Text("Are you sure you want to logout?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primaryColor.withOpacity(0.1),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.secondaryColor.withOpacity(0.1),
                                ),
                                onPressed: () {
                                  // Perform logout action here
                                  // For example: navigate to login screen
                                  Navigator.of(context).pop();
                                  authProvider.logout();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (route) =>
                                        false, // This removes all routes in the stack
                                  );
                                },
                                child: Text("Logout",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor)),
                              ),
                            ],
                          );
                        },
                      );
                      // Navigate back to the login screen
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );*/
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCardColor,
                      padding: EdgeInsets.all(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.logout,
                          size: 30,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
