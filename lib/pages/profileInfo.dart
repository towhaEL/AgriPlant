import 'package:agriplant/controllers/user_controller.dart';
import 'package:agriplant/pages/auth/global/common/toast.dart';
import 'package:agriplant/repositories/user_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:settings_ui/pages/settings.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userRepository = Get.put(UserRepository());
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool showPassword = false;
  bool btnSave = false;

  @override
  Widget build(BuildContext context) {
    Get.delete<UserController>();
    var controller = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
        ),
        
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Obx( 
              () {
                if(controller.profileLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor: Theme.of(context).colorScheme.primary,child: getShimmerLoading()),
                  );
                } else {
                return  Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                  child: CircleAvatar(
                  radius: 62,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: 
                  CircleAvatar(
                    radius: 60,
                    foregroundImage: CachedNetworkImageProvider(controller.user.value.profilePicture),
                    ),
                  ),    
                );
                }
               }
            ),
                    
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller.uploadUserProfilePicture();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Obx(() => buildTextField("Full Name", controller.user.value.fullname, false, true, false, true,)),
              Obx(() => Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: TextField(
                            decoration: InputDecoration(
                            enabled: false,
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: "Email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: controller.user.value.email,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),),
              ),),
              Obx(() => buildTextField("Phone", controller.user.value.phoneNumber, false, true, true,false)),
              // buildTextField("Password", "123456", true),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: btnSave,
                    child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.red),
                      ),
                      
                      onPressed: () {
                        _fullnameController.text = controller.user.value.fullname;
                        _phoneController.text = controller.user.value.phoneNumber;

                        setState(() {
                          btnSave = !btnSave;
                        });
                      },
                        child: Text("Cancel", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,),)    
                    ),
                  ),
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.green),
                    ),
                    onPressed: () {
                        // updateProfileInfo();
                        if(btnSave) {
                          updateProfileInfo();
                          showToast(message: 'User profile updated.');
                        } else {
                          _fullnameController.text = controller.user.value.fullname;
                          _phoneController.text = controller.user.value.phoneNumber;
                        }
                        setState(() {
                          btnSave = !btnSave;
                        });
                        
                    },
                      child: (btnSave)? Text("Save", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,),) : Text("Edit", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,),)   
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField, bool isEnabled, bool isNum, bool isName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        // initialValue: "I am smart",
        controller: isName? _fullnameController : _phoneController,
        enabled: (btnSave)? true : false,
        obscureText: isPasswordTextField ? showPassword : false,
        keyboardType: isNum? TextInputType.number : TextInputType.name,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }


  Future<void> updateProfileInfo() async {


    String FullName = _fullnameController.text;
    String phoneNo = _phoneController.text;
    
    Map<String, dynamic> updated_user = {'fullname': FullName, 'phoneNumber': phoneNo};
    
    
    await userRepository.updateSingleField(updated_user);
  }


  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, 
      child: CircleAvatar(
        radius: 60,
      )
      );
  }








}