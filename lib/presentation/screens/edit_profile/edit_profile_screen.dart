import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/components/image_picker.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/user/user_response.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/add_car/components/add_car_provider.dart';
import 'package:motors_app/presentation/screens/add_car/components/image_picker_service.dart';
import 'package:motors_app/presentation/screens/edit_profile/widgets/edit_form_field.dart';
import 'package:motors_app/presentation/screens/home_root.dart';
import 'package:motors_app/presentation/screens/image_detail/image_detail_screen.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.author}) : super(key: key);

  final Author author;

  static const String routeName = 'editProfileScreen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;

  @override
  void initState() {
    _loginController = TextEditingController(text: widget.author.username ?? '');
    _nameController = TextEditingController(text: widget.author.name ?? '');
    _surnameController = TextEditingController(text: widget.author.lastName ?? '');
    _phoneController = TextEditingController(text: widget.author.phone ?? '');
    _emailController = TextEditingController(text: widget.author.email ?? '');
    _passwordController = TextEditingController(text: preferences.getString(PreferencesName.password));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'edit_profile'.tr(),
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
          if (state is UpdatedUserState) {
            if (isAuth()) {
              Provider.of<ImagePickerProvider>(context, listen: false).deleteImg();

              BlocProvider.of<ProfileBloc>(context).add(
                LoadProfileEvent(preferences.getString(PreferencesName.userId)),
              );

              Navigator.of(context).pop();
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
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: ListView(
              children: [
                // Login
                EditFormField(
                  title: 'login'.tr(),
                  readOnly: true,
                  controller: _loginController,
                ),
                const Divider(thickness: 1),
                // FirstName
                EditFormField(
                  title: 'first_name'.tr(),
                  controller: _nameController,
                ),
                const Divider(thickness: 1),
                // LastName
                EditFormField(
                  title: 'last_name'.tr(),
                  controller: _surnameController,
                ),
                const Divider(thickness: 1),
                // Phone
                EditFormField(
                  title: 'phone'.tr(),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const Divider(thickness: 1),
                // Email
                EditFormField(
                  title: 'email'.tr(),
                  controller: _emailController,
                ),
                const Divider(thickness: 1),
                // Password
                EditFormField(
                  title: 'password'.tr(),
                  readOnly: true,
                  obscureText: _isObscureText,
                  controller: _passwordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'fill_the_form'.tr();
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                    icon: Icon(_isObscureText ? IconsMotors.eyeShow : IconsMotors.eyeClose),
                  ),
                ),
                const Divider(thickness: 1),
                // Avatar
                EditFormField(
                  title: 'avatar'.tr(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageDetailScreen(),
                    ),
                  ),
                  readOnly: true,
                  hintText: Provider.of<ImagePickerProvider>(context).image != null ? Provider.of<ImagePickerProvider>(context).image?.path.toString() : 'upload_image'.tr(),
                  suffixIcon: const Icon(IconsMotors.photo),
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Update Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AppElevatedButton.secondary(
                  onPressed: state is LoadingUpdateUserState
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final String? userToken = preferences.getString(PreferencesName.apiToken);

                            BlocProvider.of<AuthBloc>(context).add(
                              UpdateProfileEvent(
                                userLogin: _loginController.text,
                                userName: _nameController.text,
                                userSurname: _surnameController.text,
                                userPhone: _phoneController.text,
                                userEmail: _emailController.text,
                                userPassword: _passwordController.text,
                                userId: widget.author.userId!,
                                userToken: userToken,
                                userAvatar: Provider.of<ImagePickerProvider>(context, listen: false).image,
                              ),
                            );
                          }
                        },
                  child: state is LoadingUpdateUserState ? LoaderWidget() : Text('update'.tr()),
                ),
              ),
              const SizedBox(height: 10.0),
              // Delete Button
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 10),
                child: AppElevatedButton.error(
                  child: Text('delete_account'.tr()),
                  onPressed: () async {
                    showBaseDialog(
                      context,
                      title: 'quit'.tr(),
                      content: 'are_you_sure_to_delete_account'.tr(),
                      onPressed: () {
                        Provider.of<AddCarProvider>(context, listen: false).addCarMap.clear();
                        Provider.of<AddCarProvider>(context, listen: false).addCarImageMap?.clear();
                        Provider.of<ImagePickerProvider>(context, listen: false).deleteAllImage();
                        Provider.of<ImagePickerService>(context, listen: false).clearImages();
                        PreferencesName.clearPreferences();

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeRoot.routeName,
                          ModalRoute.withName(HomeRoot.routeName),
                        );

                        BlocProvider.of<NavigationBloc>(context).add(
                          ChangeNavigationEvent(NavbarItem.home, 0),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
