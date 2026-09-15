import '../controller/milk_controller.dart';
import 'package:flutter/material.dart';
import 'package:cattle_app/core/app_export.dart';

// ignore: must_be_immutable
class MilkItemWidget extends StatelessWidget {
  MilkItemWidget({
    required this.variant,
    required this.description,
    required this.name,
    required this.type,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  var controller = Get.find<MilkController>();

  bool variant;
  String name;
  String type;
  bool description;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
             BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  2.0,
                  2.0,
                ),
                blurRadius:3,
              ), //BoxShadow
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(variant == true
                    ? 'assets/images/cowImage.jpeg'
                    : "assets/images/bull.jpg"),
              ),
              Padding(
                padding: getPadding(
                  left: 10,
                ),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtOutfitBold15,
                ),
              ),
              Spacer(),
              Image(
                image: AssetImage(
                  type.toLowerCase() == "died"
                      ? 'assets/images/cow-death-icon .png'
                      : type.toLowerCase() == "donate"
                          ? 'assets/images/donate.png'
                          : variant == true
                              ? 'assets/images/gircow-r 1.png'
                              : 'assets/images/bullIcon.png',
                ),
                height: type.toLowerCase() == "died"
                    ? 41
                    : type.toLowerCase() == "donate"
                        ? 40
                        : variant == true
                            ? 35
                            : 40,
              ),
              SizedBox(
                width: type.toLowerCase() == "died"
                    ? 10
                    : type.toLowerCase() == "donate" || variant == false
                        ? 5
                        : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
