import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/authentication/services/authentication_service.dart';
import 'package:client/common/models/common_response.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/home/screens/home_screen.dart';
import 'package:client/profile/models/get_user_detail_response.dart';
import 'package:client/profile/screens/edit_profile_screen.dart';
import 'package:client/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFCAC3C9),
            width: 1
          )
        ),
        title: const Text(
          'Profil Kamu',
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
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            color: Colors.black,
          ),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: ProfileService.getUserDetail(context), 
                builder: (BuildContext context, AsyncSnapshot<CommonResponse<UserDetailResponse>> snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image(
                                image: AssetImage(
                                  snapshot.data?.content?.user.gender == "FEMALE" ? 
                                    'assets/images/placeholder_avatar.png' : 
                                    'assets/images/male_placeholder_avatar.png'), 
                                width: 70, 
                                height: 70,
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.content!.user.name, 
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF170015),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text(
                                  snapshot.data!.content!.user.phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF79747E),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                Text(
                                  snapshot.data!.content!.user.email,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF79747E),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset(
                            snapshot.data?.content?.user.gender == "FEMALE" ? 
                            "assets/images/female.png" : 
                            "assets/images/male.png"
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5C96),));
                  }
                }
              ),

              const SizedBox(height: 26),

              const Text(
                "Pengaturan",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF79747E),
                ),  
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                    );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Card(
                    elevation: 4,
                    surfaceTintColor: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFFF5C97),
                                  size: 24,
                                ),
                              ),

                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ubah Profil", 
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF170015),
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),

                                  Text(
                                    "Perbarui profil anda",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF79747E),
                                      fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),

                          const Icon(
                            Icons.arrow_forward,
                            size: 23.45,
                          )
                        ],
                      ),
                    )
                  ),
                )
              )
            ],
          ),
        )
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ElevatedButton(
          onPressed: () async {
            await AuthenticationService.logoutUser();
            await SecureStorageService.destroyAll();
            Future.delayed(Duration.zero).then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
            )));
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFCE8F2),
            minimumSize: Size(MediaQuery.of(context).size.width, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60)
            )
          ),
          child: const Text(
            "Keluar Akun",
            style: TextStyle(
              color: Color(0xFFE74D5F),
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          )
        ),
      )
    );
  }
} 