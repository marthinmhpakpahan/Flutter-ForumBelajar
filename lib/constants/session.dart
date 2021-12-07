// @dart=2.9
class Session {
  static bool login_status;
  static int login_user_id;
  static String login_full_name;
  static String login_username;
  static int selected_topic_id;
  static int selected_profile_id;

  static void setLoginStatus(bool val) {
    login_status = val;
  }

  static void setLoginUserId(int user_id) {
    login_user_id = user_id;
  }

  static void setLoginFullName(String full_name) {
    login_full_name = full_name;
  }

  static void setLoginUsername(String username) {
    login_username = username;
  }

  static void setSelectedTopicId(int topic_id) {
    selected_topic_id = topic_id;
  }

  static void setSelectedProfileId(int profile_id) {
    selected_profile_id = profile_id;
  }

  static bool getLoginStatus() {
    return login_status == null ? false : login_status;
  }

  static int getLoginUserId() {
    return login_user_id == null ? 0 : login_user_id;
  }

  static String getLoginFullName() {
    return login_full_name == null ? "" : login_full_name;
  }

  static String getLoginUsername() {
    return login_username == null ? "" : login_username;
  }

  static int getSelectedTopicId() {
    return selected_topic_id == null ? 0 : selected_topic_id;
  }

  static int getSelectedProfileId() {
    return selected_profile_id == null ? login_user_id : selected_profile_id;
  }
  
}
