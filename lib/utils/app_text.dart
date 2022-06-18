import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static labelNormal(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.normal,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelW500(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelW600(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelW700(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelW800(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelW900(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }

  static labelBold(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? height,
  }) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: colors,
        height: height ?? 1,
      ),
    );
  }
}
