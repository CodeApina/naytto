class FirestoreCollections {
  static const String apartments = "apartments";
  static const String amenities = "amenities";
  static const String residents = "resident";
  static const String announcements = "announcements";
  static const String apartmentsResidents = "Residents";
  static const String housingCooperative = "HousingCooperatives";
  static const String users = "Users";
  static const String amenitiesReservations = "reservations";
}

class FirestoreFields {
  // Apartment fields
  static const String apartmentsNumber = "apartment_number";

  // Apartments/Residents fields
  static const String apartmentsResidentsReference = "recident_reference";

  // Booking fields
  //TODO: Standardize field names for booking
  static const String booking = "";

  // Resident fields
  // TODO: should residents store apartment numbers instead of apartment id for ease of data management?
  static const String residentApartmentNumber = "apartment_number";
  static const String residentEmail = "email";
  static const String residentFirstName = "first_name";
  static const String residentLastName = "last_name";
  static const String residentTel = "tel";
  static const String residentResidentId = "uid";
  static const String residentIsAppUser = "app_user";

  // Announcement fields
  static const String announcementId = "id";
  static const String announcementBody = "body";
  static const String announcementTimestamp = "timestamp";
  static const String announcementUrgency = "urgency";
  static const String announcementTitle = "title";

  // Users fields
  static const String usersId = "uid";
  static const String usersEmail = "email";
  static const String usersHousingCooperative = "housing_cooperative";
  static const String usersApartmentNumber = "apartment_number";
  static const String phoneNumber = "tel";
  static const String firstName = "first_name";
  static const String lastName = "last_name";

  //HousingCooperative fields
  static const String housingCooperativeAddress = "address";

  //Reservation fields
  static const String reservationReserver = "reserver";
  static const String reservationEndTime = "reservation_end_time";
  static const String reservationStartTime = "reservations_start_time";
  static const String reservationWeekday = "weekday";
}
