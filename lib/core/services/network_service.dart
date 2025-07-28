import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/styles/app_color.dart';
import 'package:motors_app/main.dart';
import 'package:motors_app/presentation/bloc/network_handler/network_bloc.dart';

class NetworkService extends StatefulWidget {
  const NetworkService({super.key, required this.child});

  final Widget child;

  @override
  State<NetworkService> createState() => _NetworkServiceState();
}

class _NetworkServiceState extends State<NetworkService> {
  bool _showDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listener: (BuildContext context, NetworkState state) {
        if (state is NetworkSuccessState) {
          if (_showDialog) {
            _showDialog = false;
            Navigator.of(navigatorKey.currentContext!).pop();
          }
        }

        if (state is NetworkFailureState) {
          _showDialog = true;
          showNoInternetDialog().whenComplete(() => _showDialog = false);
        }
      },
      child: widget.child,
    );
  }

  Future<void> showNoInternetDialog() {
    return showDialog(
      context: navigatorKey.currentContext!,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                  const   Text(
                      'Internet error',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                   const  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'No internet connection',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF565656),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorApp.mainColor,
                      ),
                      child:const Text('Try again'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
