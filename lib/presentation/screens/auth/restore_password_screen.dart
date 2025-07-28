import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/extensions/string_extensions.dart';
import 'package:motors_app/core/styles/text_styles.dart';
import 'package:motors_app/presentation/bloc/restore_password/restore_password_bloc.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:motors_app/presentation/widgets/app_elevated_button.dart';
import 'package:motors_app/presentation/widgets/loader_widget.dart';

class RestorePasswordScreen extends StatefulWidget {
  const RestorePasswordScreen({super.key});

  @override
  State<RestorePasswordScreen> createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restorePasswordController = TextEditingController();

  @override
  void dispose() {
    _restorePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestorePasswordBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'restore_password'.tr(),
            style: kAppBarStyle,
          ),
          leading: AppBarIcon(
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocListener<RestorePasswordBloc, RestorePasswordState>(
          listener: (context, state) {
            if (state is SuccessRestorePasswordState) {
              showBaseDialog(
                context,
                title: '',
                content: state.restorePasswordResponse.message ?? '',
              );

              _restorePasswordController.clear();
            }
          },
          child: BlocBuilder<RestorePasswordBloc, RestorePasswordState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            controller: _restorePasswordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'fill_the_form'.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffe9eef0),
                              errorText: state is ErrorRestorePasswordState ? state.message : null,
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
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0, color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              isDense: false,
                              hintText: 'email'.tr().toCapitalized(),
                            ),
                          ),
                        ),
                        AppElevatedButton.primary(
                          onPressed: state is LoadingRestorePasswordState
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<RestorePasswordBloc>().add(
                                          ResetPasswordEvent(_restorePasswordController.text),
                                        );
                                  }
                                },
                          child: state is LoadingRestorePasswordState ? LoaderWidget() : Text('submit'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
