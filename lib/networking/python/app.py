from flask import Flask, request, jsonify
from stegano import lsb
import os

app = Flask(__name__)

@app.route('/check_steganography', methods=['POST'])
def check_steganography():
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No image file provided"}), 400

        image_file = request.files['image']
        image_path = os.path.join("uploads", image_file.filename)
        image_file.save(image_path)

        # Use stegano to detect hidden data using the LSB method
        hidden_message = lsb.reveal(image_path)

        if hidden_message:
            return jsonify({"steganography_detected": True, "hidden_message": hidden_message}), 200
        else:
            return jsonify({"steganography_detected": False}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/check_steganography', methods=['GET'])
def check_stegano():
    try:
        return "GET Berhasil"
    except Exception as e:
        return jsonify({"error": str(e)}), 500 

if __name__ == '__main__':
    os.makedirs("uploads", exist_ok=True)
    app.run(host="192.168.1.24", port=5000, debug=True)
    
#     Function to send image to Python backend for analysis
#   Future<String> checkForSteganography(String pickedImage) async {
#     try {
#       var request = http.MultipartRequest(
#         'POST',
#         Uri.parse('http://192.168.1.24:5000/check_steganography'),
#       );
#       request.files
#           .add(await http.MultipartFile.fromPath('image', pickedImage));

#       var response = await request.send();
#       print("Stegano Response Status Code: ${response.statusCode}");
#       if (response.statusCode == 200) {
#         var responseData = await response.stream.bytesToString();
#         var json = jsonDecode(responseData);
#         print("Stegano JSON: $json");

#         if (json['steganography_detected']) {
#           setState(() {
#             steganography = true;
#           });
#           return "Steganography detected! Hidden message: ${json['hidden_message']}";
#         } else {
#           setState(() {
#             steganography = false;
#           });
#           return "No steganography detected.";
#         }
#       } else {
#         return "Error: ${response.statusCode}";
#       }
#     } catch (e) {
#       print("Error sending request: $e");
#       return "Error: Could not analyze image.";
#     }
#   }

# Check File Steganography
#       await checkForSteganography(image.path);
#       print("Stegano Status: $steganography");
#       if (steganography == true) {
#         context.loaderOverlay.hide();
#         ScaffoldMessenger.of(context)
#             .showSnackBar(SnackBar(content: Text("Suspicious File!")));
#         return;
#       }