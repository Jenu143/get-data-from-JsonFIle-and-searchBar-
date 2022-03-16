import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetDataAndSearch extends StatefulWidget {
  const GetDataAndSearch({Key? key}) : super(key: key);

  @override
  _GetDataAndSearchState createState() => _GetDataAndSearchState();
}

class _GetDataAndSearchState extends State<GetDataAndSearch> {
  TextEditingController controller = TextEditingController();

  final String url = 'assets/EmployeeData.json';

  // Get json result and convert it to model. Then add

  Future<void> readJson() async {
    final response = await rootBundle.loadString(url);

    final data = await json.decode(response);

    setState(() {
      _userDetails = data;
    });
  }

  onSearchTextChanged(String text) async {
    serachData.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach(
      (data) {
        if (data.toString().contains(text.toLowerCase().toString())) {
          serachData.add(
            data,
          ); // If not empty then add search data into search data list
        }
      },
    );

    setState(() {});
    print("userDetails : ${_userDetails}");
    print("searchData : ${serachData}");
  }

  List<dynamic> serachData = [];

  List<dynamic> _userDetails = [];

  @override
  void initState() {
    super.initState();

    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Get Data From Json File',
            style: TextStyle(fontSize: 14),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: SizedBox(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            controller.text.isEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _userDetails.length,
                      itemBuilder: (context, i) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          elevation: 4,
                          color: Colors.green.shade100,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                TextWithName(
                                  name: "ID : ",
                                  text: "${_userDetails[i]["id"].toString()}",
                                ),
                                SizedBox(height: 5),
                                TextWithName(
                                  name: "NAME : ",
                                  text: "${_userDetails[i]["name"].toString()}",
                                ),
                                SizedBox(height: 5),
                                TextWithName(
                                    name: "EMAIL : ",
                                    text: "${_userDetails[i]["email"]}"),
                                SizedBox(height: 5),
                                TextWithName(
                                    name: "PASSWORD : ",
                                    text: "${_userDetails[i]["password"]}"),
                                SizedBox(height: 5),
                                TextWithName(
                                    name: "LOCATION : ",
                                    text: "${_userDetails[i]["location"]}"),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: serachData.isNotEmpty
                        ? ListView.builder(
                            itemCount: serachData.length,
                            itemBuilder: (context, i) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                elevation: 4,
                                color: Colors.green.shade100,
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      TextWithName(
                                        name: "ID : ",
                                        text:
                                            "${serachData[i]["id"].toString()}",
                                      ),
                                      SizedBox(height: 5),
                                      TextWithName(
                                        name: "NAME : ",
                                        text:
                                            "${serachData[i]["name"].toString()}",
                                      ),
                                      SizedBox(height: 5),
                                      TextWithName(
                                          name: "EMAIL : ",
                                          text: "${serachData[i]["email"]}"),
                                      SizedBox(height: 5),
                                      TextWithName(
                                          name: "PASSWORD : ",
                                          text: "${serachData[i]["password"]}"),
                                      SizedBox(height: 5),
                                      TextWithName(
                                          name: "LOCATION : ",
                                          text: "${serachData[i]["location"]}"),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Sorry, Your Search Not Found!",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 0.4,
                                wordSpacing: 2,
                              ),
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TextWithName extends StatelessWidget {
  const TextWithName({
    Key? key,
    required this.text,
    required this.name,
  }) : super(key: key);

  final String text;
  final String name;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: name,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
        children: [
          TextSpan(
              text: text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.amber.shade900,
              ))
        ],
      ),
    );
  }
}
