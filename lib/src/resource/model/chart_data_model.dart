class RevenueModel {
  RevenueModel({
    this.totalRevenue, 
    this.growthRevenue, 
    this.totalAppointmentConfirm, 
    this.growthAppointmentConfirm, 
    this.totalAppointmentCancel, 
    this.growthAppointmentCancel, 
    this.totalClient, 
    this.growthClient, 
    this.totalBeforeRevenue, 
    this.totalBeforeAppointmentConfirm, 
    this.totalBeforeAppointmentCancel, 
    this.totalBeforeClient,
  });
  final num? totalRevenue;
  final num? totalBeforeRevenue;
  final num? growthRevenue;
  final num? totalAppointmentConfirm;
  final num? totalBeforeAppointmentConfirm;
  final num? growthAppointmentConfirm;
  final num? totalAppointmentCancel;
  final num? totalBeforeAppointmentCancel;
  final num? growthAppointmentCancel;
  final num? totalClient;
  final num? totalBeforeClient;
  final num? growthClient;
}
