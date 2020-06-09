import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papertracker/config/constants.dart';
import 'package:papertracker/widgets/drop_down_stream.dart';
import 'package:papertracker/widgets/header_text.dart';
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

  Future<void> _makeToast(String message, bool error) async {
    await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: error ? Colors.red : Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
    ).then((value) async {
      print("Successfully updated track.");
      await _makeToast("Successfully updated track.", false);
    }, onError: (e) async {
      print("Error! Failure to update track.");
      print(e);
      await _makeToast("Error! Failure to update track.", true);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 50.0,
                  ),
                  child: Card(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText(text: 'Track'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropDownStream(
                                  _firestore
                                      .collection(
                                          kFirestoreTracksCollectionName)
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText(text: 'Current paper'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropDownStream(
                                  _firestore
                                      .collection(
                                          kFirestorePapersCollectionName)
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText(text: 'Next paper'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropDownStream(
                                  _firestore
                                      .collection(
                                          kFirestorePapersCollectionName)
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
