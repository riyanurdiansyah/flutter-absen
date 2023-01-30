import 'package:absensi_flutter/controllers/add_karyawan_c.dart';
import 'package:absensi_flutter/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_text.dart';

class AddKaryawanPage extends StatelessWidget {
  AddKaryawanPage({Key? key}) : super(key: key);

  final addKaryawanC = Get.find<AddKaryawanC>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: AppText.labelBold(
          "Tambah Data Karyawan",
          16,
          Colors.white,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Form(
            key: addKaryawanC.formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: addKaryawanC.tcNik,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      labelText: "Nomor Induk Karyawan",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Get.size.shortestSide < 600 ? 12 : 23),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(5)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.requiredField(value!,
                        errorMsg: "NIK Tidak Boleh Kosong")),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: addKaryawanC.tcNama,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    labelText: "Nama Lengkap",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Get.size.shortestSide < 600 ? 12 : 23),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => AppValidator.checkNama(value!),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: addKaryawanC.tcEmail,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    labelText: "Email Address",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Get.size.shortestSide < 600 ? 12 : 23),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => AppValidator.checkEmail(value!),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: addKaryawanC.tcHp,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    labelText: "No Handphone",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Get.size.shortestSide < 600 ? 12 : 23),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).errorColor),
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => AppValidator.requiredField(value!),
                ),
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => TextFormField(
                    controller: addKaryawanC.tcPassword,
                    keyboardType: TextInputType.name,
                    obscureText: addKaryawanC.isObsecure.value,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () => addKaryawanC.changeVisibilityPass(),
                        child: Icon(
                          addKaryawanC.isObsecure.value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      labelText: "Password",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Get.size.shortestSide < 600 ? 12 : 23),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(5)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.checkFieldPass(value!),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Obx(
                  () {
                    if (addKaryawanC.isLoading.value) {
                      return const Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => addKaryawanC.registerNewUser(),
                        child: AppText.labelBold(
                          "SIMPAN",
                          14,
                          Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
