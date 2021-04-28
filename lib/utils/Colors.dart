import 'dart:ui';
import 'package:pdf/pdf.dart';

const Color blue = const Color.fromRGBO(53, 104, 159, 1);
var pdfBlue = PdfColorCmyk(0.6666666666666666, 0.3459119496855346, 0.0, 0.3764705882352941);
const Color blueAccent = const Color.fromRGBO(58, 128, 182, 1);
var pdfBlueAccent = PdfColorCmyk(0.6013186813186813, 0.2967032967032967, 0.0, 0.28627450980392155);
const Color blueDark = const Color.fromRGBO(56, 104, 159, 1);
var pdfBlueDark = PdfColorCmyk(0.6477987421383647, 0.3459119496855346, 0.0, 0.3764705882352941);
const Color greyMedium = const Color.fromRGBO(112, 112, 112, 1);
const Color gold = const Color.fromRGBO(248, 183, 6, 1);
const Color silver = const Color.fromRGBO(158, 168, 186, 1);
const Color bronze = const Color.fromRGBO(246, 137, 76, 1);
const Color redAccent = const Color.fromRGBO(153, 104, 116, 1);
const Color red = const Color.fromRGBO(255, 89, 89, 1);

PdfColorCmyk rgbToCmykPdf(red, green, blue) {
  double red1 = red / 255;
  double green1 = green / 255;
  double blue1 = blue / 255;
  double max = (_max(_max(red1, green1), blue1));
  double K = 1 - max;
  double C = (1 - red1 - K) / (1 - K);
  double M = (1 - green1 - K) / (1 - K);
  double Y = (1 - blue1 - K) / (1 - K);
  print("CMYK = (${(C * 100).round()} , ${(M * 100).round()} , ${(Y * 100).round()} , ${(K * 100).round()})");
  print("CMYK = ($C , $M , $Y , $K)");
  return PdfColorCmyk(C, M, Y, K);
}

double _max(double num1, double num2) {
  if(num1 > num2) return num1;
  else return num2;
}