import 'dart:convert';

List<AssistanceRequest> assistanceRequestFromMap(String str) => List<AssistanceRequest>.from(json.decode(str).map((x) => AssistanceRequest.fromMap(x)));

String assistanceRequestToMap(List<AssistanceRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class AssistanceRequest {
    int assistanceRequestId;
    String problemDescription;
    String latitud;
    String longitud;
    String photos;
    String voiceNote;
    String status;
    String assistanceRequestDate;
    int clientId;
    String clientPhone;
    int clientUserId;
    String clientUserName;
    String clientUserEmail;
    int workshopId;
    String workshopDescription;
    String workshopLocation;
    String workshopContactInfo;
    int workshopUserId;
    String workshopUserName;
    String workshopUserEmail;
    int technicianId;
    String technicians;
    String technicianPhone;
    int vehicleId;
    String vehicleBrand;
    String vehicleModel;
    int vehicleYear;
    String vehicleLicencePlate;

    AssistanceRequest({
        required this.assistanceRequestId,
        required this.problemDescription,
        required this.latitud,
        required this.longitud,
        required this.photos,
        required this.voiceNote,
        required this.status,
        required this.assistanceRequestDate,
        required this.clientId,
        required this.clientPhone,
        required this.clientUserId,
        required this.clientUserName,
        required this.clientUserEmail,
        required this.workshopId,
        required this.workshopDescription,
        required this.workshopLocation,
        required this.workshopContactInfo,
        required this.workshopUserId,
        required this.workshopUserName,
        required this.workshopUserEmail,
        required this.technicianId,
        required this.technicians,
        required this.technicianPhone,
        required this.vehicleId,
        required this.vehicleBrand,
        required this.vehicleModel,
        required this.vehicleYear,
        required this.vehicleLicencePlate,
    });

    factory AssistanceRequest.fromMap(Map<String, dynamic> json) => AssistanceRequest(
        assistanceRequestId: json["assistance_request_id"],
        problemDescription: json["problem_description"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        photos: json["photos"],
        voiceNote: json["voice_note"],
        status: json["status"],
        assistanceRequestDate: json["assistance_request_date"],
        clientId: json["client_id"],
        clientPhone: json["client_phone"],
        clientUserId: json["client_user_id"],
        clientUserName: json["client_user_name"],
        clientUserEmail: json["client_user_email"],
        workshopId: json["workshop_id"],
        workshopDescription: json["workshop_description"],
        workshopLocation: json["workshop_location"],
        workshopContactInfo: json["workshop_contact_info"],
        workshopUserId: json["workshop_user_id"],
        workshopUserName: json["workshop_user_name"],
        workshopUserEmail: json["workshop_user_email"],
        technicianId: json["technician_id"],
        technicians: json["technicians"],
        technicianPhone: json["technician_phone"],
        vehicleId: json["vehicle_id"],
        vehicleBrand: json["vehicle_brand"],
        vehicleModel: json["vehicle_model"],
        vehicleYear: json["vehicle_year"],
        vehicleLicencePlate: json["vehicle_licence_plate"],
    );

    Map<String, dynamic> toMap() => {
        "assistance_request_id": assistanceRequestId,
        "problem_description": problemDescription,
        "latitud": latitud,
        "longitud": longitud,
        "photos": photos,
        "voice_note": voiceNote,
        "status": status,
        "assistance_request_date": assistanceRequestDate,
        "client_id": clientId,
        "client_phone": clientPhone,
        "client_user_id": clientUserId,
        "client_user_name": clientUserName,
        "client_user_email": clientUserEmail,
        "workshop_id": workshopId,
        "workshop_description": workshopDescription,
        "workshop_location": workshopLocation,
        "workshop_contact_info": workshopContactInfo,
        "workshop_user_id": workshopUserId,
        "workshop_user_name": workshopUserName,
        "workshop_user_email": workshopUserEmail,
        "technician_id": technicianId,
        "technicians": technicians,
        "technician_phone": technicianPhone,
        "vehicle_id": vehicleId,
        "vehicle_brand": vehicleBrand,
        "vehicle_model": vehicleModel,
        "vehicle_year": vehicleYear,
        "vehicle_licence_plate": vehicleLicencePlate,
    };
}
