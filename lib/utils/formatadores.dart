String formatarMoeda(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');

    String inteiro = partes[0];
    final decimal = partes[1];

    final buffer = StringBuffer();
    int contador = 0;

    for (int i = inteiro.length - 1; i >= 0; i--) {
      buffer.write(inteiro[i]);
      contador++;

      if (contador == 3 && i != 0) {
        buffer.write('.');
        contador = 0;
      }
    }

    final inteiroFormatado =
        buffer.toString().split('').reversed.join();

    return 'R\$ $inteiroFormatado,$decimal';
  }
