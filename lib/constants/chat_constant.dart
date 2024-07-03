import 'package:firebase_database/firebase_database.dart';

final DatabaseReference chatGroupRef = FirebaseDatabase.instance.reference().child("GroupChat");
var chatref = FirebaseDatabase.instance.reference().child("PersonalChat");
