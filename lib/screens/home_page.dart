import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:papertracker/config/constants.dart';
import 'package:papertracker/models/track.dart';
import 'package:papertracker/widgets/custom_dropdown/custom_drop_down_stream.dart';
import 'package:papertracker/widgets/form_card.dart';
import 'package:papertracker/widgets/rounded_button.dart';
import 'package:papertracker/widgets/track_drop_down/track_drop_down_stream.dart';
import 'package:progress_dialog/progress_dialog.dart';

final _firestore = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Track currentTrack;
  bool isButtonDisabled = false;

  void _disableButton() {
    setState(() {
      isButtonDisabled = true;
    });
  }

  void _enableButton() {
    setState(() {
      isButtonDisabled = false;
    });
  }

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
    ProgressDialog dialog = ProgressDialog(context, isDismissible: false);

    final snapshot = await _firestore
        .collection(kFirestoreTracksCollectionName)
        .where('no', isEqualTo: currentTrack?.no)
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
        'currentPaper': currentTrack?.currentPaper,
        'nextPaper': currentTrack?.nextPaper,
      },
    ).then((value) async {
      _enableButton();
      await dialog.hide();
      print("Successfully updated track.");
      await _makeToast("Successfully updated track.", false);
    }, onError: (e) async {
      _enableButton();
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
        title: Center(child: Text('Pratibha 2020 - Organizer')),
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
                          child: TrackDropDownStream(
                            _firestore
                                .collection(kFirestoreTracksCollectionName)
                                .snapshots(),
                            currentTrack: currentTrack,
                            hintText: 'Select the track',
                            defaultText: 'No tracks available',
                            onChangeCallback: (track) {
                              setState(() {
                                currentTrack = track;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: FormCard(
                          headerText: 'Current Paper',
                          child: CustomDropDownStream(
                            _firestore
                                .collection(kFirestorePapersCollectionName)
                                .where('trackNo',
                                    isEqualTo: currentTrack?.no ?? -1)
                                .snapshots(),
                            currentValue: currentTrack?.currentPaper,
                            fieldName: 'name',
                            hintText: 'Select the current paper',
                            defaultText: 'No papers available',
                            noneValue: 'None',
                            onChangeCallback: (value) {
                              setState(() {
                                currentTrack?.currentPaper = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: FormCard(
                          headerText: 'Next Paper',
                          child: CustomDropDownStream(
                            _firestore
                                .collection(kFirestorePapersCollectionName)
                                .where('trackNo',
                                    isEqualTo: currentTrack?.no ?? -1)
                                .snapshots(),
                            currentValue: currentTrack?.nextPaper,
                            fieldName: 'name',
                            hintText: 'Select the next paper',
                            defaultText: 'No papers available',
                            noneValue: 'None',
                            onChangeCallback: (value) {
                              setState(() {
                                currentTrack?.nextPaper = value;
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
                onPressedCallback: !isButtonDisabled
                    ? () async {
                        if (currentTrack == null) {
                          await _makeToast('Please select a track', true);
                          return;
                        }
                        if (currentTrack.currentPaper == null) {
                          await _makeToast(
                              'Please select a current paper', true);
                          return;
                        }
                        if (currentTrack.nextPaper == null) {
                          await _makeToast('Please select a next paper', true);
                          return;
                        }

                        _disableButton();
                        await _submitTrack();
                      }
                    : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
