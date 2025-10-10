import 'package:crustascan_app/controllers/auth_controller.dart';
import 'package:crustascan_app/data/_list.dart';
import 'package:crustascan_app/providers/register_user_image_provider.dart';
import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:crustascan_app/views/pages/auth/login_page.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_bottom_nav.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_button.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_image_modal_bottom_sheet.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_password_form_field.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_text_form_field.dart';
import 'package:crustascan_app/views/pages/settings/data_policy_page.dart';
import 'package:crustascan_app/views/pages/settings/terms_and_condition_page.dart';
import 'package:crustascan_app/views/widgets/global-appbar.dart';
import 'package:crustascan_app/views/widgets/global-logo-header-container.dart';
import 'package:crustascan_app/views/widgets/global_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final RegisterController _registerController = RegisterController();

  bool _agreedToTermsAndPolicy = false;

  DateTime? _selectedDate;
  String? _gender = 'Male'; // default to Male
  String? _selectedLocation;
  final List<String> _locations = locationList;
  String? _selectedRole;
  final List<String> _roles = roleList;

  @override
  void dispose() {
    _registerController.dispose();
    super.dispose();
  }

  bool checkPasswordValid() {
    String password = _registerController.passwordController.text;
    return password.length >= 8 &&
        checkIfHasUppercase(password) &&
        checkIfHasNumber(password);
  }

  bool checkIfHasUppercase(String text) {
    bool valid = text.contains(RegExp(r'[A-Z]'));
    debugPrint('======== Uppercase: $valid =======');
    return valid;
  }

  bool checkIfHasNumber(String text) {
    bool valid = text.contains(RegExp(r'[0-9]'));
    debugPrint('======== Number: $valid =======');
    return valid;
  }

  Future<DateTime?> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onPressedRegisterButton() async {
    // First check internet connection
    if (!await checkInternetOrShowDialog(
      context,
      title: "No Internet Connection",
      description: "Account registration requires an internet connection.",
    )) {
      return;
    }

    _registerController.selectedBirthday = _selectedDate;
    _registerController.selectedGender = _gender;
    _registerController.selectedLocation = _selectedLocation;
    _registerController.selectedRole = _selectedRole;

    final isFormValid = _formKey.currentState!.validate();
    _registerController.agreedToTerms = _agreedToTermsAndPolicy;
    final isCheckboxValid = _registerController.validateRegister(context);
    bool isSuccessful = false;

    // Update UI to display any error messages.
    setState(() {});

    if (isFormValid && isCheckboxValid) {
      isSuccessful = await _registerController.submitRegistration(
        context,
      ); // Send to firebase
    }
    if (isFormValid && isCheckboxValid && isSuccessful) {
      // KOBE: Now checks if sent to firebase without errors

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Created account successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 54, 143, 57),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalLoadingPage(
            navigateNextPage: LoginPage(),
            duration: Duration(seconds: 1),
          ),
        ),
      );

      // Reset register user image provider
      Provider.of<RegisterUserImageProvider>(
        context,
        listen: false,
      ).resetImagePath();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid registration details. Try again!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(text: "Register", navigatePage: LoginPage()),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GlobalLogoHeaderContainer(
                            text: "Welcome to CrustaScan!",
                            description: "Sign up to get started",
                          ),

                          const SizedBox(height: 40),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "PERSONAL INFORMATION",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          // CustomImageModalBottomSheet(),

                          // SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // First name input
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: _registerController
                                            .firstNameController,
                                        textInput: "FIRST NAME:",
                                        // iconInput: Icons.person,
                                        hintTextInput: "First Name",
                                        isValidationIcon: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'First Name is required!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // Last name input
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: _registerController
                                            .lastNameController,
                                        textInput: "LAST NAME:",
                                        // iconInput: Icons.person,
                                        hintTextInput: "Last Name",
                                        isValidationIcon: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Last Name is required!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Birthday input
                                const SizedBox(height: 20),
                                FormField<DateTime>(
                                  validator: (value) {
                                    if (_selectedDate == null) {
                                      return 'Please select your birthday.';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<DateTime> field) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            DateTime? picked =
                                                await _pickDate();
                                            if (picked != null) {
                                              setState(() {
                                                _selectedDate = picked;
                                              });
                                              field.didChange(
                                                picked,
                                              ); // tell FormField it changed
                                            }
                                          },
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                              labelText: 'BIRTHDAY:',
                                              labelStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 14,
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                255,
                                                247,
                                                247,
                                                247,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                    255,
                                                    70,
                                                    70,
                                                    70,
                                                  ),
                                                  width: 1.0,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                  width: 1,
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                      width: 1,
                                                    ),
                                                  ),
                                              errorText: field.errorText,
                                            ),
                                            child: Text(
                                              _selectedDate != null
                                                  ? DateFormat(
                                                      'MMMM d, y',
                                                    ).format(_selectedDate!)
                                                  : 'Select your birthday ...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _selectedDate != null
                                                    ? Colors.black
                                                    : Colors.grey.shade500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                // Gender radio input
                                const SizedBox(height: 12),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "GENDER:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Male',
                                      groupValue: _gender,
                                      onChanged: (value) =>
                                          setState(() => _gender = value),
                                    ),
                                    const Text('Male'),
                                    Radio<String>(
                                      value: 'Female',
                                      groupValue: _gender,
                                      onChanged: (value) =>
                                          setState(() => _gender = value),
                                    ),
                                    const Text('Female'),
                                    Radio<String>(
                                      value: 'Others',
                                      groupValue: _gender,
                                      onChanged: (value) =>
                                          setState(() => _gender = value),
                                    ),
                                    const Text('Others'),
                                  ],
                                ),

                                // Location input
                                const SizedBox(height: 8),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "LOCATION:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownSearch<String>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              labelText:
                                                  "Select your country ...",
                                              labelStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 14,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                    left: 20,
                                                    right: 5,
                                                  ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                255,
                                                247,
                                                247,
                                                247,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                    255,
                                                    70,
                                                    70,
                                                    70,
                                                  ),
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                      ),
                                  items: _locations,
                                  selectedItem: _selectedLocation,
                                  onChanged: (value) =>
                                      setState(() => _selectedLocation = value),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Please select your location.'
                                      : null,
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                ),

                                // Role input
                                const SizedBox(height: 8),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "ROLE:",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'I am here as ...',
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      left: 20,
                                      right: 10,
                                    ),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                      255,
                                      247,
                                      247,
                                      247,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 70, 70, 70),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  value: _selectedRole,
                                  items: _roles
                                      .map(
                                        (role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(
                                            role,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => _selectedRole = value),
                                  validator: (value) => value == null
                                      ? 'Please select your role.'
                                      : null,
                                ),
                                const SizedBox(height: 40),

                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ACCOUNT INFORMATION",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Email input
                                const SizedBox(height: 30),
                                CustomTextFormField(
                                  controller:
                                      _registerController.emailController,
                                  textInput: "EMAIL:",
                                  // iconInput: Icons.email,
                                  hintTextInput: "Email",
                                  isValidationIcon: true,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Email is required!'
                                      : null,
                                ),

                                // Username input
                                const SizedBox(height: 8),
                                CustomTextFormField(
                                  controller:
                                      _registerController.usernameController,
                                  textInput: "USERNAME:",
                                  // iconInput: Icons.person,
                                  hintTextInput: "Username",
                                  isValidationIcon: true,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Username is required!'
                                      : null,
                                ),

                                // Password input
                                const SizedBox(height: 8),
                                CustomPasswordFormField(
                                  controller:
                                      _registerController.passwordController,
                                  text: "PASSWORD:",
                                  hintText: "Password",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required!';
                                    }

                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long!';
                                    }

                                    if (!checkIfHasUppercase(value)) {
                                      return 'Password must contain at least 1 uppercase letter!';
                                    }

                                    if (!checkIfHasNumber(value)) {
                                      return 'Password must contain at least 1 number!';
                                    }

                                    return null; // valid
                                  },
                                ),

                                // Confirm password input
                                const SizedBox(height: 8),
                                CustomPasswordFormField(
                                  controller: _registerController
                                      .confirmPasswordController,
                                  text: "CONFIRM PASSWORD:",
                                  // icon: Icons.lock,
                                  hintText: "Confirm Password",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required!';
                                    }

                                    // if (!checkConfirmPasswordValid()) {
                                    //   return 'Password does not match!';
                                    // }

                                    if (value !=
                                        _registerController
                                            .passwordController
                                            .text) {
                                      return 'Passwords do not match!';
                                    }

                                    return null; // valid
                                  },
                                ),

                                // Password requirements
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Password must be at least:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          left: 20,
                                        ),
                                        child: Text(
                                          "• 8 characters long",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          left: 20,
                                        ),
                                        child: Text(
                                          "• 1 uppercase letter",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          left: 20,
                                        ),
                                        child: Text(
                                          "• 1 number",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkbox
                                const SizedBox(height: 30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: _agreedToTermsAndPolicy,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreedToTermsAndPolicy =
                                              value ?? false;
                                          if (_agreedToTermsAndPolicy) {
                                            _registerController.termsError =
                                                null;
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'I agree to the ',
                                            ),
                                            TextSpan(
                                              text: 'Terms and Conditions',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const TermsAndConditionPage(
                                                            popOnly: true,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            ),
                                            const TextSpan(text: ' and '),
                                            TextSpan(
                                              text: 'Privacy Policy',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const DataPolicyPage(
                                                            popOnly: true,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            ),
                                            const TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Show error message
                                if (_registerController.termsError != null)
                                  Text(
                                    _registerController.termsError!,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      fontSize: 12,
                                    ),
                                  ),

                                // Create button
                                const SizedBox(height: 30),
                                CustomButton(
                                  onPressed: _onPressedRegisterButton,
                                  textButton: "CREATE",
                                ),
                                const SizedBox(height: 130),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer Section
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(height: 30, color: Colors.white),
                      Container(
                        color: Colors.white,
                        // padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: CustomBottomNav(
                              navigatePage: LoginPage(),
                              textMessage: "Already have an account? ",
                              textAuth: "Login!",
                            ),
                          ),
                        ),
                      ),
                      Container(height: 70, color: Colors.white),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
