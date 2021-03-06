import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  static const String id = '/dashboard/main';
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("메인"),
        ),
        body: LayoutBuilder(
          builder: (builder, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     children: <Widget>[
                        //       Container(
                        //         margin: const EdgeInsets.only(
                        //             left: 30.0, right: 30.0, top: 30.0),
                        //         decoration: BoxDecoration(
                        //           color: Color(0xF2404B60),
                        //         ),
                        //         height: 50.0,
                        //         child: Center(
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: <Widget>[
                        //               Icon(Icons.warning_amber_outlined,
                        //                   color: Colors.white),
                        //               SizedBox(width: 10.0),
                        //               Text('공지사항',
                        //                   style: TextStyle(
                        //                       fontSize: 20.0,
                        //                       color: Colors.white)),
                        //               SizedBox(width: 10.0),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: StreamBuilder(
                        //             stream: firestore
                        //                 .collection('info')
                        //                 .doc('notice')
                        //                 .snapshots(),
                        //             builder: (context, snapshot) {
                        //               if (!snapshot.hasData)
                        //                 return Container(
                        //                     width: MediaQuery.of(context)
                        //                         .size
                        //                         .width,
                        //                     height: MediaQuery.of(context)
                        //                         .size
                        //                         .height,
                        //                     child: Center(
                        //                         child:
                        //                             CircularProgressIndicator()));

                        //               return SingleChildScrollView(
                        //                 child: ListView.separated(
                        //                   shrinkWrap: true,
                        //                   padding: const EdgeInsets.only(
                        //                       left: 50.0,
                        //                       right: 50.0,
                        //                       top: 20.0),
                        //                   itemCount:
                        //                       snapshot.data['notice'].length,
                        //                   itemBuilder: (context, index) {
                        //                     return Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.start,
                        //                       mainAxisSize: MainAxisSize.min,
                        //                       children: <Widget>[
                        //                         Icon(Icons.circle, size: 12.0),
                        //                         SizedBox(width: 10.0),
                        //                         Expanded(
                        //                             child: Text(
                        //                                 snapshot.data['notice']
                        //                                     [index],
                        //                                 style: TextStyle(
                        //                                     fontSize: 16.0))),
                        //                       ],
                        //                     );
                        //                   },
                        //                   separatorBuilder: (builder, index) {
                        //                     return SizedBox(height: 10.0);
                        //                   },
                        //                 ),
                        //               );
                        //             }),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // Expanded(
                        //   flex: 1,
                        //   child: Column(
                        //     children: <Widget>[
                        //       Container(
                        //         margin: const EdgeInsets.only(
                        //             left: 30.0, right: 30.0, top: 30.0),
                        //         decoration: BoxDecoration(
                        //           color: Color(0xF2404B60),
                        //         ),
                        //         height: 50.0,
                        //         child: Center(
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: <Widget>[
                        //               Icon(Icons.auto_fix_high,
                        //                   color: Colors.white),
                        //               SizedBox(width: 10.0),
                        //               Text('업데이트 내역',
                        //                   style: TextStyle(
                        //                       fontSize: 20.0,
                        //                       color: Colors.white)),
                        //               SizedBox(width: 10.0),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 1,
                        //         child: StreamBuilder(
                        //           stream: firestore
                        //               .collection('info')
                        //               .doc('update')
                        //               .collection('history')
                        //               .orderBy('date', descending: true)
                        //               .snapshots(),
                        //           builder: (context, snapshot) {
                        //             if (!snapshot.hasData)
                        //               return Container(
                        //                   width:
                        //                       MediaQuery.of(context).size.width,
                        //                   height: MediaQuery.of(context)
                        //                       .size
                        //                       .height,
                        //                   child: Center(
                        //                       child:
                        //                           CircularProgressIndicator()));

                        //             return SingleChildScrollView(
                        //               child: ListView.separated(
                        //                 shrinkWrap: true,
                        //                 physics: NeverScrollableScrollPhysics(),
                        //                 padding: const EdgeInsets.only(
                        //                     left: 50.0, right: 50.0, top: 20.0),
                        //                 itemCount: snapshot.data.docs.length,
                        //                 itemBuilder: (context, index) {
                        //                   // final snaps =
                        //                   //     snapshot.data.docs[index];
                        //                   // final date = snaps['date'];
                        //                   // final history = snaps['history'];

                        //                   return Column(
                        //                     children: <Widget>[
                        //                       Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.start,
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: <Widget>[
                        //                           Icon(Icons.circle,
                        //                               size: 12.0),
                        //                           SizedBox(width: 10.0),
                        //                           Expanded(
                        //                               child: Text(
                        //                                   DateFormat(
                        //                                           'yyyy.MM.dd')
                        //                                       .format(snapshot
                        //                                           .data
                        //                                           .docs[index]
                        //                                               ['date']
                        //                                           .toDate()),
                        //                                   style: TextStyle(
                        //                                       fontSize: 16.0))),
                        //                         ],
                        //                       ),
                        //                       ListView.builder(
                        //                         shrinkWrap: true,
                        //                         physics:
                        //                             NeverScrollableScrollPhysics(),
                        //                         padding: const EdgeInsets.only(
                        //                             left: 20.0),
                        //                         itemCount: snapshot
                        //                             .data
                        //                             .docs[index]['history']
                        //                             .length,
                        //                         itemBuilder:
                        //                             (context, subIndex) {
                        //                           return Row(
                        //                             mainAxisAlignment:
                        //                                 MainAxisAlignment.start,
                        //                             mainAxisSize:
                        //                                 MainAxisSize.min,
                        //                             crossAxisAlignment:
                        //                                 CrossAxisAlignment
                        //                                     .start,
                        //                             children: <Widget>[
                        //                               Icon(Icons.check,
                        //                                   size: 10.0),
                        //                               SizedBox(width: 6.0),
                        //                               Expanded(
                        //                                   child: Text(
                        //                                       snapshot.data.docs[
                        //                                                   index]
                        //                                               [
                        //                                               'history']
                        //                                           [subIndex],
                        //                                       style: TextStyle(
                        //                                           fontSize:
                        //                                               14.0))),
                        //                             ],
                        //                           );
                        //                         },
                        //                       ),
                        //                     ],
                        //                   );
                        //                 },
                        //                 separatorBuilder: (builder, index) {
                        //                   return SizedBox(height: 10.0);
                        //                 },
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: StreamBuilder(
                      stream: firestore
                          .collection('recent')
                          .orderBy('date', descending: true)
                          .limit(25)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 30.0, right: 30.0, top: 30.0),
                                decoration: BoxDecoration(
                                  color: Color(0xF2404B60),
                                ),
                                height: 50.0,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.access_time,
                                          color: Colors.white),
                                      SizedBox(width: 10.0),
                                      Text('최근 작성내역',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                      SizedBox(width: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                        left: 50.0,
                                        right: 50.0,
                                        top: 20.0,
                                        bottom: 20.0),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() => previousPage = 0);
                                          await firestore
                                              .collection('board')
                                              .doc(snapshot.data.docs[index]
                                                  ['projectNum'])
                                              .get()
                                              .then((value) {
                                            selectedReport = Report(
                                              companyName:
                                                  value.data()['companyName'],
                                              date: value.data()['date'],
                                              factoryName:
                                                  value.data()['factoryName'],
                                              manager: value.data()['manager'],
                                              projectNum:
                                                  value.data()['projectNum'],
                                              title: value.data()['title'],
                                              views: value.data()['views'],
                                            );
                                            onTabNavigate(3);
                                          });
                                        },
                                        child: Text(
                                          snapshot.data.docs[index]['recent'],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (builder, index) {
                                      return Divider(
                                          thickness: 0.3, color: Colors.black);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 30.0, right: 30.0, top: 30.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xF2404B60),
                                      ),
                                      height: 50.0,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.warning_amber_outlined,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text('공지사항',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white)),
                                            SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder(
                                          stream: firestore
                                              .collection('info')
                                              .doc('notice')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));

                                            return SingleChildScrollView(
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.only(
                                                    left: 50.0,
                                                    right: 50.0,
                                                    top: 20.0),
                                                itemCount: snapshot
                                                    .data['notice'].length,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(Icons.circle,
                                                          size: 12.0),
                                                      SizedBox(width: 10.0),
                                                      Expanded(
                                                          child: Text(
                                                              snapshot.data[
                                                                      'notice']
                                                                  [index],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0))),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (builder, index) {
                                                  return SizedBox(height: 10.0);
                                                },
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 30.0, right: 30.0, top: 30.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xF2404B60),
                                      ),
                                      height: 50.0,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.auto_fix_high,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text('업데이트 내역',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white)),
                                            SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: StreamBuilder(
                                        stream: firestore
                                            .collection('info')
                                            .doc('update')
                                            .collection('history')
                                            .orderBy('date', descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()));

                                          return SingleChildScrollView(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  left: 50.0,
                                                  right: 50.0,
                                                  top: 20.0),
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                // final snaps =
                                                //     snapshot.data.docs[index];
                                                // final date = snaps['date'];
                                                // final history = snaps['history'];

                                                return Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(Icons.circle,
                                                            size: 12.0),
                                                        SizedBox(width: 10.0),
                                                        Expanded(
                                                            child: Text(
                                                                DateFormat(
                                                                        'yyyy.MM.dd')
                                                                    .format(snapshot
                                                                        .data
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'date']
                                                                        .toDate()),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0))),
                                                      ],
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0),
                                                      itemCount: snapshot
                                                          .data
                                                          .docs[index]
                                                              ['history']
                                                          .length,
                                                      itemBuilder:
                                                          (context, subIndex) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Icon(Icons.check,
                                                                size: 10.0),
                                                            SizedBox(
                                                                width: 6.0),
                                                            Expanded(
                                                                child: Text(
                                                                    snapshot.data.docs[index]
                                                                            [
                                                                            'history']
                                                                        [
                                                                        subIndex],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0))),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (builder, index) {
                                                return SizedBox(height: 10.0);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: StreamBuilder(
                            stream: firestore
                                .collection('recent')
                                .orderBy('date', descending: true)
                                .limit(25)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 30.0, right: 30.0, top: 30.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xF2404B60),
                                      ),
                                      height: 50.0,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(Icons.access_time,
                                                color: Colors.white),
                                            SizedBox(width: 10.0),
                                            Text('최근 작성내역',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white)),
                                            SizedBox(width: 10.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              left: 50.0,
                                              right: 50.0,
                                              top: 20.0,
                                              bottom: 20.0),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                setState(
                                                    () => previousPage = 0);
                                                await firestore
                                                    .collection('board')
                                                    .doc(snapshot
                                                            .data.docs[index]
                                                        ['projectNum'])
                                                    .get()
                                                    .then((value) {
                                                  selectedReport = Report(
                                                    companyName: value
                                                        .data()['companyName'],
                                                    date: value.data()['date'],
                                                    factoryName: value
                                                        .data()['factoryName'],
                                                    manager:
                                                        value.data()['manager'],
                                                    projectNum: value
                                                        .data()['projectNum'],
                                                    title:
                                                        value.data()['title'],
                                                    views:
                                                        value.data()['views'],
                                                  );
                                                  onTabNavigate(3);
                                                });
                                              },
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['recent'],
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (builder, index) {
                                            return Divider(
                                                thickness: 0.3,
                                                color: Colors.black);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
