import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/token_preferences.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:provider/provider.dart';

class AppBarActionItems extends StatelessWidget {
  const AppBarActionItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        const SizedBox(width: 15),
        Row(children: [
          PopupMenuButton(
              icon: Consumer<AuthProvider>(builder: (_, state, __) => CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(
                    state.user!.photoUrl ?? 'https://png.pngtree.com/element_our/20190529/ourmid/pngtree-user-icon-image_1187018.jpg'
                ),
              )),
              itemBuilder: (context) => [
                PopupMenuItem<int>(enabled: false, value: 0, child: Text('${Provider.of<AuthProvider>(context, listen: false).user!.displayName}')),
                const PopupMenuItem<int>(value: 0, child: Text("Profil")),
                const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Privacy Policy page")
                ),
                const PopupMenuItem(child: PopupMenuDivider(height: 2,),),
                PopupMenuItem<int>(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Logout")
                      ],
                    ),
                    onTap: ()async => Provider.of<AuthProvider>(context, listen: false).logout(),
                ),
              ],
              onSelected: (item) => print(item),
          ),
          const Icon(Icons.arrow_drop_down_outlined, color: AppColors.black)
        ]),
      ],
    );
  }
}