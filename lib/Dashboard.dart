
import 'dart:io';
import 'dart:io' as io;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomSheet.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Login.dart';


const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final LocalStorage storage = new LocalStorage('data');
  int _pageIndex = 0;
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  var ImagePath;
  bool showCapturedPhoto = false;
  List data = [];
  int length = 0;
  get cameras => null;
  List dataArray = [];
  ArchiveSheet archiveSheet = ArchiveSheet();
  List dataLength = [];
  File _image;
  String type;
  String name;
  String cust_name;
  final picker = ImagePicker();
  var date;

  Future getImage(context) async {
    _image = null;
    final pickedFile = await picker.getImage(source: ImageSource.camera, maxWidth: MediaQuery.of(context).size.width , maxHeight: MediaQuery.of(context).size.width);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  requestPermission() async {
  var status = await Permission.storage.request();
    print(status.isUndetermined);
    if (status.isUndetermined) {
    }
  }

  pdf(flag) async{
    date = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm aaa').format(date);
    this.requestPermission();
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      maxPages: 1000,
        // crossAxisAlignment: pw.CrossAxisAlignment.start,
        // mainAxisAlignment: pw.MainAxisAlignment.center,
        header: (pw.Context context) {
          return pw.Container(
              child: pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 14),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(this.type.toString(),
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.grey800)),
                      pw.Text(this.name.toString().toUpperCase(),
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.grey800)),
                      if(this.cust_name != 'null' && this.cust_name != null && this.cust_name != '')
                        pw.Text(this.cust_name.toString().toUpperCase(),
                            style: pw.Theme.of(context)
                                .defaultTextStyle
                                .copyWith(color: PdfColors.grey800)),
                      pw.Text((formattedDate).toString(),
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.grey800)),
                      // pw.SizedBox(height: 20)
                    ]
                )
              )
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.center,
              margin: pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        margin: pw.EdgeInsets.only(left: 70, right: 20, top: 30, bottom: 30),
        // symmetric(horizontal: 30, vertical: 20),
        pageFormat:
        PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        build: (pw.Context context) => <pw.Widget>[

          // pw.Column(
          //   children: [
              for(var i = 0,k = 0;this.dataArray.length>i;i++)
                pw.Column(
                    children: [
                      pw.SizedBox(height: 8),
                      pw.Container(
                        color: PdfColors.blueGrey50,
                        child: pw.Row(
                            // mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  decoration: pw.BoxDecoration(
                                      border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true, right: true)
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text('Code' , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                  ),
                                )
                              ),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  decoration: pw.BoxDecoration(
                                      border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true, right: true)
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text('Image' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                  ),
                                )
                              ),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  decoration: pw.BoxDecoration(
                                      border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true, right: true)
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text('Cable No.' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                  ),
                                )
                              ),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  decoration: pw.BoxDecoration(
                                      border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true, right: true)
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Text('Length' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                  ),
                                )
                              ),
                            ]
                        ),
                      ),
                      for(var j = 0;j<dataArray[i].length;j++,k++)
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              // pw.SizedBox(height: 3),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  decoration: pw.BoxDecoration(
                                      border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true)
                                  ),
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.all(13),
                                    child: pw.Text(dataArray[i][j]['coil_no'] , textAlign: pw.TextAlign.center,),
                                  ),
                                )
                              ),
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                    border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true)
                                ),
                                // width: 170,
                                // height: 30,
                                child: pw.Image(
                                  PdfImage.jpeg(
                                    doc.document,
                                    image: File(dataArray[i][j]['image']).readAsBytesSync(),
                                  ),
                                  // width: 40,
                                  height: 40,
                                  fit: pw.BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true)
                              ),
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(13),
                                child: pw.Text(dataArray[i][j]['category'] , textAlign: pw.TextAlign.center,),
                              ),
                            )
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.BoxBorder(color: PdfColors.grey, bottom: true, left: true, top: true, right: true)
                              ),
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(13),
                                child: pw.Text(dataArray[i][j]['length'] , textAlign: pw.TextAlign.center,),
                              ),
                            )
                          )
                        ]
                      ),
                      // pw.SizedBox(height: 20),
                      // pw.Table(
                      //   tableWidth: pw.TableWidth.max,
                      //   columnWidths: {
                      //     0: pw.FlexColumnWidth(1),
                      //     1: pw.FlexColumnWidth(1),
                      //     2: pw.FlexColumnWidth(1),
                      //     3: pw.FlexColumnWidth(1),
                      //   },
                      //   border: pw.TableBorder(width: 1.0, color: PdfColors.grey),
                      //   children: [
                      //     // if(i == 0)
                      //       pw.TableRow(
                      //         decoration: pw.BoxDecoration(
                      //           color: PdfColors.blueGrey50,
                      //         ),
                      //         children: [
                      //           pw.Padding(
                      //             padding: const pw.EdgeInsets.all(8),
                      //             child: pw.Text('Code' , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      //           ),
                      //           pw.Padding(
                      //             padding: const pw.EdgeInsets.all(8),
                      //             child: pw.Text('Image' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      //           ),
                      //           pw.Padding(
                      //             padding: const pw.EdgeInsets.all(8),
                      //             child: pw.Text('Cable No.' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      //           ),
                      //           pw.Padding(
                      //             padding: const pw.EdgeInsets.all(8),
                      //             child: pw.Text('Length' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      //           ),
                      //         ]
                      //     ),
                      //     for(var j = 0;j<dataArray[i].length;j++,k++)
                      //       // if(i == 0)
                      //       pw.TableRow(
                      //           decoration: pw.BoxDecoration(
                      //             // color: PdfColors.lightBlue,
                      //           ),
                      //           children: [
                      //             pw.Padding(
                      //               padding: const pw.EdgeInsets.all(10),
                      //               child: pw.Text(dataArray[i][j]['coil_no'] , textAlign: pw.TextAlign.center,),
                      //             ),
                      //             pw.Container(
                      //               width: 70,
                      //               // height: 30,
                      //               child: pw.Image(
                      //                 PdfImage.jpeg(
                      //                   doc.document,
                      //                   image: File(dataArray[i][j]['image']).readAsBytesSync(),
                      //                 ),
                      //                 width: 40,
                      //                 height: 40,
                      //                 fit: pw.BoxFit.fitWidth,
                      //               ),
                      //             ),
                      //             pw.Padding(
                      //               padding: const pw.EdgeInsets.all(10),
                      //               child: pw.Text(dataArray[i][j]['category'] , textAlign: pw.TextAlign.center,),
                      //             ),
                      //             pw.Padding(
                      //               padding: const pw.EdgeInsets.all(10),
                      //               child: pw.Text(dataArray[i][j]['length'] , textAlign: pw.TextAlign.center,),
                      //             ),
                      //           ]
                      //       ),
                      //   ],
                      // ),
                      pw.SizedBox(height: 10),
                      pw.Table(
                        children: [
                          pw.TableRow(
                              children: [
                                pw.Text('No of Coils: '+ this.dataArray[i].length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black),),
                                pw.Text('Length: '+ this.dataLength[i].toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black),),
                              ]
                          )
                        ],
                      ),
                    ]
                ),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(
                      children: [
                        pw.Text('Total Coils: '+ this.data.length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold,height: 1.4, color: PdfColors.black),),
                        pw.Text('Total Length: '+ this.length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, height: 1.4, color: PdfColors.black),),
                      ]
                  )
                ],
              ),
            ]
          ),

        // ])
    );
    var name = (DateTime.now()).millisecondsSinceEpoch;
    var path1 = '/storage/emulated/0/Download/$name.pdf';
    print(path1.toString());
    await File(path1).writeAsBytes(doc.save());
    toaster('Saved to Download file', Colors.blueAccent);
    if(flag == 'share'){
    Directory dir = await getExternalStorageDirectory();
    var a = '/storage/emulated/0/Download';
    File path2 = new File(a);
    await io.File(path2.path+'/$name.pdf').exists().then((value) =>
    {
    print(path2),
    print('true or false' + value.toString()),
    Share.shareFiles(['${path2.path}/$name.pdf'], text: '')
    });
    }
    // return doc.save();


  }

  toaster(msg, color){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  getData() async{
    // var dataArray = [];
    await this.storage.ready.then((value) => {
      // print(this.storage.getItem('tabledata.json')),
      setState(() {
        this.name = this.storage.getItem('name').toString();
        this.type = this.storage.getItem('type').toString();
        this.cust_name = this.storage.getItem('customer').toString();
        this.data = (this.storage.getItem('tabledata.json') == null)?[]:(this.storage.getItem('tabledata.json'));
        // this.data.sort((a,b) => a['coil_no'].compareTo(b['coil_no']));
      }),
      this.formatData(),
      for(int i=0;this.data.length>i;i++){
          this.length = this.length + int.parse(this.data[i]['length'])
      }
    });
  }
  formatData(){
    dataArray = [];
    dataLength = [];
    var code = [];
    // this.data.sort((a,b) => a['coil_no'].compareTo(b['coil_no']));
    code = this.data.map((e) => e['coil_no']).toSet().toList();
    for(var i = 0;i<code.length;i++){
      dataArray.add(this.data.where((e) => e['coil_no'] == code[i]).toSet().toList());
      dataLength.add(this.data.where((e) => e['coil_no'] == code[i]).map((e) => int.parse(e['length'])).toList().reduce((a, b) => a + b));
      print(dataLength);
    }
  }

  licenceCheck(){    // not used
    var date = DateTime.now();
    var dt = date.toString().substring(0,10);
    if(dt.substring(0,4) != '2020' || dt.substring(5,7) != '12' || (int.parse(dt.substring(8,10)) > 30)){
      this.storage.ready.then((value) =>
      {
        storage.setItem('isLoggedIn', 'false'),
        Get.off(MyHomePage()),
        toaster('Validity Expired', Colors.red)
      });
    }
  }

  void initState() {
    super.initState();
  // this.licenceCheck();
    this.getData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292929),
        title: const Text('NetLink'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: (){
              this.storage.ready.then((value) => {
                storage.setItem('isLoggedIn', 'false'),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => MyHomePage()
                ))
              });

            },
          )
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) async{
            RegExp txt1;
            RegExp txt2;
            if(value == 1){
              var scaning = (await BarcodeScanner.scan());
              txt1 = RegExp(r'^[a-zA-Z0-9]+$');
              txt2 = RegExp(r'^[0-9]+$');
              if(scaning.rawContent.length == 15){

                var code = '';
                if(scaning.rawContent.substring(0,7) == '000002F'){
                  code = '2F SM';
                }
                else if(scaning.rawContent.substring(0,7) == '00002FY'){
                  code = '2F SM YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '000004F'){
                  code = '4F SM';
                }
                else if(scaning.rawContent.substring(0,7) == '00004FY'){
                  code = '4F SM YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '000006F'){
                  code = '6F SM';
                }
                else if(scaning.rawContent.substring(0,7) == '00006FY'){
                  code = '6F SM YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '000012F'){
                  code = '12F SM';
                }
                else if(scaning.rawContent.substring(0,7) == '00012FY'){
                  code = '12F SM YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '02FTTHY'){
                  code = '2F FTTH YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '04FTTHY'){
                  code = '4F FTTH YARN';
                }
                else if(scaning.rawContent.substring(0,7) == '02FADSS'){
                  code = '2F SM ADSS';
                }
                else if(scaning.rawContent.substring(0,7) == '04FADSS'){
                  code = '4F SM ADSS';
                }
                else if(scaning.rawContent.substring(0,7) == '06FADSS'){
                  code = '6F SM ADSS';
                }
                else if(scaning.rawContent.substring(0,7) == '12FADSS'){
                  code = '12F SM ADSS';
                }
                else if(scaning.rawContent.substring(0,7) == '0002FA2'){
                  code = '2F SM A2 SERIES';
                }
                else if(scaning.rawContent.substring(0,7) == '0004FA2'){
                  code = '4F SM A2 SERIES';
                }
                else if(scaning.rawContent.substring(0,7) == '0006FA2'){
                  code = '6F SM A2 SERIES';
                }
                else if(scaning.rawContent.substring(0,7) == '0012FA2'){
                  code = '12F SM A2 SERIES';
                }
                else{
                  code = '';
                }
                if(txt1.hasMatch(scaning.rawContent.substring(0,7)) && txt2.hasMatch(scaning.rawContent.substring(7,15)) && code != ''){
                  var temp = this.data.map((e) => e['category']).toList();
                  print(temp.contains(scaning.rawContent.substring(11,15)));
                  if(!temp.contains(scaning.rawContent.substring(11,15))){
                    var data = {};
                    await getImage(context);
                    if(this._image != null){
                      setState(() {
                        data['coil_no'] = code;
                        data['length'] = scaning.rawContent.substring(7,11);
                        data['category'] = scaning.rawContent.substring(11,15);
                        //json.decode(scaning.rawContent);
                        data['image'] = (_image == null)?'No image':_image.path;
                        this.data.add(data);
                        this.length = this.length + int.parse(data['length']);
                      });
                      this.formatData();
                      // print(scaning.rawContent);
                      final path = join(
                        (await getTemporaryDirectory()).path, //Temporary path
                        '${DateTime.now()}.png',
                      );
                      ImagePath = path;
                      setState(() {
                        this.qrText = scaning.rawContent;
                        showCapturedPhoto = true;
                      });
                      // print((scaning.rawContent));

                      this.storage.ready.then((value) => {
                        this.storage.setItem('tabledata.json', (this.data)),
                        print(this.storage.getItem('tabledata.json'))
                      });
                    }
                    else{
                      toaster('No Image found', Colors.red);
                    }
                  }
                  else{
                    toaster('Cable No. Already Exist', Colors.red);
                  }
                }
                else{
                  toaster('Invalid QR data', Colors.red);
                }
              }
              else{
                toaster('Invalid QR data', Colors.red);
              }
            }
            else if(value == 2){
              // this.getGrid(context, 'download');
              this.pdf('download');
            }
            else{
              // this.getGrid(context, 'share');
              this.pdf('share');
            }
            // print(value);
          },
          backgroundColor: Color(0xFF292929),
          fixedColor: Colors.grey[300],
          unselectedItemColor: Colors.grey[300],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem( icon: Icon(Icons.share), title: Text("Share")),
            BottomNavigationBarItem(icon: Icon(Icons.camera_alt), title: Text("Scan")),
            BottomNavigationBarItem(icon: Icon(Icons.save), title: Text("Download")),
          ],
        ),
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            SizedBox(height: 20,),
            Table(
              children: [
                TableRow(
                    children: [
                      TableCell(
                        child: Text('Total Coils: '+ this.data.length.toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,height: 1.4, color: Colors.grey[900]),),
                      ),
                      TableCell(
                        child: Text('Total Length: '+ this.length.toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.4, color: Colors.grey[900]),),
                      ),
                      TableCell(
                        child: InkWell(
                            onTap: (){
                              showAlertDialog(context, '', '');
                              setState(() {
                              });
                            },
                            child: Icon(Icons.delete_forever, size: 20,)),
                        // Text('Coil No: ' , textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ),
                    ]
                )
              ],
            ),
        if(this.data.length == 0)
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Text(this.qrText,),
            // if(i != 0)
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                // border: TableBorder.all(width: 1.0, color: Colors.grey[400]),
                children: [
                    TableRow(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                        ),
                        children: [
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Code' , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Image' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Cable No.' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Length' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Container(
                              // color: Colors.teal[100],
                              child: InkWell(
                                  onTap: (){
                                    _showdialog(context,data, 1);
                                    setState(() {
                                    });
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(Icons.add, size: 28,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        ]
                    ),
                ],
              ),
            ),
          ]
        ),
            for(var i = 0,k = 0;this.dataArray.length>i;i++)
              Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Text(this.qrText,),
                // if(i != 0)
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(3),
                    },
                    // border: TableBorder.all(width: 1.0, color: Colors.grey[400]),
                    children: [
                      if(i == 0)
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                        ),
                          children: [
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Code' , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Image' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          TableCell(
                            child:Padding(
                              padding: const EdgeInsets.only(bottom:10.0, top: 10),
                              child: Text('Cable No.' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                          ),
                            TableCell(
                              child:Padding(
                                padding: const EdgeInsets.only(left:4.0, right: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:10.0, top: 10),
                                      child: Text('Length' , textAlign: TextAlign.center , style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                    ),
                                    Container(
                                      // color: Colors.teal[100],
                                      child: InkWell(
                                          onTap: (){
                                            _showdialog(context,data, 1);
                                            setState(() {
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(Icons.add, size: 28,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ]
                      ),
                      // for(var i in data)
                        for(var j = 0;j<dataArray[i].length;j++,k++)
                          table(dataArray[i][j], j, k, context),
                    ],
                  ),
                ),

                // SizedBox(height: 20,),
                this.data.length == 0? Container(
                  height: MediaQuery.of(context).size.height *0.30,
                  child: Center(
                    child: Text('No data Found',
                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                    ),
                  ),
                ):
                Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Text('No of Coils: '+ this.dataArray[i].length.toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),),
                        ),
                        TableCell(
                          child: Text('Length: '+ this.dataLength[i].toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),),
                        ),
                      ]
                    )
                  ],
                )

              ],
            ),
            SizedBox(height: 30,)
          ],
        ),
      )
    );
  }
  showAlertDialog(BuildContext context, data, i) {

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();

        if(i == ''){
          setState(() {
            this.data = [];
            this.length = 0;
          });
        }
        else{
          var flag = this.data.indexWhere((element) => element['category'] == data);
          print('index:'+flag.toString());
          setState(() {
            this.data.removeAt(flag);
          });
        }
        this.storage.ready.then((value) => {
          this.storage.setItem('tabledata.json', (this.data)),
          print(this.storage.getItem('tabledata.json'))
        });
        this.formatData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text((i == '')?'Delete All':'Delete '+ data),
      content: Text("Are you Sure Do you want to continue"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  table(data, j, i, BuildContext context){
    return TableRow(
        decoration: BoxDecoration(
            color: j % 2 == 0?Colors.grey[100]:Colors.grey[50]
        ),
        children: [
          TableCell(
            child:Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 0.0),
              child: Text(data['coil_no'].toString() , textAlign: TextAlign.center),
            ),
          ),
          TableCell(
            child: Center(
              child: data['image'] == 'No imgae'?
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 0.0),
                child: Text(data['coil_no'].toString() , textAlign: TextAlign.center),
              ):
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.file(File(data['image']),
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: (){
                  _showdialogimage(context,data);
                },
              )
            ),
          ),
          TableCell(
            child:Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 0.0),
              child: Text(data['category'].toString() , textAlign: TextAlign.center),
            ),
          ),
          TableCell(
            child:Padding(
              padding: const EdgeInsets.only(left:8.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 0.0),
                    child: Text(data['length'].toString() , textAlign: TextAlign.center),
                  ),
                  InkWell(
                      onTap: (){
                        print(i);
                        showAlertDialog(context, data['category'].toString(), i);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.delete, size: 20, color: Colors.black,),
                      )
                  ),
                ],
              ),
            ),
          ),
          // TableCell(
          //   child:InkWell(
          //     onTap: (){
          //       print(i);
          //       showAlertDialog(context, data['coil_no'].toString() + data['length'].toString() + data['category'].toString(), i);
          //     },
          //       child: Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: Icon(Icons.delete, size: 20, color: Colors.black,),
          //       )
          //   ),
          // ),
        ]
    );
  }
  _showdialog(context, data, i){
    var text2 = '';
    showDialog(child: Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('QR code', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 20),),

            TextField(
              controller: TextEditingController()..text = '',
              decoration: InputDecoration(hintText: "QR Text"),
              onChanged: (val){
                setState(() {
                  text2 = val;
                });
              },
            ),
            FlatButton(
              child: Text("Add"),
              onPressed: () async{
                RegExp txt1;
                RegExp txt2;
                data = {};
                if(text2.length == 15){
                  var code = '';
                  if(text2.substring(0,7) == '000002F'){
                    code = '2F SM';
                  }
                  else if(text2.substring(0,7) == '00002FY'){
                    code = '2F SM YARN';
                  }
                  else if(text2.substring(0,7) == '000004F'){
                    code = '4F SM';
                  }
                  else if(text2.substring(0,7) == '00004FY'){
                    code = '4F SM YARN';
                  }
                  else if(text2.substring(0,7) == '000006F'){
                    code = '6F SM';
                  }
                  else if(text2.substring(0,7) == '00006FY'){
                    code = '6F SM YARN';
                  }
                  else if(text2.substring(0,7) == '000012F'){
                    code = '12F SM';
                  }
                  else if(text2.substring(0,7) == '00012FY'){
                    code = '12F SM YARN';
                  }
                  else if(text2.substring(0,7) == '02FTTHY'){
                    code = '2F FTTH YARN';
                  }
                  else if(text2.substring(0,7) == '04FTTHY'){
                    code = '4F FTTH YARN';
                  }
                  else if(text2.substring(0,7) == '02FADSS'){
                    code = '2F SM ADSS';
                  }
                  else if(text2.substring(0,7) == '04FADSS'){
                    code = '4F SM ADSS';
                  }
                  else if(text2.substring(0,7) == '06FADSS'){
                    code = '6F SM ADSS';
                  }
                  else if(text2.substring(0,7) == '12FADSS'){
                    code = '12F SM ADSS';
                  }
                  else if(text2.substring(0,7) == '0002FA2'){
                    code = '2F SM A2 SERIES';
                  }
                  else if(text2.substring(0,7) == '0004FA2'){
                    code = '4F SM A2 SERIES';
                  }
                  else if(text2.substring(0,7) == '0006FA2'){
                    code = '6F SM A2 SERIES';
                  }
                  else if(text2.substring(0,7) == '0012FA2'){
                    code = '12F SM A2 SERIES';
                  }
                  else{
                    code = '';
                  }
                  setState(() {
                    txt1 = RegExp(r'^[a-zA-Z0-9]+$');
                    txt2 = RegExp(r'^[0-9]+$');
                  });
                  if(txt1.hasMatch(text2.substring(0,7)) && txt2.hasMatch(text2.substring(7,15)) && code != ''){
                    await getImage(context);
                    setState(() {
                      if(this._image != null){
                        data['coil_no'] = code;
                        data['length'] = text2.substring(7,11);
                        data['category'] = text2.substring(11,15);
                        //json.decode(scaning.rawContent);
                        data['image'] = (_image == null)?'No image':_image.path;
                        this.data.add(data);
                        this.length = this.length + int.parse(data['length']);
                        this.storage.ready.then((value) => {
                          this.storage.setItem('tabledata.json', (this.data)),
                          // print(this.storage.getItem('tabledata.json'))
                        });
                      }
                    });
                    this.formatData();
                  }
                  else{
                    toaster("Invalid Data", Colors.red);
                  }
                }
                else{
                  toaster("Invalid Data", Colors.red);
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),

    ), context: context);
  }

  _showdialogimage(context, data){

    showDialog(child: Dialog(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Image.file(
              File(data['image'].toString(),),
              // height: 200,
              width: 500,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),

    ), context: context);
  }
}