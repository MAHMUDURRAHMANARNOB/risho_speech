// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/HomeScreen.dart';
import '../screens/LearnScreen.dart';
import '../screens/ProfileScreen.dart';
import '../ui/colors.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  int _selectedMobileIndex = 0;

  bool extended = false;

  changeIndex(int index) {
    _selectedIndex = index;
    setState(() {
      extended = !extended;
    });
  }

  /*final destinations = <AdaptiveScaffoldDestination>[
    AdaptiveScaffoldDestination(
      title: 'Dashboard',
      icon: CustomIcon(
        imagePath:
            'assets/images/risho_guru_icon.png', // Replace with your actual logo asset path
      ).iconData,
    ),
    AdaptiveScaffoldDestination(
        title: 'Courses', icon: Icons.cast_for_education_outlined),
    AdaptiveScaffoldDestination(title: 'StudyBoard', icon: Icons.book_outlined),
    AdaptiveScaffoldDestination(title: 'Tools', icon: Icons.handyman),
    AdaptiveScaffoldDestination(
        title: 'Packages', icon: Icons.inventory_2_outlined),
  ];*/
  final List<CustomDestination> destinations = [
    CustomDestination(
        title: 'Dashboard', imagePath: 'assets/images/risho_guru_icon.png'),
    /*CustomDestination(
        title: 'Courses', imagePath: 'assets/images/risho_guru_icon.png'),*/
    CustomDestination(
        title: 'StudyBoard', imagePath: 'assets/images/risho_guru_icon.png'),
  ];

  final destinationsMobile = <NavigationDestination>[
    const NavigationDestination(
      icon: Icon(
        Icons.home_outlined,
        color: AppColors.primaryColor,
      ),
      label: 'Home',
      selectedIcon: Icon(
        Icons.home_rounded,
        color: AppColors.primaryColor,
      ),
    ),
    /*const NavigationDestination(
      icon: Icon(
        Icons.menu_book_rounded,
        color: AppColors.primaryColor,
      ),
      label: 'Learn',
      selectedIcon: Icon(
        FontAwesomeIcons.bookOpen,
        color: AppColors.primaryColor,
      ),
    ),*/
    const NavigationDestination(
      icon: Icon(
        Icons.person_outline_rounded,
        color: AppColors.primaryColor,
      ),
      label: 'Profile',
      selectedIcon: Icon(
        Icons.person,
        color: AppColors.primaryColor,
      ),
    ),
  ];

  bool showLabels() {
    // You can adjust the threshold value based on your design requirements.
    return MediaQuery.of(context).size.width >
        600; // Example threshold: 600 pixels
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth > 600) {
          // Desktop layout with NavigationRail
          return buildDesktopLayout();
        } else {
          // Mobile layout with BottomNavigationBar
          return buildMobileLayout();
        }
      },
    );
  }

  Widget buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            groupAlignment: -1,
            extended: extended,
            selectedIndex: _selectedIndex,
            labelType: showLabels()
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.none,
            destinations: destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final destination = entry.value;
              return NavigationRailDestination(
                  icon: GestureDetector(
                    onTap: () {
                      _navigateToScreen(index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedIndex == index
                            ? Colors.white
                            : AppColors
                                .backgroundColorDark, // Customize the background color
                      ),
                      child: Image.asset(
                        destination.imagePath,
                        width: 30,
                        height: 40,
                      ),
                    ),
                  ),
                  label: /*showLabels()
                      ? */
                      Text(
                    destination.title,
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? AppColors.secondaryColor // Active label color
                          : Colors.white, // Inactive label color
                    ),
                  ));
            }).toList(),
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Add your content here
          Expanded(
            child: Center(
              child: Container(
                child: _getSelectedScreen(_selectedIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileLayout() {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _onWillPop();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            child: _getSelectedMobileScreen(_selectedMobileIndex),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 60,
          backgroundColor: AppColors.backgroundColorDark,
          destinations: destinationsMobile,
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedMobileIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedMobileIndex == 0) {
      // Show confirmation dialog if user is on the first item
      final shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel exit
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              }, // Confirm exit
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      return shouldExit ?? false; // Handle null case (e.g., dialog dismissed)
    } else {
      // Navigate to the first item if not on the first item
      setState(() {
        _selectedMobileIndex = 0;
      });
      return false; // Prevent further navigation handling by Flutter
    }
  }

  void _onItemTapped(int index) {
    /*setState(() {
      _selectedMobileIndex = index;
    });*/
    /*if (_selectedMobileIndex == index) {
      // If the user taps on the currently selected item
      if (index == 0) {
        // If the user is on the first item, show exit confirmation dialog
        _showExitConfirmationDialog();
      }
    } else {
      // If the user taps on a different item, navigate to that item
      setState(() {
        _selectedMobileIndex = index;
      });
    }*/
    if (index == 0 && _selectedMobileIndex != 0) {
      // If tapping "Home" from another item, set visual indicator
      _selectedMobileIndex = 0;
    }
    setState(() {
      _selectedMobileIndex = index;
    });
  }

  Widget _getSelectedScreen(int selectedIndex) {
    Widget screen;
    switch (selectedIndex) {
      case 0:
        return HomeScreen();
        break;
      /*case 1:
        return LearnScreen();
        break;*/
      case 1:
        return ProfileScreen();
        break;

      default:
        return Text('Select a screen');
    }
  }

  Widget _getSelectedMobileScreen(int selectedIndex) {
    Widget screen;
    switch (selectedIndex) {
      case 0:
        return HomeScreen();
        break;
      /*case 1:
        return LearnScreen();
        break;*/
      case 1:
        return ProfileScreen();
        break;
      default:
        return Text('Select a screen');
    }
  }

  void _navigateToScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Confirmation'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform exit action here, like SystemNavigator.pop();
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class CustomDestination {
  final String title;
  final String imagePath;

  CustomDestination({required this.title, required this.imagePath});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CustomDestination &&
        other.title == title &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode => title.hashCode ^ imagePath.hashCode;
}
