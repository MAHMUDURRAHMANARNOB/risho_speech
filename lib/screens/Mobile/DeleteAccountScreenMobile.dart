import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:risho_speech/ui/colors.dart';

class DeleteAccountScreenMobile extends StatefulWidget {
  const DeleteAccountScreenMobile({super.key});

  @override
  State<DeleteAccountScreenMobile> createState() =>
      _DeleteAccountScreenMobileState();
}

class _DeleteAccountScreenMobileState extends State<DeleteAccountScreenMobile> {
  String selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                  "If you need to delete an account, please provide a reason."),
              // Pass the callback to update the selected option
              CheckboxListPage(
                onOptionSelected: (String option) {
                  setState(() {
                    selectedOption = option;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
                onPressed: () {
                  // Print the selected option when the button is pressed
                  print(selectedOption);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Icon(
                              IconsaxPlusBold.info_circle,
                              size: 50,
                              color: AppColors.secondaryColor,
                            ),
                            const Text(
                              "Are you Sure?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              "Your account will be deleted permanently",
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500]),
                              "Ensuring that the user understands the consequences of deleting their account / loss of data, subscriptions, etc.",
                            ),
                          ],
                        ),
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
                              "Keep Account",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.secondaryColor.withOpacity(0.1),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const DeleteAccount()),
                              );*/
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: AppColors.secondaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckboxListPage extends StatefulWidget {
  final Function(String) onOptionSelected;

  const CheckboxListPage({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  _CheckboxListPageState createState() => _CheckboxListPageState();
}

class _CheckboxListPageState extends State<CheckboxListPage> {
  final List<String> options = [
    "No longer using the platform",
    "Found a better alternative",
    "Privacy concerns",
    "Difficulty navigating the platform",
    "Account security concerns",
    "Personal reasons",
    "Others"
  ];

  String selectedOption = "";
  bool isOthersSelected = false;
  TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondaryCardColorGreenish.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    options[index],
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  value: (options[index] == "Others" && isOthersSelected) ||
                      selectedOption == options[index],
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (options[index] == "Others") {
                          isOthersSelected = true;
                          selectedOption = "Others";
                        } else {
                          selectedOption = options[index];
                          isOthersSelected = false;
                          _otherReasonController
                              .clear(); // Clear when not "Others"
                        }
                        // Pass the selected option back to the parent
                        widget.onOptionSelected(selectedOption);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryColor,
                  checkColor: Colors.black,
                );
              },
            ),
            if (isOthersSelected)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _otherReasonController,
                  decoration: InputDecoration(
                    hintText: 'Please specify your reason to leave us.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = "Others: $value";
                      // Update the selected option when the text changes
                      widget.onOptionSelected(selectedOption);
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
