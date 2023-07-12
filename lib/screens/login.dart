import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_card_scanning/bloc/login_bloc/login_bloc.dart';
import 'package:identity_card_scanning/models/login_model.dart';
import 'package:identity_card_scanning/screens/lobby.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/shared_preference.dart';
import 'package:identity_card_scanning/widgets/ktext_form_field.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _fromKey = GlobalKey<FormState>();
  bool remember = getRememberMe ?? true;
  TextEditingController usernameTEController = TextEditingController(),
      passwordTEController = TextEditingController();
  final LoginBloc _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                SizedBox(
                  height: 25.0.h,
                ),
                Text(
                  "Welcome to",
                  style: AppTextTheme.headline20,
                ),
                Text(
                  "Identity Card Scanning",
                  style: AppTextTheme.headline32.copyWith(color: primaryColor),
                ),
                const Expanded(flex: 2, child: SizedBox()),
                Text(
                  "Hello, ADMIN",
                  style: AppTextTheme.headline20,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Login here",
                  style: AppTextTheme.bodyText18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.h,
                ),
                KTextFormField(
                  textInputAction: TextInputAction.next,
                  controller: usernameTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter User ID/ Name";
                    } else {
                      return null;
                    }
                  },
                  labelText: "User ID/ Name",
                  hintText: "Enter User ID/ Name",
                ),
                const SizedBox(
                  height: 18.0,
                ),
                KTextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  minLines: 1,
                  maxLines: 1,
                  controller: passwordTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else {
                      return null;
                    }
                  },
                  labelText: "Password",
                  hintText: "Enter password",
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Checkbox(
                      value: remember,
                      onChanged: (value) {
                        setState(() {
                          remember = value ?? false;
                        });
                      },
                    ),
                    Text(
                      "Remember Me",
                      softWrap: true,
                      style: AppTextTheme.bodyText14,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text.rich(
                  TextSpan(
                    text: "Forgot Password?",
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    style: AppTextTheme.bodyText14
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
                const Expanded(flex: 3, child: SizedBox()),
                BlocProvider(
                  create: (_) => _loginBloc,
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginError) {
                        Fluttertoast.showToast(msg: state.error);
                      } else if (state is LoginLoaded) {
                        login(state.response);
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return RectangleButton(
                          isLoading: state is LoginLoading ? true : false,
                          text: "Login".toUpperCase(),
                          textColor: Colors.white,
                          buttonColor: primaryColor,
                          onPressed: () async {
                            if (_fromKey.currentState?.validate() ?? false) {
                              _loginBloc.add(SendLoginRequest(
                                userName: usernameTEController.text,
                                password: passwordTEController.text,
                              ));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(LoginModel model) async {
    await setAuthData(model);
    await setUsername(usernameTEController.text);
    await setRememberMe(remember);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => Lobby()),
    );
  }
}
