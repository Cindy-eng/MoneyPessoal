import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TelaPrincipal());
  
}

class TelaPrincipal extends StatefulWidget{
  const TelaPrincipal({super.key});
  @override
  State<StatefulWidget> createState()=>TelaPrincipalState();
}

class TelaPrincipalState extends State<TelaPrincipal>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Dashbord "),
          centerTitle: true,
          actions: [IconButton(onPressed: (){}, icon: Icon(Icons.tune))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),

          child:Column(
            children: [
              _buildsaldo(),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Dia" , style: TextStyle(color: Colors.grey),),
                  Text("Semana", style: TextStyle(color:Colors.grey),),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("Mes"),
                  ),
                  Text("Ano", style: TextStyle(color: Colors.grey),)
                ],
              ),
              SizedBox(height: 20,),
              _buildChart(),
              SizedBox(height: 25,),
              _buildCurrencyCard()

            ],
          )        ),
      ),
    )
    ;
    throw UnimplementedError();
  }

  Widget _buildsaldo(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF5F5F5)
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.attach_money , color: Colors.blue,),
              ),
              SizedBox(width: 10,),
              Text("Metical", style: TextStyle(fontSize: 16),),
              Spacer(),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Text("MZN 149.869",
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text('+49,89%',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              )
            ],
          ),

          

        ],
      ),

    );
  }
  Widget _buildChart() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: Text("\$2,65", style: TextStyle(color: Colors.red)),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text("\$5,65", style: TextStyle(color: Colors.green)),
          ),
          // Gráfico simulado
          Center(
            child: Icon(Icons.show_chart, size: 80, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.attach_money, color: Colors.white),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("5.679121"),
                  Text("MZN 2,65"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("MZN 5.385"),
                  Text("-5,93%", style: TextStyle(color: Colors.red)),
                ],
              ),
            ],
            ),
        );
    }






}