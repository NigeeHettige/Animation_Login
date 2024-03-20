
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandup, isChecking;
  SMINumber? numLock;
  StateMachineController? stateMachineController;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    animationURL =
        'assets/animated_login_character.riv';
    rootBundle.load(animationURL).then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(artBoard, 'Login Machine');

      if (stateMachineController != null) {
        artBoard.addController(stateMachineController!);

        stateMachineController!.inputs.forEach((element) {
          debugPrint(element.runtimeType.toString());
          debugPrint("name${element.name}End");
        });

        stateMachineController!.inputs.forEach((element) {
          if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == 'trigFail') {
            failTrigger = element as SMITrigger;
          } else if (element.name == 'isHandsUp') {
            isHandup = element as SMIBool;
          } else if (element.name == 'isChecking') {
            isChecking = element as SMIBool;
          } else if (element.name == 'numLook') {
            numLock = element as SMINumber;
          }
        });
      }

      setState(() {
        _teddyArtboard = artBoard;
      });
    });
    super.initState();
  }

  void handsOnTheEye() {
    isHandup?.change(true);
  }

  void lookOnTheField() {
    isHandup?.change(false);
    isChecking?.change(true);
    numLock?.change(0);
  }

  void moveEyeBall(value) {
    numLock?.change(value.length.toDouble());
  }

  void login() async{
    await isChecking?.change(false);
    await isHandup?.change(false);
    if (_email.text == 'user' && _password.text == 'user123') {
      successTrigger?.fire();
     
    }else{
      failTrigger?.fire();
    }

     setState(() {
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_teddyArtboard != null)
              SizedBox(
                width: 400,
                height: 300,
                child: Rive(
                  artboard: _teddyArtboard!,
                  fit: BoxFit.fitWidth,
                ),
              ),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 211, 210, 209)),
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      border: InputBorder.none,
                    ),
                    onTap: lookOnTheField,
                    onChanged: moveEyeBall,
                  ),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    onTap: handsOnTheEye,
                  ),
                  ElevatedButton(onPressed: login, child: const Text("Login"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
