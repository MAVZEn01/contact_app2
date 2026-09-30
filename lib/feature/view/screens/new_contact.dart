import 'package:contact_app2/feature/data/models/contact_user.dart';
import 'package:contact_app2/feature/view/widget/app_dialog.dart';
import 'package:contact_app2/firebase/firebase_service.dart';
import 'package:contact_app2/helper/custom_matrial_button.dart';
import 'package:contact_app2/helper/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key, this.contactUser});

  final ContactUser? contactUser;

  @override
  State<NewContact> createState() => _AddTaskState();
}

class _AddTaskState extends State<NewContact> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contactUser?.name ?? "";
    phoneController.text = widget.contactUser?.phone ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.contactUser == null ? "Add New Contact" : "Edit Contact",
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                label: "Name",
                hint: "Enter Name",
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter a name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: "Phone Number",
                hint: "Enter Phone Number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter a phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomMaterialButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  var name = nameController.text;
                  var phone = phoneController.text;
                  AppDialog.showLoading(context);

                  try {
                    var contactUser = ContactUser(name: name, phone: phone);
                    if (widget.contactUser == null) {
                      await firebaseService.addUser(contactUser);
                    } else {
                      await firebaseService.update(
                        ContactUser(
                          id: widget.contactUser!.id,
                          name: name,
                          phone: phone,
                        ),
                      );
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    AppDialog.showError(context, e.toString());
                  }
                },
                text: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
