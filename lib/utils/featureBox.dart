import 'package:flutter/material.dart';

import '../constants/colors.dart';

class FeatureBox extends StatefulWidget {
  final Color colorF;
  String headerText;
  String DecriptionText;
   FeatureBox({super.key,
     required this.colorF,
     required this.headerText,
   required this.DecriptionText
   });

  @override
  State<FeatureBox> createState() => _FeatureBoxState();
}

class _FeatureBoxState extends State<FeatureBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: widget.colorF,
            borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 15,
          bottom: 20
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
            left: 15,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.headerText,
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              SizedBox(height: 4,),
              Text(widget.DecriptionText,
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,

                ),),
            ],
          ),
        ),
      ),
    );
  }
}
