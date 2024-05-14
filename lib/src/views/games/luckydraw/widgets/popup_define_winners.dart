import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PopUpDefineWinner extends StatefulWidget {

  final PrizeModel prize;
  final List<ParticipantModel> availableParticipants;
  final List<ParticipantModel?> stageDefinedWinners;
  final Function(List<ParticipantModel?>)? handlerSaveDefinedWinners;

  const PopUpDefineWinner({
    super.key, 
    required this.prize,
    required this.availableParticipants,
    required this.stageDefinedWinners,
    this.handlerSaveDefinedWinners
  });

  @override
  State<PopUpDefineWinner> createState() => _PopUpDefineWinnerState();
}

class _PopUpDefineWinnerState extends State<PopUpDefineWinner> {

  List<PickerListItemModel> items = [PickerListItemModel(value: "Pilih Peserta", data: null)];
  List<ParticipantModel?> _stageDefinedWinners = [];
  
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    setState(() {
      items.addAll(List.generate(widget.availableParticipants.length, (index) => PickerListItemModel(value: widget.availableParticipants[index].name, data: widget.availableParticipants[index])));

       _stageDefinedWinners = List.generate(widget.prize.winners.length, (index) => widget.prize.winners[index]);
      if (widget.stageDefinedWinners.isNotEmpty) {
        List<ParticipantModel?> sliced = widget.stageDefinedWinners.sublist(widget.prize.winners.length);
        _stageDefinedWinners.addAll(sliced);
      } else _stageDefinedWinners.addAll(List.generate((widget.prize.total-widget.prize.winners.length), (index) => null));
    });
  }

  handlerSelectParticipant(int slot_idx, List<PickerListItemModel> scopedItems) {

    return (PickerListItemModel item, int part_idx) {
      setState(() {
        if (_stageDefinedWinners[slot_idx] == scopedItems[part_idx].data) {
          items.insert(1, item);
          _stageDefinedWinners[slot_idx] = null;
        } else {
          
          for (var k = 0; k < scopedItems.length; k++) {
            if (_stageDefinedWinners[slot_idx] == scopedItems[k].data) {
              bool existOnListSource = false;
              for (var j = 0; j < items.length; j++) {
                if (scopedItems[k].data == items[j].data) existOnListSource = true;
              }
              if (!existOnListSource) items.insert(1, scopedItems[k]);
            }
          }

          _stageDefinedWinners[slot_idx] = items[part_idx].data;
          if (part_idx != 0) items.remove(items[part_idx]);
        }
      });
    };      
  }

  void handlerSaveDefinedWinners() {
    widget.handlerSaveDefinedWinners?.call(_stageDefinedWinners);
    Navigator.pop(context);
  }

  List<PickerListItemModel> generateList(int slot_idx) {
    
    List<PickerListItemModel> res = [];
    bool exist = false;
    res.addAll(items);

    if (_stageDefinedWinners[slot_idx] != null) {
      for (var j = 0; j < items.length; j++) {
        if (_stageDefinedWinners[slot_idx]!.id == items[j].data?.id) exist = true;
      }
      if (!exist) res.insert(
        1,
        PickerListItemModel(
          value: _stageDefinedWinners[slot_idx]!.name,
          data: _stageDefinedWinners[slot_idx]
        )
      );
    }
    
    return res;
  }

  Widget buildPickerList(int slot_idx) {

    List<PickerListItemModel> scopedItems = generateList(slot_idx).toList();
    int? i = scopedItems.indexWhere((e) => e.data == _stageDefinedWinners[slot_idx]);
    
    return Expanded(
      child: PickerList(
        value: scopedItems[(_stageDefinedWinners[slot_idx] != null && i != -1) ? i : 0],
        list: scopedItems,
        disable: (items.isEmpty || ((slot_idx+1) <= widget.prize.winners.length)),
        margin: const EdgeInsets.only(left: 24),
        firstItemDisable: true,
        onChange: handlerSelectParticipant(slot_idx, scopedItems),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Atur Pemenang", style: TextStyle(color: Colors.white, fontSize: 20),),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: widget.prize.total,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Undian ${index + 1}",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      buildPickerList(index),
                    ],
                  ),
                );
              }
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Center(
            child: TouchableOpacity(
              onPress: handlerSaveDefinedWinners,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 189, 65, 211),
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Text("Simpan", style: appStyles["text"]!["bold1White"]),
              )
            ),
          ),
        ],
      ),
    );
  }
}