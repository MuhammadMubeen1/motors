import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/data/models/app_settings/app_settings_response.dart';
import 'package:motors_app/data/models/form_reg/form_reg.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/image_detail/image_detail_screen.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const String routeName = 'signUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  final _avatarController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'registration'.tr(),
          style: kAppBarStyle,
        ),
        leading: AppBarIcon(
          onTap: () {
            Provider.of<ImagePickerProvider>(context, listen: false).deleteImg();

            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state is SuccessSignUpState) {
            // Deleted image if user upload avatar
            Provider.of<ImagePickerProvider>(context, listen: false).deleteImg();

            BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(preferences.getString(PreferencesName.userId)));

            Navigator.of(context).pop();

            BlocProvider.of<NavigationBloc>(context).add(
              ChangeNavigationEvent(
                NavbarItem.profile,
                appType == AppType.dealership ? 2 : 3,
              ),
            );
          }

          if (state is ErrorSignUpState) {
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
            return Form(
              key: _formKey,
              child: SafeArea(
                child: ListView(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: itemList.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      itemBuilder: (BuildContext ctx, int index) {
                        _controllers.add(TextEditingController());

                        return _buildBodyForm(
                          index,
                          _controllers[index],
                          context,
                        );
                      },
                    ),
                    const Divider(thickness: 0.5, color: Colors.grey),
                    // Avatar Field
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 20, left: 10),
                      child: Row(
                        children: [
                          Text(
                            'avatar'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              controller: _avatarController,
                              readOnly: true,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ImageDetailScreen(),
                                ),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffe9eef0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                isDense: true,
                                hintText: Provider.of<ImagePickerProvider>(context).image != null ? Provider.of<ImagePickerProvider>(context).image?.path.toString() : 'upload_image'.tr(),
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildSignUpButton(context),
    );
  }

  _buildBodyForm(int index, TextEditingController controllerTxt, BuildContext context) {
    final FormReg item = itemList[index];

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 20, left: 10),
      child: Row(
        children: [
          Text(
            '${item.name} ${item.required == '' ? '' : item.required}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextFormField(
              controller: controllerTxt,
              keyboardType: item.keyboardType,
              readOnly: item.imgValidate == true ? true : false,
              obscureText: item.obscure == true ? _obscureText : item.obscure,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffe9eef0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                isDense: true,
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                suffixIcon: IconButton(
                  icon: item.obscure ? Icon(_obscureText && item.obscure ? IconsMotors.eyeShow : IconsMotors.eyeClose) : const SizedBox(),
                  onPressed: item.obscure == false
                      ? null
                      : () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                ),
              ),
              inputFormatters: item.inputFormat,
              validator: (val) {
                if (item.required != '') {
                  if (_controllers[index].text == '') {
                    return 'fill_the_form'.tr();
                  }
                }

                if (item.emailValidate == true) {
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_controllers[index].text)) {
                    return 'email_error'.tr();
                  }
                }

                if (item.phoneValidate == true) {
                  if (_controllers[5].text.length < 8) {
                    return 'password_error'.tr();
                  }
                }

                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSignUpButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: AppElevatedButton.primary(
            onPressed: state is LoadingSignUpState
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final login = _controllers[0].text;
                      final firstName = _controllers[1].text;
                      final lastName = _controllers[2].text;
                      final phone = _controllers[3].text;
                      final email = _controllers[4].text;
                      final password = _controllers[5].text;

                      BlocProvider.of<AuthBloc>(context).add(
                        SignUpEvent(
                          login: login,
                          name: firstName,
                          surname: lastName,
                          phone: phone,
                          email: email,
                          password: password,
                          avatar: Provider.of<ImagePickerProvider>(context, listen: false).image,
                        ),
                      );
                    }
                  },
            child: state is LoadingSignUpState ? LoaderWidget() : Text('sign_up'.tr()),
          ),
        );
      },
    );
  }
}

List<FormReg> itemList = [
  FormReg(
    name: 'login'.tr(),
    required: '*',
    hintText: '',
    obscure: false,
  ),
  FormReg(
    name: 'first_name'.tr(),
    required: '',
    hintText: '',
    obscure: false,
  ),
  FormReg(
    name: 'last_name'.tr(),
    required: '',
    hintText: '',
    obscure: false,
  ),
  FormReg(
    name: 'phone'.tr(),
    required: '',
    inputFormat: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
    hintText: '',
    obscure: false,
    keyboardType: TextInputType.number,
  ),
  FormReg(
    name: 'email'.tr(),
    required: '*',
    hintText: '',
    obscure: false,
    emailValidate: true,
  ),
  FormReg(
    name: 'password'.tr(),
    required: '*',
    hintText: '',
    obscure: true,
    phoneValidate: true,
  ),
];
