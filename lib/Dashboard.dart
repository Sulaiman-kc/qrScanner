
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:intl/intl.dart';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:simple_permissions/simple_permissions.dart';/
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomSheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:share/share.dart';
// import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/widgets.dart' as pw;

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
  final LocalStorage storage = new LocalStorage('data');
  // Permission permission;
  int _pageIndex = 0;
  int _selectedIndex = 0;
  CameraController _controller;
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  Future<void> _initializeControllerFuture;
  var ImagePath;
  bool showCapturedPhoto = false;
  List data = [];
  int length = 0;
  get cameras => null;
  List dataArray = [];
  // Future<void> _initializeControllerFuture;
  ArchiveSheet archiveSheet = ArchiveSheet();
  List dataLength = [];
  File _image;
  String type;
  String name;
  final picker = ImagePicker();
  var date;

  Future getImage(context) async {
    _image = null;
    final pickedFile = await picker.getImage(source: ImageSource.camera, maxWidth: MediaQuery.of(context).size.width , maxHeight: MediaQuery.of(context).size.width);
    // print(pickedFile.path);
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
    // final image = PdfImage.file(
    //   pdf.document,
    //   bytes: File('test.webp').readAsBytesSync(),
    // );
    doc.addPage(pw.MultiPage(
        header: (pw.Context context) {
          // if (context.pageNumber == 1) {
          //   return null;
          // }
          return pw.Container(
              // alignment: pw.Alignment.centerRight,
              // margin: const pw.EdgeInsets.only(bottom: 2.0 * PdfPageFormat.mm),
              // padding: const pw.EdgeInsets.only(bottom: 2.0 * PdfPageFormat.mm),
              // decoration: const pw.BoxDecoration(
              //     border: pw.BoxBorder(
              //         bottom: true, width: 0.1, color: PdfColors.grey)),
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
                  pw.Text((formattedDate).toString(),
                      style: pw.Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.grey800)),
                ]
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
        margin: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(
            children: [
              for(var i = 0,k = 0;this.dataArray.length>i;i++)
                pw.Column(
                    children: [
                      pw.SizedBox(height: 20),
                      pw.Table(
                        columnWidths: {
                          0: pw.FlexColumnWidth(1),
                          1: pw.FlexColumnWidth(1),
                          2: pw.FlexColumnWidth(1),
                          3: pw.FlexColumnWidth(1),
                        },
                        border: pw.TableBorder(width: 1.0, color: PdfColors.grey),
                        children: [
                          // if(i == 0)
                            pw.TableRow(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.blueGrey50,
                              ),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('Code' , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('Image' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('Cable No.' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('Length' , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),),
                                ),
                              ]
                          ),
                          for(var j = 0;j<dataArray[i].length;j++,k++)
                            // if(i == 0)
                            pw.TableRow(
                                decoration: pw.BoxDecoration(
                                  // color: PdfColors.lightBlue,
                                ),
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(10),
                                    child: pw.Text(dataArray[i][j]['coil_no'] , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10),),
                                  ),
                                  pw.Container(
                                    width: 70,
                                    // height: 30,
                                    child: pw.Image(
                                      PdfImage.jpeg(
                                        doc.document,
                                        image: File(dataArray[i][j]['image']).readAsBytesSync(),
                                      ),
                                      width: 40,
                                      height: 40,
                                      fit: pw.BoxFit.fitWidth,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(10),
                                    child: pw.Text(dataArray[i][j]['category'] , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontSize: 10),),
                                  ),
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(10),
                                    child: pw.Text(dataArray[i][j]['length'] , textAlign: pw.TextAlign.center , style: pw.TextStyle(fontSize: 10),),
                                  ),
                                ]
                            ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Table(
                        children: [
                          pw.TableRow(
                              children: [
                                pw.Text('No of Records: '+ this.dataArray[i].length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black),),
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
                        pw.Text('Total Records: '+ this.data.length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold,height: 1.4, color: PdfColors.black),),
                        pw.Text('Total Length: '+ this.length.toString() , textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, height: 1.4, color: PdfColors.black),),
                      ]
                  )
                ],
              ),
            ]
          ),

        ]));
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

  // getGrid(context, flag) async {
  //   this.requestPermission();
  //   final PdfDocument document = PdfDocument();
  //   final PdfGrid grid = PdfGrid();
  //   PdfPage page;// = document.pages.add()
  //   double height = 0;
  //   double textHeight = 20;
  //   for(var i = 0; this.data.length>i;i++){
  //     final Uint8List imageData = File(this.data[i]['image']).readAsBytesSync();
  //     final PdfBitmap image = PdfBitmap(imageData);
  //     if(i % 3 == 0){
  //       page = document.pages.add();
  //       height = 15;
  //       textHeight = 35;
  //     }
  //     else{
  //       height = height + 250.0;
  //       textHeight = textHeight + 250.0;
  //     }
  //     page.graphics.drawLine(
  //         PdfPen(PdfColor(0, 0, 0), width: MediaQuery.of(context).size.width*3),
  //         Offset(0, 239),
  //         Offset(0, 241));
  //     // print(i);
  //     // print(i == this.data.length);
  //     if(i + 1  == this.data.length){
  //       if(this.data.length - 1 % 3 == 1){
  //         print('hello');
  //         page.graphics.drawLine(
  //             PdfPen(PdfColor(0, 0, 0), width: MediaQuery.of(context).size.width*3),
  //             Offset(0, 489),
  //             Offset(0, 491));
  //       }
  //     }else{
  //       page.graphics.drawLine(
  //           PdfPen(PdfColor(0, 0, 0), width: MediaQuery.of(context).size.width*3),
  //           Offset(0, 489),
  //           Offset(0, 491));
  //     }
  //
  //
  //
  //     PdfTextElement textElement1 = PdfTextElement(
  //         text:
  //         (i+1).toString()+'.',
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement1.font = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
  //     PdfLayoutResult layoutResult1 = textElement1.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             0, height, page.getClientSize().width - 250, page.getClientSize().height));
  //
  //     PdfTextElement textElement = PdfTextElement(
  //         text:
  //         'Category code :',
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
  //     PdfLayoutResult layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             250, textHeight, page.getClientSize().width - 250, page.getClientSize().height));
  //     textElement = PdfTextElement(
  //         text:
  //         'Cable length :',
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
  //     layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             250, textHeight + 70.0, page.getClientSize().width - 250, page.getClientSize().height));
  //     textElement = PdfTextElement(
  //         text:
  //         'Cable number :',
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
  //     layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             250, textHeight + 140, page.getClientSize().width - 250, page.getClientSize().height));
  //     page.graphics.drawImage(
  //         image,
  //
  //         Rect.fromLTWH(
  //             30, height, 200, 200));
  //     textElement = PdfTextElement(
  //         text:
  //         this.data[i]['category'].toString(),
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18,);
  //     layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             400, textHeight, page.getClientSize().width - 250, page.getClientSize().height));
  //     textElement = PdfTextElement(
  //         text:
  //         this.data[i]['length'].toString(),
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18,);
  //     layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             400, textHeight + 70, page.getClientSize().width - 250, page.getClientSize().height));
  //     textElement = PdfTextElement(
  //         text:
  //         this.data[i]['coil_no'].toString(),
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 12));
  //     textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 18,);
  //     layoutResult = textElement.draw(
  //         page: page,
  //         bounds: Rect.fromLTWH(
  //             400, textHeight + 140, page.getClientSize().width - 250, page.getClientSize().height));
  //
  //
  //   }
  //   grid.style.cellPadding = PdfPaddings(left: 2, top: 5);
  //   this.requestPermission();
  //   final path = join(
  //     (await getExternalStorageDirectory()).path, //Temporary path
  //     'hello.pdf',//${DateTime.now()}
  //   );
  //   var name = (DateTime.now()).millisecondsSinceEpoch;
  //   var path1 = '/storage/emulated/0/Download/$name.pdf';
  //   print(path1.toString());
  //   await File(path1).writeAsBytes(document.save());
  //   toaster('Saved to Download file', Colors.blueAccent);
  //   document.dispose();
  //   if(flag == 'share'){
  //     Directory dir = await getExternalStorageDirectory();
  //     var a = '/storage/emulated/0/Download';
  //     File path2 = new File(a);
  //     await io.File(path2.path+'/$name.pdf').exists().then((value) =>
  //     {
  //       print(path2),
  //       print('true or false' + value.toString()),
  //       Share.shareFiles(['${path2.path}/$name.pdf'], text: '')
  //     });
  //   }
  // }

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
        this.data = (this.storage.getItem('tabledata.json') == null)?[]:(this.storage.getItem('tabledata.json'));
        this.data.sort((a,b) => a['coil_no'].compareTo(b['coil_no']));
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
    this.data.sort((a,b) => a['coil_no'].compareTo(b['coil_no']));
    code = this.data.map((e) => e['coil_no']).toSet().toList();
    for(var i = 0;i<code.length;i++){
      dataArray.add(this.data.where((e) => e['coil_no'] == code[i]).toSet().toList());
      dataLength.add(this.data.where((e) => e['coil_no'] == code[i]).map((e) => int.parse(e['length'])).toList().reduce((a, b) => a + b));
      print(dataLength);
    }

  }


  void initState() {
    super.initState();

    // this.requestPermission();
    this.getData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292929),
        title: const Text('QR Scanner'),
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
              if(scaning.rawContent.length == 15){//

                var code = '';
                if(scaning.rawContent.substring(0,7) == '000006F'){
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
        // Column(
        //   mainAxisSize: MainAxisSize.max,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        //       child: Row(
        //         children: [
        //           Text(':: ', style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 18, height: 1),),
        //           Text('AF', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),),
        //         ],
        //       ),
        //     ),
        //     Card(
        //       elevation: 2.0,
        //       child: Container(
        //         width: MediaQuery.of(context).size.width * 65,
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Container(
        //                   // width: MediaQuery.of(context).size.width * 0.65 * 0.5,
        //                     child:InkWell(
        //                       child: ClipRRect(
        //                         borderRadius: BorderRadius.circular(6.0),
        //                         child: Image.file(File(data[0]['image']),
        //                           width: 65,
        //                           height: 65,
        //                           fit: BoxFit.cover,
        //                         ),
        //                       ),
        //                       onTap: (){
        //                         _showdialogimage(context,data[0]);
        //                       },
        //                     ),
        //                 ),
        //                 SizedBox(width: 30,),
        //                 Container(
        //                   height: 65,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       mainAxisSize: MainAxisSize.max,
        //                       children: [
        //                         // Row(
        //                         //   children: [
        //                         //     Container(
        //                         //       child: Text('Code', style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //       ),),
        //                         //       width: 75,
        //                         //     ),
        //                         //     // Icon(
        //                         //     //   Icons.category
        //                         //     // ),
        //                         //     Text(': ' , style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //     ),),
        //                         //     Text('AF'),
        //                         //   ],
        //                         // ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Cable No.', style: TextStyle(
        //                                   fontWeight: FontWeight.bold
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('7890'),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Length', style: TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                   color: Color(0xFF292929)
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('3450'),
        //                           ],
        //                         ),
        //
        //                         // Text('hello'),
        //                       ],
        //                     )
        //                 ),
        //                 Container(
        //                   width: MediaQuery.of(context).size.width * .40,
        //                   height: 65,
        //                   child: InkWell(
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.max,
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Icon(
        //                           Icons.delete,
        //                           size: 20,
        //                           color: Colors.red[900],
        //                         ),
        //                         Text('Delete',style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w400,height: 1.7),)
        //                       ],
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           )
        //       ),
        //     ),
        //     Card(
        //       elevation: 2.0,
        //       child: Container(
        //           width: MediaQuery.of(context).size.width * 65,
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Container(
        //                   // width: MediaQuery.of(context).size.width * 0.65 * 0.5,
        //                   child:InkWell(
        //                     child: ClipRRect(
        //                       borderRadius: BorderRadius.circular(6.0),
        //                       child: Image.file(File(data[1]['image']),
        //                         width: 65,
        //                         height: 65,
        //                         fit: BoxFit.cover,
        //                       ),
        //                     ),
        //                     onTap: (){
        //                       _showdialogimage(context,data[1]);
        //                     },
        //                   ),
        //                 ),
        //                 SizedBox(width: 30,),
        //                 Container(
        //                     height: 65,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       mainAxisSize: MainAxisSize.max,
        //                       children: [
        //                         // Row(
        //                         //   children: [
        //                         //     Container(
        //                         //       child: Text('Code', style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //       ),),
        //                         //       width: 75,
        //                         //     ),
        //                         //     // Icon(
        //                         //     //   Icons.category
        //                         //     // ),
        //                         //     Text(': ' , style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //     ),),
        //                         //     Text('AF'),
        //                         //   ],
        //                         // ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Cable No.', style: TextStyle(
        //                                   fontWeight: FontWeight.bold
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('7890'),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Length', style: TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                   color: Color(0xFF292929)
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('3450'),
        //                           ],
        //                         ),
        //
        //                         // Text('hello'),
        //                       ],
        //                     )
        //                 ),
        //                 Container(
        //                   width: MediaQuery.of(context).size.width * .40,
        //                   height: 65,
        //                   child: InkWell(
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.max,
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Icon(
        //                           Icons.delete,
        //                           size: 20,
        //                           color: Colors.red[900],
        //                         ),
        //                         Text('Delete',style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w400,height: 1.7),)
        //                       ],
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           )
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Text('No. of Records: 2', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16, color: Colors.blueGrey),),
        //           Text('Length: 7234', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16, color: Colors.blueGrey),),
        //         ],
        //       ),
        //     ),
        //     SizedBox(height: 10,),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        //       child: Row(
        //         children: [
        //           Text(':: ', style: TextStyle(fontWeight: FontWeight.w900 , fontSize: 18, height: 1),),
        //           Text('1F', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),),
        //         ],
        //       ),
        //     ),
        //     Card(
        //       elevation: 2.0,
        //       child: Container(
        //           width: MediaQuery.of(context).size.width * 65,
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Container(
        //                   // width: MediaQuery.of(context).size.width * 0.65 * 0.5,
        //                   child:InkWell(
        //                     child: ClipRRect(
        //                       borderRadius: BorderRadius.circular(6.0),
        //                       child: Image.file(File(data[0]['image']),
        //                         width: 65,
        //                         height: 65,
        //                         fit: BoxFit.cover,
        //                       ),
        //                     ),
        //                     onTap: (){
        //                       _showdialogimage(context,data[0]);
        //                     },
        //                   ),
        //                 ),
        //                 SizedBox(width: 30,),
        //                 Container(
        //                     height: 65,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       mainAxisSize: MainAxisSize.max,
        //                       children: [
        //                         // Row(
        //                         //   children: [
        //                         //     Container(
        //                         //       child: Text('Code', style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //       ),),
        //                         //       width: 75,
        //                         //     ),
        //                         //     // Icon(
        //                         //     //   Icons.category
        //                         //     // ),
        //                         //     Text(': ' , style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //     ),),
        //                         //     Text('AF'),
        //                         //   ],
        //                         // ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Cable No.', style: TextStyle(
        //                                   fontWeight: FontWeight.bold
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('7890'),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Length', style: TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                   color: Color(0xFF292929)
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('3450'),
        //                           ],
        //                         ),
        //
        //                         // Text('hello'),
        //                       ],
        //                     )
        //                 ),
        //                 Container(
        //                   width: MediaQuery.of(context).size.width * .40,
        //                   height: 65,
        //                   child: InkWell(
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.max,
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Icon(
        //                           Icons.delete,
        //                           size: 20,
        //                           color: Colors.red[900],
        //                         ),
        //                         Text('Delete',style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w400,height: 1.7),)
        //                       ],
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           )
        //       ),
        //     ),
        //     Card(
        //       elevation: 2.0,
        //       child: Container(
        //           width: MediaQuery.of(context).size.width * 65,
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Container(
        //                   // width: MediaQuery.of(context).size.width * 0.65 * 0.5,
        //                   child:InkWell(
        //                     child: ClipRRect(
        //                       borderRadius: BorderRadius.circular(6.0),
        //                       child: Image.file(File(data[1]['image']),
        //                         width: 65,
        //                         height: 65,
        //                         fit: BoxFit.cover,
        //                       ),
        //                     ),
        //                     onTap: (){
        //                       _showdialogimage(context,data[1]);
        //                     },
        //                   ),
        //                 ),
        //                 SizedBox(width: 30,),
        //                 Container(
        //                     height: 65,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                       mainAxisSize: MainAxisSize.max,
        //                       children: [
        //                         // Row(
        //                         //   children: [
        //                         //     Container(
        //                         //       child: Text('Code', style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //       ),),
        //                         //       width: 75,
        //                         //     ),
        //                         //     // Icon(
        //                         //     //   Icons.category
        //                         //     // ),
        //                         //     Text(': ' , style: TextStyle(
        //                         //         fontWeight: FontWeight.bold,
        //                         //         color: Color(0xFF292929)
        //                         //     ),),
        //                         //     Text('AF'),
        //                         //   ],
        //                         // ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Cable No.', style: TextStyle(
        //                                   fontWeight: FontWeight.bold
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('7890'),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             Container(
        //                               child: Text('Length', style: TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                   color: Color(0xFF292929)
        //                               ),),
        //                               width: 75,
        //                             ),
        //                             // Icon(
        //                             //   Icons.category
        //                             // ),
        //                             Text(': ' , style: TextStyle(
        //                                 fontWeight: FontWeight.bold
        //                             ),),
        //                             Text('3450'),
        //                           ],
        //                         ),
        //
        //                         // Text('hello'),
        //                       ],
        //                     )
        //                 ),
        //                 Container(
        //                   width: MediaQuery.of(context).size.width * .40,
        //                   height: 65,
        //                   child: InkWell(
        //                     child: Row(
        //                       mainAxisSize: MainAxisSize.max,
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: [
        //                         Icon(
        //                           Icons.delete,
        //                           size: 20,
        //                           color: Colors.red[900],
        //                         ),
        //                         Text('Delete',style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w400,height: 1.7),)
        //                       ],
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           )
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Text('No. of Records: 2', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16, color: Colors.blueGrey),),
        //           Text('Length: 7234', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16, color: Colors.blueGrey),),
        //         ],
        //       ),
        //     ),
        //     SizedBox(height: 10,),
        //   ],
        // )

        Column(
          children: [
            SizedBox(height: 20,),
            Table(
              children: [
                TableRow(
                    children: [
                      TableCell(
                        child: Text('Total Records: '+ this.data.length.toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,height: 1.4, color: Colors.grey[900]),),
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
                          // TableCell(
                          //   child:Container(
                          //     // color: Colors.teal[100],
                          //     child: InkWell(
                          //       onTap: (){
                          //         _showdialog(context,data, 1);
                          //         setState(() {
                          //         });
                          //       },
                          //       child: Center(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(4.0),
                          //           child: Icon(Icons.add, size: 28,
                          //           ),
                          //         ),
                          //       )),
                          //   ),
                          // )
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
                          child: Text('No of Records: '+ this.dataArray[i].length.toString() , textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),),
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

          setState(() {
            this.data.removeAt(i);
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
                        showAlertDialog(context, data['coil_no'].toString() + data['length'].toString() + data['category'].toString(), i);
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
                  if(text2.substring(0,7) == '000006F'){
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