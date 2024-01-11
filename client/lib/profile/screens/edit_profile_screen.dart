import 'package:client/authentication/screens/login_screen.dart';
import 'package:client/common/components/text_field_component.dart';
import 'package:client/common/models/common_response.dart';
import 'package:client/common/models/user_session.dart';
import 'package:client/common/services/secure_storage_service.dart';
import 'package:client/profile/models/get_user_detail_response.dart';
import 'package:client/profile/screens/my_profile_screen.dart';
import 'package:client/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _editFormKey = GlobalKey<FormState>();

  TextEditingController _dateController = TextEditingController();
  String _namaLengkap = "";
  String _email = "";
  String _phoneNumber = "";
  String _gender = "Perempuan";

  var _listOfGenders = [
    "Laki-laki",
    "Perempuan"
  ];

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
          child: Form(
            key: _editFormKey,
            child: FutureBuilder(
              future: ProfileService.getUserDetail(context), 
              builder: (BuildContext context, AsyncSnapshot<CommonResponse<UserDetailResponse>> snapshot) {
                DateTime birthdate = snapshot.data?.content?.user.birthdate ?? DateTime.now();
                String formattedDate = "${birthdate.day}/${birthdate.month}/${birthdate.year}";
                _dateController.text = formattedDate;
                if (formattedDate == "1/1/1") {
                  _dateController.text = "";
                } else {
                  _dateController.text = formattedDate;
                }

                if (snapshot.hasData) {
                  return Column(
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
                                      snapshot.data?.content?.user.gender == "FEMALE"
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
                        initialValue: snapshot.data?.content?.user.name,
                        labelText: "Nama Lengkap",
                        hintText: "Masukkan Nama Lengkap",
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

                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Email",
                          style: TextStyle(
                            color: Color(0xFF170015),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),

                      const SizedBox(height: 7),

                      TextFieldComponent(
                        initialValue: snapshot.data?.content?.user.email,
                        labelText: "Email", 
                        hintText: "Masukkan Email",
                        action: (String? value) {
                          setState(() {
                            _namaLengkap = value!;
                          });
                        },  
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          }
                          return null;
                        }
                      ),

                      const SizedBox(height: 12),

                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "No. Handphone",
                          style: TextStyle(
                            color: Color(0xFF170015),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),

                      const SizedBox(height: 7),

                      TextFieldComponent(
                        keyboardType: TextInputType.phone,
                        initialValue: snapshot.data?.content?.user.phoneNumber,
                        labelText: "No. HP",
                        hintText: "No. HP",
                        action: (String? value) {
                          setState(() {
                            _phoneNumber = value!;
                          });
                        }, 
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number cannot be empty";
                          }  else if (!_phoneNumber.startsWith("+62") &&
                              !_phoneNumber.startsWith("62") &&
                              !_phoneNumber.startsWith("0")) {
                            return 'Phone number is invalid!';
                          }
                          return null;
                        },
                        isForPhone: true,
                      ),

                      const SizedBox(height: 12),

                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Tanggal Lahir",
                          style: TextStyle(
                            color: Color(0xFF170015),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),

                      const SizedBox(height: 7),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _dateController,
                          maxLines: 1,
                          keyboardType: TextInputType.datetime,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "Tanggal Lahir",
                            labelText: "Tanggal Lahir",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Gender",
                          style: TextStyle(
                            color: Color(0xFF170015),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ),

                      const SizedBox(height: 7),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          items: _listOfGenders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                          onChanged:  (String? value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5C96),));
                }
              }
            )
          )
        ),
      ),
    );
  }
}