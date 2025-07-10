import '../utils/import_export.dart';
class SignUP{


  String? validateUserInput(String? name, String message){
    if(name!.isEmpty){
      return " Enter 3 - 23 Characters";
    }if(!RegExp(r"^[a-zA-Z\s'-]{3,50}$").hasMatch(message)){
      return " Enter 3 - 23 Characters";
    }
    return null;
  }



  // void _submit() {
  //   // Validate the form fields
  //   final isValid = _formKey.currentState!.validate();
  //   if (!isValid) {
  //     // If the form is not valid, return without doing anything
  //     return;
  //   } else {
  //     // If the form is valid, show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text(
  //           "Successfully logged in",
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   // Save the form state
  //   _formKey.currentState!.save();
  // }
}