import 'package:flutter/material.dart';
import 'package:smart_chef/utils/colors.dart';

class NotificationsIcon extends StatelessWidget {
  final int notificationsCount;
  final VoidCallback onTap;
  final bool shown;

  const NotificationsIcon({
    Key key,
    this.notificationsCount = 0,
    this.onTap,
    this.shown = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: shown ? redF55B31 : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: shown
                ? Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 70,
                  )
                : Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.notifications,
                          color: yellowFFC107,
                          size: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 46,
                          height: 46,
                          child: Center(
                            child: Text(
                              notificationsCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: redF55B31,
                            borderRadius: BorderRadius.all(Radius.circular(23)),
                            border: Border.all(
                              color: grey5B6163,
                              width: 6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
