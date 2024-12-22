
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:sizer/sizer.dart';

enum TipoFuente { large, medium, small, body }

double calcularTamanhoLetra(tipoFuente, BoxConstraints constraints) {
  double tamanhoFinalLetra = 3.sp;

  // Esté código es sencillo , le pide por parametros que fuente hay que calcular , en base a eso llama al switch donde este llama a la
  // función correspondiente que devolvera el numero de sp.

  switch (tipoFuente) {
    case TipoFuente.large:
      tamanhoFinalLetra = spLarge(constraints);
      break;

    case TipoFuente.medium:
      tamanhoFinalLetra = spMedium(constraints);
      break;

    case TipoFuente.small:
      tamanhoFinalLetra = spSmall(constraints);
      break;

    case TipoFuente.body:
      tamanhoFinalLetra = spBody(constraints);
      break;
  }

  return tamanhoFinalLetra.sp;
}

double spLarge(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final _maxWidth = constraints.maxWidth;



  if (_maxWidth < mobileMaxWidth) { //Movil
    return 30;
  } else if (_maxWidth < webMaxWidth) { // Tablet
    return 20;
  } else {
    return 10;
  }


}

double spMedium(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final _maxWidth = constraints.maxWidth;



  if (_maxWidth < mobileMaxWidth) {
    return 28; // Movil 
  } else if (_maxWidth < webMaxWidth) {
    return 18;
  } else {
    return 8;
  }


}

double spSmall(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final _maxWidth = constraints.maxWidth;



  if (_maxWidth < mobileMaxWidth) {
    return 26;
  } else if (_maxWidth < webMaxWidth) {
    return 16;
  } else {
    return 6;
  }


}

double spBody(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final _maxWidth = constraints.maxWidth;



  if (_maxWidth < mobileMaxWidth) {
    return 24;
  } else if (_maxWidth < webMaxWidth) {
    return 14;
  } else {
    return 4.5;
  }


}


