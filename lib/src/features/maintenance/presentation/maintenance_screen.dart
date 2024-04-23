import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/maintenance/data/firebase_maintenance.dart';
import 'package:naytto/src/features/maintenance/domain/maintenance.dart';
import 'package:naytto/src/utilities/capitalizer.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    final bodyController = TextEditingController();
    final typeController = TextEditingController();
    final streamWatcher = ref.watch(maintenanceStreamProvider);
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
         appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Maintenance',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body:SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: 400.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/maintenance.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [Text(
                        AppUser().housingCooperative,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 50),
                                child: Text(
                                  "Address: ",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                              Text(AppUser().housingCooperativeAddress,
                                  style: Theme.of(context).textTheme.bodySmall)
                            ],
                          )),
                      Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.only(right: 90),
                              child: Text("Tel: ",
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                            ),
                            Text(
                              AppUser().housingCooperativeTel,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ]))
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    content: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40,
                                      top: -40,
                                      child: InkResponse(
                                        onTap: () {
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
                                          const Text("Maintenance reason:"),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                                controller: reasonController),
                                          ),
                                          const Text("Additional info:"),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                                controller: bodyController),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ElevatedButton(
                                              child: const Text("Submit"),
                                              onPressed: () {
                                                createTicket(
                                                    reasonController.text,
                                                    bodyController.text);
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )));
                      },
                      child: const SizedBox(
                        width: 120,
                        child:Row(
                        children: [
                          Icon(Icons.receipt, color: Color.fromRGBO(0, 124, 124, 1.0),),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Text('Create Ticket')
                        ],
                      ), 
                    ),
                  ),
                  streamWatcher.when(
                      data: (streamWatcher) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: streamWatcher.length,
                            itemBuilder: (context, index) {
                              final maintenance = streamWatcher[index];
                              return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration( 
                                      color: const Color.fromARGB(128, 238, 238, 238),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Row(children: [
                                        const Padding(padding: EdgeInsets.only(left: 10)),
                                        const Icon(Icons.build),
                                        const Padding(padding: EdgeInsets.only(left: 10),),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            capitalizer(maintenance.reason),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                maintenance.statusTextGiver(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                              Text(
                                                maintenance.body,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              Text(maintenance.date,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall)
                                            ],
                                          )
                                        )
                                      ]),
                                    ),
                                  ));
                            });
                      },
                      error: (error, stackTrace) => Text('$error'),
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ],
              ),
            ),
          ),
        )
      );
  }
}
