

class FirestoreCollections{
  static const String apartments = "apartments";
  static const String bookings = "bookings";
  static const String residents = "resident";
}
class FirestoreFields{
  // Apartment fields
  static const String apartmentsAdress = "adress";
  //TODO this is not needed as document ID functions as apartment ID
  static const String apartmentsApartemntId = "apartmentid";
  static const String apartmentsResidents = "residents";
  static const String apartmentsResidentsId = "residentid";

  // Booking fields
  //TODO: Standardize field names for booking
  static const String booking = "";

  // Resident fields
  static const String residentApartmentId = "aparmentid";
  static const String residentEmail = "email";
  static const String residentFirstName = "firstname";
  static const String residentLastName = "lastname";
  static const String residentTel = "phonenumber";
  //TODO: make resident ID be a userID from auth
  static const String residentResidentId = "residentid";
}