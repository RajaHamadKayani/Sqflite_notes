import 'package:flutter/material.dart';
import 'package:sqflite_tutorial/view_model/database_helper/database_helper.dart';
import 'package:sqflite_tutorial/view_model/models/notes_model/notes_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<NotesModel>> showNotes;
  DatabaseHelper? databaseHelper;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    showNotes = databaseHelper!.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ))
          ],
          title: const Text(
            "My Notes",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: showNotes,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snaphot) {
                    if (snaphot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: snaphot.data?.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(
                                child: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  databaseHelper!.deleteNote(snaphot
                                      .data![index]
                                      .id!); // it will access the delete method of the database helper to delete the particular note from the database
                                  showNotes = databaseHelper!
                                      .getData(); // it will refresh the database and assign the list of the data in the database to showNotes list
                                  snaphot.data!.remove(snaphot.data![index]);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.teal,
                                          content: Text(
                                            "Item ${snaphot.data![index].id!} has been deleted from the notes list",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ))); // it will remove the widget from the screen of the list item of which we deleted from the database
                                });
                              },
                              key: ValueKey<int>(snaphot.data![index].id!),
                              child: Card(
                                child: ListTile(
                                  title: Text(snaphot.data![index].title),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                0.6),
                                        child: Text(
                                          snaphot.data![index].description,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(snaphot.data![index].age.toString())
                                    ],
                                  ),
                                  trailing: Text(
                                      snaphot.data![index].email.toString()),
                                  leading:
                                      Text(snaphot.data![index].id.toString()),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            databaseHelper!
                .insertData(NotesModel(
                    age: 22,
                    description: "Hello this is my first note",
                    email: "hamad25@gmail.com",
                    title: "Hamad"))
                .then((value) {
              print("values added");
              print("name is ${value.title}");
              setState(() {
                showNotes = databaseHelper!.getData();
              });
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
