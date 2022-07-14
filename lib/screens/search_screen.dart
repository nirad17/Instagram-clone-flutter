import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.search),
        backgroundColor: mobileSearchColor,

        title: TextField(
          controller: _searchController,
          onSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUser = true;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search',
            // focusColor: primaryColor,
            fillColor: primaryColor,
            icon: Icon(Icons.search),
            suffix: IconButton(onPressed: () {
              _searchController.text="";
            }, icon: Icon(Icons.close, color: Colors.white54,)),
            border: InputBorder.none,
            // OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: _searchController.text)
            .orderBy('username', descending: false)
            .get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return isShowUser
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: snapshot.data!.docs[index]['uid']),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['photoURL'])),
                      title: Text(
                        snapshot.data!.docs[index]['username'],
                      ),
                    );
                  },
                )
              : FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          Image.network(snapshot.data!.docs[index]['postUrl']),
                      staggeredTileBuilder: (index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1,
                        (index % 7 == 0) ? 2 : 1,
                      ),
                      mainAxisSpacing: 8,
                    );
                  });
        },
      ),
    );
  }
}
