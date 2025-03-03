import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenanceapp/controllers/bottompages/mannacontroller.dart';

class Manna extends StatefulWidget {
  const Manna({super.key});

  @override
  State<Manna> createState() => _MannaState();
}

class _MannaState extends State<Manna> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MannaController>(
        init: MannaController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Manna's",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xff005F01),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Manna",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text("August 24, 2024",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        Text("Tuesday",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Christ Nourishing the Church",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Bible Verses",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Eph 5:29 For no one ever hated his own flesh, but nourishes and cherishes it, even as Christ also the church, (30) Because we are members of His Body.",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Words of Ministry",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ReadMoreText(
                            text:
                                "Christ's care of the church has two aspects. The inner aspect is the nourishing, and the outer aspect is the cherishing. To be nourished is to have something imparted into us inwardly, whereas to be cherished is to be warmed and comforted outwardly. If we would be nourished by Christ today, we need to abide in Him to absorb His content into our being as life and the life supply. In order to experience this in a practical way, we daily need to contact the living Word, for the Word is the embodiment of life and of the life supply. The more we abide in the Lord and contact the Word, the more we experience His nourishing. This is the way Christ nourishes the church. All the members of the church need to practice abiding in the Lord. There should be no insulation, no separation, between us and the Lord and no detachment from Him. As soon as we are detached from Him, the supply of nourishment is cut off. Along with abiding in the Lord constantly, we must daily come to the Word and take it in as our life and life supply. Then we shall receive nourishment. Furthermore, all the meetings of the church should be meetings of nourishment. Morning watch [prayer and Bible reading time] and our fellowship with the saints should also be times of nourishment.",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  const ReadMoreText({
    super.key,
    this.trimLines = 5,
    required this.text,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool readMore = true;


  @override
  Widget build(BuildContext context) {
    final maxLines = readMore ? widget.trimLines : null;
    return Column(
      children: [
        Text(
          widget.text,
          maxLines: maxLines,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5,),
        InkWell(
          onTap: (){
            toggleReadMore();
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              readMore ? 'Read More...' : 'Read Less...',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  void toggleReadMore() {
    setState(() {
      readMore = !readMore;
    });
  }
}
