import 'package:crustascan_app/controllers/auth_controller.dart';
import 'package:crustascan_app/providers/auth_provider.dart';
import 'package:crustascan_app/providers/guest_provider.dart';
import 'package:crustascan_app/utils/helpers/connectivity_helper.dart';
import 'package:crustascan_app/views/pages/auth/register_page.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_bottom_nav.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_button.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_password_form_field.dart';
import 'package:crustascan_app/views/pages/auth/widgets/custom_text_form_field.dart';
import 'package:crustascan_app/views/pages/home/home_page.dart';
import 'package:crustascan_app/views/widgets/global-logo-header-container.dart';
import 'package:crustascan_app/views/widgets/global_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = LoginController();

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  void _onPressedLoginButton() async {
    // First check internet connection
    if (!await checkInternetOrShowDialog(context)) return;

    if (_formKey.currentState!.validate()) {
      final success = await _loginController.validateLogin(context);
      if (success) {
        // Set authentication state to user
        Provider.of<AuthProvider>(context, listen: false).loginAsUser();

        _loginController.emailController.clear();
        _loginController.passwordController.clear();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GlobalLoadingPage(
              navigateNextPage: const HomePage(),
              duration: const Duration(seconds: 1),
            ),
          ),
        );
      } else {
        _loginController.passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid login credentials. Try again!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onPressedGuestButton() {
    // Set both guest provider and auth provider
    Provider.of<GuestProvider>(context, listen: false).loginAsGuest();
    Provider.of<AuthProvider>(context, listen: false).loginAsGuest();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GlobalLoadingPage(
          navigateNextPage: const HomePage(),
          duration: const Duration(seconds: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            const GlobalLogoHeaderContainer(
                              text: "Welcome to CrustaScan!",
                              description: "Sign in to your account",
                            ),
                            const SizedBox(height: 60),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller:
                                        _loginController.emailController,
                                    textInput: "EMAIL:",
                                    iconInput: Icons.person,
                                    hintTextInput: "Email",
                                    isValidationIcon: false,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  CustomPasswordFormField(
                                    controller:
                                        _loginController.passwordController,
                                    text: "PASSWORD:",
                                    icon: Icons.lock,
                                    hintText: "Password",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  CustomButton(
                                    onPressed: _onPressedLoginButton,
                                    textButton: "LOGIN",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Divider(
                              thickness: 1,
                              indent: 30,
                              endIndent: 30,
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              onPressed: _onPressedGuestButton,
                              textButton: "CONTINUE AS GUEST",
                              isGuestButton: true,
                            ),
                            const SizedBox(height: 70),
                          ],
                        ),
                      ),

                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            CustomBottomNav(
                              navigatePage: const RegisterPage(),
                              textMessage: "Don't have an account? ",
                              textAuth: "Register!",
                            ),
                            const SizedBox(height: 70),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
