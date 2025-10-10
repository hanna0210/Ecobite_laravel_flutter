// To parse this JSON data, do
//
//     final driverDocument = driverDocumentFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

DriverDocument driverDocumentFromJson(String str) =>
    DriverDocument.fromJson(json.decode(str));

String driverDocumentToJson(DriverDocument data) =>
    json.encode(data.toJson());

class DriverDocument {
  DriverDocument({
    this.id,
    required this.documentType,
    this.documentNumber,
    this.expiryDate,
    this.issuedDate,
    this.issuingAuthority,
    this.filePath,
    this.file,
    this.isVerified = false,
    this.verificationStatus = DocumentVerificationStatus.pending,
    this.rejectionReason,
  });

  int? id;
  DocumentType documentType;
  String? documentNumber;
  DateTime? expiryDate;
  DateTime? issuedDate;
  String? issuingAuthority;
  String? filePath;
  File? file; // For local file upload
  bool isVerified;
  DocumentVerificationStatus verificationStatus;
  String? rejectionReason;

  factory DriverDocument.fromJson(Map<String, dynamic> json) {
    return DriverDocument(
      id: json["id"],
      documentType: _parseDocumentType(json["document_type"]),
      documentNumber: json["document_number"],
      expiryDate: json["expiry_date"] != null
          ? DateTime.parse(json["expiry_date"])
          : null,
      issuedDate: json["issued_date"] != null
          ? DateTime.parse(json["issued_date"])
          : null,
      issuingAuthority: json["issuing_authority"],
      filePath: json["file_path"],
      isVerified: json["is_verified"] ?? false,
      verificationStatus:
          _parseVerificationStatus(json["verification_status"]),
      rejectionReason: json["rejection_reason"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "document_type": documentType.value,
        "document_number": documentNumber,
        "expiry_date": expiryDate?.toIso8601String(),
        "issued_date": issuedDate?.toIso8601String(),
        "issuing_authority": issuingAuthority,
        "file_path": filePath,
        "is_verified": isVerified,
        "verification_status": verificationStatus.value,
        "rejection_reason": rejectionReason,
      };

  static DocumentType _parseDocumentType(dynamic value) {
    if (value == null) return DocumentType.other;
    final stringValue = value.toString().toLowerCase();
    return DocumentType.values.firstWhere(
      (type) => type.value == stringValue,
      orElse: () => DocumentType.other,
    );
  }

  static DocumentVerificationStatus _parseVerificationStatus(dynamic value) {
    if (value == null) return DocumentVerificationStatus.pending;
    final stringValue = value.toString().toLowerCase();
    return DocumentVerificationStatus.values.firstWhere(
      (status) => status.value == stringValue,
      orElse: () => DocumentVerificationStatus.pending,
    );
  }
}

enum DocumentType {
  nationalId('national_id', 'National ID / Passport'),
  driverLicense('driver_license', 'Driver License'),
  vehicleRegistration('vehicle_registration', 'Vehicle Registration'),
  vehicleInsurance('vehicle_insurance', 'Vehicle Insurance'),
  proofOfAddress('proof_of_address', 'Proof of Address'),
  policeCheck('police_check', 'Police Clearance / Background Check'),
  vehiclePhoto('vehicle_photo', 'Vehicle Photo'),
  profilePhoto('profile_photo', 'Profile Photo'),
  other('other', 'Other Document');

  final String value;
  final String displayName;

  const DocumentType(this.value, this.displayName);

  static List<DocumentType> get requiredDocuments => [
        DocumentType.nationalId,
        DocumentType.driverLicense,
        DocumentType.vehicleRegistration,
        DocumentType.vehicleInsurance,
      ];

  static List<DocumentType> get optionalDocuments => [
        DocumentType.proofOfAddress,
        DocumentType.policeCheck,
        DocumentType.vehiclePhoto,
        DocumentType.profilePhoto,
        DocumentType.other,
      ];
}

enum DocumentVerificationStatus {
  pending('pending', 'Pending Review'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected'),
  expired('expired', 'Expired');

  final String value;
  final String displayName;

  const DocumentVerificationStatus(this.value, this.displayName);
}

