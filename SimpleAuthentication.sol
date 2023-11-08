// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SimpleAuthentication {
struct User {
string name;
string phoneNumber;
string email;
bytes32 hashedUsername;
bytes32 salt;
bytes32 hashedPassword;
uint256 otp; // Added field for OTP
}
mapping(bytes32 => User) public users;
bytes32[] public usernames; // Dynamic array to store usernames

26

event LogAuthenticationAttempt(bool success, string username, uint256 otp);
event LogGeneratedOTP(address indexed user, uint256 otp);

function registerUser(
string memory _name,
string memory _phoneNumber,
string memory _email,
string memory _username,
string memory _password
) public {
bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
bytes32 hashedUsername = keccak256(abi.encodePacked(_username, salt));
bytes32 hashedPassword = keccak256(abi.encodePacked(_password, salt));
require(users[hashedUsername].hashedUsername == bytes32(0), "Username already registered");
users[hashedUsername] = User({
name: _name,
phoneNumber: _phoneNumber,
email: _email,
hashedUsername: hashedUsername,
salt: salt,
hashedPassword: hashedPassword,
otp: 0 // Initialize OTP to 0
});
usernames.push(hashedUsername); // Add the username to the array
}
function generateRandomOTP() public {
// Ensure that the function can only be called by the contract owner or another authorized entity
// Add your authorization logic here

27

// For example, you can use the 'msg.sender' to check the authorization
// Generate a random 6-digit OTP
uint256 otp = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao,
msg.sender))) % 1000000;

// Store the generated OTP in the user's data
users[keccak256(abi.encodePacked(msg.sender))].otp = otp;

// Emit an event to log the generated OTP
emit LogGeneratedOTP(msg.sender, otp);
}
function authenticate(string memory _username, string memory _password, uint256 _otp) public view
returns (bool) {
bytes32 hashedUsername = keccak256(abi.encodePacked(_username));
User memory user = users[hashedUsername];

// Hash the provided password with the user's salt
bytes32 hashedPassword = keccak256(abi.encodePacked(user.salt, _password));

// Check if the provided OTP matches the stored OTP
bool otpMatch = user.otp == _otp;

bool success = user.hashedPassword == hashedPassword && otpMatch;
// No event emitted here since it's a view function
return success;
}
function getUsernames() public view returns (bytes32[] memory) {
return usernames;
}

28

// Function to retrieve user details by hashed username
function getUserDetails(bytes32 hashedUsername) public view returns (string memory, string memory,
string memory) {
User memory user = users[hashedUsername];
return (user.name, user.phoneNumber, user.email);
}
}