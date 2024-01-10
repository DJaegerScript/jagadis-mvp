import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/common/components/text_field_component.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/profile/screens/my_profile_screen.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserSession? _currentUser;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    UserSession? user = await SecureStorageService.getSession();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    } else {
      Future.delayed(Duration.zero).then((value) =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
      )));
    }
  }
  
  String _namaLengkap = "";

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF5C97),),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFCAC3C9),
            width: 1
          )
        ),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Color(0xFF170015),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 23.45,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfileScreen(),
                ),
              );
            },
            color: Colors.black,
        ),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), 
                              BlendMode.darken,
                            ),
                            child: Image.asset(
                              _currentUser!.gender == "FEMALE"
                                  ? "assets/images/placeholder_avatar.png"
                                  : "assets/images/male_placeholder_avatar.png",
                              width: 156,
                              height: 156,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 45,
                        )
                      ],
                    )
                  ),
                ],
              ),

              const SizedBox(height: 26),

              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Nama Lengkap",
                  style: TextStyle(
                    color: Color(0xFF170015),
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  )
                )
              ),

              const SizedBox(height: 7),

              TextFieldComponent(
                labelText: "Nama Lengkap", 
                hintText: "Masukkan nama lengkap",
                action: (String? value) {
                  setState(() {
                    _namaLengkap = value!;
                  });
                },  
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                }
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}