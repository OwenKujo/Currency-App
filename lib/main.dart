import 'package:flutter/material.dart';
import 'package:flutter_application_1/ExchRate.dart';
import 'package:http/http.dart' as http;
import 'MoneyBox.dart';

void main() {
  runApp(CareRider());
}

class CareRider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Care Rider",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int number = 0;
  ExchangeRate? _dataFromAPI;
  @override

  void initState() {
    super.initState();
    getExchangeRate();
  }

  Future<ExchangeRate?> getExchangeRate() async{
  var url = Uri.parse('https://open.er-api.com/v6/latest/THB');
  var response=await http.get(url);
  _dataFromAPI = exchangeRateFromJson(response.body);
  return _dataFromAPI;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title:
              const Text('Care Rider', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 21, 0, 96),
        ),
        
        body: FutureBuilder(
          future : getExchangeRate(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              var result = snapshot.data;
              double amount=100;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                children: [
                  MoneyBox("Currency(THB)", amount,120, Colors.blue),
                  SizedBox(height: 8,),
                  MoneyBox("THB",  amount*result.rates["THB"],120, Colors.green),
                  SizedBox(height: 8,),
                  MoneyBox("USD",amount*result.rates["USD"],120, Colors.red)
                ],
                ),
              );
            }
            return LinearProgressIndicator();
          },)
          );
  }
}
