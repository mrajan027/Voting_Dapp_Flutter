import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/pages/electionInfo.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:voting_dapp/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Election"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  filled: true, hintText: 'Enter Election Name'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(14.0),
              height: 80.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.text.length > 0) {
                    await startElection(controller.text, ethClient!);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ElectionInfo(
                                ethClient: ethClient!,
                                ElectionName: controller.text)));
                  }
                },
                child: Text("Start Election"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
