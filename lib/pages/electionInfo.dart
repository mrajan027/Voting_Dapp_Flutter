import 'package:flutter/material.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String ElectionName;
  const ElectionInfo(
      {Key? key, required this.ethClient, required this.ElectionName})
      : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  bool reset = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ElectionName + " Election"),
      ),
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: getCandidatesNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data!.toString(),
                            style: TextStyle(
                                fontSize: 50.0, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text("Total Candidates")
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data!.toString(),
                            style: TextStyle(
                                fontSize: 50.0, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text("Total Votes")
                  ],
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration:
                        InputDecoration(hintText: "Enter Candidate Name"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      addCandidate(
                          addCandidateController.text, widget.ethClient);
                    },
                    child: Text("Add Candidate"))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration:
                        InputDecoration(hintText: "Enter Voter Address"),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      authorizeVoter(
                          authorizeVoterController.text, widget.ethClient);
                    },
                    child: Text("Add Voter"))
              ],
            ),
            Divider(),
            FutureBuilder<List>(
                future: getCandidatesNum(widget.ethClient),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                            future: candidateInfo(i, widget.ethClient),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListTile(
                                  title: Text("Name: " +
                                      snapshot.data![0][0].toString()),
                                  subtitle: Text('Votes: ' +
                                      snapshot.data![0][1].toString()),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      vote(i, widget.ethClient);
                                    },
                                    child: Text("Vote"),
                                  ),
                                );
                              }
                            })
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
