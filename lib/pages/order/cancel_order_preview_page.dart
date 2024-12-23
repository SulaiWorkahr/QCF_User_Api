// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:namfood/widgets/heading_widget.dart';
// import 'package:namfood/widgets/sub_heading_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../constants/app_assets.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_constants.dart';
// import '../../services/comFuncService.dart';
// import '../../services/nam_food_api_service.dart';
// import '../../widgets/custom_text_field.dart';
// import 'canceloreder_preview_model.dart';

// class CancelOrderPreviewPage extends StatefulWidget {
//   int? orderid;
//   CancelOrderPreviewPage({super.key, this.orderid});

//   @override
//   _CancelOrderPreviewPageState createState() => _CancelOrderPreviewPageState();
// }

// class _CancelOrderPreviewPageState extends State<CancelOrderPreviewPage> {
//   final NamFoodApiService apiService = NamFoodApiService();

//   @override
//   void initState() {
//     super.initState();

//     getOrderPreviewlist();
//     print(widget.orderid);
//   }

//   List<Item> orderPreviewList = [];
//   List<Address> addressList = [];
//   List<Item> orderPreviewListAll = [];
//   ListClass? orderDetailsList;
//   StoreAddress? storeAddress;
//   Address? customerAddress;
//   Customer? CustomerDetails;

//   bool isLoading = false;

//   Future<void> getOrderPreviewlist() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getstoredetailbyidList(widget.orderid);
//       print("API Response: $result");

//       var response = cancelOrderPreviewmodelFromJson(result);
//       print("hi");
//       if (response.status?.toUpperCase() == 'SUCCESS') {
//         setState(() {
//           orderDetailsList = response.list;
//           print(response.list);
//           orderPreviewList = response.items ?? [];
//           orderPreviewListAll = orderPreviewList;
//           storeAddress = response.storeAddress;
//           customerAddress = (response.address?.isNotEmpty ?? false)
//               ? response.address![0]
//               : null; // Assign the first address or null
//           CustomerDetails = response.customer;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           orderDetailsList = null;
//           orderPreviewList = [];
//           addressList = [];
//           orderPreviewListAll = [];
//           storeAddress = null;
//           customerAddress = null;
//           CustomerDetails = null;
//           isLoading = false;
//         });
//         print("Error: ${response.message}");
//       }
//     } catch (e) {
//       setState(() {
//         orderDetailsList = null;
//         orderPreviewList = [];
//         addressList = [];
//         orderPreviewListAll = [];
//         storeAddress = null;
//         customerAddress = null;
//         CustomerDetails = null;
//         isLoading = false;
//       });
//       print('Error occurred: $e');
//       showInSnackBar(context, 'Error occurred: $e');
//     }
//   }

//   String dateFormat(dynamic date) {
//     try {
//       DateTime dateTime = date is DateTime ? date : DateTime.parse(date);
//       String formattedTime =
//           DateFormat('h:mm a').format(dateTime).toLowerCase();
//       String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
//       return "$formattedTime | $formattedDate";
//     } catch (e) {
//       return "Invalid date"; // Fallback for invalid date format
//     }
//   }

