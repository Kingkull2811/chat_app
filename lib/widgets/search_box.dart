import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;

  const SearchBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _isShowClear = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        _isShowClear = widget.controller.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: TextField(
                  controller: widget.controller,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.search,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    prefixIcon:const Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            _isShowClear
                ? const Padding(padding: EdgeInsets.only(left: 10, right: 10))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
