

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/news_model.dart';
import 'package:untitled1/pages/homepage.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({Key? key}) : super(key: key);
  static const String routeName='/newsdetailpage';   // for routing this page

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  List<String> keywords=['Guardian','BBC','CNN', 'Football','Elon Musk','Tesla','Amazon','Twitter','al jazeera'];
  List<String> links=['www.theguardian.com','www.bbc.com','us.cnn.com','www.fifa.com/fifaplus/en/news','www.forbes.com','www.tesla.com','www.aboutamazon.com','www.twitter.com','www.aljazeera.com'];
  List<String> keyword_detected=[];
  int linkno=0,j=0,i=0;
  Future<void> _launchUrl(String link) async {
    final Uri uri = Uri(scheme: "https", host: link);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $link';
    }
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Article;  //getting arguments
    for(j=0;j<keywords.length;j++)
      {
        for(i=0;i<=args.description!.length;i++)
          {
            if(args.description!.contains(keywords[j]) || args.title!.contains(keywords[j]) || args.content!.contains(keywords[j]))
              {
                keyword_detected.add(keywords[j]);
              }
          }
      }
    List<String> updatedkeywords = keyword_detected.toSet().toList();
    //List<String> updatedkeywordslink = keyword_detectedlink.toSet().toList();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$Selectedcategory',style: TextStyle(color: Colors.blue),),
            Text('News',style: TextStyle(color: Colors.amber),)
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                 Text(args.title.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),),
                Text('Published Date: ${args.publishedAt}'),
                SizedBox(height: 8,),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: Image.network(args.urlToImage.toString())),
                SizedBox(height: 5,),
                Text(args.description.toString(),style: TextStyle(fontSize: 25,color: Colors.white)),
                SizedBox(height: 10,),
                Expanded(child: Text(args.content.toString(),style: TextStyle(fontSize: 20,color: Colors.white))),
                SizedBox(height: 45,),
                Container(
                  height: 65,
                  width: 300,
                  child: ListView.builder(
                      itemCount: updatedkeywords.length,
                      itemBuilder: (context, index){
                        return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  }
                                  return Colors.black;
                                },
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                                int linksr=0;
                                for(i=0;i<keywords.length;i++)
                                  {
                                    if(updatedkeywords[index]==keywords[i])
                                      break;
                                    linksr++;
                                  }
                                _launchUrl(links[linksr].toString());
                              });
                            },
                            child: Text('Learn More About ${updatedkeywords[index]}'));
                      }
                  )
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
