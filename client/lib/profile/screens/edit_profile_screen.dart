import 'package:jagadis/common/components/text_field_component.dart';
import 'package:jagadis/common/models/common_response.dart';
import 'package:jagadis/profile/models/get_user_detail_response.dart';
import 'package:jagadis/profile/screens/my_profile_screen.dart';
import 'package:jagadis/profile/services/profile_service.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _editFormKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  String _namaLengkap = "";
  final String _email = "";
  String _phoneNumber = "";
  String _gender = "Perempuan";
  String _city = "Kota Administrasi Jakarta Barat";
  DateTime _actualDate = DateTime.now();

  final _listOfGenders = ["Laki-laki", "Perempuan"];

  final _listOfCities = [
    "Kabupaten Aceh Barat",
    "Kabupaten Aceh Barat Daya",
    "Kabupaten Aceh Besar",
    "Kabupaten Aceh Jaya",
    "Kabupaten Aceh Selatan",
    "Kabupaten Aceh Singkil",
    "Kabupaten Aceh Tamiang",
    "Kabupaten Aceh Tengah",
    "Kabupaten Aceh Tenggara",
    "Kabupaten Aceh Timur",
    "Kabupaten Aceh Utara",
    "Kabupaten Bener Meriah",
    "Kabupaten Bireuen",
    "Kabupaten Gayo Lues",
    "Kabupaten Nagan Raya",
    "Kabupaten Pidie",
    "Kabupaten Pidie Jaya",
    "Kabupaten Simeulue",
    "Kota Banda Aceh",
    "Kota Langsa",
    "Kota Lhokseumawe",
    "Kota Sabang",
    "Kota Subulussalam",
    "Kabupaten Asahan",
    "Kabupaten Batu Bara",
    "Kabupaten Dairi",
    "Kabupaten Deli Serdang",
    "Kabupaten Humbang Hasundutan",
    "Kabupaten Karo",
    "Kabupaten Labuhanbatu",
    "Kabupaten Labuhanbatu Selatan",
    "Kabupaten Labuhanbatu Utara",
    "Kabupaten Langkat",
    "Kabupaten Mandailing Natal",
    "Kabupaten Nias",
    "Kabupaten Nias Barat",
    "Kabupaten Nias Selatan",
    "Kabupaten Nias Utara",
    "Kabupaten Padang Lawas",
    "Kabupaten Padang Lawas Utara",
    "Kabupaten Pakpak Bharat",
    "Kabupaten Samosir",
    "Kabupaten Serdang Bedagai",
    "Kabupaten Simalungun",
    "Kabupaten Tapanuli Selatan",
    "Kabupaten Tapanuli Tengah",
    "Kabupaten Tapanuli Utara",
    "Kabupaten Toba",
    "Kota Binjai",
    "Kota Gunungsitoli",
    "Kota Medan",
    "Kota Padang Sidempuan",
    "Kota Pematangsiantar",
    "Kota Sibolga",
    "Kota Tanjungbalai",
    "Kota Tebing Tinggi",
    "Kabupaten Agam",
    "Kabupaten Dharmasraya",
    "Kabupaten Kepulauan Mentawai",
    "Kabupaten Lima Puluh Kota",
    "Kabupaten Padang Pariaman",
    "Kabupaten Pasaman",
    "Kabupaten Pasaman Barat",
    "Kabupaten Pesisir Selatan",
    "Kabupaten Sijunjung",
    "Kabupaten Solok",
    "Kabupaten Solok Selatan",
    "Kabupaten Tanah Datar",
    "Kota Bukittinggi",
    "Kota Padang",
    "Kota Padang Panjang",
    "Kota Pariaman",
    "Kota Payakumbuh",
    "Kota Sawahlunto",
    "Kota Solok",
    "Kabupaten Bengkalis",
    "Kabupaten Indragiri Hilir",
    "Kabupaten Indragiri Hulu",
    "Kabupaten Kampar",
    "Kabupaten Kepulauan Meranti",
    "Kabupaten Kuantan Singingi",
    "Kabupaten Pelalawan",
    "Kabupaten Rokan Hilir",
    "Kabupaten Rokan Hulu",
    "Kabupaten Siak",
    "Kota Dumai",
    "Kota Pekanbaru",
    "Kabupaten Bintan",
    "Kabupaten Karimun",
    "Kabupaten Kepulauan Anambas",
    "Kabupaten Lingga",
    "Kabupaten Natuna",
    "Kota Batam",
    "Kota Tanjungpinang",
    "Kabupaten Batanghari",
    "Kabupaten Bungo",
    "Kabupaten Kerinci",
    "Kabupaten Merangin",
    "Kabupaten Muaro Jambi",
    "Kabupaten Sarolangun",
    "Kabupaten Tanjung Jabung Barat",
    "Kabupaten Tanjung Jabung Timur",
    "Kabupaten Tebo",
    "Kota Jambi",
    "Kota Sungai Penuh",
    "Kabupaten Bengkulu Selatan",
    "Kabupaten Bengkulu Tengah",
    "Kabupaten Bengkulu Utara",
    "Kabupaten Kaur",
    "Kabupaten Kepahiang",
    "Kabupaten Lebong",
    "Kabupaten Mukomuko",
    "Kabupaten Rejang Lebong",
    "Kabupaten Seluma",
    "Kota Bengkulu",
    "Kabupaten Banyuasin",
    "Kabupaten Empat Lawang",
    "Kabupaten Lahat",
    "Kabupaten Muara Enim",
    "Kabupaten Musi Banyuasin",
    "Kabupaten Musi Rawas",
    "Kabupaten Musi Rawas Utara",
    "Kabupaten Ogan Ilir",
    "Kabupaten Ogan Komering Ilir",
    "Kabupaten Ogan Komering Ulu",
    "Kabupaten Ogan Komering Ulu Selatan",
    "Kabupaten Ogan Komering Ulu Timur",
    "Kabupaten Penukal Abab Lematang Ilir",
    "Kota Lubuklinggau",
    "Kota Pagar Alam",
    "Kota Palembang",
    "Kota Prabumulih",
    "Kabupaten Bangka",
    "Kabupaten Bangka Barat",
    "Kabupaten Bangka Selatan",
    "Kabupaten Bangka Tengah",
    "Kabupaten Belitung",
    "Kabupaten Belitung Timur",
    "Kota Pangkalpinang",
    "Kabupaten Lampung Barat",
    "Kabupaten Lampung Selatan",
    "Kabupaten Lampung Tengah",
    "Kabupaten Lampung Timur",
    "Kabupaten Lampung Utara",
    "Kabupaten Mesuji",
    "Kabupaten Pesawaran",
    "Kabupaten Pesisir Barat",
    "Kabupaten Pringsewu",
    "Kabupaten Tanggamus",
    "Kabupaten Tulang Bawang",
    "Kabupaten Tulang Bawang Barat",
    "Kabupaten Way Kanan",
    "Kota Bandar Lampung",
    "Kota Metro",
    "Kabupaten Lebak",
    "Kabupaten Pandeglang",
    "Kabupaten Serang",
    "Kabupaten Tangerang",
    "Kota Cilegon",
    "Kota Serang",
    "Kota Tangerang",
    "Kota Tangerang Selatan",
    "Kabupaten Bandung",
    "Kabupaten Bandung Barat",
    "Kabupaten Bekasi",
    "Kabupaten Bogor",
    "Kabupaten Ciamis",
    "Kabupaten Cianjur",
    "Kabupaten Cirebon",
    "Kabupaten Garut",
    "Kabupaten Indramayu",
    "Kabupaten Karawang",
    "Kabupaten Kuningan",
    "Kabupaten Majalengka",
    "Kabupaten Pangandaran",
    "Kabupaten Purwakarta",
    "Kabupaten Subang",
    "Kabupaten Sukabumi",
    "Kabupaten Sumedang",
    "Kabupaten Tasikmalaya",
    "Kota Bandung",
    "Kota Banjar",
    "Kota Bekasi",
    "Kota Bogor",
    "Kota Cimahi",
    "Kota Cirebon",
    "Kota Depok",
    "Kota Sukabumi",
    "Kota Tasikmalaya",
    "Kabupaten Administrasi Kepulauan Seribu",
    "Kota Administrasi Jakarta Barat",
    "Kota Administrasi Jakarta Pusat",
    "Kota Administrasi Jakarta Selatan",
    "Kota Administrasi Jakarta Timur",
    "Kota Administrasi Jakarta Utara",
    "Kabupaten Banjarnegara",
    "Kabupaten Banyumas",
    "Kabupaten Batang",
    "Kabupaten Blora",
    "Kabupaten Boyolali",
    "Kabupaten Brebes",
    "Kabupaten Cilacap",
    "Kabupaten Demak",
    "Kabupaten Grobogan",
    "Kabupaten Jepara",
    "Kabupaten Karanganyar",
    "Kabupaten Kebumen",
    "Kabupaten Kendal",
    "Kabupaten Klaten",
    "Kabupaten Kudus",
    "Kabupaten Magelang",
    "Kabupaten Pati",
    "Kabupaten Pekalongan",
    "Kabupaten Pemalang",
    "Kabupaten Purbalingga",
    "Kabupaten Purworejo",
    "Kabupaten Rembang",
    "Kabupaten Semarang",
    "Kabupaten Sragen",
    "Kabupaten Sukoharjo",
    "Kabupaten Tegal",
    "Kabupaten Temanggung",
    "Kabupaten Wonogiri",
    "Kabupaten Wonosobo",
    "Kota Magelang",
    "Kota Pekalongan",
    "Kota Salatiga",
    "Kota Semarang",
    "Kota Surakarta",
    "Kota Tegal",
    "Kabupaten Bantul",
    "Kabupaten Gunungkidul",
    "Kabupaten Kulon Progo",
    "Kabupaten Sleman",
    "Kota Yogyakarta",
    "Bangkalan",
    "Banyuwangi",
    "Blitar",
    "Bojonegoro",
    "Bondowoso",
    "Gresik",
    "Jember",
    "Jombang",
    "Kediri",
    "Lamongan",
    "Lumajang",
    "Madiun",
    "Magetan",
    "Malang",
    "Mojokerto",
    "Nganjuk",
    "Ngawi",
    "Pacitan",
    "Pamekasan",
    "Pasuruan",
    "Ponorogo",
    "Probolinggo",
    "Sampang",
    "Sidoarjo",
    "Situbondo",
    "Sumenep",
    "Trenggalek",
    "Tuban",
    "Tulungagung",
    "Kota Batu",
    "Kota Blitar",
    "Kota Kediri",
    "Kota Madiun",
    "Kota Malang",
    "Kota Mojokerto",
    "Kota Pasuruan",
    "Kota Probolinggo",
    "Kota Surabaya",
    "Kabupaten Badung",
    "Kabupaten Bangli",
    "Kabupaten Buleleng",
    "Kabupaten Gianyar",
    "Kabupaten Jembrana",
    "Kabupaten Karangasem",
    "Kabupaten Klungkung",
    "Kabupaten Tabanan",
    "Kota Denpasar",
    "Kabupaten Bima",
    "Kabupaten Dompu",
    "Kabupaten Lombok Barat",
    "Kabupaten Lombok Tengah",
    "Kabupaten Lombok Timur",
    "Kabupaten Lombok Utara",
    "Kabupaten Sumbawa",
    "Kabupaten Sumbawa Barat",
    "Kota Bima",
    "Kota Mataram",
    "Kabupaten Alor",
    "Kabupaten Belu",
    "Kabupaten Ende",
    "Kabupaten Flores Timur",
    "Kabupaten Kupang",
    "Kabupaten Lembata",
    "Kabupaten Malaka",
    "Kabupaten Manggarai",
    "Kabupaten Manggarai Barat",
    "Kabupaten Manggarai Timur",
    "Kabupaten Nagekeo",
    "Kabupaten Ngada",
    "Kabupaten Rote Ndao",
    "Kabupaten Sabu Raijua",
    "Kabupaten Sikka",
    "Kabupaten Sumba Barat",
    "Kabupaten Sumba Barat Daya",
    "Kabupaten Sumba Tengah",
    "Kabupaten Sumba Timur",
    "Kabupaten Timor Tengah Selatan",
    "Kabupaten Timor Tengah Utara",
    "Kota Kupang",
    "Kabupaten Bengkayang",
    "Kabupaten Kapuas Hulu",
    "Kabupaten Kayong Utara",
    "Kabupaten Ketapang",
    "Kabupaten Kubu Raya",
    "Kabupaten Landak",
    "Kabupaten Melawi",
    "Kabupaten Mempawah",
    "Kabupaten Sambas",
    "Kabupaten Sanggau",
    "Kabupaten Sekadau",
    "Kabupaten Sintang",
    "Kota Pontianak",
    "Kota Singkawang",
    "Kabupaten Balangan",
    "Kabupaten Banjar",
    "Kabupaten Barito Kuala",
    "Kabupaten Hulu Sungai Selatan",
    "Kabupaten Hulu Sungai Tengah",
    "Kabupaten Hulu Sungai Utara",
    "Kabupaten Kotabaru",
    "Kabupaten Tabalong",
    "Kabupaten Tanah Bumbu",
    "Kabupaten Tanah Laut",
    "Kabupaten Tapin",
    "Kota Banjarbaru",
    "Kota Banjarmasin",
    "Kabupaten Barito Selatan",
    "Kabupaten Barito Timur",
    "Kabupaten Barito Utara",
    "Kabupaten Gunung Mas",
    "Kabupaten Kapuas",
    "Kabupaten Katingan",
    "Kabupaten Kotawaringin Barat",
    "Kabupaten Kotawaringin Timur",
    "Kabupaten Lamandau",
    "Kabupaten Murung Raya",
    "Kabupaten Pulang Pisau",
    "Kabupaten Sukamara",
    "Kabupaten Seruyan",
    "Kota Palangka Raya",
    "Kabupaten Berau",
    "Kabupaten Kutai Barat",
    "Kabupaten Kutai Kartanegara",
    "Kabupaten Kutai Timur",
    "Kabupaten Mahakam Ulu",
    "Kabupaten Paser",
    "Kabupaten Penajam Paser Utara",
    "Kota Balikpapan",
    "Kota Bontang",
    "Kota Samarinda",
    "Kabupaten Bulungan",
    "Kabupaten Malinau",
    "Kabupaten Nunukan",
    "Kabupaten Tana Tidung",
    "Kota Tarakan",
    "Kabupaten Bolaang Mongondow",
    "Kabupaten Bolaang Mongondow Selatan",
    "Kabupaten Bolaang Mongondow Timur",
    "Kabupaten Bolaang Mongondow Utara",
    "Kabupaten Kepulauan Sangihe",
    "Kabupaten Kepulauan Siau Tagulandang Biaro",
    "Kabupaten Kepulauan Talaud",
    "Kabupaten Minahasa",
    "Kabupaten Minahasa Selatan",
    "Kabupaten Minahasa Tenggara",
    "Kabupaten Minahasa Utara",
    "Kota Bitung",
    "Kota Kotamobagu",
    "Kota Manado",
    "Kota Tomohon",
    "Kabupaten Boalemo",
    "Kabupaten Bone Bolango",
    "Kabupaten Gorontalo",
    "Kabupaten Gorontalo Utara",
    "Kabupaten Pohuwato",
    "Kota Gorontalo",
    "Kabupaten Banggai",
    "Kabupaten Banggai Kepulauan",
    "Kabupaten Banggai Laut",
    "Kabupaten Buol",
    "Kabupaten Donggala",
    "Kabupaten Morowali",
    "Kabupaten Morowali Utara",
    "Kabupaten Parigi Moutong",
    "Kabupaten Poso",
    "Kabupaten Sigi",
    "Kabupaten Tojo Una-Una",
    "Kabupaten Tolitoli",
    "Kota Palu",
    "Kabupaten Majene",
    "Kabupaten Mamasa",
    "Kabupaten Mamuju",
    "Kabupaten Mamuju Tengah",
    "Kabupaten Pasangkayu",
    "Kabupaten Polewali Mandar",
    "Kabupaten Bantaeng",
    "Kabupaten Barru",
    "Kabupaten Bone",
    "Kabupaten Bulukumba",
    "Kabupaten Enrekang",
    "Kabupaten Gowa",
    "Kabupaten Jeneponto",
    "Kabupaten Kepulauan Selayar",
    "Kabupaten Luwu",
    "Kabupaten Luwu Timur",
    "Kabupaten Luwu Utara",
    "Kabupaten Maros",
    "Kabupaten Pangkajene dan Kepulauan",
    "Kabupaten Pinrang",
    "Kabupaten Sidenreng Rappang",
    "Kabupaten Sinjai",
    "Kabupaten Soppeng",
    "Kabupaten Takalar",
    "Kabupaten Tana Toraja",
    "Kabupaten Toraja Utara",
    "Kabupaten Wajo",
    "Kota Makassar",
    "Kota Palopo",
    "Kota Parepare",
    "Kabupaten Bombana",
    "Kabupaten Buton",
    "Kabupaten Buton Selatan",
    "Kabupaten Buton Tengah",
    "Kabupaten Buton Utara",
    "Kabupaten Kolaka",
    "Kabupaten Kolaka Timur",
    "Kabupaten Kolaka Utara",
    "Kabupaten Konawe",
    "Kabupaten Konawe Kepulauan",
    "Kabupaten Konawe Selatan",
    "Kabupaten Konawe Utara",
    "Kabupaten Muna",
    "Kabupaten Muna Barat",
    "Kabupaten Wakatobi",
    "Kota Baubau",
    "Kota Kendari",
    "Kabupaten Buru",
    "Kabupaten Buru Selatan",
    "Kabupaten Kepulauan Aru",
    "Kabupaten Kepulauan Tanimbar",
    "Kabupaten Maluku Barat Daya",
    "Kabupaten Maluku Tengah",
    "Kabupaten Maluku Tenggara",
    "Kabupaten Seram Bagian Barat",
    "Kabupaten Seram Bagian Timur",
    "Kota Ambon",
    "Kota Tual",
    "Kabupaten Halmahera Barat",
    "Kabupaten Halmahera Tengah",
    "Kabupaten Halmahera Timur",
    "Kabupaten Halmahera Selatan",
    "Kabupaten Halmahera Utara",
    "Kabupaten Kepulauan Sula",
    "Kabupaten Pulau Morotai",
    "Kabupaten Pulau Taliabu",
    "Kota Ternate",
    "Kota Tidore Kepulauan",
    "Kabupaten Biak Numfor",
    "Kabupaten Jayapura",
    "Kabupaten Keerom",
    "Kabupaten Kepulauan Yapen",
    "Kabupaten Mamberamo Raya",
    "Kabupaten Sarmi",
    "Kabupaten Supiori",
    "Kabupaten Waropen",
    "Kota Jayapura",
    "Kabupaten Fakfak",
    "Kabupaten Kaimana",
    "Kabupaten Manokwari",
    "Kabupaten Manokwari Selatan",
    "Kabupaten Pegunungan Arfak",
    "Kabupaten Teluk Bintuni",
    "Kabupaten Teluk Wondama",
    "Kabupaten Jayawijaya",
    "Kabupaten Lanny Jaya",
    "Kabupaten Mamberamo Tengah",
    "Kabupaten Nduga",
    "Kabupaten Pegunungan Bintang",
    "Kabupaten Tolikara",
    "Kabupaten Yalimo",
    "Kabupaten Yahukimo",
    "Kabupaten Asmat",
    "Kabupaten Boven Digoel",
    "Kabupaten Mappi",
    "Kabupaten Merauke",
    "Kabupaten Deiyai",
    "Kabupaten Dogiyai",
    "Kabupaten Intan Jaya",
    "Kabupaten Mimika",
    "Kabupaten Nabire",
    "Kabupaten Paniai",
    "Kabupaten Puncak",
    "Kabupaten Puncak Jaya",
    "Kabupaten Maybrat",
    "Kabupaten Raja Ampat",
    "Kabupaten Sorong",
    "Kabupaten Sorong Selatan",
    "Kabupaten Tambrauw",
    "Kota Sorong"
  ];

  @override
  void initState() {
    super.initState();
    _setInitialDateValue();
    _setInitialGenderValue();
    _setInitialCityValue();
  }

  _setInitialDateValue() async {
    CommonResponse<UserDetailResponse> snapshot =
        await ProfileService.getUserDetail(context);
    if (snapshot.content == null || snapshot.content?.user == null) {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFFFF5C96),
      ));
    }

    DateTime birthdate = snapshot.content?.user.birthdate ?? DateTime.now();
    String formattedDate =
        "${birthdate.day}/${birthdate.month}/${birthdate.year}";
    _dateController.text = formattedDate;
    if (formattedDate == "1/1/1") {
      int epochTimeInSeconds = 0;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          epochTimeInSeconds * 1000,
          isUtc: true);
      _actualDate = dateTime;
      _dateController.text =
          "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } else {
      _dateController.text = formattedDate;
      _actualDate = birthdate;
    }
  }

  _setInitialGenderValue() async {
    CommonResponse<UserDetailResponse> snapshot =
        await ProfileService.getUserDetail(context);
    if (snapshot.content == null || snapshot.content?.user == null) {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFFFF5C96),
      ));
    }

    String gender = snapshot.content!.user.gender;
    if (gender == "MALE") {
      _gender = "Laki-laki";
    } else {
      _gender = "Perempuan";
    }
  }

  _setInitialCityValue() async {
    CommonResponse<UserDetailResponse> snapshot =
        await ProfileService.getUserDetail(context);
    if (snapshot.content == null || snapshot.content?.user == null) {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFFFF5C96),
      ));
    }

    String city = snapshot.content!.user.city;
    if (city == "") {
      _city = "Kota Administrasi Jakarta Barat";
    } else {
      _city = city;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
            bottom: BorderSide(color: Color(0xFFCAC3C9), width: 1)),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Color(0xFF170015),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 18),
            child: Form(
                key: _editFormKey,
                child: FutureBuilder(
                    future: ProfileService.getUserDetail(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<CommonResponse<UserDetailResponse>>
                            snapshot) {
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
                                              snapshot.data?.content?.user
                                                          .gender ==
                                                      "MALE"
                                                  ? "assets/images/male_placeholder_avatar.png"
                                                  : "assets/images/placeholder_avatar.png",
                                              width: 130,
                                              height: 130,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 45,
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text("Nama Lengkap",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
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
                                }),
                            const SizedBox(height: 12),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text("Email",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(height: 7),
                            TextFieldComponent(
                                initialValue:
                                    snapshot.data?.content?.user.email,
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
                                }),
                            const SizedBox(height: 12),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text("No. Handphone",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(height: 7),
                            TextFieldComponent(
                              keyboardType: TextInputType.phone,
                              initialValue:
                                  snapshot.data?.content?.user.phoneNumber,
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
                                } else if (!_phoneNumber.startsWith("+62") &&
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
                                child: const Text("Tanggal Lahir",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
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
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: _actualDate,
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(DateTime.now().year),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: Color(0xFFFF5C96),
                                              onPrimary: Colors.black,
                                              onSurface: Colors.black,
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    const Color(0xFFFF5C96),
                                              ),
                                            ),
                                            datePickerTheme:
                                                const DatePickerThemeData(
                                                    surfaceTintColor:
                                                        Colors.transparent)),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                      _actualDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text("Gender",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
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
                                onChanged: (String? value) {
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
                            ),
                            const SizedBox(height: 12),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text("Alamat Kota/Kabupaten",
                                    style: TextStyle(
                                        color: Color(0xFF170015),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(height: 7),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonFormField<String>(
                                value: _city,
                                items: _listOfCities.map((String city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(city)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _city = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Alamat Kota/Kabupaten",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: _updateProfile,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5C96),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 60),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60))),
                                child: const Text(
                                  "Simpan Perubahan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                )),
                          ],
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFFFF5C96),
                        ));
                      }
                    }))),
      ),
    );
  }

  void _updateProfile() async {
    if (_editFormKey.currentState!.validate()) {
      String genderReal = _gender == "Laki-laki" ? "MALE" : "FEMALE";
      String formattedPhoneNumber = _phoneNumber.startsWith("62")
          ? "+$_phoneNumber"
          : _phoneNumber.startsWith("0")
              ? _phoneNumber.replaceFirst("0", "+62")
              : _phoneNumber;

      Map<String, String> body = {
        "name": _namaLengkap,
        "gender": genderReal,
        "email": _email,
        "phoneNumber": formattedPhoneNumber,
        "city": _city,
        "birthdate": _actualDate.toString(),
      };

      CommonResponse response =
          await ProfileService.updateUserDetail(context, body);

      if (response.isSuccess) {
        Future.delayed(Duration.zero).then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Perubahan profil kamu berhasil di simpan!"))));
        Future.delayed(Duration.zero).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MyProfileScreen(),
                )));
      } else {
        Future.delayed(Duration.zero).then((value) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response.message))));
      }
    }
  }
}
