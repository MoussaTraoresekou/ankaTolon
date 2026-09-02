import 'package:flutter/material.dart';

class ChampDefi extends StatelessWidget {

  final String label;

  final TextEditingController controller;

  final String? hint;

  final int maxLines;

  final TextInputType? keyboardType;

  const ChampDefi({

    super.key,

    required this.label,

    required this.controller,

    this.hint,

    this.maxLines = 1,

    this.keyboardType,
  });

  @override
  Widget build(
      BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style:
          const TextStyle(

            fontSize:
            13,

            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(
          height:
          7,
        ),

        TextField(

          controller:
          controller,

          maxLines:
          maxLines,

          keyboardType:
          keyboardType,

          decoration:
          InputDecoration(

            hintText:
            hint,

            hintStyle:
            const TextStyle(

              color:
              Colors.grey,

              fontSize:
              13,
            ),

            filled:
            true,

            fillColor:
            Colors.white,

            border:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                8,
              ),

              borderSide:
              BorderSide(
                color:
                Colors.grey.shade300,
              ),
            ),

            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                8,
              ),

              borderSide:
              BorderSide(
                color:
                Colors.grey.shade300,
              ),
            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                8,
              ),

              borderSide:
              const BorderSide(
                color:
                Color(0xFFE98219),
              ),
            ),

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal:
              12,

              vertical:
              12,
            ),
          ),
        ),
      ],
    );
  }
}