import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'icon': const FaIcon(
      FontAwesomeIcons.burger,
      color: Colors.white,
    ),
    'color': Colors.yellow[700],
    'name': 'Food',
    'totalAmount': '-\$ 45.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.bagShopping,
      color: Colors.white,
    ),
    'color': Colors.purple,
    'name': 'Shopping',
    'totalAmount': '-\$ 200.00',
    'date': 'Today',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.heartCircleBolt,
      color: Colors.white,
    ),
    'color': Colors.green,
    'name': 'Health',
    'totalAmount': '-\$ 86.00',
    'date': 'Yesterday',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.plane,
      color: Colors.white,
    ),
    'color': Colors.blue,
    'name': 'Travel',
    'totalAmount': '-\$ 190.00',
    'date': 'Yesterday',
  }
];
