import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_mobile/blocs/search/search_bloc.dart';
import 'package:streaming_mobile/blocs/search/search_event.dart';
import 'package:streaming_mobile/core/app/size_configs.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(350),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
          onChanged: (value) {
            if (value != '') {
              BlocProvider.of<SearchBloc>(context)
                  .add(Search(searchKey: value, searchIn: SearchIn.SONGS));
              BlocProvider.of<SearchBloc>(context)
                  .add(SetCurrentKey(currentKey: value));
            } else {
              BlocProvider.of<SearchBloc>(context)
                  .add(SetCurrentKey(currentKey: value));
              BlocProvider.of<SearchBloc>(context).add(ExitSearch());
            }
          },
          textInputAction: TextInputAction.search,
          // textAlign: TextAlign.left,

          decoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.search,
                color: Colors.grey.withOpacity(0.6),
              ),
            ),
            hintStyle: TextStyle(fontSize: 14, color: Color(0x882D2D2D)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search Songs, Albums, Artists, Playlist",
            // prefixIcon: SvgPicture.asset(
            //   'assets/svgs/search.svg',
            //   fit: BoxFit.cover,
            //   color: Color(0x882D2D2D),
            // ),
            suffixIcon: Container(
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                'assets/svgs/filter.svg',
                color: Colors.grey,
                fit: BoxFit.scaleDown,
              ),
            ),
          )),
    );
  }
}
