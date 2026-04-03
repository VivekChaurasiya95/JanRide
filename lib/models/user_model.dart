class UserModel {
  const UserModel({
	required this.id,
	required this.name,
	required this.phone,
	this.email,
	this.photoUrl,
	this.trustScore = 0.5,
	this.profileCompleted = false,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final double trustScore;
  final bool profileCompleted;

  factory UserModel.fromJson(Map<String, dynamic> json) {
	return UserModel(
	  id: json['id']?.toString() ?? '',
	  name: json['name']?.toString() ?? 'JanRide User',
	  phone: json['phone']?.toString() ?? '',
	  email: json['email']?.toString(),
	  photoUrl: json['photoUrl']?.toString(),
	  trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.5,
	  profileCompleted: json['profileCompleted'] == true,
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'id': id,
	  'name': name,
	  'phone': phone,
	  'email': email,
	  'photoUrl': photoUrl,
	  'trustScore': trustScore,
	  'profileCompleted': profileCompleted,
	};
  }
}

