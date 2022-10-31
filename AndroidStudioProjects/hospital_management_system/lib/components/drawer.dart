import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class CDM {
  //complex drawer menu
  final IconData icon;
  final String title;
  final List<String> submenus;

  CDM(this.icon, this.title, this.submenus);
}

class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({Key? key}) : super(key: key);

  @override
  State<ComplexDrawer> createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {

  int selectedIndex = -1;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: row(),
    );
  }

  Widget row(){
    return Row(
        children: [
          Flexible(child: isExpanded? greenIconTiles():greenIconMenu()),
          invisibleSubMenus(),
        ],
    );
  }

  Widget greenIconTiles(){
    return Container(
      width: 250,
      color: Colors.green[900],
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
            itemCount: cdms.length,
            itemBuilder: (BuildContext context, int index) {
              //  if(index==0) return controlTile();


              CDM cdm = cdms[index];
              bool selected = selectedIndex == index;
              return ExpansionTile(

                  onExpansionChanged:(z){
                    String title = cdm.title;
                    Provider.of<DrawerNavigator>(context, listen: false).navigate('$title/');
                    setState(() {
                      selectedIndex = z?index:-1;
                    });
                  },
                  leading: Icon(cdm.icon,color: Colors.white, size: 20,),
                  title: PrimaryText(
                    text:cdm.title,
                    color: Colors.white,
                    size: 15,
                  ),
                  trailing: cdm.submenus.isEmpty? null :

                  Icon(selected?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  children: cdm.submenus.map((subMenu){
                    return sMenuButton(cdm.title ,subMenu, false);
                  }).toList()
              );
            },
          ),
          ),
        ],
      ),
    );
  }

  Widget greenIconMenu(){
    return AnimatedContainer(
      duration: const Duration(seconds:1),
      width: 100,
      color: Colors.green[900],
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
                itemCount: cdms.length,
                itemBuilder: (context, index){
                  // if(index==0) return controlButton();
                  return InkWell(
                    onTap: (){
                      String title = cdms[index].title;
                      Provider.of<DrawerNavigator>(context, listen: false).navigate('$title/');
                      setState(() {
                        selectedIndex = index;
                      });

                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Icon(cdms[index].icon,color: Colors.white),
                    ),
                  );
                }
            ),
          ),

        ],
      ),
    );
  }

  Widget controlButton(){
    return Padding(
      padding: const EdgeInsets.only(top:20,bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/hospicon.svg'),
        ),
      ),
    );
  }

  Widget controlTile(){
    return Padding(
      padding: const EdgeInsets.only(top:20,bottom: 30),
      child: ListTile(
        leading: SizedBox(width: 30, child: SvgPicture.asset('assets/hospicon.svg'),),
        title: const PrimaryText(
          text: "Hope & Charity",
          size: 17,
          color: Colors.white,
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget invisibleSubMenus(){
    // List<CDM> _cmds = cdms..removeAt(0);
    return AnimatedContainer(
      duration: const Duration(milliseconds:500),
      width: isExpanded? 0:125,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(height:95),
          Expanded(
            child: ListView.builder(

                itemCount: cdms.length,
                itemBuilder: (context, index){
                  CDM cmd = cdms[index];
                  // if(index==0) return Container(height:95);
                  //control button has 45 h + 20 top + 30 bottom = 95

                  bool selected = selectedIndex==index;
                  bool isValidSubMenu = selected && cmd.submenus.isNotEmpty;
                  return subMenuWidget([cmd.title]..addAll(cmd.submenus) ,isValidSubMenu);
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget subMenuWidget(List<String> submenus,bool isValidSubMenu){
    return AnimatedContainer(
      duration: const Duration(milliseconds:500),
      height: isValidSubMenu? submenus.length.toDouble() *37.5 : 45,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color:isValidSubMenu? Colors.green[900]:
          Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight:  Radius.circular(8),
          )
      ),
      child: ListView.builder(

          padding: const EdgeInsets.all(6),
          itemCount: isValidSubMenu? submenus.length:0,
          itemBuilder: (context,index){
            String subMenu = submenus[index];
            return sMenuButton(submenus[0], subMenu, index==0);
          }
      ),
    );
  }


  Widget sMenuButton(String menu, String subMenu,bool isTitle){
    return InkWell(
      onTap: (){
        if(subMenu==menu) {
          subMenu = '';
        }
        //handle the function
        Provider.of<DrawerNavigator>(context, listen: false).navigate('$menu/$subMenu') ;
      },

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PrimaryText(
          text: subMenu,
          color: Colors.white,
          fontWeight: isTitle? FontWeight.bold: FontWeight.normal,
          size:  isTitle?15:13,
        ),
      ),
    );
  }

  static List<CDM> cdms = [
    // CDM(Icons.grid_view, "Control", []),

    CDM(Icons.grid_view, "Dashboard", []),
    CDM(Icons.money, "Caisse", ["Depenses", "Recettes","Factures", "Magasin", "Clinique"]),
    CDM(Icons.local_pharmacy, "Pharmacie", ["Sorties","Entrees","Clients"]),
    CDM(Icons.biotech, "Laboratoire", []),
    CDM(Icons.bed, "Hospitalisation", []),

    CDM(Icons.pregnant_woman, "Maternité", []),
    CDM(Icons.health_and_safety, "Infirmerie", []),
    CDM(Icons.assessment, "Consultation", []),
    CDM(Icons.warehouse, "Magasin", []),
  ];

  void expandOrShrinkDrawer(){
    setState(() {
      isExpanded = !isExpanded;
    });
  }

}
