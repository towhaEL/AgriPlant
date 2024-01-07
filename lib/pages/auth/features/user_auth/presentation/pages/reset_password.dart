// import 'package:agriplant/pages/auth/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:agriplant/pages/auth/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:agriplant/pages/auth/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isReset = false;
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Back to login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
                icon: Icon(Icons.email),
              ),
              SizedBox(
                height: 10,
              ),
              FilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  // _isReset = true;
                  _resetPass();
                },
                child: _isReset ? CircularProgressIndicator(
                      color: Colors.white,): Text("Reset Password", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
              // GestureDetector(
              //   onTap: () {
              //     _isReset = true;
              //     _resetPass();
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     height: 45,
              //     decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Center(
                    // child: _isReset ? CircularProgressIndicator(
                    //   color: Colors.white,) : Text(
              //         "Reset Password",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                            (route) => false,
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ]
          )
      )
      )
      );
  }




  void _resetPass() async {
    setState(() {
      _isReset = true;
    });

    String email = _emailController.text;
    // await _auth.userExist(email, "rprrantsssword");

    if(email != ""){
        try {
      await FirebaseAuth.instance
    .sendPasswordResetEmail(email: email);
    showToast(message: "Reset password email sent");
    } on FirebaseAuthException catch(e) {
        // print(e.code);
      showToast(message: e.code);
    }  
       
    } else {
      showToast(message: "Email field cannot be empty");
    }
    

     


    setState(() {
      _isReset = false;
    });

  }



}