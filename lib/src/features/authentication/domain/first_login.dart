import "../data/link_auth_to_db.dart";

class FirstLogIn{
  bool FirtsLogIn(uid, {email, firstName, lastName, apartmentNumber, tel}){
    bool isUserFound = false;
    LinkAuthToDb().checkDbForUser(uid).then((value) => isUserFound = true);
    if (isUserFound){
      LinkAuthToDb().linkResidentToUser(uid, email: email, firstName: firstName, lastName: lastName ,apartmentNumber: apartmentNumber, tel: tel).then((value) {
          return LinkAuthToDb().storeUserInDB({"uid": uid, "email": email, "firstName": firstName, "lastName": lastName ,"apartmentNumber": apartmentNumber, "tel": tel}).then((value) {return true;}).onError((error, stackTrace) {print("Error: $error \n $stackTrace"); return true;});
      });
    }
    return false;
  }
}