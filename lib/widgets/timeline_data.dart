import 'package:flutter/material.dart';

class Doodle {
  final String name;
  final String time;
  final String content;
  final String doodle;
  final Color iconBackground;
  final Icon icon;
  const Doodle(
      {this.name,
        this.time,
        this.content,
        this.doodle,
        this.icon,
        this.iconBackground});
}

const List<Doodle> doodles = [
  Doodle(
      name: "Cachoeira do Santuario",
      time: "903 - 986",
      content:
      "One of Al-Sufi's greatest works involved fact-checking the Greek astronomer Ptolemy's measurements of the brightness and size of stars. In the year 964 AD, Al-Sufi published his findings in a book titled Kitab al-Kawatib al-Thabita al-Musawwar, or The Book of Fixed Stars. In many cases, he confirmed Ptolemy’s discoveries, but he also improved upon his work by illustrating the constellations and correcting some of Ptolemy’s observations about the brightness of stars.",
      doodle:
      "images/santuario.jpg",
      icon: Icon(Icons.photo_camera, color: Colors.white),
      iconBackground: Colors.green),
  Doodle(
      name: "Cachoeira de Iracema",
      time: "940 - 998",
      content:
      " Abu al-Wafa' is an innovator whose contributions to science include one of the first known introductions to negative numbers, and the development of the first quadrant, a tool used by astronomers to examine the sky. His pioneering work in spherical trigonometry was hugely influential for both mathematics and astronomy.",
      doodle: "images/iracema.jpg",
      icon: Icon(
        Icons.photo_camera,
        color: Colors.white,
      ),
      iconBackground: Colors.grey),
  Doodle(
      name: "Cachoeira Pedra Furada",
      time: "c. 965 - c. 1040",
      content:
      "Ibn al-Haytham was the first to explain through experimentation that vision occurs when light bounces on an object and then is directed to one's eyes. He was also an early proponent of the concept that a hypothesis must be proved by experiments based on confirmable procedures or mathematical evidence—hence understanding the scientific method five centuries before Renaissance scientists.",
      doodle:
      "images/pedrafurada.jpg",
      icon: Icon(
        Icons.photo_camera,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.grey),
  Doodle(
      name: "Cachoeira do Mutum",
      time: "973 - 1050",
      content:
      "Biruni is regarded as one of the greatest scholars of the Golden Age of Muslim civilisation and was well versed in physics, mathematics, astronomy, and natural sciences, and also distinguished himself as a historian, chronologist and linguist. He studied almost all fields of science and was compensated for his research and strenuous work. Royalty and powerful members of society sought out Al-Biruni to conduct research and study to uncover certain findings.",
      doodle:
      "images/mutum.jpg",
      icon: Icon(
        Icons.photo_camera,
        color: Colors.white,
      ),
      iconBackground: Colors.grey),
];