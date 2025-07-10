
import '../utils/import_export.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  // final _key = GlobalKey<FormState>();
  GlobalKey<FormState> _fromKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            APPBAR_NAME,
            style: TextStyle(
              fontSize: 20,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
                key: _fromKey,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 18,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return " Enter 3 - 23 Characters";
                    }if(!RegExp(r"^[a-zA-Z\s'-]{3,50}$").hasMatch(value)){
                      return " Enter 3 - 23 Characters";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter Your Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a valid email address.";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                        .hasMatch(value)) {
                      return "Enter a valid email address.";
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Your Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a valid 10-digit mobile number.";
                    }
                    if (!RegExp(r"^\+?[0-9]{10}$").hasMatch(value)) {
                      return "Enter a valid 10-digit mobile number.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                      labelText: "Phone",
                      hintText: "Enter Your Phone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      return "Password must be 8+ chars, include a number & symbol.";
                    }
                    return null;
                  },
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Pass",
                      hintText: "Enter Your Pass",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 18,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value != confirmPassController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  controller: confirmPassController,
                  decoration: InputDecoration(
                      labelText: "Confirm Pass",
                      hintText: "Enter Your Pass",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                      )
                  ),
                ),
                SizedBox(
                  width: double.infinity, // Set the width to fill the parent
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () => null,
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
