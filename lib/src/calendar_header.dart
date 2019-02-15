import 'package:flutter/material.dart';
import 'default_styles.dart';

class CalendarHeader extends StatelessWidget {
	CalendarHeader({
		this.showHeader,
		this.headerStyle,
		this.showHeaderButtons,
		this.headerIconColor,
		this.onLeftButtonPressed,
		this.onRightButtonPressed,
		this.isTitleTouchable,
		this.onHeaderTitlePressed
	});
	final bool showHeader;
	final TextStyle headerStyle;
	final bool showHeaderButtons;
	final Color headerIconColor;
	final VoidCallback onLeftButtonPressed;
	final VoidCallback onRightButtonPressed;
	final bool isTitleTouchable;
	final VoidCallback onHeaderTitlePressed;

	@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}