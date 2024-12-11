import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa a biblioteca intl

import 'utils/peso_input_formatter.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      // Remover qualquer ponto ou formatação visual e converter para número
      String weightText =
          weightController.text.replaceAll(RegExp(r'[^0-9]'), '');
      String heightText =
          heightController.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Converter os valores para double corretamente
      double weight = double.tryParse(weightText) ?? 0.0;
      double height = double.tryParse(heightText) ?? 0.0;

      // Verificar se a altura não é zero para evitar divisão por zero
      if (height > 0) {
        double imc = weight / ((height / 100) * (height / 100));

        // Formatar o valor do IMC com 2 casas decimais
        String formattedImc = NumberFormat('#.#').format(imc);

        // Alterar a lógica de exibição de texto
        if (imc < 18.6) {
          _infoText = "Abaixo do Peso ($formattedImc)";
        } else if (imc >= 18.6 && imc < 24.9) {
          _infoText = "Peso ideal ($formattedImc)";
        } else if (imc >= 24.9 && imc < 29.9) {
          _infoText = "Levemente Acima do Peso ($formattedImc)";
        } else if (imc >= 29.9 && imc < 34.9) {
          _infoText = "Obesidade Grau I ($formattedImc)";
        } else if (imc >= 34.9 && imc < 39.9) {
          _infoText = "Obesidade Grau II ($formattedImc)";
        } else if (imc >= 40.0) {
          _infoText = "Obesidade Grau III ($formattedImc)";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _resetFields, icon: const Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_outline,
                size: 120.0,
                color: Colors.green,
              ),
              // Peso
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  PesoInputFormatter(),
                ],
                decoration: const InputDecoration(
                    labelText: "Peso (KG)",
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira um Peso";
                  }
                },
              ),

              //Altura
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  AlturaInputFormatter(),
                ],
                decoration: const InputDecoration(
                    labelText: "Altura (CM)",
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira sua Altura!";
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _calculate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
