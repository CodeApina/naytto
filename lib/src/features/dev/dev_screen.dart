import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/theme.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:naytto/src/utilities/housing_cooperative_creator.dart';

class DevScreen extends ConsumerWidget {
  const DevScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController1 = TextEditingController();
    final textController2 = TextEditingController();
    final textController3 = TextEditingController();
    return ColorfulSafeArea(
      color: colors(context).color2!,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                colors(context).color2!,
                colors(context).color3!,
              ])),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Positioned(
                                  right: -40,
                                  top:  -40,
                                  child: InkResponse(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                                Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text("Housing cooperative name:"),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(controller: textController1),
                                      ),
                                      const Text("Housing cooperative address:"),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(controller: textController2),
                                      ),
                                      const Text("Number of apartments wanted:"),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(controller: textController3,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: ElevatedButton(
                                          child: const Text("Submit"),
                                          onPressed: (){
                                            HousingCooperativeCreator().CreateNewHousingCooperative(textController1.text,textController2.text,int.parse(textController3.text));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          )
                        );
                      },
                      child: const Text('Create Housing Cooperative')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 2')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 3')),
                  TextButton(
                      onPressed: () {
                        // Put logic here
                      },
                      child: const Text('Button 4')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
