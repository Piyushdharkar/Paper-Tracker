import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papertracker/config/constants.dart';
import 'package:papertracker/widgets/drop_down_stream.dart';
import 'package:papertracker/widgets/form_card.dart';
import 'package:papertracker/widgets/rounded_button.dart';
import 'package:progress_dialog/progress_dialog.dart';

final _firestore = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int trackNo;
  String trackName;
  String currentPaper;
  String nextPaper;

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
    ProgressDialog dialog = ProgressDialog(context);

    final snapshot = await _firestore
        .collection(kFirestoreTracksCollectionName)
        .where('no', isEqualTo: trackNo)
        .getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;

    if (documents.length < 1) {
      await _makeToast('Error! Track not found.', true);

      return;
    }

    if (documents.length > 1) {
      await _makeToast('Error! Duplicate track no. found.', true);

      return;
    }

    String documentId = documents[0].documentID;

    await dialog.show();

    await _firestore
        .collection(kFirestoreTracksCollectionName)
        .document(documentId)
        .updateData(
      {
        'currentPaper': currentPaper,
        'nextPaper': nextPaper,
      },
    ).then((value) async {
      await dialog.hide();
      print("Successfully updated track.");
      await _makeToast("Successfully updated track.", false);
    }, onError: (e) async {
      await dialog.hide();
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: FormCard(
                          headerText: 'Track',
                          child: DropDownStream(
                            _firestore
                                .collection(kFirestoreTracksCollectionName)
                                .snapshots(),
                            currentValue: trackNo,
                            fieldName: 'no',
                            field2Name: 'name',
                            hintText: 'Select the track',
                            onChangeCallback: (value, name) {
                              setState(() {
                                trackNo = value;
                                trackName = name;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: FormCard(
                          headerText: 'Current Paper',
                          child: DropDownStream(
                            _firestore
                                .collection(kFirestorePapersCollectionName)
                                .snapshots(),
                            currentValue: currentPaper,
                            fieldName: 'name',
                            hintText: 'Select the current paper',
                            onChangeCallback: (value, name) {
                              setState(() {
                                currentPaper = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: FormCard(
                          headerText: 'Next Paper',
                          child: DropDownStream(
                            _firestore
                                .collection(kFirestorePapersCollectionName)
                                .snapshots(),
                            currentValue: nextPaper,
                            fieldName: 'name',
                            hintText: 'Select the next paper',
                            onChangeCallback: (value, name) {
                              setState(() {
                                nextPaper = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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
