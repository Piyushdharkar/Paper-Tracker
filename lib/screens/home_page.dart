import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papertracker/config/constants.dart';

final _firestore = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int trackNo = 1;
  String trackName = 'Machine Learning';
  String currentPaper = 'CNN';
  String nextPaper = 'CNN';

  Future<void> _submitTrack() async {
    final snapshot = await _firestore
        .collection(kFirestoreTracksCollectionName)
        .where('no', isEqualTo: trackNo)
        .getDocuments();
    String documentId = snapshot.documents[0].documentID;
    await _firestore
        .collection(kFirestoreTracksCollectionName)
        .document(documentId)
        .updateData(
      {
        'currentPaper': currentPaper,
        'nextPaper': nextPaper,
      },
    ).then((value) {
      print("Successfully updated track.");
    }, onError: (e) {
      print("Error! Failure to update track.");
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Track no.'),
                              DropDownStream(
                                currentValue: trackNo,
                                collectionName: kFirestoreTracksCollectionName,
                                fieldName: 'no',
                                field2Name: 'name',
                                onChangeCallback: (value, name) {
                                  setState(() {
                                    trackNo = value;
                                    trackName = name;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Current Paper'),
                              DropDownStream(
                                currentValue: currentPaper,
                                collectionName: kFirestorePapersCollectionName,
                                fieldName: 'name',
                                onChangeCallback: (value, name) {
                                  setState(() {
                                    currentPaper = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Next Paper'),
                              DropDownStream(
                                currentValue: nextPaper,
                                collectionName: kFirestorePapersCollectionName,
                                fieldName: 'name',
                                onChangeCallback: (value, name) {
                                  setState(() {
                                    nextPaper = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundButton(
                text: 'SUBMIT',
                onPressedCallback: () async {
                  await _submitTrack();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton({this.text, this.onPressedCallback});

  final String text;
  final Function onPressedCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      elevation: 10.0,
      color: Colors.lightBlueAccent,
      child: FlatButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        onPressed: () {
          onPressedCallback();
        },
      ),
    );
  }
}

class DropDownStream<T, U> extends StatelessWidget {
  DropDownStream(
      {@required this.currentValue,
      this.currentName,
      @required this.collectionName,
      @required this.fieldName,
      this.field2Name,
      this.onChangeCallback});

  final T currentValue;
  final U currentName;
  final String collectionName;
  final String fieldName;
  final String field2Name;
  final Function onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        final List<T> itemList = [];
        final Map<T, U> map = field2Name == null ? null : {};
        final items = snapshot.data.documents;
        for (var item in items) {
          T value = item.data[fieldName];
          if (field2Name != null) {
            U name = item.data[field2Name];
            map[value] = name;
          }
          itemList.add(value);
        }
        itemList.sort();
        return DropDownRow(
          currentValue: currentValue,
          items: itemList,
          map: map,
          onChangeCallback: (value, name) {
            onChangeCallback(value, name);
          },
        );
      },
    );
  }
}

class DropDownRow<T, U> extends StatelessWidget {
  DropDownRow(
      {@required this.currentValue,
      @required this.items,
      this.map,
      this.onChangeCallback});

  final T currentValue;
  final List<T> items;
  final Map<T, U> map;
  final Function onChangeCallback;

  DropdownMenuItem<T> _buildDropDownMenuItem(T item) {
    String name = '';

    if (map != null) {
      name = '. ${map[item].toString()}';
    }

    return DropdownMenuItem(
      child: Text('${item.toString()}$name'),
      value: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: true,
      value: currentValue,
      items: items.map(_buildDropDownMenuItem).toList(),
      onChanged: (value) {
        U name;
        if (map != null) {
          name = map[value];
        }
        print(value);
        onChangeCallback(value, name);
      },
    );
  }
}
