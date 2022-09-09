import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:intl/intl.dart';

class OAuthSchoology {

  OAuthSchoology();
  // static final OAuthSchoology db = OAuthSchoology._();

  String apiRoot = "https://api.schoology.com/v1";
  String domainRoot = "https://srvusd.schoology.com";
  String consumerKey = "e3c2632f9add6e8f11a3c214a7a9bf92062f9e326";
  String consumerSecret = "224e200d7904df32d90ebcf049dabe7b";
  String accessToken = "";
  String accessTokenKey = "";
  String oauthNonce = "";
  String reqToken = "";
  String reqTokenSecret = "";


  // random number
  int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  // oauth header
  String oauthHeader(){
    String auth = "";

    if(oauthNonce != null){
      for(int i = 0; i < 8; i++){
        oauthNonce+=random(0, 9).toString();
      }
    }
    auth += 'OAuth realm="Schoology API",';
    auth += 'oauth_consumer_key="' + consumerKey + '",';
    auth += 'oauth_token="' + accessToken != "" ? accessToken : "" + '",';
    auth += 'oauth_nonce="' + oauthNonce + '",';
    auth += 'oauth_timestamp="' + (DateTime.now().millisecondsSinceEpoch/1000).toString() + '",';
    auth += 'oauth_signature_method="PLAINTEXT",';
    auth += 'oauth_version="1.0",';
    auth += 'oauth_signature="' + consumerSecret + '%26' + accessTokenKey + '"';
    return auth;
  }

  requestHeader(){
    return {
      'Authorization': oauthHeader(),
      'Accept': 'application/json',
      'Host': 'api.schoology.com',
      'Content-Type': 'application/json',
    };
  }

  reqAuth()async{
    // first get access token:
    // for(String authItem in oauthHeader()){

    // }
    oauthHeader();
    if(accessToken == ""){
      var r = await http.get(Uri.parse(apiRoot+"/oauth/request_token"),
        headers: {'Authorization': oauthHeader(),
        // {
        //     // 'OAuth realm':"Schoology API",
        //     'oauth_consumer_key':consumerKey,
        //     'oauth_token': accessToken != "" ? accessToken : "",
        //     'oauth_nonce': oauthNonce,
        //     'oauth_timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        //     'oauth_signature_method': "PLAINTEXT",
        //     'oauth_version': "1.0",
        //     'oauth_signature': consumerSecret + '%%26' + consumerKey,
        //   }
        }
      );
      List reqData = [];
      String tempDump = "";
      for(int i = 0; i < r.body.toString().length; i++){
        if(!["=","&"].contains(r.body[i])){
          tempDump+= r.body[i];
        }
        else{
          reqData.add(tempDump);
          tempDump = "";
        }
      }

      reqToken = reqData[1];
      reqTokenSecret = reqData[3];

      http.get(Uri.parse(domainRoot));
    }
  }
  auth(){
    String accessTokenUrl = apiRoot+"/oauth/access_token";

  }
}