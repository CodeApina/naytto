import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';

class HousingCooperativeCreator{
  var db = FirebaseFirestore.instance;
  static List<String> emailProviders = ["luukku.com", "gmail.com", "hotmail.fi", "outlook.com"];

  ///Requires the name for the housing cooperative, the address and the amount of apartments you want the building to have
  ///
  ///Creates a new housing cooperative collection in the firestore database filled with random residents and data
  Future<bool>CreateNewHousingCooperative(String housingCooperativeName, String address, int apartmentNumber) async{
    List<Person> persons = PersonGenerator().personListGenerator(apartmentNumber);
    return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).set({
      FirestoreFields.housingCooperativeAddress: address}).then((value)
      {
        for(int i = 1; i <= apartmentNumber; i++){
          db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.residents).add({
          FirestoreFields.residentApartmentNumber: "A$i",
          FirestoreFields.residentEmail: "${persons[i].firstName}.${persons[i].lastName}@${emailProviders[Random().nextInt(emailProviders.length)]}",
          FirestoreFields.residentFirstName: persons[i].firstName,
          FirestoreFields.residentLastName: persons[i].lastName,
          FirestoreFields.residentTel: persons[i].phoneNumber
        }).then((documentSnapshot) {
          return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.apartments).doc("A$i").collection(FirestoreCollections.apartmentsResidents).doc().set({
            FirestoreFields.apartmentsResidentsReference: "/${FirestoreCollections.housingCooperative}/$housingCooperativeName/${FirestoreCollections.residents}/${documentSnapshot.id}"
          });
          });
        }
        return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.announcements).doc().set({
          FirestoreFields.announcementBody: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse semper imperdiet elit, sit amet finibus ex vulputate vel. Fusce sagittis volutpat sem, a rhoncus sapien pretium ac. Vestibulum posuere, tellus at sollicitudin iaculis, libero lacus facilisis ipsum, et accumsan odio massa at felis. Duis ac tortor ultrices turpis vestibulum bibendum. Praesent ornare leo eget dapibus euismod. Curabitur elementum purus libero, eget dapibus lectus hendrerit quis. Duis id tincidunt quam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Praesent placerat vel augue id fringilla. Sed congue semper nibh, auctor molestie lectus tempus nec. Curabitur pretium leo leo, venenatis congue purus molestie sit amet. Aliquam sem magna, aliquam vitae risus id, maximus scelerisque velit. Quisque dui dolor, ullamcorper vel tellus non, tempus lacinia libero.",
          FirestoreFields.announcementTitle: "Lorem ipsum dolor sit amet",
          FirestoreFields.announcementTimestamp: DateTime.now(),
          FirestoreFields.announcementUrgency: 1
        }).then((value) {
          return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.amenities).doc("saunas").collection("saunas").doc("sauna1").collection(FirestoreCollections.amenitiesReservations).add({
            FirestoreFields.reservationReserver: "A1",
            FirestoreFields.reservationWeekday: 3,
            FirestoreFields.reservationStartTime: 13.00,
            FirestoreFields.reservationEndTime: 14.00
        }).then((value) {return true;});
      });
    });
  }
}
class PersonGenerator{

  static List<String> firstNames = ["Juhani", "Johannes", "Olavi", "Antero", "Tapani", "Kalevi", "Tapio", "Matti", "Mikael", "Ilmari", "Maria", "Helena", "Johannna", "Anneli", "Kaarina", "Marjatta", "Anna", "Liisa", "Annikki", "Hannele"];
  static List<String> lastNames = ["Korhonen", "Virtanen", "Mäkinen", "Nieminen", "Mäkelä", "Hämäläinen", "Laine", "Heikkinen", "Koskinen", "Järvinen", "Lehtonen", "Lehtinen", "Saarinen", "Niemi", "Salminen", "Heinone", "Heikkilä", "Kinnunen", "Salonen", "Turunen"];
  static List<String> phoneNumberPrefix = ["044", "050", "040"];
  /// Requires the amount of people to create
  List<Person> personListGenerator(int amountNeeded){
    List<Person> persons = [Person("test","test","test")];
    for (int i = 1; i <= amountNeeded; i++){
      String phoneNumber = phoneNumberPrefix[Random().nextInt(phoneNumberPrefix.length)];
      for(int i = 0; i < 7; i++){
        phoneNumber = phoneNumber + Random().nextInt(10).toString();
      }
      bool isUnique = false;
    List<String>names = nameGenerator(persons);
      persons.add(Person(names[0], names[1], phoneNumber));
    }
    return persons;
  }
  List<String>nameGenerator(List<Person> persons){
    List<String>names = [firstNames[Random().nextInt(firstNames.length)], lastNames[Random().nextInt(lastNames.length)]];
    for(Person person in persons){
      if(person.firstName == names[0] && person.lastName == names[1]){
        nameGenerator(persons);
      }
    }
    return names;
  }
}

class Person{
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  Person(this.firstName, this.lastName, this.phoneNumber);
}