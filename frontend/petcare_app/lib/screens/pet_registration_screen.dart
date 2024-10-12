import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../services/auth_service.dart'; // AuthService をインポート
import 'package:http/http.dart' as http;

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
  final AuthService _authService = AuthService(); // AuthService をインスタンス化

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // AuthServiceを使用してアクセストークンを取得
      String? accessToken = await _authService.getAccessToken();
      print('accessToken: $accessToken'); // トークンが取得できているか確認

      if (accessToken != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8000/api/pets/'),
        );

        request.headers['Authorization'] = 'Bearer $accessToken';
        request.headers['Content-Type'] = 'multipart/form-data';

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
        } else if (response.statusCode == 401) {
          // アクセストークンが無効な場合、リフレッシュ処理を試みる
          await _authService.refreshToken();
          _submitForm(); // 再度リクエスト
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
              title: Text('権限が拒否されました'),
              content: Text('画像を選択するには写真ライブラリのアクセスが必要です。'),
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
        title: Text('ペット登録'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '名前'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ペットの名前を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '種類'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ペットの種類を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _species = value;
                },
              ),
              ListTile(
                title: Text(_birthday == null
                    ? '誕生日を選択'
                    : '誕生日: ${_birthday!.toLocal()}'.split(' ')[0]),
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
                decoration: InputDecoration(labelText: '性別'),
                items: <String>['オス', 'メス'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ペットの性別を選択してください';
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
                decoration: InputDecoration(labelText: '体重 (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ペットの体重を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.tryParse(value ?? '');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '身長 (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ペットの身長を入力してください';
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
                child: Text('画像を選択'),
              ),
              SizedBox(height: 20),
              _photo == null
                  ? Text('画像が選択されていません。')
                  : Image.file(_photo!, height: 200),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('ペットを登録'),
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
