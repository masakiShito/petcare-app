import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PetRegistrationScreen extends StatefulWidget {
  @override
  _PetRegistrationScreenState createState() => _PetRegistrationScreenState();
}

class _PetRegistrationScreenState extends State<PetRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _species;
  DateTime? _birthday;
  String? _gender;
  double? _weight;
  double? _height;
  File? _photo;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8000/api/pets/'),
        );
        request.headers['Authorization'] = 'Bearer $accessToken';

        request.fields['name'] = _name!;
        request.fields['species'] = _species!;
        if (_birthday != null) {
          request.fields['birthday'] =
              _birthday!.toIso8601String().split('T').first;
        }
        request.fields['gender'] = _gender!;
        request.fields['weight'] = _weight.toString();
        request.fields['height'] = _height.toString();

        if (_photo != null) {
          request.files
              .add(await http.MultipartFile.fromPath('photo', _photo!.path));
        }

        var response = await request.send();

        if (response.statusCode == 201) {
          Navigator.pop(context, true); // 登録成功後に成功フラグを渡して戻る
        } else {
          var responseData = await response.stream.bytesToString();
          print(
              'Failed to register pet: ${response.statusCode} - $responseData');
        }
      } else {
        print('Access token not found');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }

  Future<void> _pickImage() async {
    if (await Permission.photos.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _photo = File(pickedFile.path);
        });
      }
    } else {
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission denied'),
              content:
                  Text('Photo library access is required to pick an image.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Pet'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s species';
                  }
                  return null;
                },
                onSaved: (value) {
                  _species = value;
                },
              ),
              ListTile(
                title: Text(_birthday == null
                    ? 'Select Birthday'
                    : 'Birthday: ${_birthday!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _birthday) {
                    setState(() {
                      _birthday = picked;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the pet\'s gender';
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.tryParse(value ?? '');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s height';
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.tryParse(value ?? '');
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick an image'),
              ),
              SizedBox(height: 20),
              _photo == null
                  ? Text('No image selected.')
                  : Image.file(_photo!, height: 200),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register Pet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
