import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}

class _PredModelState extends State<PredModel> with TickerProviderStateMixin {
  var predValue;

  @override
  void initState() {
    super.initState();
    predValue = "";
  }

  String inputString = ''; // chuỗi đầu vào
  List<List<double>> input = [[]]; // mảng 2 chiều
  final TextEditingController _controller = TextEditingController();
  Future<void> predData() async {
    final interpreter = await Interpreter.fromAsset('reg_model1.tflite');
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    this.setState(() {
      predValue = output[0][0].round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/robot-Ai-6.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                // color: Colors.grey.shade800,
                child: Text(
                  'Dự đoán số lượng xe đạp được thuê'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 29,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 90),
              Text(
                "Hãy nhập vào 1 mẫu dữ liệu",
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.grey.shade100,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _controller,
                  onChanged: (value) {
                    // Lưu giá trị đầu vào vào biến inputString
                    inputString = value;

                    // Phân tích chuỗi đầu vào thành mảng 2 chiều
                    List<String> rows = inputString.split('\n');
                    input = rows.map((row) {
                      List<String> elements = row.split(',');
                      return elements
                          .map((element) => double.parse(element))
                          .toList();
                    }).toList();
                  },
                  maxLines: null, // cho phép nhập nhiều dòng
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    fillColor: Colors.white38,
                    focusColor: Colors.blueGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MaterialButton(
                      color: Colors.deepPurpleAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "dự đoán".toUpperCase(),
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      onPressed: predData,
                    ),
                  ),
                  SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MaterialButton(
                      color: Colors.deepPurpleAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          "Tải lại".toUpperCase(),
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Future.delayed(Duration(milliseconds: 5000));
                          predValue = "";
                          _controller.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              predValue == ""
                  ? SizedBox(
                      height: 100,
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  : Container(
                      height: 120,
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  "Chào ! Tôi là Siêu Ây Ai, \nDự đoán nên có lúc đúng lúc sai, \nTôi dự đoán ${(predValue)} xe đạp được thuê.",
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  speed: const Duration(milliseconds: 50),
                                ),
                              ],
                              totalRepeatCount: 1,
                              pause: const Duration(milliseconds: 1000),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