//   void _makePhoneCall(String phoneNumber) async {
//     final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(telUri)) {
//       await launchUrl(telUri);
//     } else {
//       throw 'Could not launch $telUri';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.lightGrey3,
//         elevation: 0,
//         title: HeadingWidget(
//           title: "Back",
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           HeadingWidget(
//                             title: storeAddress?.name ?? 'Default Store Name',
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           GestureDetector(
//                               onTap: () async {
//                                 _makePhoneCall(storeAddress!.mobile.toString());
//                               },
//                               child: Image.asset(
//                                 AppAssets.call_icon,
//                                 width: 30,
//                                 height: 30,
//                                 // color: AppColors.red,
//                               )),
//                         ]),
//                     if (orderDetailsList != null) ...[
//                       Row(
//                         children: [
//                           SubHeadingWidget(
//                             title: "Order Id #",
//                             fontSize: 18.0,
//                             color: Colors.black,
//                           ),
//                           SubHeadingWidget(
//                             title: orderDetailsList!.id ?? "Unknown",
//                             fontSize: 18.0,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           SubHeadingWidget(
//                             title:
//                                 "${orderDetailsList!.totalProduct} ${orderDetailsList!.totalProduct! > 1 ? 'items' : 'item'}",
//                             fontSize: 14.0,
//                             color: Colors.black,
//                           ),
//                           SubHeadingWidget(
//                             title: " | ",
//                             fontSize: 16.0,
//                             color: Colors.black,
//                           ),
//                           SubHeadingWidget(
//                             title: dateFormat(orderDetailsList!.createdDate),
//                             fontSize: 14.0,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ],
//                     SizedBox(height: 8),
//                     Container(
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15.0),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: orderPreviewList.length,
//                           separatorBuilder: (context, index) => Divider(
//                             color: Colors.grey.shade300,
//                             thickness: 1,
//                           ),
//                           itemBuilder: (context, index) {
//                             final item = orderPreviewList[index];

//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0, horizontal: 10.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   item.imageUrl == null
//                                       ? ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: Image.asset(
//                                             AppAssets.storeBiriyaniImg,
//                                             height: 50,
//                                             width: 50,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )
//                                       : ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: Image.network(
//                                             AppConstants.imgBaseUrl +
//                                                 item.imageUrl.toString(),
//                                             height: 50,
//                                             width: 50,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                   const SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               // const SizedBox(height: 5),
//                                               HeadingWidget(
//                                                 title: item.productName,
//                                               ),
//                                               HeadingWidget(
//                                                 title: "₹${item.price}.00",
//                                               )
//                                             ]),
//                                         SizedBox(height: 10),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                                 // mainAxisAlignment:
//                                                 //     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   SubHeadingWidget(
//                                                     title: item.quantity,
//                                                     color: AppColors.black,
//                                                   ),
//                                                   SubHeadingWidget(
//                                                     title: " x ",
//                                                     color: AppColors.black,
//                                                   ),
//                                                   SubHeadingWidget(
//                                                     title:
//                                                         "₹${item.totalPrice}.00",
//                                                     color: AppColors.black,
//                                                   )
//                                                 ]),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         )),
//                     SizedBox(height: 20),
//                     HeadingWidget(
//                       title: "Bill Details",
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     SizedBox(height: 5),

//                     //Bill container details
//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15.0),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Item total",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(
//                                   orderDetailsList?.totalPrice == null
//                                       ? ''
//                                       : "₹${orderDetailsList?.totalPrice?.toString() ?? '0'}",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                   ),
//                                 )
//                               ]),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Delivery Fee | 9.8 km",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   "₹0.00",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 14,
//                                   ),
//                                 )
//                               ]),
//                           Divider(color: Colors.grey[300]),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Platform fee",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               Text(
//                                 "₹0.00",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "GST & Restaurant Charges",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               Text(
//                                 "₹00.00",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Divider(color: Colors.grey[300]),
//                           BillRow(
//                             label: "Total Amount",
//                             value: orderDetailsList?.totalPrice == null
//                                 ? '0'
//                                 : "₹${orderDetailsList?.totalPrice?.toString() ?? '0'}",
//                             isTotal: true,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     HeadingWidget(
//                       title: "Address",
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     SizedBox(height: 5),

//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15.0),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Container(
//                           //   width: 100.0,
//                           //   padding: EdgeInsets.all(8.0),
//                           //   decoration: BoxDecoration(
//                           //       border: Border.all(
//                           //         color: AppColors.red,
//                           //       ),
//                           //       borderRadius: BorderRadius.circular(10.0),
//                           //       color: AppColors.light),
//                           //   child: Row(
//                           //     mainAxisAlignment: MainAxisAlignment.center,
//                           //     children: [
//                           //       Image.asset(
//                           //         AppAssets.cart_home_icon,
//                           //         height: 18,
//                           //         width: 18,
//                           //         color: AppColors.red,
//                           //       ),
//                           //       SizedBox(width: 8),
//                           //       // Text(
//                           //       //   "Home",
//                           //       //   style: TextStyle(
//                           //       //       fontWeight: FontWeight.bold,
//                           //       //       color: AppColors.red),
//                           //       // ),
//                           //     ],
//                           //   ),
//                           // ),
//                           SizedBox(height: 8),
//                           Text(''
//                               // "${customerAddress!.address},${customerAddress!.city},${customerAddress!.state},"
//                               //  "No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
//                               ),
//                           SizedBox(height: 8),
//                           Text(""
//                               //"${customerAddress!.pincode}"
//                               //  "No 37 Paranjothi Nagar Thylakoid, velour Nagar\nTrichy-620005",
//                               ),
//                           SizedBox(height: 8),
//                           Text(""
//                               //"Contact : ${CustomerDetails!.mobile.toString()}"
//                               // "Contact : 1234567890"
//                               ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// class BillRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isTotal;
//   const BillRow({
//     required this.label,
//     required this.value,
//     this.isTotal = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
