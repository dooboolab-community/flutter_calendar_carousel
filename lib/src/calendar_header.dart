import 'package:flutter/material.dart';
import 'default_styles.dart';

class CalendarHeader extends StatelessWidget {
	CalendarHeader({
		this.headerTitle,
		this.headerMargin,
		this.showHeader,
		this.headerTextStyle,
		this.showHeaderButtons,
		this.headerIconColor,
		this.onLeftButtonPressed,
		this.onRightButtonPressed,
		this.isTitleTouchable,
		this.onHeaderTitlePressed
	}) : assert (onHeaderTitlePressed != null, headerTitle != null);

	final String headerTitle;
	final EdgeInsetsGeometry headerMargin;
	final bool showHeader;
	final TextStyle headerTextStyle;
	final bool showHeaderButtons;
	final Color headerIconColor;
	final VoidCallback onLeftButtonPressed;
	final VoidCallback onRightButtonPressed;
	final bool isTitleTouchable;
	final VoidCallback onHeaderTitlePressed;

	Widget _leftButton() => IconButton(
		onPressed: onLeftButtonPressed,
		icon: Icon(Icons.chevron_left,
				color: headerIconColor
		),
	);

	Widget _rightButton() => IconButton(
		onPressed: onRightButtonPressed,
		icon: Icon(Icons.chevron_right,
				color: headerIconColor
		),
	);

	Widget _headerTouchable() => FlatButton(
		onPressed: onHeaderTitlePressed,
		child: Text(headerTitle, style: headerTextStyle),
	);

	@override
	Widget build(BuildContext context) =>
			showHeader ?
			Container(
				margin: headerMargin,
				child: DefaultTextStyle(
						style: headerTextStyle != null
								? headerTextStyle
								: defaultHeaderTextStyle,
						child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: <Widget>[
									showHeaderButtons
											? _leftButton()
											: Container(),
									isTitleTouchable
											? _headerTouchable()
											: Text(headerTitle, style: headerTextStyle),
									showHeaderButtons
											? _rightButton()
											: Container(),
								]
						)
				),
			) : Container();
}