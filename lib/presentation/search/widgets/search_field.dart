import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getHeight(15)),
      child: Container(
        width: getWidth(350),
        decoration: BoxDecoration(
          color: Color(0x227521D5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextField(
            onChanged: (value) => print(value),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getWidth(6), vertical: getHeight(14)),
              hintStyle: TextStyle(fontSize: 14, color: Color(0x882D2D2D)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Search Songs, Albums, Artists",
              prefixIcon: SvgPicture.asset(
                'assets/svgs/search.svg',
                fit: BoxFit.scaleDown,
                color: Color(0x882D2D2D),
              ),
              suffixIcon: Container(
                width: 16,
                height: 16,
                child: SvgPicture.asset(
                  'assets/svgs/filter.svg',
                  color: Color(0xCC741855),
                  fit: BoxFit.scaleDown,
                ),
              ),
            )),
      ),
    );
  }
}
