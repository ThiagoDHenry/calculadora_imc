import 'package:flutter/services.dart';

class PesoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não for número
    String numericText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita o tamanho máximo para 4 dígitos (9999)
    if (numericText.length > 4) {
      numericText = numericText.substring(0, 4);
    }

    // Se a string estiver vazia, não exibe nada
    String formatted = "";
    if (numericText.isEmpty) {
      formatted = "";
    } else if (numericText.length == 1) {
      formatted = "$numericText"; // Exibe "X"
    } else if (numericText.length == 2) {
      formatted = "$numericText"; // Exibe "XX"
    } else if (numericText.length == 3) {
      formatted = "$numericText"; // Exibe "XXX"
    } else if (numericText.length == 4) {
      formatted =
          "${numericText.substring(0, 3)}.${numericText[3]}"; // Exibe "XXX.X"
    }

    // Limita o valor ao máximo permitido de 999.9
    double weight =
        double.tryParse(formatted.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    if (weight > 999.9) {
      formatted = "999.9"; // Não permite valores acima de 999.9
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AlturaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Extrai apenas os números
    String numericText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita o tamanho máximo para 3 dígitos
    if (numericText.length > 3) {
      numericText = numericText.substring(0, 3);
    }

    // Se a string estiver vazia, retorna um campo vazio
    if (numericText.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Se tiver 1 ou 2 caracteres, exibe como números inteiros ou com ponto decimal
    String formatted = "";
    if (numericText.length == 1) {
      formatted = numericText;
    } else if (numericText.length == 2) {
      formatted = "${numericText[0]}.${numericText[1]}"; // Exibe "X.X"
    } else if (numericText.length == 3) {
      formatted =
          "${numericText[0]}.${numericText.substring(1)}"; // Exibe "X.XX"
    }

    // Limita o valor ao máximo permitido (9.99)
    double height =
        double.tryParse(formatted.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    if (height > 9.99) {
      formatted = "9.99"; // Não permite mais que 9.99
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
