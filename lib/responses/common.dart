class CommonResponse {
  List<LeaveTypeResponse> leaveTypes;
  List<CustomerListResponse> customerLists;
  List<ProductResponse> productLists;
  List<ExpenseCategoryListResponse> expenseCategoryLists;
  String message;

  CommonResponse({
    this.leaveTypes,
    this.customerLists,
    this.productLists,
    this.expenseCategoryLists,
    this.message,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      leaveTypes: List<LeaveTypeResponse>.from(json['leave_types'].map((x) => LeaveTypeResponse.fromJson(x))),
      customerLists:
          List<CustomerListResponse>.from(json['customer_lists'].map((x) => CustomerListResponse.fromJson(x))),
      productLists: List<ProductResponse>.from(json['product_lists'].map((x) => ProductResponse.fromJson(x))),
      expenseCategoryLists: List<ExpenseCategoryListResponse>.from(
          json['expense_category_lists'].map((x) => ExpenseCategoryListResponse.fromJson(x))),
      message: json['message'],
    );
  }
}

class ExpenseCategoryListResponse {
  final int id;
  final String name;

  ExpenseCategoryListResponse({
    this.id,
    this.name,
  });

  factory ExpenseCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryListResponse(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CustomerListResponse {
  final int id;
  final String customerName;

  CustomerListResponse({
    this.id,
    this.customerName,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      id: json['id'],
      customerName: json['customer_name'],
    );
  }
}

class LeaveTypeResponse {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveTypeResponse({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResponse(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ProductResponse {
  final int id;
  final String name;

  ProductResponse({
    this.id,
    this.name,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'],
      name: json['name'] as String,
    );
  }
}
