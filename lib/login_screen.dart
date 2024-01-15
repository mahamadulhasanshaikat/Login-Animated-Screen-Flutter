import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool hidden = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var animationLink = 'assets/animations_logins.riv';
  late SMITrigger trigSuccess, trigFail;
  late SMIBool isChecking, isHandsUp;
  late SMINumber numLook;
  Artboard? artBoard;
  late StateMachineController? stateMachineController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initArtBoard();
  }

  initArtBoard(){
    rootBundle.load(animationLink).then((value){
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController = StateMachineController.fromArtboard(art, "Login Machine");

      if(stateMachineController != null){
        art.addController(stateMachineController!);

        for(var element in stateMachineController!.inputs){
          if(element.name == "isChecking"){
            isChecking = element as SMIBool;

          } else if(element.name == "isHandsUp"){
            isHandsUp = element as SMIBool;

          } else if(element.name == "trigSuccess"){
            trigSuccess = element as SMITrigger;

          } else if(element.name == "trigFail"){
            trigFail = element as SMITrigger;

          } else if(element.name == "numLook"){
            numLook = element as SMINumber;
          }
        }
      }

      setState(() {
        artBoard = art;
      });

    });

  }

  checking(){
    isHandsUp.change(false);
    isChecking.change(true);
    numLook.change(0);
  }

  handsUp(){
    isHandsUp.change(true);
    isChecking.change(false);
  }

  moveEyes(value){
    numLook.change(value.length.toDouble());
  }


  login(){
    isHandsUp.change(false);
    isChecking.change(false);
    if(emailController.text == 'admin' && passwordController.text == 'admin'){
      trigSuccess.fire();
    }else{
      trigFail.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const SizedBox(height: 30*2,),

                  //artBoard
                  if(artBoard != null)
                    SizedBox(
                      width: 390,
                      height: 300,
                      child: Rive(artboard: artBoard!,
                        fit: BoxFit.cover,

                      ),
                    ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      TextFormField(
                        onTap:checking ,
                        onChanged: ((value) => moveEyes(value)),
                        controller: emailController,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Input email address',
                          //fillColor: Colors.white,
                          // filled: true,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 2)),
                        ),

                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onTap: handsUp ,
                        controller: passwordController,
                        obscureText: hidden,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Input password',
                          //fillColor: Colors.white,
                          // filled: true,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.blue,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                hidden = !hidden;
                              });
                            },
                            child: hidden
                                ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.blueAccent,
                            )
                                : const Icon(
                              Icons.visibility_outlined,
                              color: Colors.blueAccent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 2,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 2)),
                        ),
                      ),

                      const SizedBox(height: 20,),

                      ElevatedButton(
                        onPressed: () {
                          login();
                        },

                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(11),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('LOGIN',

                          style:TextStyle(
                              fontSize: 18,
                            color: Colors.white
                          ),

                          // style: TextStyle(fontSize: 20,fontFamily: 'Regular',),

                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
