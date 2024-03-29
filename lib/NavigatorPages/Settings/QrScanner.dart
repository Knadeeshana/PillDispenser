import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:pill_dispensor/Services/Services.dart';
import 'package:pill_dispensor/globals.dart' as globals;
import 'dart:math';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String qrAction = "* Scan the QR Code on Dispenser to link your device.";
  var qrResult;
  String qrError = "";

  Future _scanQR() async {
    try {
      String devId = globals.deviceID; //retrieve if any device number is linked
      if (devId != "#") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifiedDevice(devId)));
      } else {
        var scan = await BarcodeScanner.scan();
        if (scan.rawContent != "") {
          //Remove the hard coded random number and uncomment above lines for QR code scanner
          //Random random = new Random();
          //String randomNumber = (random.nextInt(100) + 123000).toString();

          String randomNumber = scan.rawContent;
          print(randomNumber);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifiedDevice(randomNumber)));
        }
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          qrError = "Camera permission was denied";
        });
      }
    } catch (e) {
      setState(() {
        qrError = "Unknown Error !";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scan Device"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
              image: AssetImage('images/scan.png'),
            ),
            FlatButton(
              onPressed: _scanQR,
              child: Text("Scan Device QR Code "),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.teal, width: 3)),
            ),
            Center(
                child: Text("$qrAction",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic))),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text("$qrError",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red)))
          ],
        ),
      ),
    );
  }
}

// Page to show the status of device verification once scanning is done.
class VerifiedDevice extends StatelessWidget {
  final String deviceId;
  VerifiedDevice(this.deviceId);
  @override
  Widget build(BuildContext context) {
    print(deviceId);
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(50),
          child: Center(
            child: FutureBuilder<DeviceVerifier>(
                future: registerDevice(deviceId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String _devicestate;
                    //globals.deviceId=snapshot.data.
                    if (snapshot.data.registration == "success") {
                      globals.deviceID = (snapshot.data.deviceId);
                      _devicestate =
                          "Your Dispenser is Linked and Functionality Activated";
                    } else if (snapshot.data.availableEmail != " ") {
                      _devicestate =
                          "This Dispenser is already linked to ${snapshot.data.availableEmail}. Contact Support for More Information";
                    } else {
                      _devicestate = "Invalid QR Code, Try again";
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _devicestate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            child: Text(
                                (snapshot.data.registration) == "success"
                                    ? "Continue"
                                    : "Back"),
                          ),
                          onPressed: () {
                            (snapshot.data.registration) == "success"
                                ? Navigator.popAndPushNamed(
                                    context, '/navigator')
                                : Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.teal, width: 3)),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                }),
          )),
    );
  }
}
