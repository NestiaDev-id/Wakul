import 'package:flutter/material.dart';
import 'package:wakul2/controller/products/add_products.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class AddProductView extends StatefulWidget {
  final String kategori;

  AddProductView({Key? key, required this.kategori}) : super(key: key);

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final AddProductController controller = AddProductController();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController imageController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    stockController = TextEditingController();
    imageController = TextEditingController();
    priceController = TextEditingController();
    controller.onImageChanged = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Description Product',
                    hintText: 'Enter a description',
                    icon: const Icon(Icons.fastfood_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description Product',
                    hintText: 'Enter a description',
                    icon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    icon: const Icon(Icons.shopping_cart),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    icon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        if (controller.image != null) {
                          return Container(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              File(
                                controller.image!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        } else if (imageController.text.isNotEmpty) {
                          // Display image from URL
                          return Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return const Text('No image chosen');
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Choose Image Source"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      controller
                                          .pickImage(); // Upload from gallery
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.photo),
                                        SizedBox(width: 8),
                                        Text("Upload from Gallery"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: imageController,
                                    decoration: InputDecoration(
                                      labelText: 'Image URL from Google',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 16.0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.link),
                                        SizedBox(width: 8),
                                        Text("Use Image URL"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.photo),
                          SizedBox(width: 8),
                          Text("Choose Image"),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back),
                          Text('Kembali'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.addProduct(
                          nameController.text,
                          descriptionController.text,
                          int.parse(stockController.text),
                          imageController.text,
                          int.parse(priceController.text),
                          widget.kategori,
                        );
                      },
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    imageController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
