class FirestoreCollections {
  static const String apartments = "apartments";
  static const String amenities = "amenities";
  static const String residents = "residents";
  static const String announcements = "announcements";
  static const String apartmentsResidents = "Residents";
  static const String housingCooperative = "HousingCooperatives";
  static const String users = "Users";
  static const String amenitiesReservations = "reservations";
  static const String saunas = "saunas";
  static const String bookings = "bookings";
  static const String laundry = "laundry";
  static const String maintenance = "maintenance";
}

class FirestoreFields {
  // Apartment fields
  static const String apartmentsNumber = "apartment_number";

  // Apartments/Residents fields
  static const String apartmentsResidentsReference = "recident_reference";

  // Booking fields
  //TODO: Standardize field names for booking
  static const String booking = "";
  static const String bookingApartmentID = "apartmentID";
  static const String bookingDay = "day";
  static const String bookingTime = "time";
  static const String bookingTimestamp = "timestamp";
  static const String bookingID = "amenityID";
  static const String bookingType = "type";
  static const String bookingAmenityID = "amenityID";

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
  static const String userId = "uid";
  static const String userEmail = "email";
  static const String userHousingCooperative = "housing_cooperative";
  static const String userApartmentNumber = "apartment_number";
  static const String userphoneNumber = "tel";
  static const String userfirstName = "first_name";
  static const String userlastName = "last_name";

  //HousingCooperative fields
  static const String housingCooperativeAddress = "address";
  static const String housingCooperativeTel = "tel";

  //Reservation fields
  static const String reservationReserver = "reserver";
  static const String reservationEndTime = "reservation_end_time";
  static const String reservationStartTime = "reservations_start_time";
  static const String reservationWeekday = "weekday";

  // Sauna fields
  static const String saunaWeekdays = "weekdays";

  // Amenity fields
  static const String amenityID = "";
  static const String amenityWeekDays = "weekdays";
  static const String amenityAvailableFrom = "available_from";
  static const String amenityAvailableTo = "available_to";
  static const String amenityDisplayName = "display_name";
  static const String amenityOutOfService = "out_of_service";
  static const String amenityTimeSlotAvailability = "available";

  // Maintenance fields
  static const String maintenanceApartmentNumber = "apartment_number";
  static const String maintenanceBody = "body";
  static const String maintenanceDate = "date";
  static const String maintenanceType = "type";
  static const String maintenanceReason = "reason";
  static const String maintenanceStatus = "status";
}
