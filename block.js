import Web3 from "web3";
import contractABI from "./contractABI.json"; // This is your contract ABI file
if (window.ethereum) {
  window.web3 = new Web3(window.ethereum);
  try {
    // Request account access if needed
    await window.ethereum.enable();
  } catch (error) {
    // User denied account access...
  }
}
const contractAddress = "0x24525987424359a70e13eE843abeeEcfbf29fE1b";
const contract = new Web3.eth.Contract(contractABI, contractAddress);
async function Register() {
  const name = document.getElementById("name").value;
  const phoneNumber = document.getElementById("phoneNumber").value;
  const email = document.getElementById("email").value;
  const username = document.getElementById("username").value;
  const password = document.getElementById("password").value;
  try {
    // Prompt for account access if needed
    await window.web3.currentProvider.enable();
    Web3 = new Web3(window.web3.currentProvider);
    const accounts = await Web3.eth.getAccounts();

    34;

    const salt = Web3.utils.randomHex(32);
    const hashedUsername = Web3.utils.soliditySha3(username, salt);
    const hashedPassword = Web3.utils.soliditySha3(password, salt);
    const result = await contract.methods
      .registerUser(
        name,
        phoneNumber,
        email,
        hashedUsername,
        salt,
        hashedPassword
      )
      .send({ from: accounts[0] });

    console.log("User registered successfully", result);
    showMessage("User registered successfully!");
  } catch (error) {
    console.error("Error registering user", error);
    showMessage("Error registering user: " + error.message);
  }
}
async function login() {
  const authUsername = document.getElementById("authUsername").value;
  const authPassword = document.getElementById("authPassword").value;
  const otp = document.getElementById("otp").value;
  try {
    // Prompt for account access if needed
    await window.ethereum.enable();
    const accounts = await Web3.eth.getAccounts();
    const salt = await contract.methods.getSalt(authUsername).call();
    const hashedUsername = Web3.utils.soliditySha3(authUsername, salt);
    const hashedPassword = Web3.utils.soliditySha3(authPassword, salt);
    const isAuthentic = await contract.methods
      .authenticate(hashedUsername, hashedPassword, otp)
      .call();
    if (isAuthentic) {
      console.log("Authentication successful");

      35;

      showMessage("Authentication successful!");
    } else {
      console.error("Authentication failed");
      showMessage(
        "Authentication failed. Please check your credentials and OTP."
      );
    }
  } catch (error) {
    console.error("Error authenticating user", error);
    showMessage("Error authenticating user: " + error.message);
  }
}
