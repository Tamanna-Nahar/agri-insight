
import 'package:flutter/material.dart';
import '../constants.dart';
import 'RootPage.dart';
import 'signin.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: constants.p1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: () => {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> RootPage())),
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'RobotoFlex',
                ),
              ),

          )
          ),
        ],
      ),
      backgroundColor: const Color(0xFFfef7ed),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(image:'assets/images/one1.png',
                title: constants.titleOne,
                description: constants.descriptionOne,

              ),
              createPage(image:'assets/images/on3.png',
                title: constants.titleTwo,
                description: constants.descriptionTwo,

              ),
              createPage(image:'assets/images/on2.png',
                title: constants.titleThree,
                description: constants.descritpionThree,

              )
            ],
          ),
          Positioned(
            bottom: 80,
              left: 30,
              child: Row(
                children: _buildIndicator(),
              ),
          ),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration:BoxDecoration(
                shape: BoxShape.circle,
                color: constants.primaryColor,
              ),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    if(currentIndex<2){
                      currentIndex++;
                      if(currentIndex<3){
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

                      }
                    }else{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const SignIn()));
                    }
                  });
                },
                  icon:const Icon(Icons.arrow_forward_ios,size: 24,color: Colors.white
                      ,)

              ),
            ),


          )
        ],
      ),
    );
  }

  Widget _indicator(bool isActive){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20:8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: constants.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),);
  }

  List<Widget> _buildIndicator(){
    List<Widget> indicator=[];

    for(int i=0;i<3;i++){
      if(currentIndex == i){
        indicator.add(_indicator(true));

      }else{
        indicator.add(_indicator(false));
      }
    }

    return indicator;
  }


}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const createPage({
    Key? key, required this.image,required this.title,required this.description,
  }) :     super(key: key);



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: Image.asset(image),
    ),
            const SizedBox(height: 20),
            Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: constants.primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  ),

            ),
            const SizedBox(height: 20,),
            Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
        ),
      );

  }
}

