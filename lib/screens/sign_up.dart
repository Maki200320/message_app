import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging/services/sign_up.dart';

import '../utils/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignUpFirebase signObj = SignUpFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(_emailController),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(_passwordController),
                      _buildForgotPasswordBtn(),
                     // _buildRememberMeCheckbox(),
                      _buildLoginBtn(_emailController,_passwordController),
                      _buildSignInWithText(),
                      //_buildSocialBtnRow(),
                      _buildSignupBtn(context),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSignupBtn(BuildContext context) {
  return GestureDetector(
    onTap: () =>Navigator.pop(context),

    child: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmailTF(TextEditingController email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Email',
        style: kLabelStyle,
      ),
      const SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 60.0,
        child: TextField(
          controller:email,
          keyboardType: TextInputType.emailAddress,
          style:const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 14.0),
            prefixIcon:const Icon(
              Icons.email,
              color: Colors.white,
            ),
            hintText: 'Enter your Email',
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPasswordTF(TextEditingController password) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Password',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 60.0,
        child: TextField(
          controller: password,
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            hintText: 'Enter your Password',
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    ],
  );
}

Widget _buildForgotPasswordBtn() {
  return Container(
      alignment: Alignment.centerRight,
      child:TextButton(
        onPressed: () {
          print('Forgot Password Button Pressed');
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 0.0),
        ),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle, // Use your custom text style here
        ),
      )

  );
}

Widget _buildLoginBtn(TextEditingController email, TextEditingController password) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child:ElevatedButton(
        onPressed: () {
          SignUpFirebase signObj = SignUpFirebase();
          signObj.signUpWithEmailPassword(email.text, password.text);
          email.clear();
          password.clear();
          print('Login Button Pressed');
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0, backgroundColor: Colors.white,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ), // Background color
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      )

  );
}

Widget _buildSignInWithText() {
  return Column(
    children: <Widget>[
    const Text(
        '- OR -',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: 20.0),
      Text(
        'Sign in with',
        style: kLabelStyle,
      ),
    ],
  );
}

Widget _buildSocialBtn(Function onTap, AssetImage logo) {
  return GestureDetector(
    onTap: (){},
    child: Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: const [
           BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        image: DecorationImage(
          image: logo,
        ),
      ),
    ),
  );
}


