import 'package:flutter/material.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class ProfileEnfant extends StatelessWidget {
 final EnfantModel enfant;

  const ProfileEnfant({
    super.key,
    required this.enfant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
             title: Text("profil enfant"),
           ),
    );
  }
}