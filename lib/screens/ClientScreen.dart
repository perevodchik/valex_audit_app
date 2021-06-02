import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, EventList;
import 'package:easy_localization/easy_localization.dart';

import '../All.dart';

class ClientScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  ClientScreen(this.args);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic> args = {};
  ClientPreview? clientPreview;
  ClientFull? client;
  TabController? tab;
  AppBar? appBar;
  TabBar? tabBar;
  DateTime selectedDate = DateTime.now();
  bool isLoadingReviews = true;
  List<ClientReview> reviews = [];
  List<ClientReview> reviewsByDate = [];
  EventList<Event> _markedDateMap = EventList<Event>(events: {});

  @override
  void didChangeDependencies() {
    args = widget.args ?? {};
    clientPreview = args["client"];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      load();
    });
    tab = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<void> load() async {
    if(clientPreview!.isCached) {
      client = await LocalStorage().getClient(clientPreview!.id);
    } else {
      client = await ClientsRepository.getClientById(clientPreview!.id);
    }
    setState(() {});
    try {
      var r = await ReviewRepository.getClientReviews(client?.id ?? "");
      var rLocal = await LocalStorage().getReviews(client!.id);
      reviews.clear();
      reviewsByDate.clear();
      _markedDateMap.events.clear();

      reviews.addAll(r);
      reviews.addAll(rLocal);

      for(var review in reviews) {
        if(!_markedDateMap.events.containsKey(review.date))
          _markedDateMap.events[review.date!] = [];
        _markedDateMap.events[review.date!]?.add(Event(
            date: review.date!
        ));
        if(selectedDate.year == review.date?.year &&
            selectedDate.month == review.date?.month &&
            selectedDate.day == review.date?.day)
          reviewsByDate.add(review);
      }
      setState(() {});
    } catch(e) {
      print("e0 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if(appBar == null)
      appBar = AppBar(
          title: Text("client".tr()),
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: blueAccent,
          actions: [
            Icon(Icons.edit, color: Colors.white).onClick(() async {
              await goToNamed(Routes.editClient, {"client": clientPreview});
              if(clientPreview!.isCached) {
                client = await LocalStorage().getClient(clientPreview!.id);
              } else
                client = await ClientsRepository.getClientById(clientPreview?.id ?? "123");
              setState(() {});
            }).marginSymmetricWidget(horizontal: blockX * 3)
          ]
      );
    if(tabBar == null)
      tabBar = TabBar(
        controller: tab,
        labelStyle: styleBoldP14.copyWith(color: blueAccent),
        unselectedLabelStyle: styleBoldP14.copyWith(color: blueAccent),
        unselectedLabelColor: greyMedium,
        labelColor: blueAccent,
        tabs: [
          Tab(text: "client_calendar".tr(), icon: Icon(Icons.calendar_today_outlined)),
          Tab(text: "client_inventory".tr(), icon: Icon(Icons.inventory_2_outlined)),
          Tab(text: "client_contact_peoples".tr(), icon: Icon(Icons.contact_phone_outlined))
        ]
    );
    print(client?.countPC);
    return Scaffold(
      appBar: appBar,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            expandedHeight: 400,
            flexibleSpace: Column(
                children: [
                  Wrap(
                        runSpacing: 10,
                        children: [
                          CustomRoundedTextField(TextEditingController(text: client?.name), helperText: "client_name".tr(),isEnable: false),
                          CustomRoundedTextField(TextEditingController(text: client?.address), helperText: "client_address".tr(), isEnable: false),
                          CustomRoundedTextField(TextEditingController(text: client?.inventory), helperText: "client_inventory".tr(), isEnable: false),
                          CustomRoundedTextField(TextEditingController(text: "${client?.countPC}"), helperText: "client_countPC".tr(), isEnable: false),
                          CustomRoundedTextField(TextEditingController(text: "${client?.countCow}"), helperText: "client_countCow".tr(), isEnable: false),
                        ]
                    ).marginSymmetricWidget(vertical: blockY, horizontal: margin5X),
                  AppTextButton(Text("audits".tr(), style: styleBoldP14.copyWith(color: blueAccent)), onPressed: () async {
                    print(client);
                    await goToNamed(Routes.auditListClient, {
                      "client": client
                    });
                  }).width(width).marginSymmetricWidget(vertical: blockY, horizontal: margin5X)
                ]
            ).scrollWidget(),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
                [
                  tabBar as Widget,
                  TabBarView(
                      controller: tab,
                      children: [
                        Container(
                            child: Column(
                              children: [
                                CalendarCarousel<Event>(
                                    key: Key("calendar_${DateTime.now().toString()}"),
                                    customGridViewPhysics: NeverScrollableScrollPhysics(),
                                    onDayPressed: (DateTime date, List<Event> events) {
                                      setState(() => selectedDate = date);
                                      var r = reviews.where((r) {
                                        return r.date?.year == date.year && r.date?.month == date.month && r.date?.day == date.day;
                                      }).toList();
                                      setState(() => reviewsByDate = r);
                                    },
                                    height: 450,
                                    weekendTextStyle: styleNormalP14.copyWith(color: Colors.black),
                                    daysTextStyle: styleNormalP14.copyWith(color: Colors.black),
                                    todayBorderColor: red,
                                    todayButtonColor: red,
                                    selectedDayButtonColor: blueAccent,
                                    selectedDayBorderColor: blueAccent,
                                    iconColor: blueAccent,
                                    headerTextStyle: styleBoldP20.copyWith(color: blueAccent),
                                    customDayBuilder: (
                                        bool isSelectable,
                                        int index,
                                        bool isSelectedDay,
                                        bool isToday,
                                        bool isPrevMonthDay,
                                        TextStyle textStyle,
                                        bool isNextMonthDay,
                                        bool isThisMonthDay,
                                        DateTime day,
                                        ) {
                                      if (day.day == 15) {
                                        return null;
                                      } else {return null;}
                                    },
                                    weekFormat: false,
                                    locale: "uk",
                                    markedDatesMap: _markedDateMap,
                                    selectedDateTime: selectedDate,
                                    daysHaveCircularBorder: false
                                ),
                                ListView.separated(
                                    key: Key(DateTime.now().toString()),
                                    itemCount: reviewsByDate.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (_, i) => ReviewItem(reviewsByDate[i])
                                        .marginSymmetricWidget(horizontal: margin5X)
                                        .onClick(() => goToNamed(Routes.reviewPage, {
                                          "review": reviewsByDate[i],
                                          "client": client
                                        })),
                                    separatorBuilder: (_, i) => Container(height: 10)
                                ),
                                AppElevatedButton(Text("review_add".tr()), onPressed: () async {
                                  var newReview = await goToNamed(Routes.reviewClient, {
                                    "date": selectedDate,
                                    "client": client
                                  });
                                  if(newReview != null) {
                                    if(newReview is ClientReview) {
                                      load();
                                    }
                                  }
                                }, shadow: false).width(width).marginSymmetricWidget(horizontal: margin5X)
                              ]
                            )
                        ).scrollWidget(),
                        Container(
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: (client?.clientInventory ?? []).length,
                            itemBuilder: (_, i) => InventoryItem((client?.clientInventory ?? [])[i], isEditable: false)
                                .marginSymmetricWidget(horizontal: margin5X),
                            separatorBuilder: (_, i) => Container(height: blockY)
                          ).marginSymmetricWidget(vertical: blockY * 2.5)
                        ).scrollWidget(),
                        Container(
                            child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (client?.contactPeoples ?? []).length,
                                itemBuilder: (_, i) => ContactPeopleItem((client?.contactPeoples ?? [])[i], isEditable: false)
                                    .marginSymmetricWidget(horizontal: margin5X),
                                separatorBuilder: (_, i) => Container(height: blockY)
                            ).marginSymmetricWidget(vertical: blockY * 2.5)
                        ).scrollWidget()
                      ]
                  ).height(height - (appBar?.preferredSize.height ?? 0) - (tabBar?.preferredSize.height ?? 0) * 2)
                ]
            )
          )
        ]
      ).safe()
    );
  }
}