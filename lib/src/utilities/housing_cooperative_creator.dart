import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naytto/src/constants/firestore_constants.dart';


class HousingCooperativeCreator{
  var db = FirebaseFirestore.instance;
  ///Requires the name for the housing cooperative, the address and the amount of apartments you want the building to have
  ///
  ///Creates a new housing cooperative collection in the firestore database filled with random residents and data
  Future<bool>CreateNewHousingCooperative(String housingCooperativeName, String address, int apartmentNumber) async{
    List<Person> persons = PersonGenerator().personListGenerator(apartmentNumber);
    return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).set({
      FirestoreFields.housingCooperativeAddress: address}).then((value)
      {
        for(int i = 0; i < apartmentNumber; i++){
          db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.residents).add({
          FirestoreFields.residentApartmentNumber: "A${i + 1}",
          FirestoreFields.residentEmail: persons[i].email,
          FirestoreFields.residentFirstName: persons[i].firstName,
          FirestoreFields.residentLastName: persons[i].lastName,
          FirestoreFields.residentTel: persons[i].phoneNumber
        }).then((documentSnapshot) {
          return db.collection(FirestoreCollections.housingCooperative).doc(housingCooperativeName).collection(FirestoreCollections.apartments).doc("A${i + 1}").collection(FirestoreCollections.apartmentsResidents).doc().set({
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
        }).then((value) {return true;});
      });
    });
  }
}

/// Creates new residents with random names chosen from pre generated lists
class PersonGenerator{
  /// Requires the amount of people to create
  List<Person> personListGenerator(int amountNeeded){
    List<Person> persons = List.empty(growable: true);
    // Creates phonenumber for the person
    for (int i = 0; i < amountNeeded; i++){
      String phoneNumber = phoneNumberGenerator();
      List<String>names = nameGenerator(persons);
      String email = emailGenerator(names);
      persons.add(Person(names[0], names[1], phoneNumber, email));
    }
    return persons;
  }
  /// Generates email address for resident
  /// 
  /// Requires List[(0) first name, (1) last name] 
  String emailGenerator(names){
    List<String> emailProviders = ["luukku.com", "gmail.com", "hotmail.fi", "outlook.com"];
    String email = "${names[0]}.${names[1]}@${emailProviders[Random().nextInt(emailProviders.length)]}";
    return email;
  }

  /// Generates a random phone number chooses one prefix and adds 7 numbers to it creating a full phone number
  String phoneNumberGenerator(){
    List<String> phoneNumberPrefix = ["044", "050", "040"];
    String phoneNumber = phoneNumberPrefix[Random().nextInt(phoneNumberPrefix.length)];
      for(int i = 0; i < 7; i++){
        phoneNumber = phoneNumber + Random().nextInt(10).toString();
      }
    return phoneNumber;
  }
  /// Generates name for person and checks that the name isn't a duplicate of a name already on the list
  /// 
  /// Takes a list of Persons created so far
  /// 
  /// Returns List[(0)first name, (1)last name]
  List<String>nameGenerator(List<Person> persons){
    List<String> firstNames = ["Juhani", "Johannes", "Olavi", "Antero", "Tapani", "Kalevi", "Tapio", "Matti", "Mikael", "Ilmari", "Maria", "Helena", "Johannna", "Anneli", "Kaarina", "Marjatta", "Anna", "Liisa", "Annikki", "Hannele"];
    List<String> lastNames = ["Korhonen", "Virtanen", "Mäkinen", "Nieminen", "Mäkelä", "Hämäläinen", "Laine", "Heikkinen", "Koskinen", "Järvinen", "Lehtonen", "Lehtinen", "Saarinen", "Niemi", "Salminen", "Heinone", "Heikkilä", "Kinnunen", "Salonen", "Turunen"];
    List<String>names = [firstNames[Random().nextInt(firstNames.length)], lastNames[Random().nextInt(lastNames.length)]];
    for(Person person in persons){
      if(person.firstName == names[0] && person.lastName == names[1]){
        nameGenerator(persons);
      }
    }
    return names;
  }
}

/// Basic information template for generated resident
/// 
/// Stores first and last name and phone number
class Person{
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String email = "";
  Person(this.firstName, this.lastName, this.phoneNumber, this.email);
}