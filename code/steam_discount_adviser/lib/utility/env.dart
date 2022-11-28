import 'package:flutter/material.dart';

//URL to the steam games list
const String getAllGamesApi =
    "https://api.steampowered.com/ISteamApps/GetAppList/v2/";

//URL to the details of a given game, the courrency parameter gives the price results in euro
const String getGameDetailsFromIdApi =
    "http://store.steampowered.com/api/appdetails?courrency=3&appids=";
