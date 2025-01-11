

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum TipoFuente { large, medium, small, body, textField }

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

    case TipoFuente.textField:
      tamanhoFinalLetra = spTextField(constraints);
      break;
  }

  return tamanhoFinalLetra.sp;
}

double spTextField(BoxConstraints constraints) {
    const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final maxWidth = constraints.maxWidth;



  if (maxWidth < mobileMaxWidth) { //Movil
    return 14;
  } else if (maxWidth < webMaxWidth) { // Tablet
    return 20;
  } else {
    return 10;
  }
}

double spLarge(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final maxWidth = constraints.maxWidth;



  if (maxWidth < mobileMaxWidth) { //Movil
    return 30;
  } else if (maxWidth < webMaxWidth) { // Tablet
    return 20;
  } else {
    return 10;
  }


}

double spMedium(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final maxWidth = constraints.maxWidth;



  if (maxWidth < mobileMaxWidth) {
    return 24; // Movil 
  } else if (maxWidth < webMaxWidth) {
    return 14;
  } else {
    return 4;
  }


}

double spSmall(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final maxWidth = constraints.maxWidth;



  if (maxWidth < mobileMaxWidth) {
    return 20;
  } else if (maxWidth < webMaxWidth) {
    return 10;
  } else {
    return 1;
  }


}

double spBody(BoxConstraints constraints) {
  const mobileMaxWidth = 500;
  const webMaxWidth = 900;
  final maxWidth = constraints.maxWidth;



  if (maxWidth < mobileMaxWidth) {
    return 14;
  } else if (maxWidth < webMaxWidth) {
    return 4; //TODO Corregir
  } else {
    return 3.5;
  }


}


