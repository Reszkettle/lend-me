import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/screens/home/home.dart';
import 'package:lendme/screens/other/add_item.dart';
import 'package:lendme/screens/other/history.dart';
import 'package:lendme/screens/other/item_details/item_details.dart';
import 'package:lendme/screens/other/lent_qr.dart';
import 'package:lendme/screens/other/requests/request_screen.dart';
import 'package:lendme/screens/settings/change_theme.dart';
import 'package:lendme/screens/settings/credits.dart';
import 'package:lendme/screens/settings/delete_account.dart';
import 'package:lendme/screens/settings/edit_profile.dart';
import 'package:lendme/screens/settings/settings.dart';
import 'package:page_transition/page_transition.dart';

final GlobalKey<NavigatorState> mainNavigator = GlobalKey();

Route? mainRoutes(RouteSettings settings) {
  if(settings.name == '/') {
    return MaterialPageRoute(builder: (context) {return const Home();});
  }
  else if(settings.name == '/settings') {
    return PageTransition(child: Settings(), type: PageTransitionType.rightToLeft);
  }
  else if(settings.name == '/edit_profile') {
    return MaterialPageRoute(builder: (context) {return const EditProfile();});
  }
  else if(settings.name == '/credits') {
    return MaterialPageRoute(builder: (context) {return const Credits();});
  }
  else if(settings.name == '/change_theme') {
    return MaterialPageRoute(builder: (context) {return const ChangeTheme();});
  }
  else if(settings.name == '/add_item') {
    return MaterialPageRoute(builder: (context) {return const AddItem();});
  }
  else if(settings.name == '/item_details') {
    var itemId = settings.arguments! as String;
    return MaterialPageRoute(builder: (context) {return ItemDetails(itemId: itemId);});
  }
  else if(settings.name == '/history') {
    var item = settings.arguments! as Item;
    return PageTransition(child: History(item: item), type: PageTransitionType.fade);
  }
  else if(settings.name == '/lent_qr') {
    var item = settings.arguments! as Item;
    return PageTransition(child: LentQr(item: item), type: PageTransitionType.fade);
  }
  else if(settings.name == '/request') {
    var requestId = settings.arguments! as String;
    return MaterialPageRoute(builder: (context) {return RequestScreen(requestId: requestId);});
  }
  else if(settings.name == '/delete') {
    return MaterialPageRoute(builder: (context) {return DeleteAccount();});
  }
}