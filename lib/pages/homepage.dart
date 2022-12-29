import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/connectapi/newsprovider.dart';
import 'package:untitled1/models/news_model.dart';
import 'package:untitled1/pages/newsdetainpage.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName='/';

  @override
  State<HomePage> createState() => _HomePageState();
}
List<Article> selectednews=[]; //for storing api data after collecting from the provider
String Selectedcategory='Business';
class _HomePageState extends State<HomePage> {
  Icon morenewsicon=Icon(Icons.arrow_drop_up);  //for making changable icon in the bottom left corner
  double height=0;   //for controlling size of animatedcontainer
  double wedth=0;
  bool catselected=false;
  Color catboxonebgcolor=Colors.black;
  Color catboxonetxtcolor=Colors.white;
  bool loading=true;
  String selectedcategory='business';
  List<Article> articlesbycat  = [];
  late NewsProvder provider;
  List<String> categories=['Business','Sports', 'Entertainment','Health', 'General', 'Technology'];
  getData() async {
    provider =  Provider.of<NewsProvder>(context, listen: false);
    await provider.getCurrentData(selectedcategory);
    articlesbycat = provider.newsPaper!.articles!;
    for(int i=0;i<articlesbycat.length;i++)
      {
        if(articlesbycat[i].urlToImage==null || articlesbycat[i].description==null)
          {
            articlesbycat.removeAt(i);
          }
      } //removing the articles without image or description
    //print(articlesbycat.length.toString());
    setState(() {
       loading=false; //for stopping the loading sign
    });

  }
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _launchUrl(String link) async {
    final Uri uri = Uri(scheme: "https", host: link);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('News',style: TextStyle(color: Colors.blue),),
          Text('Hub',style: TextStyle(color: Colors.amber),)
        ],
      ),
    ),
      body:loading? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$Selectedcategory News is Loading",style: TextStyle(fontSize: 20),),
          CircularProgressIndicator(),
        ],
      )): Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: categories.length,
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
                    onPressed: () {
                      setState(() {
                        loading=true;
                        if(categories[index]=='Business')
                          {
                            selectedcategory='business'; //selecting category for passing string value to the link
                            Selectedcategory=categories[index];
                            getData();
                          }
                        else if(categories[index]=='Sports')
                        {
                          selectedcategory='sports';
                          Selectedcategory=categories[index];
                          getData();
                        }
                        else if(categories[index]=='Entertainment')
                        {
                          selectedcategory='entertainment';
                          Selectedcategory=categories[index];
                          getData();
                        }
                        else if(categories[index]=='Health')
                        {
                          selectedcategory='health';
                          Selectedcategory=categories[index];
                          getData();
                        }
                        else if(categories[index]=='General')
                        {
                          selectedcategory='general';
                          Selectedcategory=categories[index];
                          getData();
                        }
                        else if(categories[index]=='Technology')
                        {
                          selectedcategory='technology';
                          Selectedcategory=categories[index];
                          getData();
                        }
                      });
                    },
                    child: Text('${categories[index]}'),
                  );
                }
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            child: Container(
              height:MediaQuery.of(context).size.height-140 ,  //after category part, the least screen will show all news
              child: ListView.builder(
                      itemCount: articlesbycat.length,
                      shrinkWrap: true,
                      itemBuilder:(context, index){
                        return Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                //gestureDitector used to make the whole container clickable
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectednews.add(articlesbycat[index]);
                                      Navigator.pushNamed(
                                          context,NewsDetailPage.routeName,arguments: articlesbycat[index]);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(05),
                                      color: Colors.black12,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black, spreadRadius: 3),
                                      ],
                                    ),
                                    height:290,
                                    child: ListView(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.network('${articlesbycat[index].urlToImage}'),
                                            //Text('${articlesbycat[index].title}',style: TextStyle(fontSize: 20, color: Colors.black)),
                                            Text(
                                                articlesbycat[index].title!.length > 0 ? articlesbycat[index].title!.substring(0, 30)+'...' : articlesbycat[index].title!,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                           Container(
                                               child: Text('${articlesbycat[index].description}',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15, color: Colors.white))
                                           )

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),SizedBox(height: 20,)
                            ],

                          ),
                        );

                      }

                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          IconButton(
              onPressed: (){
                setState(() {
                  height==0? height=400: height=0;
                  wedth==0?wedth=90:wedth=0;
                });
              },
              icon: height==0? Icon(Icons.arrow_right):Icon(Icons.arrow_left),iconSize: 70,color: Colors.amber,),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: height,
            width: wedth,
            child: Column(
            children: <Widget>[
              Container(
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: (){
                      _launchUrl("www.cnn.com");
                    },
                    backgroundColor: Colors.red,
                    child: Text('CNN'),
                  )
              ), //button first

              Container(
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: (){
                      _launchUrl("www.bbc.com");
                    },
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Text('BBC'),
                  )
              ), // button second

              Container(
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: (){
                      _launchUrl("www.aljazeera.com");
                    },
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Text('Aljazera'),
                  )
              ),
              Container(
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: (){
                      _launchUrl("www.btvlive.gov.bd");
                    },
                    backgroundColor: Colors.green,
                    child: Text('BTV'),
                  )
              ),

            ],),),
        ],
      )
    );
  }


}
