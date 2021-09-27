class DashboardResponse {
  final List<LeaveResponse> leaves;
  final int totalRequest;
  final int pendingRequest;
  final int approveRequest;
  final String message;
  final List<ProductResponse> product;
  final List<TotalRequestDetail> approveRequestDetails;
  final List<TotalRequestDetail> pendingRequestDetails;
  final List<TotalRequestDetail> totalRequestDetails;
  final bool timeSheetMessage;

  DashboardResponse({
    this.leaves,
    this.totalRequest,
    this.pendingRequest,
    this.approveRequest,
    this.message,
    this.product,
    this.approveRequestDetails,
    this.pendingRequestDetails,
    this.totalRequestDetails,
    this.timeSheetMessage,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      leaves: List<LeaveResponse>.from(
          json['leaves'].map((x) => LeaveResponse.fromJson(x))),
      totalRequest: json['total_request'] as int,
      pendingRequest: json['pending_request'],
      approveRequest: json['approve_request'],
      message: json['message'],
      product: List<ProductResponse>.from(
          json['product'].map((x) => ProductResponse.fromJson(x))),
      approveRequestDetails: List<TotalRequestDetail>.from(
          json['approve_request_details']
              .map((x) => TotalRequestDetail.fromJson(x))),
      pendingRequestDetails: List<TotalRequestDetail>.from(
          json['pending_request_details']
              .map((x) => TotalRequestDetail.fromJson(x))),
      totalRequestDetails: List<TotalRequestDetail>.from(
          json['total_request_details']
              .map((x) => TotalRequestDetail.fromJson(x))),
      timeSheetMessage: json['time_sheet_message'] as bool,
    );
  }
}

class LeaveResponse {
  final int id;
  final int durationType;
  final int durationDay;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final int employeeId;
  final int leaveTypeId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String typeName;

  LeaveResponse({
    this.id,
    this.durationType,
    this.durationDay,
    this.startDate,
    this.endDate,
    this.reason,
    this.employeeId,
    this.leaveTypeId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.typeName,
  });

  factory LeaveResponse.fromJson(Map<String, dynamic> json) {
    return LeaveResponse(
      id: json['id'],
      durationType: json['duration_type'],
      durationDay: json['duration_day'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'],
      employeeId: json['employee_id'],
      leaveTypeId: json['leave_type_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      typeName: json['type_name'],
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
  final String name;
  final String quantity;

  ProductResponse({
    this.name,
    this.quantity,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
    );
  }
}

class TotalRequestDetail {
  final int id;
  final String title;
  final String referenceNumber;
  final String description;
  final String quantity;
  final String totalPrice;
  final String unitPrice;
  final String expenseBy;
  final DateTime date;
  final String siteName;

  TotalRequestDetail({
    this.id,
    this.title,
    this.referenceNumber,
    this.description,
    this.quantity,
    this.totalPrice,
    this.unitPrice,
    this.expenseBy,
    this.date,
    this.siteName,
  });

  factory TotalRequestDetail.fromJson(Map<String, dynamic> json) {
    return TotalRequestDetail(
      id: json['id'],
      title: json['title'] as String,
      referenceNumber: json['reference_number'] as String,
      description: json['description'] as String,
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      unitPrice: json['unit_price'],
      expenseBy: json['expense_by'] as String,
      date: DateTime.parse(json['date']),
      siteName: json['site_name'] as String,
    );
  }
}
