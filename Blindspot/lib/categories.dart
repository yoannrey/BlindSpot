import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotify/spotify.dart' as prefix;
import 'main.dart';


class HomeNav extends StatefulWidget {
  final prefix.SpotifyApi client;
  HomeNav(this.client);
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {

  List<prefix.Category> _categories;
  String selected = '';
  @override
  void initState() {
    super.initState();
    final api = widget.client;
    final categories = api.categories.list().all().then((value) => value.toList());

    categories.then((categoriesTmp) {
      categoriesTmp.forEach((element) {
        SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          _categories = categoriesTmp;
          print ('coucou ' + _categories.length.toString());
        })
        );
      });
    });

  }

  Widget _buildCatList() {

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 2,
      children: List.generate(_categories.length, (index) {
        return Card(
          borderOnForeground: selected == _categories[index].id,
          semanticContainer: true,

          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            child: Stack(
              children: <Widget>[
                Image.network(_categories[index].icons.first.url,
                fit: BoxFit.fill,
                height: double.maxFinite,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(_categories[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ))
                  )

                )
              ],
            ),
            onTap: () {
              bool isSelected = selected == _categories[index].id;
              setState(() {
                if (isSelected) {
                  selected = '';
                }
                else {
                  selected =  _categories[index].id;
                }
              });
              // CATÉGORIE SELECTIONNÉE
            },
          ),
          shape: selected != _categories[index].id ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ) :
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Color(0xff1DB954),
              width: 3.0
            ),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    final infos = SpotifyContainer.of(context).myDetails;
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Liste de toutes les catégories : grid
          Expanded(
            child: _buildCatList(),
          )
          // Difficulté
          
          // Jouer
          
        ],
      ),
      backgroundColor: Color(0xff191414),
    );
  }
}