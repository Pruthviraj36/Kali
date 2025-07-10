import 'card_model.dart';

class ProfileController {
  CardModel createProfile({
    required String name,
    required String email,
    required String age,
  }) {
    return CardModel(
      name: name,
      email: email,
      age: int.parse(age),
    );
  }
}