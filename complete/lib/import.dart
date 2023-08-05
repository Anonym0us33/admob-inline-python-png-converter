import 'package:admob_inline_ads_in_flutter/destination.dart';
import 'package:flutter/material.dart';

class TavernPage extends StatefulWidget {
  final List<Destination> entries;

  const TavernPage({
    required this.entries,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _TavernPageState();
}

class _TavernPageState extends State<TavernPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tavern import'),
      ),
      // body: ListView.builder(
      //   // COMPLETE: Adjust itemCount based on the ad load state
      //   itemBuilder: (context, index) {
      //       // COMPLETE: Get adjusted item index from _getDestinationItemIndex()
      //       final item = widget.entries[_getDestinationItemIndex(index)];

      //       return ListTile(
      //         leading: Image.asset(
      //           item.asset,
      //           width: 48,
      //           height: 48,
      //           package: 'flutter_gallery_assets',
      //           fit: BoxFit.cover,
      //         ),
      //         title: Text(item.name),
      //         subtitle: Text(item.duration),
      //         onTap: () {
      //           debugPrint('Clicked ${item.name}');
      //         },
      //       );
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a NativeAd object
    super.dispose();
  }

  // COMPLETE: Add _getDestinationItemIndex()
  int _getDestinationItemIndex(int rawIndex) {
    return rawIndex;
  }
}
