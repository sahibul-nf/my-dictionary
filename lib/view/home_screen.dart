import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dictionary/controller/color.dart';
import 'package:my_dictionary/model/nabi_rasul_model.dart';

class HomeScreen extends StatefulWidget {
  final FaIcon icon;
  final Color iconColor;
  final String title;


  HomeScreen({this.title, this.icon, this.iconColor});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List dataList;
  List filterList;

  var searchC = TextEditingController();
  bool isSearch = true;
  String query = "";

  @override
  void initState() {
    super.initState();

    dataList = new List<String>();
  }

  data() => NabiRasul.getData().then((value) {
        dataList = new List<String>();
        // List<String> b = [];
        for (var i = 0; i < value.length; i++) {
          var s = value[i].name;
          var f = value[i].id;
          // print(s);
          // b.add(s);
          // f + '\t\t\t' +
          dataList.add(f + '    ' + s);
          // print(dataList);
        }
        return dataList;
      });

  _HomeScreenState() {
    searchC.addListener(() {
      if (searchC.text.isEmpty) {
        setState(() {
          isSearch = false;
          query = "";
        });
      } else {
        setState(() {
          isSearch = true;
          query = searchC.text;
        });
      }
    });
  }

  Widget filterListResult() {
    dataFilter() => data().then((value) {
          filterList = new List<String>();
          for (var i in value) {
            var item = i;
            if (item.toLowerCase().contains(query.toLowerCase())) {
              filterList.add(item);
              // filterList.addAll(item);
            }
          }
          return filterList;
        });

    return Flexible(
        child: FutureBuilder(
            future: dataFilter(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 10),
                      decoration: BoxDecoration(
                        color: MyColor().color5,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: ListView.builder(
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                  color: MyColor().color4,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Text(filterList[index],
                                  style: GoogleFonts.sourceSansPro(
                                      color: MyColor().color1, fontSize: 16)));
                        },
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 24, right: 24, top: 10),
                      decoration: BoxDecoration(
                        color: MyColor().color5,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: MyColor().color4,
                        ),
                      ),
                    );
            }));
  }

  Widget getData() {
    return Flexible(
      child: FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? itemList(list: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget itemList({list}) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 10),
      decoration: BoxDecoration(
        color: MyColor().color5,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                  color: MyColor().color4,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(list[index],
                  style: GoogleFonts.sourceSansPro(
                      color: MyColor().color1, fontSize: 16)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().color2,
      body: Column(
        children: [_banner(), isSearch ? filterListResult() : getData()],
      ),
    );
  }

  Widget _banner() {
    return Container(
      decoration: BoxDecoration(
          color: MyColor().color2,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0))),
      height: 250,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '313',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: MyColor().color4),
          ),
          SizedBox(height: 2),
          Text(
            'Nabi & Rasul',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserratAlternates(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: MyColor().color4),
          ),
          Container(
            decoration: BoxDecoration(
                color: MyColor().color5,
                borderRadius: BorderRadius.circular(30)),
            margin:
                const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 30),
            child: TextField(
              controller: searchC,
              style: GoogleFonts.sourceSansPro(
                  fontSize: 16, color: MyColor().color1),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: MyColor().color1,
                  ),
                  hintStyle: GoogleFonts.sourceSansPro(fontSize: 16),
                  hintText: 'Search',
                  border: InputBorder.none),
            ),
          ),
        ],
      )),
    );
  }
}
