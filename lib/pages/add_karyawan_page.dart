import 'package:absensi_flutter/controllers/add_karyawan_c.dart';
import 'package:absensi_flutter/utils/app_style_textfield.dart';
import 'package:absensi_flutter/utils/app_text.dart';
import 'package:absensi_flutter/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddKaryawanPage extends StatelessWidget {
  const AddKaryawanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addC = Get.find<AddKaryawanC>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Text(
          "Tambah Karyawan",
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade300,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: Get.height,
          color: Colors.white,
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: addC.txUsername,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: AppStyleTextfield.authTextFieldStyle(),
                      textInputAction: TextInputAction.next,
                      decoration: AppStyleTextfield.authFormInput(
                          'Nomor Induk Karyawan'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => AppValidator.requiredField(
                        value!,
                        errorMsg: "NIK tidak boleh kosong",
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: addC.txNama,
                      keyboardType: TextInputType.name,
                      style: AppStyleTextfield.authTextFieldStyle(),
                      textInputAction: TextInputAction.next,
                      decoration:
                          AppStyleTextfield.authFormInput('Nama Lengkap'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => AppValidator.requiredField(
                        value!,
                        errorMsg: "Nama tidak boleh kosong",
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: addC.txEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: AppStyleTextfield.authTextFieldStyle(),
                      textInputAction: TextInputAction.next,
                      decoration:
                          AppStyleTextfield.authFormInput('Email Address'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => AppValidator.requiredField(
                        value!,
                        errorMsg: "Email tidak boleh kosong",
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: addC.txHp,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: AppStyleTextfield.authTextFieldStyle(),
                      textInputAction: TextInputAction.next,
                      decoration:
                          AppStyleTextfield.authFormInput('No Handphone'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => AppValidator.requiredField(
                        value!,
                        errorMsg: "No Handphone tidak boleh kosong",
                      ),
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => TextFormField(
                        controller: addC.txPass,
                        style: AppStyleTextfield.authTextFieldStyle(),
                        decoration: AppStyleTextfield.authFormInput('Password')
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: addC.isHidePassword.value == true
                                  ? Colors.grey[600]
                                  : Colors.blue,
                              size: Get.size.shortestSide < 600 ? 22 : 42,
                            ),
                            onPressed: () {
                              addC.hidePassword();
                            },
                          ),
                        ),
                        obscureText: addC.isHidePassword.value,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password tidak boleh kosong';
                          } else if (value.length < 8) {
                            return 'Tidak boleh kurang dari 8 karakter';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Obx(
                      () => SizedBox(
                        width: Get.size.width,
                        height: Get.size.shortestSide < 600 ? 45 : 75,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: addC.isLoading.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator())
                              : AppText.labelBold(
                                  "Masuk",
                                  16,
                                  Colors.white,
                                ),
                          onPressed: addC.isLoading.value
                              ? null
                              : () => addC.fnAddKaryawan(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
