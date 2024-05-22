import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  /// Get the dictionary from SharedPreferences.
  ///
  /// If the dictionary does not exist, an empty dictionary will be returned.
  static Future<Map<String, dynamic>> getDictionary(String key) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the dictionary exists.
    if (!prefs.containsKey(key)) {
      // If the dictionary does not exist, return an empty dictionary.
      return {};
    }

    // Get the dictionary as JSON string from SharedPreferences.
    String? objjson = prefs.getString(key);

    // Return the dictionary.
    return jsonDecode(objjson!) as Map<String, dynamic>;
  }

  /// Save the dictionary to SharedPreferences.
  static Future<void> saveDictionary(String key, Map<String, dynamic> dictionary) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the dictionary to a JSON string.
    String objjson = jsonEncode(dictionary);

    // Save the string list to SharedPreferences.
    prefs.setString(key, objjson);
  }

  /// Save the List to SharedPreferences.
  static Future<void> saveList(String key, List<dynamic> list) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the dictionary to a JSON string.
    String objjson = jsonEncode(list);

    // Save the string list to SharedPreferences.
    prefs.setString(key, objjson);
  }

  /// Get the List from SharedPreferences.
  ///
  /// If the list does not exist, an empty list will be returned.
  static Future<List<dynamic>> getList(String key) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the dictionary exists.
    if (!prefs.containsKey(key)) {
      // If the dictionary does not exist, return an empty dictionary.
      return <dynamic>[];
    }

    // Get the dictionary as JSON string from SharedPreferences.
    String? objjson = prefs.getString(key);

    // Return the dictionary.
    return jsonDecode(objjson!) as List<dynamic>;
  }

  /// Get a double value from SharedPreferences.
  static Future<double?> getDouble(String key) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the double value.
    return prefs.getDouble(key);
  }

  /// Save a double value to SharedPreferences.
  static Future<void> setDouble(String key, double value) async {
    // Get an instance of SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the double value.
    prefs.setDouble(key, value);
  }
}
