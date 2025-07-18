import 'package:flutter/material.dart';
import 'package:stayzi_ui/screens/search/search_filter_screen.dart';

class CustomSearchAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSearchAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  // AppBar'ın yüksekliğini ayarlamak için kullanılır. 70px ayarladık. istersek değişebilir.
  //Ayrıca bunu search_screen üzerinde ancak prefferdSizeWidget ile kullanabiliriz.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.white,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      SearchFilterScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.black),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Start your search',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
