import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/boxes.dart';
import 'package:flutter_hive/models/notes_models.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Hive Databse')),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList()..cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString()),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              delete(data[index]);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                _editDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              },
                              child: Icon(Icons.edit)),
                        ],
                      ),
                      Text(data[index].description.toString())
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'Enter Typle',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            hintText: 'Enter Description',
                            border: OutlineInputBorder()),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  // data.save();
                  titleController.clear();
                  descriptionController.clear();

                  Navigator.pop(context);
                },
                child: Text('Cancle'),
              )
            ],
          );
        });
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'Enter Typle',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            hintText: 'Enter Description',
                            border: OutlineInputBorder()),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancle'),
              ),
              TextButton(
                onPressed: () async {
                  notesModel.title = titleController.text.toString();
                  notesModel.description =
                      descriptionController.text.toString();

                  await notesModel.save();
                  Navigator.pop(context);
                },
                child: Text('Edit'),
              )
            ],
          );
        });
  }
}
