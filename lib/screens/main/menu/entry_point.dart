import 'dart:math';
import 'package:chat_app/utilities/rive_utils.dart';
import 'package:rive/rive.dart';
import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/screens/main/menu/menu.dart';
import 'package:flutter/material.dart';

///using create animation navigation_drawer
class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  bool isMenuClose = true;
  late SMIBool isSideBarClosed;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            width: 280,
            left: isMenuClose ? -280 : 0,
            height: MediaQuery.of(context).size.height,
            child: const Menu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: ChatsPage(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            left: isMenuClose ? 0 : 220,
            top: 16,
            child: GestureDetector(
              onTap: (){},
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: RiveAnimation.asset(
                  "assets/RiveAssets/menu_button.riv",
                  onInit: (artboard) {
                    StateMachineController controller = RiveUtils.getRiveController(
                        artboard,
                        stateMachineName: "State Machine");
                    isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
                    // Now it's easy to understand
                    isSideBarClosed.value = true;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
