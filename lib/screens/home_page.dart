import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papertracker/config/constants.dart';
import 'package:papertracker/widgets/drop_down_stream.dart';
import 'package:papertracker/widgets/rounded_button.dart';

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
                  elevation: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Track no.'),
                              DropDownStream(
                                _firestore
                                    .collection(kFirestoreTracksCollectionName)
                                    .snapshots(),
                                currentValue: trackNo,
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
                                _firestore
                                    .collection(kFirestorePapersCollectionName)
                                    .snapshots(),
                                currentValue: currentPaper,
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
                                _firestore
                                    .collection(kFirestorePapersCollectionName)
                                    .snapshots(),
                                currentValue: nextPaper,
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
