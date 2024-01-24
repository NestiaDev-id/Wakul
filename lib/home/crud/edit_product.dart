import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakul2/controller/products/edit_products.dart';

class EditProductView extends StatefulWidget {
  final Map<String, dynamic> kategori;

  EditProductView({Key? key, required this.kategori}) : super(key: key);

  @override
  _EditProductViewState createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final EditProductController controller = EditProductController();
  final TextEditingController idProductController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController idcategoryController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool isUsingImageUrl = false;

  @override
  void initState() {
    super.initState();

    controller.onImageChanged = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    print(widget.kategori);
    idProductController.text = widget.kategori['idProduct'] ?? '';
    idcategoryController.text = widget.kategori['idkategori'] ?? '';
    nameController.text = widget.kategori['name'] ?? '';
    descriptionController.text = widget.kategori['description'] ?? '';
    stockController.text = widget.kategori['stock'].toString();
    imageController.text = widget.kategori['imageUrls'] ?? '';
    priceController.text = widget.kategori['price'].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name Product',
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
                                    Navigator.pop(context); // Close the dialog
                                    controller
                                        .pickImage(); // Upload from gallery
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.updateProduct(
                          nameController.text,
                          descriptionController.text,
                          int.parse(stockController.text),
                          int.parse(priceController.text),
                          imageController.text,
                          idcategoryController.text);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.update),
                        SizedBox(width: 8),
                        Text('Update Product'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    idcategoryController.dispose();
    stockController.dispose();
    imageController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
