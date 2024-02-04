class FirestoreCollections {
  static const String apartments = "apartments";
  static const String bookings = "bookings";
  static const String residents = "resident";
  static const String announcements = "announcements";
}

class FirestoreFields {
  // Apartment fields
  static const String apartmentsNumber = "adress";
  //TODO this is not needed as document ID functions as apartment ID
  static const String apartmentsApartemntId = "apartmentid";
  static const String apartmentsResidents = "residents";
  static const String apartmentsResidentsId = "residentid";

  // Booking fields
  //TODO: Standardize field names for booking
  static const String booking = "";

  // Resident fields
  // TODO: should residents store apartment numbers instead of apartment id for ease of data management?
  static const String residentApartmentId = "aparmentid";
  static const String residentEmail = "email";
  // TODO: should names be compiled into one field for ease of data management?
  static const String residentFirstName = "firstname";
  static const String residentLastName = "lastname";
  static const String residentTel = "phonenumber";
  //TODO: make resident ID be a userID from auth
  static const String residentResidentId = "residentid";

  // Announcement fields
  static const String announcementId = "id";
  static const String announcementBody = "body";
  static const String announcementTimestamp = "timestamp";
  static const String announcementUrgency = "urgency";
}
