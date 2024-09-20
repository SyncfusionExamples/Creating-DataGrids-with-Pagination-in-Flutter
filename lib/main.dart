import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const OrderApp());
}

/// The application that contains datagrid on it.
class OrderApp extends StatelessWidget {
  const OrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order DataGrid Demo',
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: const OrderHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class OrderHomePage extends StatefulWidget {
  /// Creates the home page.
  const OrderHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHomePageState createState() => _OrderHomePageState();
}

int _rowsPerPage = 15;

class _OrderHomePageState extends State<OrderHomePage> {
  late OrderDataSource _orderDataSource;
  final double _dataPagerHeight = 60.0;
  List<Order> _orders = <Order>[];

  @override
  void initState() {
    super.initState();
    _orders = _fetchOrders();
    _orderDataSource = OrderDataSource(orders: _orders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Order Details')),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return Column(children: [
          SizedBox(
              height: constraint.maxHeight - _dataPagerHeight,
              width: constraint.maxWidth,
              child: _buildDataGrid(constraint)),
          SizedBox(
            height: _dataPagerHeight,
            child: SfDataPager(
              delegate: _orderDataSource,
              pageCount: (_orders.length / _rowsPerPage).ceil().toDouble(),
              availableRowsPerPage: const [15, 20, 25],
              onRowsPerPageChanged: (value) {
                setState(() {
                  if (value != null) {
                    _rowsPerPage = value;
                  }
                });
              },
            ),
          )
        ]);
      }),
    );
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
        source: _orderDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'orderId',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Order ID',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'customerId',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Customer ID',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'product',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Product',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'price',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Price',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'city',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'City',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'shippementPrice',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Shippement Price',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GridColumn(
            columnName: 'totalPrice',
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Total Price',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ]);
  }

  List<Order> _fetchOrders() {
    List<Order> orderData = [];
    final Random random = Random();

    // Cities list
    List<String> city = [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'San Francisco',
      'Dallas',
      'Miami',
      'Atlanta',
      'Seattle'
    ];

    // Mapping of products to their market prices.
    Map<String, double> productPrices = {
      'Laptop': 1200.0,
      'Smartphone': 800.0,
      'Tablet': 500.0,
      'Headphones': 150.0,
      'Smartwatch': 200.0,
      'Desktop PC': 1000.0,
      'Gaming Console': 400.0,
      'Fitness Tracker': 100.0,
      'Router': 75.0,
      'Smart TV': 900.0,
      'Drone': 600.0,
      'VR Headset': 350.0,
      'Graphics Card': 800.0,
      'Power Bank': 50.0,
      'Projector': 450.0,
      'Microphone': 80.0,
      'Webcam': 60.0,
      'E-reader': 120.0,
    };

    List<String> products = productPrices.keys.toList();

    // Build exactly 100 records.
    for (int i = 0; i < 100; i++) {
      // Get product name.
      String product = products[i % products.length];

      // Get the price of the product from the productPrices map.
      double price = productPrices[product]!;

      // Generate random shipment price.
      double shipmentPrice = random.nextInt(100) + random.nextDouble();

      // Create an Order object with product and price details.
      orderData.add(Order(
        orderId: 1000 + i,
        customerId: 1700 + i,
        product: product,
        orderPrice: price,
        city: city[i % city.length],
        shippementPrice: shipmentPrice,
        totalPrice: price + shipmentPrice,
      ));
    }
    return orderData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the order which will be rendered in datagrid.
class Order {
  /// Creates the order class with required details.
  Order({
    required this.orderId,
    required this.customerId,
    required this.product,
    required this.orderPrice,
    required this.city,
    required this.shippementPrice,
    required this.totalPrice,
  });

  /// Id of an order.
  final int orderId;

  /// Customer Id of an order.
  final int customerId;

  /// Product name.
  final String product;

  /// City of an order.
  final String city;

  /// Price of an order.
  final double orderPrice;

  /// Shippement price.
  final double shippementPrice;

  /// Total price (order price + shipment price).
  final double totalPrice;
}

/// Set order's data collection to data grid source.
class OrderDataSource extends DataGridSource {
  /// Creates the order data source class with required details.
  OrderDataSource({required this.orders}) {
    _paginatedOrders = orders.getRange(0, 19).toList(growable: false);
    _buildDataGridRows(_paginatedOrders);
  }

  List<DataGridRow> dataGridRows = [];
  List<Order> _paginatedOrders = [];
  List<Order> orders;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text((e.columnName == 'price' ||
                  e.columnName == 'shippementPrice' ||
                  e.columnName == 'totalPrice')
              ? NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '\$',
                  decimalDigits: 2,
                ).format(e.value)
              : e.value.toString()),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > orders.length) {
      endIndex = orders.length;
    }
    if (startIndex < orders.length && endIndex <= orders.length) {
      _paginatedOrders =
          orders.getRange(startIndex, endIndex).toList(growable: false);
      _buildDataGridRows(_paginatedOrders);
      notifyListeners();
    } else {
      dataGridRows = [];
    }
    return true;
  }

  void _buildDataGridRows(List<Order> orders) {
    dataGridRows = orders
        .map<DataGridRow>((order) => DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'orderId', value: order.orderId),
              DataGridCell<int>(
                  columnName: 'customerId', value: order.customerId),
              DataGridCell<String>(columnName: 'product', value: order.product),
              DataGridCell<double>(
                  columnName: 'price', value: order.orderPrice),
              DataGridCell<String>(columnName: 'city', value: order.city),
              DataGridCell<double>(
                  columnName: 'shippementPrice', value: order.shippementPrice),
              DataGridCell<double>(
                  columnName: 'totalPrice', value: order.totalPrice),
            ]))
        .toList();
  }
}
