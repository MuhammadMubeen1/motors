import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/extensions/string_extensions.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/auth/restore_password_screen.dart';
import 'package:motors_app/presentation/screens/auth/sign_up_screen.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          leading: const SizedBox(),
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Hero(
              tag: 'logo',
              child: CachedNetworkImage(
                width: 190,
                height: 150,
                imageUrl: '$logo',
                placeholder: (context, url) => const LoaderWidget(
                  loaderColor: Colors.white,
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/images/logo_dark.png'),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, right: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.black),
                ),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NavigationBloc>(context).add(
                      ChangeNavigationEvent(
                        NavbarItem.home,
                        0,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      IconsMotors.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state is SuccessSignInState) {
            if (isAuth()) {
              BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(preferences.getString(PreferencesName.userId)));

              BlocProvider.of<NavigationBloc>(context).add(
                ChangeNavigationEvent(
                  NavbarItem.profile,
                  appType == AppType.dealership ? 2 : 3,
                ),
              );
            }
          }

          if (state is ErrorSignInState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => showBaseDialog(
                context,
                title: 'error'.tr(),
                content: state.message,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_bg.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment(-.6, 0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 70),
                        // Login
                        TextFormField(
                          textAlign: TextAlign.left,
                          controller: _loginController,
                          cursorColor: ColorApp.secondaryColor,
                          validator: (val) {
                            if (_loginController.text == '') {
                              return 'fill_the_form'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabled: state is! LoadingSignInState,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0, color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.red, width: 2),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),
                            isDense: false,
                            hintText: 'login'.tr().toCapitalized(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Password
                        TextFormField(
                          controller: _passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'fill_the_form'.tr();
                            }
                            return null;
                          },
                          enabled: state is! LoadingSignInState,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.red, width: 2),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText ? IconsMotors.eyeClose : IconsMotors.eyeShow,
                                size: 16,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0, color: Colors.white),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            isDense: false,
                            hintText: 'password'.tr().toCapitalized(),
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Sign In
                        AppElevatedButton.secondary(
                          onPressed: state is LoadingSignInState
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthBloc>(context).add(
                                      SignInEvent(
                                        _loginController.text,
                                        _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                          child: state is LoadingSignInState
                              ? LoaderWidget()
                              : Text(
                                  'sign_in'.tr(),
                                ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestorePasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'restore_password'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        // OR
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.white,
                                endIndent: 10,
                                indent: 130,
                                thickness: 1.5,
                              ),
                            ),
                            Text(
                              'or'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.white,
                                endIndent: 130,
                                indent: 10,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Sign Up
                        AppElevatedButton.neutral(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          ),
                          child: Text('sign_up'.tr()),
                        ),
                        const SizedBox(height: 60),
                        // By creating
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Text(
                            'by_creating'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Terms & Privacy Statement
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'terms_conditions'.tr(),
                                recognizer: TapGestureRecognizer()..onTap = () => log('Tap Here onTap'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' ${'and'.tr()} ',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              // TODO: 06.08.2023 Add privacy policy and terms link
                              TextSpan(
                                text: 'privacy_statement'.tr(),
                                recognizer: TapGestureRecognizer()..onTap = () => log('Tap Here onTap'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
