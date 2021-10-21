import 'package:flutter/material.dart';

class SafeModalBottomSheet {
  static show({required context, required body}) {
    BuildContext _context = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(_context).padding.top),
        child: body,
      ),
    );
  }
}
