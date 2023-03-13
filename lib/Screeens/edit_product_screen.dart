import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/product.dart';
import '../Providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const route = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageContoller = TextEditingController();
  final _Form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);

  // ignore: prefer_final_fields
  var _initValues = {
    'id': null,
    'title': '',
    ' description': '',
    'imageUrl': '',
    'price': ''
  };
  var _init = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageContoller.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    if (_init) {
      final id = ModalRoute.of(context)!.settings.arguments as String?;

      if (id != null) {
        _editedProduct = Provider.of<Products>(context).findById(id);
        _initValues = {
          'title': _editedProduct.title,
          'imageUrl': '',
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageContoller.text = _editedProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      if (!_imageContoller.text.endsWith('jpg') &&
          !_imageContoller.text.endsWith('jpeg') &&
          !_imageContoller.text.endsWith('png') &&
          _imageContoller.text.startsWith('http') &&
          _imageContoller.text.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _formSave() async {
    final isValidate = _Form.currentState!.validate();
    if (!isValidate) {
      return;
    }
    _Form.currentState?.save();
    // print("hello");
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
        // print("hello1 32");
      } catch (error) {
        print(error);
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text("Edit Your Product"),
              actions: [
                IconButton(
                    onPressed: () {
                      _formSave();
                    },
                    icon: Icon(Icons.save))
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _Form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a tittle';
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value.toString(),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'].toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a number';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a Valid number';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'Please Enter a number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value.toString()));
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value.toString(),
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(left: 2, right: 8, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: _imageContoller.text.isEmpty
                                ? Text("Enter the URl ")
                                : FittedBox(
                                    child: Image.network(
                                      _imageContoller.text,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text("Error in URL......"),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    // fit: BoxFit.fill,
                                  )),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            decoration: InputDecoration(
                                labelText: "Enter the URL here"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageFocusNode,
                            controller: _imageContoller,
                            onFieldSubmitted: (_) {
                              _formSave();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter a url';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('jpeg')) {
                                return 'please enter a valid image URL';
                              }
                              if (!value.startsWith('http') &&
                                  value.startsWith('https')) {
                                return 'please enter a valid url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value.toString(),
                                  price: _editedProduct.price);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
